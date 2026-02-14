--[[
	BaseService.lua
	Manages player bases where purchased characters are placed and earn money.
	Handles EPS calculation and the earning loop.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BaseService = {}

-- Store base assignments and earners
local PlayerBases = {} -- {[UserId] = BasePad}
local BaseEarners = {} -- {[UserId] = {character1, character2, ...}}

local CurrencyService

function BaseService.Initialize(currencyService)
	CurrencyService = currencyService

	-- Start the earning loop
	BaseService.StartEarningLoop()

	print("[BaseService] Initialized")
end

-- Assign a base to a player
function BaseService.AssignBase(player: Player): Part?
	local bases = workspace:FindFirstChild("Bases")
	if not bases then
		warn("[BaseService] No Bases folder in workspace!")
		return nil
	end

	-- Find an unassigned base
	for _, basePad in bases:GetChildren() do
		if basePad:IsA("BasePart") and basePad.Name == "BasePad" then
			local assigned = false

			-- Check if already assigned
			for _, assignedBase in PlayerBases do
				if assignedBase == basePad then
					assigned = true
					break
				end
			end

			if not assigned then
				PlayerBases[player.UserId] = basePad
				BaseEarners[player.UserId] = {}

				-- Visual feedback (optional - change base color)
				basePad.BrickColor = BrickColor.new("Bright blue")

				print("[BaseService] Assigned base to player:", player.Name)
				return basePad
			end
		end
	end

	warn("[BaseService] No available bases for player:", player.Name)
	return nil
end

-- Add an earning character to a player's base
function BaseService.AddEarner(player: Player, characterData)
	if not BaseEarners[player.UserId] then
		BaseEarners[player.UserId] = {}
	end

	table.insert(BaseEarners[player.UserId], {
		id = characterData.id,
		name = characterData.name,
		eps = characterData.earningsPerSecond,
	})

	print(
		"[BaseService] Added earner to",
		player.Name,
		"- Total EPS:",
		BaseService.GetTotalEPS(player)
	)
end

-- Calculate total earnings per second for a player
function BaseService.GetTotalEPS(player: Player): number
	if not BaseEarners[player.UserId] then
		return 0
	end

	local totalEPS = 0
	for _, earner in BaseEarners[player.UserId] do
		totalEPS += earner.eps
	end

	return totalEPS
end

-- Get player's base
function BaseService.GetPlayerBase(player: Player): Part?
	return PlayerBases[player.UserId]
end

-- Get player's earners (for saving)
function BaseService.GetPlayerEarners(player: Player)
	return BaseEarners[player.UserId] or {}
end

-- Restore earners from saved data
function BaseService.RestoreEarners(player: Player, savedEarners)
	if not savedEarners then
		return
	end

	BaseEarners[player.UserId] = savedEarners
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
	PlayerBases[player.UserId] = nil
	BaseEarners[player.UserId] = nil
	print("[BaseService] Cleaned up player:", player.Name)
end

return BaseService
