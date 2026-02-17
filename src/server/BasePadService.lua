--[[
	BasePadService.lua
	Manages 5 tier-specific basepads where characters spawn after purchase.
	Each tier has its own dedicated basepad.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterConfig = require(ReplicatedStorage.Shared.Config.CharacterConfig)

local BasePadService = {}

-- Store basepad references by tier
local BasePads = {} -- {[tier] = BasePad}
local BasePadCharacters = {} -- {[tier] = {character1, character2, ...}}

function BasePadService.Initialize()
	local basePadsFolder = workspace:FindFirstChild("BasePads")
	if not basePadsFolder then
		warn("[BasePadService] No BasePads folder in workspace! Creating one...")
		basePadsFolder = Instance.new("Folder")
		basePadsFolder.Name = "BasePads"
		basePadsFolder.Parent = workspace
	end

	-- Find and assign basepads for each tier (1-5)
	for tier = 1, 5 do
		local padName = "BasePad_T" .. tier
		local basePad = basePadsFolder:FindFirstChild(padName)
		
		if basePad and basePad:IsA("BasePart") then
			BasePads[tier] = basePad
			BasePadCharacters[tier] = {}
			print("[BasePadService] Found basepad for Tier", tier)
		else
			warn("[BasePadService] Missing basepad:", padName)
		end
	end

	print("[BasePadService] Initialized with", #BasePads, "basepads")
end

-- Get basepad for a specific tier
function BasePadService.GetBasePad(tier: number): Part?
	return BasePads[tier]
end

-- Add a character to a tier's basepad
function BasePadService.AddCharacter(tier: number, characterData, player: Player, existingModel)
	if not BasePads[tier] then
		warn("[BasePadService] No basepad found for tier", tier)
		return nil
	end

	if not BasePadCharacters[tier] then
		BasePadCharacters[tier] = {}
	end

	-- Create or move character model to the basepad
	local characterModel = BasePadService.CreateOrMoveCharacterModel(characterData, tier, player, existingModel)

	-- Store character data
	table.insert(BasePadCharacters[tier], {
		id = characterData.id,
		name = characterData.name,
		eps = characterData.earningsPerSecond,
		model = characterModel,
		owner = player.UserId,
	})

	print("[BasePadService] Added", characterData.name, "to Tier", tier, "basepad for player", player.Name)
	return characterModel
end

-- Create a character model on the basepad
function BasePadService.CreateCharacterModel(characterData, tier: number, player: Player)
	local basePad = BasePads[tier]
	if not basePad then
		return nil
	end

	-- Get the character model template from ReplicatedStorage
	local characterModelsFolder = ReplicatedStorage:FindFirstChild("CharacterModels")
	if not characterModelsFolder then
		warn("[BasePadService] CharacterModels folder not found in ReplicatedStorage!")
		return nil
	end

	local template = characterModelsFolder:FindFirstChild(characterData.modelKey)
	if not template then
		warn("[BasePadService] Model not found:", characterData.modelKey)
		return nil
	end

	-- Clone the model
	local model = template:Clone()
	model.Name = characterData.name .. "_" .. player.Name

	-- Find humanoid and set properties
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayDistance = 0
		humanoid.NameDisplayDistance = 0
	end

	-- Make sure we have a PrimaryPart
	local rootPart = model:FindFirstChild("HumanoidRootPart")
	if rootPart then
		model.PrimaryPart = rootPart
	end

	-- Only anchor the primary part
	if model.PrimaryPart then
		model.PrimaryPart.Anchored = true
	end

	-- Disable collision for all parts and apply tier color
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			-- Apply character color to body parts
			if part.Name ~= "HumanoidRootPart" then
				part.Color = characterData.color
			end
		end
	end

	-- Position on the basepad - arrange characters in a grid
	local position = BasePadService.GetNextCharacterPosition(tier, basePad, player)
	if model.PrimaryPart then
		model:SetPrimaryPartCFrame(CFrame.new(position))
	end

	-- Store owner and character data
	local ownerValue = Instance.new("StringValue")
	ownerValue.Name = "Owner"
	ownerValue.Value = player.Name
	ownerValue.Parent = model

	local tierValue = Instance.new("IntValue")
	tierValue.Name = "Tier"
	tierValue.Value = tier
	tierValue.Parent = model

	local idValue = Instance.new("IntValue")
	idValue.Name = "CharacterId"
	idValue.Value = characterData.id
	idValue.Parent = model

	-- Add a name tag
	local billboardPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
	if billboardPart then
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = billboardPart

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		
		-- Color based on tier (Darker, more readable colors)
		local tierColors = {
			Color3.fromRGB(80, 100, 120),   -- Tier 1: Dark Blue-Gray
			Color3.fromRGB(60, 160, 100),   -- Tier 2: Dark Mint Green
			Color3.fromRGB(30, 100, 200),   -- Tier 3: Deep Blue
			Color3.fromRGB(130, 60, 200),   -- Tier 4: Deep Purple
			Color3.fromRGB(220, 100, 60),   -- Tier 5: Deep Coral
		}
		frame.BackgroundColor3 = tierColors[tier] or Color3.fromRGB(35, 45, 60)
		frame.BackgroundTransparency = 0.1 -- More opaque
		frame.BorderSizePixel = 0
		frame.Parent = billboard

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -6, 0.5, 0)
		nameLabel.Position = UDim2.new(0, 3, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = characterData.name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.Parent = frame
		
		-- Add text stroke for readability
		local nameStroke = Instance.new("UIStroke")
		nameStroke.Color = Color3.fromRGB(0, 0, 0)
		nameStroke.Thickness = 2
		nameStroke.Parent = nameLabel

		local epsLabel = Instance.new("TextLabel")
		epsLabel.Size = UDim2.new(1, -6, 0.5, 0)
		epsLabel.Position = UDim2.new(0, 3, 0.5, 0)
		epsLabel.BackgroundTransparency = 1
		epsLabel.Text = "$" .. characterData.earningsPerSecond .. "/s"
		epsLabel.TextColor3 = Color3.fromRGB(150, 255, 150) -- Light green
		epsLabel.TextScaled = true
		epsLabel.Font = Enum.Font.Gotham
		epsLabel.Parent = frame
		
		-- Add text stroke
		local epsStroke = Instance.new("UIStroke")
		epsStroke.Color = Color3.fromRGB(0, 0, 0)
		epsStroke.Thickness = 2
		epsStroke.Parent = epsLabel
	end

	model.Parent = workspace
	return model
end

-- Create or move a character model to the basepad
function BasePadService.CreateOrMoveCharacterModel(characterData, tier: number, player: Player, existingModel)
	local basePad = BasePads[tier]
	if not basePad then
		return nil
	end

	-- Get the target position on the basepad
	local targetPosition = BasePadService.GetNextCharacterPosition(tier, basePad, player)

	-- If we have an existing model from the shop lane, move it
	if existingModel then
		-- Mark as purchased to stop shop lane movement
		local purchasedFlag = Instance.new("BoolValue")
		purchasedFlag.Name = "Purchased"
		purchasedFlag.Value = true
		purchasedFlag.Parent = existingModel
		
		-- Update model name
		existingModel.Name = characterData.name .. "_" .. player.Name
		
		-- Find the root part and ensure PrimaryPart is set
		local rootPart = existingModel:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			rootPart = existingModel.PrimaryPart
		end
		
		if rootPart then
			-- Ensure the model has a PrimaryPart set
			if not existingModel.PrimaryPart then
				existingModel.PrimaryPart = rootPart
			end
			
			-- Remove click detector (no longer needed)
			local clickDetector = rootPart:FindFirstChild("ClickDetector")
			if clickDetector then
				clickDetector:Destroy()
			end
			
			-- Only anchor the primary part
			rootPart.Anchored = true
			
			-- Tween the entire character model to the basepad using SetPrimaryPartCFrame
			local startTime = tick()
			local startCFrame = rootPart.CFrame
			local targetCFrame = CFrame.new(targetPosition)
			local duration = 1.5
			
			print("[BasePadService] Moving", characterData.name, "to basepad. Start:", startCFrame.Position, "End:", targetPosition)
			
			local connection
			connection = game:GetService("RunService").Heartbeat:Connect(function()
				if not existingModel or not existingModel.Parent or not existingModel.PrimaryPart then
					if connection then connection:Disconnect() end
					print("[BasePadService] Movement stopped - model or parts missing")
					return
				end
				
				local elapsed = tick() - startTime
				local alpha = math.min(elapsed / duration, 1)
				-- Use quad easing out
				local easedAlpha = 1 - (1 - alpha) * (1 - alpha)
				
				local currentCFrame = startCFrame:Lerp(targetCFrame, easedAlpha)
				existingModel:SetPrimaryPartCFrame(currentCFrame)
				
				if alpha >= 1 then
					print("[BasePadService] Movement complete for", characterData.name)
					connection:Disconnect()
				end
			end)
		else
			warn("[BasePadService] No HumanoidRootPart or PrimaryPart found in purchased character!")
		end
		
		-- Add or update owner value
		local ownerValue = existingModel:FindFirstChild("Owner")
		if not ownerValue then
			ownerValue = Instance.new("StringValue")
			ownerValue.Name = "Owner"
			ownerValue.Parent = existingModel
		end
		ownerValue.Value = player.Name

		-- Add or update tier value
		local tierValue = existingModel:FindFirstChild("Tier")
		if not tierValue then
			tierValue = Instance.new("IntValue")
			tierValue.Name = "Tier"
			tierValue.Parent = existingModel
		end
		tierValue.Value = tier

		return existingModel
	else
		-- Create a new character model (for loading saved data)
		return BasePadService.CreateCharacterModel(characterData, tier, player)
	end
end

-- Get the next position for a character on a basepad (grid layout)
function BasePadService.GetNextCharacterPosition(tier: number, basePad: BasePart, player: Player): Vector3
	local charactersOnPad = BasePadCharacters[tier] or {}
	
	-- Count only this player's characters on this tier
	local playerCharacterCount = 0
	for _, character in ipairs(charactersOnPad) do
		if character.owner == player.UserId then
			playerCharacterCount = playerCharacterCount + 1
		end
	end
	
	local count = playerCharacterCount

	-- Arrange in rows of 4
	local spacing = 5
	local row = math.floor(count / 4)
	local col = count % 4

	local basePadPos = basePad.Position
	local basePadSize = basePad.Size

	-- Calculate offset from center
	local offsetX = (col - 1.5) * spacing
	local offsetZ = (row - 1.5) * spacing
	local offsetY = basePadSize.Y / 2 + 2

	return Vector3.new(
		basePadPos.X + offsetX,
		basePadPos.Y + offsetY,
		basePadPos.Z + offsetZ
	)
end

-- Get all characters for a specific player across all basepads
function BasePadService.GetPlayerCharacters(player: Player)
	local playerCharacters = {}

	for tier, characters in pairs(BasePadCharacters) do
		for _, character in ipairs(characters) do
			if character.owner == player.UserId then
				table.insert(playerCharacters, character)
			end
		end
	end

	return playerCharacters
end

-- Get serializable earner data for saving (no Roblox Instances!)
function BasePadService.GetPlayerEarnersForSave(player: Player)
	local earnerData = {}

	for tier, characters in pairs(BasePadCharacters) do
		for _, character in ipairs(characters) do
			if character.owner == player.UserId then
				-- Only save the character ID, not the model or other non-serializable data
				table.insert(earnerData, {
					id = character.id,
				})
			end
		end
	end

	return earnerData
end

-- Calculate total EPS for a player across all basepads
function BasePadService.GetPlayerTotalEPS(player: Player): number
	local totalEPS = 0
	local playerCharacters = BasePadService.GetPlayerCharacters(player)

	for _, character in ipairs(playerCharacters) do
		totalEPS += character.eps
	end

	return totalEPS
end

-- Clear all characters for a player (for loading saved data)
function BasePadService.ClearPlayerCharacters(player: Player)
	for tier, characters in pairs(BasePadCharacters) do
		for i = #characters, 1, -1 do
			if characters[i].owner == player.UserId then
				if characters[i].model then
					characters[i].model:Destroy()
				end
				table.remove(characters, i)
			end
		end
	end
end

-- Load saved characters for a player
function BasePadService.LoadPlayerCharacters(player: Player, savedEarners)
	if not savedEarners then
		return
	end

	for _, earnerData in ipairs(savedEarners) do
		local characterData = CharacterConfig.GetCharacterById(earnerData.id)
		if characterData then
			BasePadService.AddCharacter(characterData.tier, characterData, player)
		end
	end
end

return BasePadService
