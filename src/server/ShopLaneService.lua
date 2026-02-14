--[[
	ShopLaneService.lua
	Spawns characters on the shop lane and moves them across the screen.
	Characters are clickable for purchase.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local CharacterConfig = require(ReplicatedStorage.Shared.Config.CharacterConfig)
local UIConfig = require(ReplicatedStorage.Shared.Config.UIConfig)

local ShopLaneService = {}

local LanePath
local SpawnInterval = 3 -- Seconds between spawns
local MoveDuration = 15 -- Seconds to cross the lane

function ShopLaneService.Initialize()
	-- Get the lane path
	local shopLane = workspace:FindFirstChild("ShopLane")
	if not shopLane then
		warn("[ShopLaneService] No ShopLane folder in workspace!")
		return
	end

	LanePath = shopLane:FindFirstChild("LanePath")
	if not LanePath then
		warn("[ShopLaneService] No LanePath part in ShopLane!")
		return
	end

	-- Start spawning characters
	ShopLaneService.StartSpawning()

	print("[ShopLaneService] Initialized")
end

-- Start the character spawning loop
function ShopLaneService.StartSpawning()
	task.spawn(function()
		while true do
			task.wait(SpawnInterval)
			ShopLaneService.SpawnCharacter()
		end
	end)
end

-- Spawn a random character on the lane
function ShopLaneService.SpawnCharacter()
	if not LanePath then
		return
	end

	local characterData = CharacterConfig.GetRandomCharacter()
	local characterModel = ShopLaneService.CreateCharacterModel(characterData)

	-- Position at start of lane (left side)
	local laneSize = LanePath.Size
	local lanePosition = LanePath.Position
	local startX = lanePosition.X - (laneSize.X / 2)
	local endX = lanePosition.X + (laneSize.X / 2)

	characterModel.Position = Vector3.new(startX, lanePosition.Y + 3, lanePosition.Z)

	-- Tween across the lane
	local tweenInfo = TweenInfo.new(
		MoveDuration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)

	local goal = { Position = Vector3.new(endX, lanePosition.Y + 3, lanePosition.Z) }
	local tween = TweenService:Create(characterModel, tweenInfo, goal)

	tween:Play()

	-- Cleanup when tween completes
	tween.Completed:Connect(function()
		if characterModel and characterModel.Parent then
			characterModel:Destroy()
		end
	end)
end

-- Create a character model with billboard GUI
function ShopLaneService.CreateCharacterModel(characterData)
	-- Create the physical model
	local model = Instance.new("Model")
	model.Name = "ShopCharacter_" .. characterData.name

	local part = Instance.new("Part")
	part.Name = "HitBox"
	part.Size = characterData.size
	part.Color = characterData.color
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false
	part.Parent = model

	-- Store character data in the model
	local idValue = Instance.new("IntValue")
	idValue.Name = "CharacterId"
	idValue.Value = characterData.id
	idValue.Parent = model

	-- Add click detector
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 32
	clickDetector.Parent = part

	-- Create billboard GUI
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 200, 0, 100)
	billboard.StudsOffset = Vector3.new(0, characterData.size.Y / 2 + 1.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = UIConfig.Colors.Primary
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	-- Character name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -10, 0, 30)
	nameLabel.Position = UDim2.new(0, 5, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = characterData.name
	nameLabel.TextColor3 = UIConfig.Colors.Text
	nameLabel.TextScaled = true
	nameLabel.Font = UIConfig.Fonts.Header
	nameLabel.Parent = frame

	-- Price
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(1, -10, 0, 25)
	priceLabel.Position = UDim2.new(0, 5, 0, 38)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = UIConfig.FormatMoney(characterData.price)
	priceLabel.TextColor3 = UIConfig.Colors.Success
	priceLabel.TextScaled = true
	priceLabel.Font = UIConfig.Fonts.Money
	priceLabel.Parent = frame

	-- EPS
	local epsLabel = Instance.new("TextLabel")
	epsLabel.Size = UDim2.new(1, -10, 0, 20)
	epsLabel.Position = UDim2.new(0, 5, 0, 68)
	epsLabel.BackgroundTransparency = 1
	epsLabel.Text = UIConfig.FormatEPS(characterData.earningsPerSecond)
	epsLabel.TextColor3 = UIConfig.Colors.Accent
	epsLabel.TextScaled = true
	epsLabel.Font = UIConfig.Fonts.Body
	epsLabel.Parent = frame

	model.Parent = workspace
	return part
end

return ShopLaneService
