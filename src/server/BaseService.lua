--[[
	BaseService.lua
	Manages player bases where purchased characters are placed and earn money.
	Handles EPS calculation and the earning loop.
	Now uses BasePadService for tier-based basepads.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Services = ServerScriptService:WaitForChild("Services")
local BasePadService = require(Services:WaitForChild("BasePadService"))

local BaseService = {}

local CurrencyService

function BaseService.Initialize(currencyService)
	CurrencyService = currencyService

	-- Initialize basepads
	BasePadService.Initialize()

	-- Start the earning loop
	BaseService.StartEarningLoop()

	print("[BaseService] Initialized")
end

-- Assign a base to a player (now handled by BasePadService)
-- This is kept for compatibility but basepads are tier-based now
function BaseService.AssignBase(player: Player): boolean
	-- Basepads are shared across all players per tier
	-- No need to assign individual bases anymore
	print("[BaseService] Player", player.Name, "can use tier-based basepads")
	return true
end

-- Add an earning character to a player's base (delegates to BasePadService)
function BaseService.AddEarner(player: Player, characterData, characterModel)
	-- Add character to the appropriate tier basepad
	local tier = characterData.tier or 1
	BasePadService.AddCharacter(tier, characterData, player, characterModel)

	print(
		"[BaseService] Added earner to",
		player.Name,
		"- Total EPS:",
		BaseService.GetTotalEPS(player)
	)
end

-- Calculate total earnings per second for a player
function BaseService.GetTotalEPS(player: Player): number
	return BasePadService.GetPlayerTotalEPS(player)
end

-- Get player's earners (for saving) - returns serializable data only
function BaseService.GetPlayerEarners(player: Player)
	return BasePadService.GetPlayerEarnersForSave(player)
end

-- Restore earners from saved data
function BaseService.RestoreEarners(player: Player, savedEarners)
	if not savedEarners then
		return
	end

	BasePadService.LoadPlayerCharacters(player, savedEarners)
	print("[BaseService] Restored", #savedEarners, "earners for", player.Name)
end

-- Earning loop - runs every second
function BaseService.StartEarningLoop()
	local lastUpdate = os.time()

	RunService.Heartbeat:Connect(function()
		local now = os.time()

		-- Run every 1 second
		if now - lastUpdate >= 1 then
			lastUpdate = now

			-- Process earnings for all players
			for _, player in Players:GetPlayers() do
				local eps = BaseService.GetTotalEPS(player)

				if eps > 0 then
					CurrencyService.AddUnclaimed(player, eps)
				end
			end
		end
	end)

	print("[BaseService] Earning loop started")
end

-- Cleanup when player leaves
function BaseService.CleanupPlayer(player: Player)
	BasePadService.ClearPlayerCharacters(player)
	print("[BaseService] Cleaned up player:", player.Name)
end

return BaseService
