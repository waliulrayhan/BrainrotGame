--[[
	CharacterConfig.lua
	Defines all character tiers with their prices, earnings per second (EPS),
	visual properties, and spawn weights.
]]

local CharacterConfig = {}

CharacterConfig.Characters = {
	{
		id = 1,
		tier = 1,
		name = "Tiny Brainrot",
		modelKey = "Brainrot_T1",
		price = 0,
		earningsPerSecond = 1,
		color = Color3.fromRGB(80, 100, 120), -- Dark Blue-Gray
		size = Vector3.new(2, 2, 2),
		spawnWeight = 40, -- Higher weight = more common
		description = "The smallest brainrot",
	},
	{
		id = 2,
		tier = 2,
		name = "Better Brainrot",
		modelKey = "Brainrot_T2",
		price = 25,
		earningsPerSecond = 3,
		color = Color3.fromRGB(60, 160, 100), -- Dark Mint Green
		size = Vector3.new(2.5, 2.5, 2.5),
		spawnWeight = 30,
		description = "Getting better at brainrot",
	},
	{
		id = 3,
		tier = 3,
		name = "Epic Brainrot",
		modelKey = "Brainrot_T3",
		price = 150,
		earningsPerSecond = 10,
		color = Color3.fromRGB(30, 100, 200), -- Deep Blue
		size = Vector3.new(3, 3, 3),
		spawnWeight = 20,
		description = "Epic level brainrot",
	},
	{
		id = 4,
		tier = 4,
		name = "Mythic Brainrot",
		modelKey = "Brainrot_T4",
		price = 800,
		earningsPerSecond = 40,
		color = Color3.fromRGB(130, 60, 200), -- Deep Purple
		size = Vector3.new(3.5, 3.5, 3.5),
		spawnWeight = 15,
		description = "Mythical brainrot power",
	},
	{
		id = 5,
		tier = 5,
		name = "Legend Brainrot",
		modelKey = "Brainrot_T5",
		price = 3500,
		earningsPerSecond = 120,
		color = Color3.fromRGB(220, 100, 60), -- Deep Coral
		size = Vector3.new(4, 4, 4),
		spawnWeight = 8,
		description = "Legendary brainrot master",
	},
}

-- Calculate total spawn weight for weighted random selection
CharacterConfig.TotalSpawnWeight = 0
for _, character in CharacterConfig.Characters do
	CharacterConfig.TotalSpawnWeight += character.spawnWeight
end

-- Helper function to get character by ID
function CharacterConfig.GetCharacterById(id: number)
	for _, character in CharacterConfig.Characters do
		if character.id == id then
			return character
		end
	end
	return nil
end

-- Helper function to get random character based on spawn weights
function CharacterConfig.GetRandomCharacter()
	local random = Random.new()
	local roll = random:NextInteger(1, CharacterConfig.TotalSpawnWeight)
	local currentWeight = 0

	for _, character in CharacterConfig.Characters do
		currentWeight += character.spawnWeight
		if roll <= currentWeight then
			return character
		end
	end

	-- Fallback to first character (should never happen)
	return CharacterConfig.Characters[1]
end

return CharacterConfig
