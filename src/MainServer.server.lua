--[[
	MainServer.server.lua
	Server entry point that initializes all services and handles player lifecycle.
]]

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Require all services
local Services = ServerScriptService:WaitForChild("Services")
local CurrencyService = require(Services:WaitForChild("CurrencyService"))
local UpgradeService = require(Services:WaitForChild("UpgradeService"))
local BaseService = require(Services:WaitForChild("BaseService"))
local ShopLaneService = require(Services:WaitForChild("ShopLaneService"))
local PurchaseService = require(Services:WaitForChild("PurchaseService"))
local SavingService = require(Services:WaitForChild("SavingService"))
local TutorialService = require(Services:WaitForChild("TutorialService"))

-- Remote events
local RequestClaimEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestClaim")
local ShowOfflineEarningsEvent
local ClaimOfflineEarningsEvent

-- Create ShowOfflineEarnings remote event
local remotes = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes")
ShowOfflineEarningsEvent = remotes:FindFirstChild("ShowOfflineEarnings")
if not ShowOfflineEarningsEvent then
	ShowOfflineEarningsEvent = Instance.new("RemoteEvent")
	ShowOfflineEarningsEvent.Name = "ShowOfflineEarnings"
	ShowOfflineEarningsEvent.Parent = remotes
end

-- Create ClaimOfflineEarnings remote event
ClaimOfflineEarningsEvent = remotes:FindFirstChild("ClaimOfflineEarnings")
if not ClaimOfflineEarningsEvent then
	ClaimOfflineEarningsEvent = Instance.new("RemoteEvent")
	ClaimOfflineEarningsEvent.Name = "ClaimOfflineEarnings"
	ClaimOfflineEarningsEvent.Parent = remotes
end

print("=== BRAINROT GAME SERVER STARTING ===")

-- Initialize services in correct order
CurrencyService.Initialize(nil) -- Initialize first without UpgradeService
UpgradeService.Initialize(CurrencyService) -- Initialize with CurrencyService reference
CurrencyService.Initialize(UpgradeService) -- Give CurrencyService the UpgradeService reference
BaseService.Initialize(CurrencyService, UpgradeService)
ShopLaneService.Initialize()
PurchaseService.Initialize(CurrencyService, BaseService)
SavingService.Initialize(CurrencyService, BaseService, UpgradeService)
TutorialService.Initialize()

print("=== ALL SERVICES INITIALIZED ===")

-- Store pending offline earnings for players
local PendingOfflineEarnings = {} -- {[UserId] = amount}

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
	print("========================================")
	print("[MainServer] PLAYER JOINED:", player.Name)
	print("========================================")

	-- Load saved data
	local savedData = SavingService.LoadPlayerData(player)
	
	print("[MainServer] Saved data loaded:")
	if savedData then
		print("  - Balance:", savedData.Balance)
		print("  - Unclaimed:", savedData.Unclaimed)
		print("  - Earners:", savedData.Earners and #savedData.Earners or 0)
		print("  - Upgrades:", savedData.Upgrades and "Yes" or "No")
		print("  - LastLogout:", savedData.LastLogout)
		print("  - OfflineEarnings:", savedData.OfflineEarnings)
	else
		print("  - NEW PLAYER (no saved data)")
	end

	-- Initialize upgrades first (needed for multipliers)
	local savedUpgrades = savedData and savedData.Upgrades or nil
	UpgradeService.InitPlayer(player, savedUpgrades)

	-- Initialize currency
	local savedBalance = savedData and savedData.Balance or nil
	local savedUnclaimed = savedData and savedData.Unclaimed or nil
	CurrencyService.InitPlayer(player, savedBalance, savedUnclaimed)

	-- Assign base
	local base = BaseService.AssignBase(player)

	if not base then
		warn("[MainServer] Failed to assign base to player:", player.Name)
	end

	-- Restore earners
	if savedData and savedData.Earners then
		print("[MainServer] Restoring", #savedData.Earners, "earners")
		BaseService.RestoreEarners(player, savedData.Earners)
	else
		print("[MainServer] No earners to restore")
	end

	-- Show offline earnings popup if applicable
	if savedData and savedData.OfflineEarnings and savedData.OfflineEarnings > 0 then
		print("[MainServer] Offline earnings available:", savedData.OfflineEarnings)
		print("[MainServer] Waiting 1 second for client...")
		-- Store pending offline earnings for this player
		PendingOfflineEarnings[player.UserId] = savedData.OfflineEarnings
		-- Wait a moment for client to be ready
		task.wait(1)
		print("[MainServer] Sending offline earnings to client")
		ShowOfflineEarningsEvent:FireClient(player, savedData.OfflineEarnings, savedData.OfflineTime)
	else
		print("[MainServer] No offline earnings to show")
	end

	-- Check if player should see tutorial (for new players)
	TutorialService.CheckAndShowTutorial(player, savedData)

	print("========================================")
	print("[MainServer] PLAYER FULLY INITIALIZED:", player.Name)
	print("========================================")
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
	print("[MainServer] Player leaving:", player.Name)

	-- Save data
	SavingService.OnPlayerLeaving(player)

	-- Cleanup services
	CurrencyService.CleanupPlayer(player)
	BaseService.CleanupPlayer(player)
	PurchaseService.CleanupPlayer(player)
	UpgradeService.CleanupPlayer(player)
	
	-- Clear pending offline earnings
	PendingOfflineEarnings[player.UserId] = nil
end)

-- Handle claim requests
RequestClaimEvent.OnServerEvent:Connect(function(player)
	local claimed = CurrencyService.ClaimMoney(player)
	print("[MainServer]", player.Name, "claimed", claimed)
end)

-- Handle offline earnings claim
ClaimOfflineEarningsEvent.OnServerEvent:Connect(function(player)
	local pendingAmount = PendingOfflineEarnings[player.UserId]
	if not pendingAmount or pendingAmount <= 0 then
		return
	end
	
	CurrencyService.AddBalance(player, pendingAmount)
	PendingOfflineEarnings[player.UserId] = nil
end)

-- Shutdown handler (save all data)
game:BindToClose(function()
	print("[MainServer] Server shutting down, saving all data...")

	for _, player in Players:GetPlayers() do
		SavingService.SavePlayerData(player)
	end

	task.wait(3) -- Give time for saves to complete
end)

print("=== BRAINROT GAME SERVER READY ===")
