--[[
	SavingService.lua
	Handles loading and saving player data using DataStoreService.
	Includes retry logic and periodic auto-save.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local SavingService = {}

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

local CurrencyService
local BaseService

local AutoSaveInterval = 120 -- Save every 2 minutes
local MaxRetries = 3
local RetryDelay = 0.5

function SavingService.Initialize(currencyService, baseService)
	CurrencyService = currencyService
	BaseService = baseService

	-- Start auto-save loop
	SavingService.StartAutoSave()

	print("[SavingService] Initialized")
end

-- Load player data from DataStore
function SavingService.LoadPlayerData(player: Player)
	local userId = player.UserId
	local key = "Player_" .. userId

	local success, data = SavingService.RetryOperation(function()
		return PlayerDataStore:GetAsync(key)
	end)

	if success and data then
		print("[SavingService] Loaded data for", player.Name)
		return data
	elseif success then
		print("[SavingService] No saved data for", player.Name, "- New player")
		return nil
	else
		warn("[SavingService] Failed to load data for", player.Name)
		return nil
	end
end

-- Save player data to DataStore
function SavingService.SavePlayerData(player: Player)
	local userId = player.UserId
	local key = "Player_" .. userId

	-- Gather data from services
	local currencyData = CurrencyService.GetPlayerData(player)
	local earners = BaseService.GetPlayerEarners(player)

	if not currencyData then
		warn("[SavingService] No currency data to save for", player.Name)
		return false
	end

	local dataToSave = {
		Balance = currencyData.Balance,
		Unclaimed = currencyData.Unclaimed,
		Earners = earners,
		LastSave = os.time(),
	}

	local success = SavingService.RetryOperation(function()
		PlayerDataStore:SetAsync(key, dataToSave)
		return true
	end)

	if success then
		print("[SavingService] Saved data for", player.Name)
		return true
	else
		warn("[SavingService] Failed to save data for", player.Name)
		return false
	end
end

-- Retry operation with exponential backoff
function SavingService.RetryOperation(operation)
	for attempt = 1, MaxRetries do
		local success, result = pcall(operation)

		if success then
			return true, result
		else
			warn("[SavingService] Attempt", attempt, "failed:", result)

			if attempt < MaxRetries then
				task.wait(RetryDelay * attempt) -- Exponential backoff
			end
		end
	end

	return false, nil
end

-- Auto-save loop
function SavingService.StartAutoSave()
	task.spawn(function()
		while true do
			task.wait(AutoSaveInterval)

			print("[SavingService] Auto-saving all players...")

			for _, player in Players:GetPlayers() do
				task.spawn(function()
					SavingService.SavePlayerData(player)
				end)
			end
		end
	end)

	print("[SavingService] Auto-save started (interval:", AutoSaveInterval, "seconds)")
end

-- Save on player leaving
function SavingService.OnPlayerLeaving(player: Player)
	print("[SavingService] Player leaving, saving data for", player.Name)
	SavingService.SavePlayerData(player)
end

return SavingService
