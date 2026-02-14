--[[
	CharacterConfig.lua
	Defines all character tiers with their prices, earnings per second (EPS),
	visual properties, and spawn weights.
]]

local CharacterConfig = {}

CharacterConfig.Characters = {
	{
		id = 1,
		name = "Skibidi Starter",
		price = 0,
		earningsPerSecond = 1,
		color = Color3.fromRGB(150, 150, 150), -- Gray
		size = Vector3.new(2, 2, 2),
		spawnWeight = 40, -- Higher weight = more common
		description = "The beginning of brainrot",
	},
	{
		id = 2,
		name = "Rizz Collector",
		price = 25,
		earningsPerSecond = 3,
		color = Color3.fromRGB(100, 200, 100), -- Green
		size = Vector3.new(2.5, 2.5, 2.5),
		spawnWeight = 30,
		description = "Gathering rizz points",
	},
	{
		id = 3,
		name = "Sigma Grinder",
		price = 150,
		earningsPerSecond = 10,
		color = Color3.fromRGB(100, 100, 255), -- Blue
		size = Vector3.new(3, 3, 3),
		spawnWeight = 20,
		description = "Grinding on the sigma wavelength",
	},
	{
		id = 4,
		name = "Gyatt Farmer",
		price = 800,
		earningsPerSecond = 40,
		color = Color3.fromRGB(255, 165, 0), -- Orange
		size = Vector3.new(3.5, 3.5, 3.5),
		spawnWeight = 15,
		description = "Farming gyatts all day",
	},
	{
		id = 5,
		name = "Ohio Final Boss",
		price = 3500,
		earningsPerSecond = 120,
		color = Color3.fromRGB(200, 0, 200), -- Purple
		size = Vector3.new(4, 4, 4),
		spawnWeight = 8,
		description = "Only in Ohio",
	},
	{
		id = 6,
		name = "Fanum Tax King",
		price = 15000,
		earningsPerSecond = 400,
		color = Color3.fromRGB(255, 215, 0), -- Gold
		size = Vector3.new(4.5, 4.5, 4.5),
		spawnWeight = 4,
		description = "Taxing everyone's food",
	},
	{
		id = 7,
		name = "Mewing Master",
		price = 60000,
		earningsPerSecond = 1200,
		color = Color3.fromRGB(0, 255, 255), -- Cyan
		size = Vector3.new(5, 5, 5),
		spawnWeight = 2,
		description = "Perfect jawline achieved",
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
