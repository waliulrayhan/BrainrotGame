--[[
	ShopLaneService.lua
	Spawns characters on the shop lane and moves them across the screen.
	Characters are clickable for purchase.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

	-- Position the character model
	local startPosition = Vector3.new(startX, lanePosition.Y + 3, lanePosition.Z)
	if characterModel.PrimaryPart then
		characterModel:SetPrimaryPartCFrame(CFrame.new(startPosition))
	else
		warn("[ShopLaneService] No PrimaryPart found for character")
		return
	end

	-- Tween across the lane using SetPrimaryPartCFrame in a loop for smooth movement
	local startTime = tick()
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		-- Check if character was purchased (stop movement)
		if characterModel:FindFirstChild("Purchased") then
			if connection then connection:Disconnect() end
			return
		end
		
		if not characterModel or not characterModel.Parent or not characterModel.PrimaryPart then
			if connection then connection:Disconnect() end
			return
		end

		local elapsed = tick() - startTime
		local alpha = math.min(elapsed / MoveDuration, 1)
		
		local currentX = startX + (endX - startX) * alpha
		local currentPosition = Vector3.new(currentX, lanePosition.Y + 3, lanePosition.Z)
		
		characterModel:SetPrimaryPartCFrame(CFrame.new(currentPosition))
		
		if alpha >= 1 then
			connection:Disconnect()
			-- Only destroy if character is still in workspace and hasn't been purchased
			if characterModel and characterModel.Parent == workspace and not characterModel:FindFirstChild("Purchased") then
				characterModel:Destroy()
			end
		end
	end)
end

-- Create a character model with billboard GUI
function ShopLaneService.CreateCharacterModel(characterData)
	-- Get the character model template from ReplicatedStorage
	local characterModelsFolder = ReplicatedStorage:FindFirstChild("CharacterModels")
	if not characterModelsFolder then
		warn("[ShopLaneService] CharacterModels folder not found in ReplicatedStorage!")
		return nil
	end

	local template = characterModelsFolder:FindFirstChild(characterData.modelKey)
	if not template then
		warn("[ShopLaneService] Model not found:", characterData.modelKey)
		return nil
	end

	-- Clone the model
	local model = template:Clone()
	model.Name = "ShopCharacter_" .. characterData.name

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

	-- Only anchor the primary part, don't touch other parts (Motor6Ds will handle movement)
	if model.PrimaryPart then
		model.PrimaryPart.Anchored = true
	end

	-- Disable collision for all parts
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	-- Store character data in the model
	local idValue = Instance.new("IntValue")
	idValue.Name = "CharacterId"
	idValue.Value = characterData.id
	idValue.Parent = model

	-- Add click detector to HumanoidRootPart or PrimaryPart
	local clickRoot = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
	if clickRoot then
		local clickDetector = Instance.new("ClickDetector")
		clickDetector.MaxActivationDistance = 32
		clickDetector.Parent = clickRoot
	end

	-- Create billboard GUI above the character
	local head = model:FindFirstChild("Head")
	if head then
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 200, 0, 100)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

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
	end

	model.Parent = workspace
	return model
end

return ShopLaneService
