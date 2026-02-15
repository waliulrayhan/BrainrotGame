--[[
	CurrencyService.lua
	Manages player currency with two values:
	- Balance: Spendable money for purchases
	- Unclaimed: Money earned but not yet claimed
	
	Server-authoritative to prevent exploits.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrencyService = {}

-- Constants (prevent exploits and float drift)
local MAX_CURRENCY = 1e15 -- 1 quadrillion maximum
local MIN_CURRENCY = 0

-- Helper: Clamp and round to integer (prevents float drift and absurd values)
local function ClampCurrency(value: number): number
	value = math.floor(value + 0.5) -- Round to nearest integer
	return math.clamp(value, MIN_CURRENCY, MAX_CURRENCY)
end

-- Store player money data
local PlayerData = {}

-- Remote events for client communication
local StateUpdateEvent
local PurchaseFeedbackEvent

function CurrencyService.Initialize()
	-- Get remote events
	StateUpdateEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("StateUpdate")
	PurchaseFeedbackEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("PurchaseFeedback")

	print("[CurrencyService] Initialized")
end

-- Initialize player currency
function CurrencyService.InitPlayer(player: Player, savedBalance: number?, savedUnclaimed: number?)
	PlayerData[player.UserId] = {
		Balance = ClampCurrency(savedBalance or 0), -- Starting balance
		Unclaimed = ClampCurrency(savedUnclaimed or 0),
	}

	-- Send initial state to client
	CurrencyService.SyncPlayer(player)

	print("[CurrencyService] Initialized player:", player.Name, "Balance:", PlayerData[player.UserId].Balance)
end

-- Add to player's spendable balance
function CurrencyService.AddBalance(player: Player, amount: number)
	if not PlayerData[player.UserId] then
		warn("[CurrencyService] Player data not found for AddBalance:", player.Name)
		return
	end

	amount = ClampCurrency(amount)
	PlayerData[player.UserId].Balance = ClampCurrency(PlayerData[player.UserId].Balance + amount)
	CurrencyService.SyncPlayer(player)
end

-- Deduct from player's balance (returns true if successful)
function CurrencyService.DeductBalance(player: Player, amount: number): boolean
	if not PlayerData[player.UserId] then
		warn("[CurrencyService] Player data not found for DeductBalance:", player.Name)
		return false
	end

	amount = ClampCurrency(amount)
	if PlayerData[player.UserId].Balance < amount then
		return false -- Not enough money
	end

	PlayerData[player.UserId].Balance = ClampCurrency(PlayerData[player.UserId].Balance - amount)
	CurrencyService.SyncPlayer(player)
	return true
end

-- Add to player's unclaimed earnings
function CurrencyService.AddUnclaimed(player: Player, amount: number)
	if not PlayerData[player.UserId] then
		return
	end

	amount = ClampCurrency(amount)
	PlayerData[player.UserId].Unclaimed = ClampCurrency(PlayerData[player.UserId].Unclaimed + amount)
	CurrencyService.SyncPlayer(player)
end

-- Claim unclaimed money (move to balance)
function CurrencyService.ClaimMoney(player: Player): number
	if not PlayerData[player.UserId] then
		-- Send feedback even when player data doesn't exist
		PurchaseFeedbackEvent:FireClient(player, "error", "Nothing to claim yet!")
		return 0
	end

	local unclaimed = PlayerData[player.UserId].Unclaimed

	if unclaimed > 0 then
		PlayerData[player.UserId].Balance = ClampCurrency(PlayerData[player.UserId].Balance + unclaimed)
		PlayerData[player.UserId].Unclaimed = 0
		CurrencyService.SyncPlayer(player)

		-- Send success feedback
		PurchaseFeedbackEvent:FireClient(player, "success", "Claimed $" .. tostring(math.floor(unclaimed)) .. "!")
	else
		-- Send info message when nothing to claim
		PurchaseFeedbackEvent:FireClient(player, "error", "Nothing to claim yet!")
	end

	return unclaimed
end

-- Get player balance
function CurrencyService.GetBalance(player: Player): number
	if not PlayerData[player.UserId] then
		return 0
	end
	return PlayerData[player.UserId].Balance
end

-- Get player unclaimed
function CurrencyService.GetUnclaimed(player: Player): number
	if not PlayerData[player.UserId] then
		return 0
	end
	return PlayerData[player.UserId].Unclaimed
end

-- Get both values for saving
function CurrencyService.GetPlayerData(player: Player)
	return PlayerData[player.UserId]
end

-- Sync player's currency state to their client
function CurrencyService.SyncPlayer(player: Player)
	if not PlayerData[player.UserId] then
		return
	end

	StateUpdateEvent:FireClient(player, {
		Balance = PlayerData[player.UserId].Balance,
		Unclaimed = PlayerData[player.UserId].Unclaimed,
	})
end

-- Cleanup when player leaves
function CurrencyService.CleanupPlayer(player: Player)
	-- Data will be saved before this is called
	PlayerData[player.UserId] = nil
	print("[CurrencyService] Cleaned up player:", player.Name)
end

return CurrencyService
