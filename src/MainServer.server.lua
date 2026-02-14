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
local BaseService = require(Services:WaitForChild("BaseService"))
local ShopLaneService = require(Services:WaitForChild("ShopLaneService"))
local PurchaseService = require(Services:WaitForChild("PurchaseService"))
local SavingService = require(Services:WaitForChild("SavingService"))

-- Remote events
local RequestClaimEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestClaim")

print("=== BRAINROT GAME SERVER STARTING ===")

-- Initialize services in correct order
CurrencyService.Initialize()
BaseService.Initialize(CurrencyService)
ShopLaneService.Initialize()
PurchaseService.Initialize(CurrencyService, BaseService)
SavingService.Initialize(CurrencyService, BaseService)

print("=== ALL SERVICES INITIALIZED ===")

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
	print("[MainServer] Player joined:", player.Name)

	-- Load saved data
	local savedData = SavingService.LoadPlayerData(player)

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
		BaseService.RestoreEarners(player, savedData.Earners)
	end

	print("[MainServer] Player fully initialized:", player.Name)
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
end)

-- Handle claim requests
RequestClaimEvent.OnServerEvent:Connect(function(player)
	local claimed = CurrencyService.ClaimMoney(player)
	print("[MainServer]", player.Name, "claimed", claimed)
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
