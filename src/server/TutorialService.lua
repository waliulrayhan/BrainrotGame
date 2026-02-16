--[[
	TutorialService.lua
	Manages the tutorial state and communicates with clients about tutorial display.
	Checks if player has seen tutorial and triggers it for new players.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TutorialService = {}

-- Remote Events
local ShowTutorialEvent
local TutorialCompletedEvent

function TutorialService.Initialize()
	-- Get remote events (they exist from project.json)
	local remotes = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes")
	
	ShowTutorialEvent = remotes:WaitForChild("ShowTutorial")
	TutorialCompletedEvent = remotes:WaitForChild("TutorialCompleted")
	
	-- Listen for tutorial completion from client
	TutorialCompletedEvent.OnServerEvent:Connect(function(player)
		print("[TutorialService]", player.Name, "completed the tutorial")
		-- Server acknowledges - data will be saved automatically by SavingService
	end)
	
	print("[TutorialService] Initialized")
end

-- Check if player should see tutorial and trigger it
function TutorialService.CheckAndShowTutorial(player: Player, savedData)
	-- Show tutorial if player hasn't seen it before
	local hasSeenTutorial = savedData and savedData.HasSeenTutorial or false
	
	if not hasSeenTutorial then
		-- Wait a moment for client to be ready
		task.wait(0.5)
		
		print("[TutorialService] Showing tutorial to new player:", player.Name)
		ShowTutorialEvent:FireClient(player)
	else
		print("[TutorialService] Player", player.Name, "has already seen tutorial")
	end
end

return TutorialService
