--[[
	CharacterFilter.client.lua
	Client-side script that hides other players' basepad characters.
	Each player should only see their own purchased characters.
]]

local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerName = player.Name

print("[CharacterFilter] Starting for player:", playerName)

-- Function to check if a model is a basepad character
local function isBasePadCharacter(model)
	if not model:IsA("Model") then
		return false
	end
	
	-- Check if it has an Owner value (basepad characters have this)
	local ownerValue = model:FindFirstChild("Owner")
	local tierValue = model:FindFirstChild("Tier")
	
	return ownerValue ~= nil and tierValue ~= nil
end

-- Function to filter a character model based on ownership
local function filterCharacter(model)
	if not isBasePadCharacter(model) then
		return
	end
	
	local ownerValue = model:FindFirstChild("Owner")
	if not ownerValue then
		return
	end
	
	-- If this character doesn't belong to the local player, hide it
	if ownerValue.Value ~= playerName then
		-- Hide all parts of the model
		for _, descendant in pairs(model:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.LocalTransparencyModifier = 1 -- Make invisible to this client
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.LocalTransparencyModifier = 1
			elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
				descendant.Enabled = false -- Hide UI elements
			end
		end
		
		print("[CharacterFilter] Hid character:", model.Name, "owned by", ownerValue.Value)
	else
		print("[CharacterFilter] Showing character:", model.Name, "owned by", ownerValue.Value)
	end
end

-- Function to monitor existing and new characters
local function setupFiltering()
	-- Filter existing characters in workspace
	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") then
			filterCharacter(model)
		end
	end
	
	-- Monitor for new characters being added
	workspace.DescendantAdded:Connect(function(descendant)
		-- When a new model is added, check if it becomes a basepad character
		if descendant:IsA("Model") then
			-- Wait a bit for the Owner value to be set
			task.wait(0.1)
			filterCharacter(descendant)
		end
		
		-- Also watch for Owner values being added to existing models
		if descendant.Name == "Owner" and descendant:IsA("StringValue") then
			local model = descendant.Parent
			if model and model:IsA("Model") then
				-- Owner value was just added, filter immediately
				filterCharacter(model)
			end
		end
	end)
	
	print("[CharacterFilter] Filtering active")
end

-- Start filtering after a short delay to ensure workspace is loaded
task.wait(1)
setupFiltering()
