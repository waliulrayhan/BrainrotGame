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
local UpgradeService

local AutoSaveInterval = 120 -- Save every 2 minutes
local MaxRetries = 3
local RetryDelay = 0.5

-- Offline earnings settings
local OFFLINE_EARNINGS_PERCENTAGE = 0.5 -- 50% of potential earnings
local MAX_OFFLINE_HOURS = 12 -- Cap at 12 hours
local MIN_OFFLINE_SECONDS = 10 -- Minimum 10 seconds away (lowered for testing)

function SavingService.Initialize(currencyService, baseService, upgradeService)
	CurrencyService = currencyService
	BaseService = baseService
	UpgradeService = upgradeService

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
		print("[SavingService] ✓ Loaded data for", player.Name, "- Balance:", data.Balance, "Unclaimed:", data.Unclaimed, "Earners:", data.Earners and #data.Earners or 0)
		
		-- Calculate offline earnings if player was away
		if data.LastLogout then
			local offlineEarnings = SavingService.CalculateOfflineEarnings(player, data)
			if offlineEarnings > 0 then
				data.OfflineEarnings = offlineEarnings
				data.OfflineTime = os.time() - data.LastLogout
			end
		end
		
		return data
	elseif success then
		print("[SavingService] No saved data for", player.Name, "- New player")
		return nil
	else
		warn("[SavingService] ✗ Failed to load data for", player.Name)
		return nil
	end
end

-- Calculate offline earnings based on time away
function SavingService.CalculateOfflineEarnings(player: Player, savedData): number
	if not savedData.LastLogout then
		return 0
	end
	
	if not savedData.Earners or #savedData.Earners == 0 then
		return 0
	end
	
	local currentTime = os.time()
	local offlineTimeSeconds = currentTime - savedData.LastLogout
	
	-- Cap at maximum offline hours
	local maxOfflineSeconds = MAX_OFFLINE_HOURS * 3600
	if offlineTimeSeconds > maxOfflineSeconds then
		offlineTimeSeconds = maxOfflineSeconds
	end
	
	-- Must be away for at least MIN_OFFLINE_SECONDS to get offline earnings
	if offlineTimeSeconds < MIN_OFFLINE_SECONDS then
		return 0
	end
	
	-- Calculate base EPS from saved earners
	local totalEPS = 0
	for _, earner in ipairs(savedData.Earners) do
		local earnerEPS = earner.eps or 0
		totalEPS = totalEPS + earnerEPS
	end
	
	if totalEPS <= 0 then
		return 0
	end
	
	-- Apply delivery speed multiplier if available
	local deliveryMultiplier = 1
	if savedData.Upgrades and savedData.Upgrades.DeliverySpeed then
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local UpgradeConfig = require(ReplicatedStorage.Shared.Config.UpgradeConfig)
		local levelData = UpgradeConfig.GetLevelData("DeliverySpeed", savedData.Upgrades.DeliverySpeed)
		if levelData then
			deliveryMultiplier = levelData.multiplier
		end
	end
	
	-- Calculate potential earnings (with delivery multiplier)
	local potentialEarnings = totalEPS * deliveryMultiplier * offlineTimeSeconds
	
	-- Apply offline percentage (50% by default)
	local offlineEarnings = math.floor(potentialEarnings * OFFLINE_EARNINGS_PERCENTAGE)
	
	return offlineEarnings
end

-- Save player data to DataStore
function SavingService.SavePlayerData(player: Player)
	local userId = player.UserId
	local key = "Player_" .. userId

	print("[SavingService] ==============================")
	print("[SavingService] Saving data for:", player.Name)

	-- Gather data from services
	local currencyData = CurrencyService.GetPlayerData(player)
	local earners = BaseService.GetPlayerEarners(player)
	local upgrades = UpgradeService and UpgradeService.GetPlayerUpgrades(player)

	if not currencyData then
		warn("[SavingService] No currency data to save for", player.Name)
		print("[SavingService] ==============================")
		return false
	end

	local dataToSave = {
		Balance = currencyData.Balance,
		Unclaimed = currencyData.Unclaimed,
		Earners = earners,
		Upgrades = upgrades,
		HasSeenTutorial = true, -- Always save as true after first play
		LastSave = os.time(),
		LastLogout = os.time(), -- Save logout time for offline earnings
	}

	-- Debug: Print what we're saving
	print("[SavingService] Data to save:")
	print("  - Balance:", dataToSave.Balance)
	print("  - Unclaimed:", dataToSave.Unclaimed)
	print("  - Earners:", #earners, "characters")
	if #earners > 0 then
		local totalSavedEPS = 0
		for _, e in ipairs(earners) do
			totalSavedEPS = totalSavedEPS + (e.eps or 0)
		end
		print("  - Total EPS being saved:", totalSavedEPS)
	end
	print("  - Upgrades:", upgrades)
	print("  - LastLogout:", dataToSave.LastLogout)

	local success = SavingService.RetryOperation(function()
		PlayerDataStore:SetAsync(key, dataToSave)
		return true
	end)

	if success then
		print("[SavingService] ✓ Successfully saved data for", player.Name)
	else
		warn("[SavingService] ✗ Failed to save data for", player.Name)
	end
	print("[SavingService] ==============================")
	return success
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
