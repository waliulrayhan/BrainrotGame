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
local SpawnInterval = 5 -- Seconds between spawns
local MoveDuration = 30 -- Seconds to cross the lane (slower for better readability)

-- Performance: Use single loop for all characters instead of 50 separate Heartbeat connections
local ActiveCharacters = {}

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

	-- Start single Heartbeat loop for all character movement
	ShopLaneService.StartMovementLoop()

	-- Start spawning characters
	ShopLaneService.StartSpawning()

	print("[ShopLaneService] Initialized")
end

-- Single Heartbeat loop that updates all active characters (performance optimization)
function ShopLaneService.StartMovementLoop()
	game:GetService("RunService").Heartbeat:Connect(function()
		-- Iterate backwards to safely remove completed characters
		for i = #ActiveCharacters, 1, -1 do
			local charData = ActiveCharacters[i]
			
			-- Update returns true if movement is complete
			if ShopLaneService.UpdateCharacterMovement(charData) then
				table.remove(ActiveCharacters, i)
			end
		end
	end)
end

-- Update a single character's movement (returns true if complete)
function ShopLaneService.UpdateCharacterMovement(charData): boolean
	local characterModel = charData.model
	
	-- Check if character was purchased (stop movement)
	if characterModel:FindFirstChild("Purchased") then
		return true -- Remove from active list
	end
	
	-- Check if model still exists
	if not characterModel or not characterModel.Parent or not characterModel.PrimaryPart then
		return true -- Remove from active list
	end

	local elapsed = tick() - charData.startTime
	local alpha = math.min(elapsed / MoveDuration, 1)
	
	local currentX = charData.startX + (charData.endX - charData.startX) * alpha
	local currentPosition = Vector3.new(currentX, charData.posY, charData.posZ)
	
	characterModel:SetPrimaryPartCFrame(CFrame.new(currentPosition))
	
	if alpha >= 1 then
		-- Movement complete - destroy if not purchased
		if characterModel and characterModel.Parent == workspace and not characterModel:FindFirstChild("Purchased") then
			characterModel:Destroy()
		end
		return true -- Remove from active list
	end
	
	return false -- Keep updating
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

	-- Add to active characters list (single Heartbeat will update all)
	table.insert(ActiveCharacters, {
		model = characterModel,
		startTime = tick(),
		startX = startX,
		endX = endX,
		posY = lanePosition.Y + 3,
		posZ = lanePosition.Z,
	})
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

	-- Create billboard GUI attached to HumanoidRootPart
	local billboardPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
	if billboardPart then
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 120, 0, 60)
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
		frame.BackgroundColor3 = tierColors[characterData.tier] or UIConfig.Colors.Primary
		frame.BackgroundTransparency = 0 -- Fully opaque for readability
		frame.BorderSizePixel = 0
		frame.Parent = billboard

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame

		-- Character name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -6, 0, 20)
		nameLabel.Position = UDim2.new(0, 3, 0, 2)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = characterData.name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Pure white
		nameLabel.TextScaled = true
		nameLabel.Font = UIConfig.Fonts.Header
		nameLabel.Parent = frame
		
		-- Add strong text stroke for readability
		local nameStroke = Instance.new("UIStroke")
		nameStroke.Color = Color3.fromRGB(0, 0, 0)
		nameStroke.Thickness = 3
		nameStroke.Parent = nameLabel

		-- Price
		local priceLabel = Instance.new("TextLabel")
		priceLabel.Size = UDim2.new(1, -6, 0, 18)
		priceLabel.Position = UDim2.new(0, 3, 0, 22)
		priceLabel.BackgroundTransparency = 1
		priceLabel.Text = UIConfig.FormatMoney(characterData.price)
		priceLabel.TextColor3 = Color3.fromRGB(255, 255, 100) -- Bright yellow for visibility
		priceLabel.TextScaled = true
		priceLabel.Font = UIConfig.Fonts.Money
		priceLabel.Parent = frame
		
		-- Add text stroke
		local priceStroke = Instance.new("UIStroke")
		priceStroke.Color = Color3.fromRGB(0, 0, 0)
		priceStroke.Thickness = 3
		priceStroke.Parent = priceLabel

		-- EPS
		local epsLabel = Instance.new("TextLabel")
		epsLabel.Size = UDim2.new(1, -6, 0, 14)
		epsLabel.Position = UDim2.new(0, 3, 0, 42)
		epsLabel.BackgroundTransparency = 1
		epsLabel.Text = UIConfig.FormatEPS(characterData.earningsPerSecond)
		epsLabel.TextColor3 = Color3.fromRGB(150, 255, 150) -- Light green for earnings
		epsLabel.TextScaled = true
		epsLabel.Font = UIConfig.Fonts.Body
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

return ShopLaneService
