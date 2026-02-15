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
function BasePadService.AddCharacter(tier: number, characterData, player: Player)
	if not BasePads[tier] then
		warn("[BasePadService] No basepad found for tier", tier)
		return nil
	end

	if not BasePadCharacters[tier] then
		BasePadCharacters[tier] = {}
	end

	-- Create character model on the basepad
	local characterModel = BasePadService.CreateCharacterModel(characterData, tier, player)

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

	-- Create the character model
	local model = Instance.new("Model")
	model.Name = characterData.name .. "_" .. player.Name

	local part = Instance.new("Part")
	part.Name = "Character"
	part.Size = characterData.size
	part.Color = characterData.color
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false
	part.Parent = model

	-- Position on the basepad - arrange characters in a grid
	local position = BasePadService.GetNextCharacterPosition(tier, basePad)
	part.Position = position

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
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 150, 0, 50)
	billboard.StudsOffset = Vector3.new(0, characterData.size.Y / 2 + 1, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.BorderSizePixel = 0
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -10, 0.5, 0)
	nameLabel.Position = UDim2.new(0, 5, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = characterData.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Parent = frame

	local epsLabel = Instance.new("TextLabel")
	epsLabel.Size = UDim2.new(1, -10, 0.5, 0)
	epsLabel.Position = UDim2.new(0, 5, 0.5, 0)
	epsLabel.BackgroundTransparency = 1
	epsLabel.Text = "$" .. characterData.earningsPerSecond .. "/s"
	epsLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
	epsLabel.TextScaled = true
	epsLabel.Font = Enum.Font.Gotham
	epsLabel.Parent = frame

	model.Parent = workspace
	return model
end

-- Get the next position for a character on a basepad (grid layout)
function BasePadService.GetNextCharacterPosition(tier: number, basePad: BasePart): Vector3
	local charactersOnPad = BasePadCharacters[tier] or {}
	local count = #charactersOnPad

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
