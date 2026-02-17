--[[
	UpgradeConfig.lua
	Defines all upgrade types, their levels, costs, and effects.
]]

local UpgradeConfig = {}

-- Upgrade Definitions
UpgradeConfig.Upgrades = {
	ClaimMultiplier = {
		id = "ClaimMultiplier",
		name = "Claim Multiplier",
		description = "Multiply all claimed earnings",
		icon = "💰",
		maxLevel = 6,
		levels = {
			{
				level = 1,
				cost = 0, -- Starting level (default)
				multiplier = 1, -- 1x (no bonus)
				description = "Default claim rate",
			},
			{
				level = 2,
				cost = 50000,
				multiplier = 1.25, -- 1.25x
				description = "+25% claim bonus",
			},
			{
				level = 3,
				cost = 100000,
				multiplier = 1.5, -- 1.5x
				description = "+50% claim bonus",
			},
			{
				level = 4,
				cost = 200000,
				multiplier = 1.75, -- 1.75x
				description = "+75% claim bonus",
			},
			{
				level = 5,
				cost = 300000,
				multiplier = 2, -- 2x
				description = "+100% claim bonus",
			},
			{
				level = 6,
				cost = 500000,
				multiplier = 2.5, -- 2.5x
				description = "+150% claim bonus",
			},
		},
	},
	DeliverySpeed = {
		id = "DeliverySpeed",
		name = "Delivery Speed",
		description = "Increase earning speed for all characters",
		icon = "⚡",
		maxLevel = 6,
		levels = {
			{
				level = 1,
				cost = 0, -- Starting level (default)
				multiplier = 1, -- 1x (normal speed)
				description = "Default earning speed",
			},
			{
				level = 2,
				cost = 100000,
				multiplier = 2, -- 2x (100% faster)
				description = "+100% earning speed",
			},
			{
				level = 3,
				cost = 150000,
				multiplier = 3, -- 3x (200% faster)
				description = "+200% earning speed",
			},
			{
				level = 4,
				cost = 250000,
				multiplier = 4, -- 4x (300% faster)
				description = "+300% earning speed",
			},
			{
				level = 5,
				cost = 400000,
				multiplier = 5, -- 5x (400% faster)
				description = "+400% earning speed",
			},
			{
				level = 6,
				cost = 600000,
				multiplier = 7, -- 7x (600% faster)
				description = "+600% earning speed",
			},
		},
	},
}

-- Get upgrade data by ID
function UpgradeConfig.GetUpgrade(upgradeId: string)
	return UpgradeConfig.Upgrades[upgradeId]
end

-- Get level data for an upgrade
function UpgradeConfig.GetLevelData(upgradeId: string, level: number)
	local upgrade = UpgradeConfig.GetUpgrade(upgradeId)
	if not upgrade then
		return nil
	end
	
	for _, levelData in ipairs(upgrade.levels) do
		if levelData.level == level then
			return levelData
		end
	end
	
	return nil
end

-- Get next level data (returns nil if at max level)
function UpgradeConfig.GetNextLevelData(upgradeId: string, currentLevel: number)
	local upgrade = UpgradeConfig.GetUpgrade(upgradeId)
	if not upgrade then
		return nil
	end
	
	local nextLevel = currentLevel + 1
	if nextLevel > upgrade.maxLevel then
		return nil -- Already at max level
	end
	
	return UpgradeConfig.GetLevelData(upgradeId, nextLevel)
end

-- Check if upgrade is at max level
function UpgradeConfig.IsMaxLevel(upgradeId: string, currentLevel: number): boolean
	local upgrade = UpgradeConfig.GetUpgrade(upgradeId)
	if not upgrade then
		return true
	end
	
	return currentLevel >= upgrade.maxLevel
end

return UpgradeConfig
