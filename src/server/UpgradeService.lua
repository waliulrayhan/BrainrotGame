--[[
	UpgradeService.lua
	Server-side management of player upgrades.
	Handles upgrade purchases and tracks upgrade levels.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeConfig = require(ReplicatedStorage.Shared.Config.UpgradeConfig)

local UpgradeService = {}

-- Player upgrade data: {[UserId] = {ClaimMultiplier = 1, DeliverySpeed = 1}}
local PlayerUpgrades = {}

local CurrencyService
local PurchaseFeedbackEvent
local UpgradeUpdateEvent
local RequestUpgradeEvent

function UpgradeService.Initialize(currencyService)
	CurrencyService = currencyService
	
	-- Get/create remote events
	local remotes = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes")
	
	-- Create UpgradeUpdate event
	UpgradeUpdateEvent = remotes:FindFirstChild("UpgradeUpdate")
	if not UpgradeUpdateEvent then
		UpgradeUpdateEvent = Instance.new("RemoteEvent")
		UpgradeUpdateEvent.Name = "UpgradeUpdate"
		UpgradeUpdateEvent.Parent = remotes
	end
	
	-- Create RequestUpgrade event
	RequestUpgradeEvent = remotes:FindFirstChild("RequestUpgrade")
	if not RequestUpgradeEvent then
		RequestUpgradeEvent = Instance.new("RemoteEvent")
		RequestUpgradeEvent.Name = "RequestUpgrade"
		RequestUpgradeEvent.Parent = remotes
	end
	
	PurchaseFeedbackEvent = remotes:WaitForChild("PurchaseFeedback")
	
	-- Listen for upgrade requests
	RequestUpgradeEvent.OnServerEvent:Connect(function(player, upgradeId)
		UpgradeService.HandleUpgradeRequest(player, upgradeId)
	end)
	
	print("[UpgradeService] Initialized")
end

-- Initialize player upgrades (with saved data or defaults)
function UpgradeService.InitPlayer(player: Player, savedUpgrades)
	PlayerUpgrades[player.UserId] = {
		ClaimMultiplier = savedUpgrades and savedUpgrades.ClaimMultiplier or 1,
		DeliverySpeed = savedUpgrades and savedUpgrades.DeliverySpeed or 1,
	}
	
	-- Send initial upgrade state to client
	UpgradeService.SyncPlayer(player)
end

-- Handle upgrade purchase request
function UpgradeService.HandleUpgradeRequest(player: Player, upgradeId: string)
	if not PlayerUpgrades[player.UserId] then
		return
	end
	
	local upgradeData = UpgradeConfig.GetUpgrade(upgradeId)
	if not upgradeData then
		return
	end
	
	local currentLevel = PlayerUpgrades[player.UserId][upgradeId] or 1
	
	-- Check if already at max level
	if UpgradeConfig.IsMaxLevel(upgradeId, currentLevel) then
		PurchaseFeedbackEvent:FireClient(player, "error", "Already at max level!")
		return
	end
	
	-- Get next level data
	local nextLevelData = UpgradeConfig.GetNextLevelData(upgradeId, currentLevel)
	if not nextLevelData then
		PurchaseFeedbackEvent:FireClient(player, "error", "Cannot upgrade further!")
		return
	end
	
	local cost = nextLevelData.cost
	
	-- Check if player has enough money
	local balance = CurrencyService.GetBalance(player)
	if balance < cost then
		PurchaseFeedbackEvent:FireClient(player, "error", "Not enough money!")
		return
	end
	
	-- Deduct cost
	local success = CurrencyService.DeductBalance(player, cost)
	if not success then
		PurchaseFeedbackEvent:FireClient(player, "error", "Purchase failed!")
		return
	end
	
	-- Apply upgrade
	PlayerUpgrades[player.UserId][upgradeId] = nextLevelData.level
	
	-- Sync to client
	UpgradeService.SyncPlayer(player)
	
	-- Send feedback
	PurchaseFeedbackEvent:FireClient(
		player,
		"success",
		upgradeData.name .. " upgraded to level " .. nextLevelData.level .. "!"
	)
end

-- Get player's upgrade level
function UpgradeService.GetUpgradeLevel(player: Player, upgradeId: string): number
	if not PlayerUpgrades[player.UserId] then
		return 1 -- Default level
	end
	
	return PlayerUpgrades[player.UserId][upgradeId] or 1
end

-- Get claim multiplier for player
function UpgradeService.GetClaimMultiplier(player: Player): number
	local level = UpgradeService.GetUpgradeLevel(player, "ClaimMultiplier")
	local levelData = UpgradeConfig.GetLevelData("ClaimMultiplier", level)
	local multiplier = levelData and levelData.multiplier or 1
	return multiplier
end

-- Get delivery speed multiplier for player
function UpgradeService.GetDeliveryMultiplier(player: Player): number
	local level = UpgradeService.GetUpgradeLevel(player, "DeliverySpeed")
	local levelData = UpgradeConfig.GetLevelData("DeliverySpeed", level)
	local multiplier = levelData and levelData.multiplier or 1
	return multiplier
end

-- Get all player upgrades for saving
function UpgradeService.GetPlayerUpgrades(player: Player)
	return PlayerUpgrades[player.UserId]
end

-- Sync player upgrade state to client
function UpgradeService.SyncPlayer(player: Player)
	if not PlayerUpgrades[player.UserId] then
		return
	end
	
	UpgradeUpdateEvent:FireClient(player, PlayerUpgrades[player.UserId])
end

-- Cleanup when player leaves
function UpgradeService.CleanupPlayer(player: Player)
	PlayerUpgrades[player.UserId] = nil
	print("[UpgradeService] Cleaned up player:", player.Name)
end

return UpgradeService
