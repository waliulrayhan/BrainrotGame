--[[
	PurchaseService.lua
	Validates and processes character purchases.
	Includes anti-exploit checks and rate limiting.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfig = require(ReplicatedStorage.Shared.Config.CharacterConfig)

local PurchaseService = {}

local CurrencyService
local BaseService

-- Rate limiting
local LastPurchaseTime = {} -- {[UserId] = tick()}
local PurchaseCooldown = 0.3 -- Seconds

-- Remote events
local RequestBuyEvent
local PurchaseFeedbackEvent

function PurchaseService.Initialize(currencyService, baseService)
	CurrencyService = currencyService
	BaseService = baseService

	-- Get remote events
	RequestBuyEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestBuy")
	PurchaseFeedbackEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("PurchaseFeedback")

	-- Listen for purchase requests
	RequestBuyEvent.OnServerEvent:Connect(function(player, characterModel)
		PurchaseService.HandlePurchaseRequest(player, characterModel)
	end)

	print("[PurchaseService] Initialized")
end

-- Handle purchase request from client
function PurchaseService.HandlePurchaseRequest(player: Player, characterModel)
	-- Validate character model exists AND is still in workspace (not already bought)
	if not characterModel or not characterModel:IsA("Model") or not characterModel.Parent then
		warn("[PurchaseService] Invalid or already purchased character from", player.Name)
		PurchaseFeedbackEvent:FireClient(player, "error", "Character no longer available!")
		return
	end

	-- Verify it's in the workspace (anti-exploit: prevent purchasing already-owned characters)
	if characterModel.Parent ~= workspace then
		warn("[PurchaseService] Character not in workspace from", player.Name)
		return
	end

	-- Get character ID
	local characterIdValue = characterModel:FindFirstChild("CharacterId")
	if not characterIdValue then
		warn("[PurchaseService] No CharacterId found in model")
		return
	end

	local characterId = characterIdValue.Value
	local characterData = CharacterConfig.GetCharacterById(characterId)

	if not characterData then
		warn("[PurchaseService] Invalid character ID:", characterId)
		return
	end

	-- Rate limiting check
	local now = tick()
	local lastPurchase = LastPurchaseTime[player.UserId] or 0

	if now - lastPurchase < PurchaseCooldown then
		PurchaseFeedbackEvent:FireClient(player, "error", "Slow down!")
		return
	end

	-- Check if player is in purchase zone
	if not PurchaseService.IsPlayerInPurchaseZone(player) then
		PurchaseFeedbackEvent:FireClient(player, "error", "Get closer to the lane!")
		return
	end

	-- Check if player has enough money
	local playerBalance = CurrencyService.GetBalance(player)
	if playerBalance < characterData.price then
		PurchaseFeedbackEvent:FireClient(player, "error", "Not enough money!")
		return
	end

	-- Mark character as sold immediately (prevent double-purchase race condition)
	characterModel.Parent = nil -- Remove from workspace immediately

	-- Deduct money
	local success = CurrencyService.DeductBalance(player, characterData.price)
	if not success then
		-- Refund by destroying the character (shouldn't happen, but safety check)
		characterModel:Destroy()
		PurchaseFeedbackEvent:FireClient(player, "error", "Purchase failed!")
		return
	end

	-- Update rate limit
	LastPurchaseTime[player.UserId] = now

	-- Deliver character to base
	PurchaseService.DeliverToBase(player, characterData)

	-- Destroy the character model (it's been cloned for delivery if needed)
	characterModel:Destroy()

	-- Send success feedback
	PurchaseFeedbackEvent:FireClient(player, "success", "Bought " .. characterData.name .. "!")

	print("[PurchaseService]", player.Name, "purchased", characterData.name)
end

-- Check if player is in purchase zone
function PurchaseService.IsPlayerInPurchaseZone(player: Player): boolean
	local character = player.Character
	if not character then
		return false
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return false
	end

	local purchaseZone = workspace:FindFirstChild("PurchaseZone")
	if not purchaseZone then
		warn("[PurchaseService] No PurchaseZone in workspace!")
		return true -- Allow purchase anyway if zone doesn't exist
	end

	-- Check distance
	local distance = (humanoidRootPart.Position - purchaseZone.Position).Magnitude
	local maxDistance = (purchaseZone.Size.Magnitude / 2) + 5 -- Add some buffer

	return distance <= maxDistance
end

-- Deliver purchased character to player's base
-- Note: Uses instant delivery (no movement) to avoid Tween.Completed reliability issues
-- Character immediately starts earning upon purchase (simplified gameplay)
function PurchaseService.DeliverToBase(player: Player, characterData)
	local base = BaseService.GetPlayerBase(player)

	if not base then
		warn("[PurchaseService] No base found for player:", player.Name)
		return
	end

	-- Add to earning system immediately (no movement delay)
	BaseService.AddEarner(player, characterData)

	-- Create visual representation at base (instant spawn)
	-- Parent to the base's parent (Bases folder) to avoid workspace lock issues
	local visualModel = Instance.new("Model")
	visualModel.Name = characterData.name

	local part = Instance.new("Part")
	part.Size = characterData.size * 0.8 -- Slightly smaller
	part.Color = characterData.color
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false

	-- Random position on base (aesthetic variation)
	local random = Random.new()
	local baseSize = base.Size
	local offsetX = random:NextNumber(-baseSize.X / 3, baseSize.X / 3)
	local offsetZ = random:NextNumber(-baseSize.Z / 3, baseSize.Z / 3)

	part.Position = base.Position + Vector3.new(offsetX, characterData.size.Y / 2 + 1, offsetZ)
	part.Parent = visualModel
	
	-- Parent to Bases folder (safe during runtime)
	visualModel.Parent = base.Parent
end

-- Cleanup when player leaves
function PurchaseService.CleanupPlayer(player: Player)
	LastPurchaseTime[player.UserId] = nil
end

return PurchaseService
