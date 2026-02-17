--[[
	UIController.client.lua
	Client-side controller that handles UI updates and user interactions.
	Communicates with server via RemoteEvents.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local UIConfig = require(ReplicatedStorage.Shared.Config.UIConfig)
local UpgradeConfig = require(ReplicatedStorage.Shared.Config.UpgradeConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Events
local StateUpdateEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("StateUpdate")
local RequestBuyEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestBuy")
local RequestClaimEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestClaim")
local PurchaseFeedbackEvent = ReplicatedStorage:WaitForChild("Shared")
	:WaitForChild("Remotes")
	:WaitForChild("PurchaseFeedback")
local ShowTutorialEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("ShowTutorial")
local TutorialCompletedEvent = ReplicatedStorage:WaitForChild("Shared")
	:WaitForChild("Remotes")
	:WaitForChild("TutorialCompleted")

-- Upgrade & Offline Earnings Events
local UpgradeUpdateEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("UpgradeUpdate")
local RequestUpgradeEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("RequestUpgrade")
local ShowOfflineEarningsEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("ShowOfflineEarnings")
local ClaimOfflineEarningsEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("ClaimOfflineEarnings")

-- UI Elements (wait longer for UI to be created)
local mainHud = playerGui:WaitForChild("MainHUD", 30) -- Wait up to 30 seconds
local topBar = mainHud and mainHud:WaitForChild("TopBar", 10)
-- Labels are inside containers, not directly in TopBar!
local balanceContainer = topBar and topBar:WaitForChild("BalanceContainer", 10)
local balanceLabel = balanceContainer and balanceContainer:WaitForChild("BalanceLabel", 10)
local unclaimedContainer = topBar and topBar:WaitForChild("UnclaimedContainer", 10)
local unclaimedLabel = unclaimedContainer and unclaimedContainer:WaitForChild("UnclaimedLabel", 10)
local claimSection = mainHud and mainHud:WaitForChild("ClaimSection", 10)
local claimButton = claimSection and claimSection:WaitForChild("ClaimButton", 10)
local notifications = mainHud and mainHud:WaitForChild("Notifications", 10)

-- Current values for animation
local currentBalance = 0
local currentUnclaimed = 0
local displayBalance = 0
local displayUnclaimed = 0

-- Upgrade state
local playerUpgrades = {
	ClaimMultiplier = 1,
	DeliverySpeed = 1,
}

local upgradeScreenGui = nil

local UIController = {}

-- Update UI values with animation
function UIController.StartUpdateLoop()
	-- Skip if UI doesn't exist yet (check ALL required elements)
	if not mainHud or not balanceLabel or not unclaimedLabel or not claimButton then
		print("[UIController] UI not found - create MainHUD in StarterGui!")
		return
	end
	
	local animationSpeed = 0.15

	game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
		-- Animate balance
		if math.abs(displayBalance - currentBalance) > 0.1 then
			displayBalance = displayBalance + (currentBalance - displayBalance) * (deltaTime / animationSpeed)
		else
			displayBalance = currentBalance
		end

		-- Animate unclaimed
		if math.abs(displayUnclaimed - currentUnclaimed) > 0.1 then
			displayUnclaimed = displayUnclaimed + (currentUnclaimed - displayUnclaimed) * (deltaTime / animationSpeed)
		else
			displayUnclaimed = currentUnclaimed
		end

		-- Update labels with proper format
		balanceLabel.Text = "Balance: " .. UIConfig.FormatMoney(displayBalance)
		unclaimedLabel.Text = "Unclaimed: " .. UIConfig.FormatMoney(displayUnclaimed)

		-- Highlight claim button if unclaimed > 0
		if currentUnclaimed > 0 then
			-- Bright attention-grabbing color when money is available!
			claimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150) -- Hot Pink
			claimButton.Text = "CLAIM!"
		else
			-- Dark, subtle color when nothing to claim
			claimButton.BackgroundColor3 = Color3.fromRGB(40, 50, 70) -- Dark Blue-Gray
			claimButton.Text = "CLAIM"
		end
	end)
end

-- Handle claim button click
function UIController.OnClaimClicked()
	if not claimButton then return end
	
	-- Always send claim request to server, let server handle validation
	RequestClaimEvent:FireServer()

	-- Animate button only if there's something to claim
	if currentUnclaimed > 0 then
		-- Animate button (scale up slightly)
		local originalSize = claimButton.Size
		-- Scale UDim2 properly (multiply both scale and offset components)
		local targetSize = UDim2.new(
			originalSize.X.Scale * 1.05,
			originalSize.X.Offset * 1.05,
			originalSize.Y.Scale * 1.05,
			originalSize.Y.Offset * 1.05
		)
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
		local tween = TweenService:Create(claimButton, tweenInfo, { Size = targetSize })
		tween:Play()
	end
end

-- Setup character clicking for purchases
function UIController.SetupCharacterClicking()
	local mouse = player:GetMouse()

	-- Use MouseButton1Click for more reliable clicking
	mouse.Button1Down:Connect(function()
		local target = mouse.Target

		if target and target.Parent then
			local model = target.Parent

			-- Check if it's a shop character
			if model:IsA("Model") and model.Name:match("ShopCharacter_") then
				RequestBuyEvent:FireServer(model)
			end
		end
	end)
	
	print("[UIController] Character clicking enabled")
end

-- Show toast notification
function UIController.ShowToast(type: string, message: string)
	-- Try to find notifications frame if not already cached
	local notificationsFrame = notifications
	if not notificationsFrame and mainHud then
		notificationsFrame = mainHud:FindFirstChild("Notifications")
	end
	
	-- If still not found, create it
	if not notificationsFrame and mainHud then
		notificationsFrame = Instance.new("Frame")
		notificationsFrame.Name = "Notifications"
		notificationsFrame.Size = UDim2.new(1, 0, 1, 0)
		notificationsFrame.Position = UDim2.new(0, 0, 0, 0) -- Full screen from top-left
		notificationsFrame.BackgroundTransparency = 1
		notificationsFrame.ZIndex = 10
		notificationsFrame.Parent = mainHud
		notifications = notificationsFrame -- Cache it
		print("[UIController] Created Notifications frame")
	end
	
	-- Ensure the notifications frame has correct properties (in case it was created manually)
	if notificationsFrame then
		notificationsFrame.Size = UDim2.new(1, 0, 1, 0)
		notificationsFrame.Position = UDim2.new(0, 0, 0, 0)
		notificationsFrame.BackgroundTransparency = 1
	end
	
	-- Final check
	if not notificationsFrame then 
		print("[Toast] No MainHUD found -", type, "-", message)
		return 
	end
	
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, 350, 0, UIConfig.Toast.Height)
	toast.Position = UDim2.new(0.5, 0, 1, 100) -- Start off screen at bottom
	toast.AnchorPoint = Vector2.new(0.5, 0) -- Center horizontally
	toast.BackgroundColor3 = if type == "success"
		then UIConfig.Toast.SuccessColor
		elseif type == "error" then UIConfig.Toast.ErrorColor
		else UIConfig.Toast.InfoColor
	toast.BorderSizePixel = 0
	toast.Parent = notificationsFrame

	-- Add rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = toast

	-- Add glowing border
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 3
	stroke.Transparency = 0.3
	stroke.Parent = toast

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = message
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 24
	label.Font = UIConfig.Fonts.Button
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Parent = toast

	-- Add text shadow for better readability
	local textStroke = Instance.new("UIStroke")
	textStroke.Color = Color3.fromRGB(0, 0, 0)
	textStroke.Thickness = 2
	textStroke.Parent = label

	-- Slide in with bounce
	-- Use scale positioning (0.85 = 85% from top, or 15% from bottom)
	local slideIn = TweenService:Create(
		toast,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.new(0.5, 0, 0.85, 0) }
	)

	slideIn:Play()
	slideIn.Completed:Wait()

	-- Wait
	task.wait(UIConfig.Toast.Duration)

	-- Slide out
	local slideOut = TweenService:Create(
		toast,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ Position = UDim2.new(0.5, 0, 1, 100) }
	)

	slideOut:Play()
	slideOut.Completed:Wait()

	toast:Destroy()
end

-- Show Tutorial UI
function UIController.ShowTutorial()
	print("[UIController] Showing tutorial UI")
	
	-- Create ScreenGui container (required for UI to display)
	local tutorialScreenGui = Instance.new("ScreenGui")
	tutorialScreenGui.Name = "TutorialScreenGui"
	tutorialScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tutorialScreenGui.DisplayOrder = 100 -- On top of other ScreenGuis
	tutorialScreenGui.ResetOnSpawn = false
	tutorialScreenGui.IgnoreGuiInset = true -- Ensures truly full screen
	tutorialScreenGui.Parent = playerGui
	
	-- Create full-screen overlay (blocks interaction with game)
	local tutorialOverlay = Instance.new("Frame")
	tutorialOverlay.Name = "TutorialOverlay"
	tutorialOverlay.Size = UDim2.new(1, 0, 1, 0) -- Full screen
	tutorialOverlay.Position = UDim2.new(0, 0, 0, 0) -- From top-left corner
	tutorialOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tutorialOverlay.BackgroundTransparency = UIConfig.Tutorial.OverlayTransparency
	tutorialOverlay.BorderSizePixel = 0
	tutorialOverlay.ZIndex = 1
	tutorialOverlay.Parent = tutorialScreenGui
	
	-- Create tutorial panel
	local tutorialPanel = Instance.new("Frame")
	tutorialPanel.Name = "TutorialPanel"
	tutorialPanel.Size = UDim2.new(0, 600, 0, 500)
	tutorialPanel.Position = UDim2.new(0.5, -300, 0.5, -250)
	tutorialPanel.BackgroundColor3 = UIConfig.Tutorial.BackgroundColor
	tutorialPanel.BorderSizePixel = 0
	tutorialPanel.ZIndex = 2
	tutorialPanel.Parent = tutorialOverlay
	
	-- Add rounded corners to panel
	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 20)
	panelCorner.Parent = tutorialPanel
	
	-- Add border
	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = UIConfig.Tutorial.TitleColor
	panelStroke.Thickness = 3
	panelStroke.Transparency = 0.3
	panelStroke.Parent = tutorialPanel
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -40, 0, 80)
	titleLabel.Position = UDim2.new(0, 20, 0, 20)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = UIConfig.Tutorial.Title
	titleLabel.TextColor3 = UIConfig.Tutorial.TitleColor
	titleLabel.TextSize = 38
	titleLabel.Font = UIConfig.Fonts.Header
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.ZIndex = 3
	titleLabel.Parent = tutorialPanel
	
	-- Add subtle text stroke to title
	local titleStroke = Instance.new("UIStroke")
	titleStroke.Color = Color3.fromRGB(0, 0, 0)
	titleStroke.Thickness = 2
	titleStroke.Transparency = 0.5
	titleStroke.Parent = titleLabel
	
	-- Instructions container
	local instructionsFrame = Instance.new("Frame")
	instructionsFrame.Name = "Instructions"
	instructionsFrame.Size = UDim2.new(1, -60, 0, 260)
	instructionsFrame.Position = UDim2.new(0, 30, 0, 110)
	instructionsFrame.BackgroundTransparency = 1
	instructionsFrame.ZIndex = 3
	instructionsFrame.Parent = tutorialPanel
	
	-- Add each instruction line
	local yOffset = 0
	for i, instruction in ipairs(UIConfig.Tutorial.Instructions) do
		local instructionLabel = Instance.new("TextLabel")
		instructionLabel.Name = "Instruction" .. i
		instructionLabel.Size = UDim2.new(1, 0, 0, 42)
		instructionLabel.Position = UDim2.new(0, 0, 0, yOffset)
		instructionLabel.BackgroundTransparency = 1
		instructionLabel.Text = instruction
		instructionLabel.TextColor3 = UIConfig.Tutorial.TextColor
		instructionLabel.TextSize = 20
		instructionLabel.Font = UIConfig.Fonts.Body
		instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
		instructionLabel.TextYAlignment = Enum.TextYAlignment.Top
		instructionLabel.TextWrapped = true
		instructionLabel.ZIndex = 3
		instructionLabel.Parent = instructionsFrame
		
		yOffset = yOffset + 48
	end
	
	-- "I Understand" button at bottom
	local understandButton = Instance.new("TextButton")
	understandButton.Name = "UnderstandButton"
	understandButton.Size = UDim2.new(0, 280, 0, 55)
	understandButton.Position = UDim2.new(0.5, -140, 1, -75)
	understandButton.BackgroundColor3 = UIConfig.Tutorial.ButtonColor
	understandButton.Text = "I UNDERSTAND"
	understandButton.TextColor3 = Color3.new(1, 1, 1)
	understandButton.TextSize = 24
	understandButton.Font = UIConfig.Fonts.Button
	understandButton.BorderSizePixel = 0
	understandButton.ZIndex = 3
	understandButton.AutoButtonColor = true -- Enable hover effect
	understandButton.Parent = tutorialPanel
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 12)
	buttonCorner.Parent = understandButton
	
	-- Function to close tutorial
	local function closeTutorial()
		-- Notify server that tutorial is completed
		TutorialCompletedEvent:FireServer()
		
		-- Animate out
		local fadeOut = TweenService:Create(
			tutorialOverlay,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ BackgroundTransparency = 1 }
		)
		local panelOut = TweenService:Create(
			tutorialPanel,
			TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{ Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }
		)
		
		fadeOut:Play()
		panelOut:Play()
		
		panelOut.Completed:Wait()
		tutorialScreenGui:Destroy()
		
		print("[UIController] Tutorial closed")
	end
	
	-- Connect button event
	understandButton.MouseButton1Click:Connect(closeTutorial)
	
	-- Animate in
	tutorialPanel.Size = UDim2.new(0, 0, 0, 0)
	tutorialPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
	
	local panelIn = TweenService:Create(
		tutorialPanel,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0, 600, 0, 500), Position = UDim2.new(0.5, -300, 0.5, -250) }
	)
	
	panelIn:Play()
end

-- Show Upgrade UI
function UIController.ShowUpgradeUI()
	-- Don't create multiple upgrade UIs
	if upgradeScreenGui then
		upgradeScreenGui:Destroy()
	end
	
	print("[UIController] Showing upgrade UI")
	
	-- Create ScreenGui container
	upgradeScreenGui = Instance.new("ScreenGui")
	upgradeScreenGui.Name = "UpgradeScreenGui"
	upgradeScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	upgradeScreenGui.DisplayOrder = 100
	upgradeScreenGui.ResetOnSpawn = false
	upgradeScreenGui.IgnoreGuiInset = true
	upgradeScreenGui.Parent = playerGui
	
	-- Full-screen overlay
	local overlay = Instance.new("Frame")
	overlay.Name = "UpgradeOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.6
	overlay.BorderSizePixel = 0
	overlay.Parent = upgradeScreenGui
	
	-- Upgrade panel
	local panel = Instance.new("Frame")
	panel.Name = "UpgradePanel"
	panel.Size = UDim2.new(0, 500, 0, 400)
	panel.Position = UDim2.new(0.5, -250, 0.5, -200)
	panel.BackgroundColor3 = UIConfig.Colors.DarkBackground
	panel.BorderSizePixel = 0
	panel.Parent = overlay
	
	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 15)
	panelCorner.Parent = panel
	
	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = UIConfig.Colors.Primary
	panelStroke.Thickness = 3
	panelStroke.Transparency = 0.3
	panelStroke.Parent = panel
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -40, 0, 60)
	title.Position = UDim2.new(0, 20, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "⚡ UPGRADES"
	title.TextColor3 = UIConfig.Colors.Primary
	title.TextSize = 32
	title.Font = UIConfig.Fonts.Header
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Parent = panel
	
	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -55, 0, 10)
	closeButton.BackgroundColor3 = UIConfig.Colors.Danger
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.TextSize = 24
	closeButton.Font = Enum.Font.GothamBold
	closeButton.BorderSizePixel = 0
	closeButton.ZIndex = 10
	closeButton.Parent = panel
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		upgradeScreenGui:Destroy()
		upgradeScreenGui = nil
	end)
	
	-- Upgrade list
	local listFrame = Instance.new("Frame")
	listFrame.Name = "ListFrame"
	listFrame.Size = UDim2.new(1, -40, 1, -100)
	listFrame.Position = UDim2.new(0, 20, 0, 80)
	listFrame.BackgroundTransparency = 1
	listFrame.Parent = panel
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 15)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = listFrame
	
	-- Create upgrade items
	for _, upgradeId in ipairs({"ClaimMultiplier", "DeliverySpeed"}) do
		UIController.CreateUpgradeItem(listFrame, upgradeId)
	end
	
	-- Animate in
	panel.Size = UDim2.new(0, 0, 0, 0)
	panel.Position = UDim2.new(0.5, 0, 0.5, 0)
	
	local panelIn = TweenService:Create(
		panel,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0, 500, 0, 400), Position = UDim2.new(0.5, -250, 0.5, -200) }
	)
	
	panelIn:Play()
end

-- Create an upgrade item in the list
function UIController.CreateUpgradeItem(parent, upgradeId)
	local upgradeData = UpgradeConfig.GetUpgrade(upgradeId)
	if not upgradeData then return end
	
	local currentLevel = playerUpgrades[upgradeId] or 1
	local currentLevelData = UpgradeConfig.GetLevelData(upgradeId, currentLevel)
	local nextLevelData = UpgradeConfig.GetNextLevelData(upgradeId, currentLevel)
	local isMaxLevel = UpgradeConfig.IsMaxLevel(upgradeId, currentLevel)
	
	local item = Instance.new("Frame")
	item.Name = upgradeId
	item.Size = UDim2.new(1, 0, 0, 120)
	item.BackgroundColor3 = UIConfig.Colors.MediumBackground
	item.BorderSizePixel = 0
	item.Parent = parent
	
	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 10)
	itemCorner.Parent = item
	
	-- Icon & Name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -20, 0, 30)
	nameLabel.Position = UDim2.new(0, 10, 0, 10)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = upgradeData.icon .. " " .. upgradeData.name
	nameLabel.TextColor3 = UIConfig.Colors.Text
	nameLabel.TextSize = 22
	nameLabel.Font = UIConfig.Fonts.Header
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = item
	
	-- Level display
	local levelLabel = Instance.new("TextLabel")
	levelLabel.Size = UDim2.new(1, -20, 0, 20)
	levelLabel.Position = UDim2.new(0, 10, 0, 45)
	levelLabel.BackgroundTransparency = 1
	levelLabel.Text = "Level " .. currentLevel .. "/" .. upgradeData.maxLevel
	levelLabel.TextColor3 = UIConfig.Colors.TextDim
	levelLabel.TextSize = 16
	levelLabel.Font = UIConfig.Fonts.Body
	levelLabel.TextXAlignment = Enum.TextXAlignment.Left
	levelLabel.Parent = item
	
	-- Effect description
	local effectLabel = Instance.new("TextLabel")
	effectLabel.Size = UDim2.new(1, -20, 0, 20)
	effectLabel.Position = UDim2.new(0, 10, 0, 68)
	effectLabel.BackgroundTransparency = 1
	
	if isMaxLevel then
		effectLabel.Text = "MAX LEVEL - " .. currentLevelData.description
		effectLabel.TextColor3 = UIConfig.Colors.Success
	else
		effectLabel.Text = "Next: " .. nextLevelData.description
		effectLabel.TextColor3 = UIConfig.Colors.Accent
	end
	
	effectLabel.TextSize = 15
	effectLabel.Font = UIConfig.Fonts.Body
	effectLabel.TextXAlignment = Enum.TextXAlignment.Left
	effectLabel.Parent = item
	
	-- Upgrade button
	if not isMaxLevel then
		local upgradeButton = Instance.new("TextButton")
		upgradeButton.Size = UDim2.new(0, 180, 0, 35)
		upgradeButton.Position = UDim2.new(1, -190, 1, -43)
		upgradeButton.BackgroundColor3 = UIConfig.Colors.Primary
		upgradeButton.Text = "UPGRADE - " .. UIConfig.FormatMoney(nextLevelData.cost)
		upgradeButton.TextColor3 = Color3.new(1, 1, 1)
		upgradeButton.TextSize = 16
		upgradeButton.Font = UIConfig.Fonts.Button
		upgradeButton.BorderSizePixel = 0
		upgradeButton.Parent = item
		
		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 8)
		buttonCorner.Parent = upgradeButton
		
		-- Debounce to prevent double-clicking
		local debounce = false
		upgradeButton.MouseButton1Click:Connect(function()
			if debounce then
				return
			end
			
			debounce = true
			RequestUpgradeEvent:FireServer(upgradeId)
			
			-- Reset debounce after 1 second
			task.delay(1, function()
				debounce = false
			end)
		end)
	end
end

-- Show Offline Earnings Welcome Back Screen
function UIController.ShowOfflineEarnings(amount, timeAwaySeconds)
	
	-- Format time away
	local hours = math.floor(timeAwaySeconds / 3600)
	local minutes = math.floor((timeAwaySeconds % 3600) / 60)
	local timeText = string.format("%dh %dm", hours, minutes)
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OfflineEarningsGui"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 150
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui
	
	-- Overlay
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.7
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	
	-- Welcome panel
	local panel = Instance.new("Frame")
	panel.Name = "WelcomePanel"
	panel.Size = UDim2.new(0, 450, 0, 320)
	panel.Position = UDim2.new(0.5, -225, 0.5, -160)
	panel.BackgroundColor3 = UIConfig.Colors.DarkBackground
	panel.BorderSizePixel = 0
	panel.Parent = overlay
	
	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 20)
	panelCorner.Parent = panel
	
	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = UIConfig.Colors.Success
	panelStroke.Thickness = 4
	panelStroke.Transparency = 0.2
	panelStroke.Parent = panel
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 0, 60)
	title.Position = UDim2.new(0, 20, 0, 20)
	title.BackgroundTransparency = 1
	title.Text = "🎉 WELCOME BACK! 🎉"
	title.TextColor3 = UIConfig.Colors.Success
	title.TextSize = 30
	title.Font = UIConfig.Fonts.Header
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Parent = panel
	
	-- Time away label
	local timeLabel = Instance.new("TextLabel")
	timeLabel.Size = UDim2.new(1, -40, 0, 30)
	timeLabel.Position = UDim2.new(0, 20, 0, 90)
	timeLabel.BackgroundTransparency = 1
	timeLabel.Text = "You were away for: " .. timeText
	timeLabel.TextColor3 = UIConfig.Colors.TextDim
	timeLabel.TextSize = 18
	timeLabel.Font = UIConfig.Fonts.Body
	timeLabel.TextXAlignment = Enum.TextXAlignment.Center
	timeLabel.Parent = panel
	
	-- Earnings label
	local earningsTitle = Instance.new("TextLabel")
	earningsTitle.Size = UDim2.new(1, -40, 0, 25)
	earningsTitle.Position = UDim2.new(0, 20, 0, 135)
	earningsTitle.BackgroundTransparency = 1
	earningsTitle.Text = "Your characters earned:"
	earningsTitle.TextColor3 = UIConfig.Colors.Text
	earningsTitle.TextSize = 16
	earningsTitle.Font = UIConfig.Fonts.Body
	earningsTitle.TextXAlignment = Enum.TextXAlignment.Center
	earningsTitle.Parent = panel
	
	-- Money amount
	local amountLabel = Instance.new("TextLabel")
	amountLabel.Size = UDim2.new(1, -40, 0, 50)
	amountLabel.Position = UDim2.new(0, 20, 0, 165)
	amountLabel.BackgroundTransparency = 1
	amountLabel.Text = UIConfig.FormatMoney(amount)
	amountLabel.TextColor3 = UIConfig.Colors.MoneyGold
	amountLabel.TextSize = 38
	amountLabel.Font = UIConfig.Fonts.Money
	amountLabel.TextXAlignment = Enum.TextXAlignment.Center
	amountLabel.Parent = panel
	
	-- Claim button
	local claimBtn = Instance.new("TextButton")
	claimBtn.Size = UDim2.new(0, 280, 0, 50)
	claimBtn.Position = UDim2.new(0.5, -140, 1, -70)
	claimBtn.BackgroundColor3 = UIConfig.Colors.Success
	claimBtn.Text = "CLAIM OFFLINE EARNINGS"
	claimBtn.TextColor3 = Color3.new(1, 1, 1)
	claimBtn.TextSize = 20
	claimBtn.Font = UIConfig.Fonts.Button
	claimBtn.BorderSizePixel = 0
	claimBtn.Parent = panel
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = claimBtn
	
	claimBtn.MouseButton1Click:Connect(function()
		-- Send claim request to server (server will add to balance)
		ClaimOfflineEarningsEvent:FireServer()
		
		-- Show success toast
		UIController.ShowToast("success", "Claimed " .. UIConfig.FormatMoney(amount) .. "!")
		
		-- Close the UI
		local fadeOut = TweenService:Create(
			overlay,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ BackgroundTransparency = 1 }
		)
		local panelOut = TweenService:Create(
			panel,
			TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{ Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }
		)
		
		fadeOut:Play()
		panelOut:Play()
		
		panelOut.Completed:Wait()
		screenGui:Destroy()
	end)
	
	-- Animate in
	panel.Size = UDim2.new(0, 0, 0, 0)
	panel.Position = UDim2.new(0.5, 0, 0.5, 0)
	
	local panelIn = TweenService:Create(
		panel,
		TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0, 450, 0, 320), Position = UDim2.new(0.5, -225, 0.5, -160) }
	)
	
	panelIn:Play()
end

-- Initialize controller
function UIController.Initialize()
	print("[UIController] Starting initialization...")
	print("[UIController] mainHud:", mainHud)
	print("[UIController] claimButton:", claimButton)
	print("[UIController] claimSection:", claimSection)
	
	if not mainHud or not claimButton then
		print("[UIController] UI not created yet - characters will still spawn!")
		print("[UIController] Create MainHUD in StarterGui to see the UI")
		-- Still setup character clicking even without UI
		UIController.SetupCharacterClicking()
		return
	end
	
	-- Set initial label text (check each element exists)
	if balanceLabel then
		balanceLabel.Text = "Balance: " .. UIConfig.FormatMoney(0)
	else
		warn("[UIController] BalanceLabel is missing!")
	end
	
	if unclaimedLabel then
		unclaimedLabel.Text = "Unclaimed: " .. UIConfig.FormatMoney(0)
	else
		warn("[UIController] UnclaimedLabel is missing! Check your UI structure.")
	end
	
	if claimButton then
		claimButton.Text = "CLAIM"
	end
	
	-- Setup claim button
	claimButton.MouseButton1Click:Connect(function()
		UIController.OnClaimClicked()
	end)
	
	-- Create Upgrade button next to claim button
	UIController.CreateUpgradeButton()

	-- Setup character clicking
	UIController.SetupCharacterClicking()

	-- Start UI update loop
	UIController.StartUpdateLoop()
	
	-- Request immediate state update from server (in case we missed initial sync)
	-- Wait a tiny bit for server to be ready
	task.wait(0.1)
	-- Trigger a state sync by requesting player data
	-- The server will send StateUpdate when it initializes the player

	print("[UIController] Initialized")
end

-- Create the Upgrade button in the UI
function UIController.CreateUpgradeButton()
	if not mainHud then 
		warn("[UIController] MainHUD not found - cannot create upgrade button")
		return 
	end
	
	-- Don't create if already exists
	if mainHud:FindFirstChild("UpgradeButton") then
		print("[UIController] Upgrade button already exists")
		return
	end
	
	-- Create Upgrade button (placed at top-right of screen for visibility)
	local upgradeButton = Instance.new("TextButton")
	upgradeButton.Name = "UpgradeButton"
	upgradeButton.Size = UDim2.new(0, 180, 0, 55)
	-- Position at top-right corner
	upgradeButton.Position = UDim2.new(1, -200, 0, 80)
	upgradeButton.AnchorPoint = Vector2.new(0, 0)
	upgradeButton.BackgroundColor3 = UIConfig.Colors.Primary
	upgradeButton.Text = "⚡ UPGRADES"
	upgradeButton.TextColor3 = Color3.new(1, 1, 1)
	upgradeButton.TextSize = 22
	upgradeButton.Font = UIConfig.Fonts.Button
	upgradeButton.BorderSizePixel = 0
	upgradeButton.ZIndex = 5
	upgradeButton.Parent = mainHud
	
	local upgradeCorner = Instance.new("UICorner")
	upgradeCorner.CornerRadius = UDim.new(0, 12)
	upgradeCorner.Parent = upgradeButton
	
	local upgradeStroke = Instance.new("UIStroke")
	upgradeStroke.Color = Color3.fromRGB(255, 255, 255)
	upgradeStroke.Thickness = 2
	upgradeStroke.Transparency = 0.7
	upgradeStroke.Parent = upgradeButton
	
	upgradeButton.MouseButton1Click:Connect(function()
		UIController.ShowUpgradeUI()
		
		-- Animate button click
		local originalSize = upgradeButton.Size
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
		local tween = TweenService:Create(upgradeButton, tweenInfo, { 
			Size = UDim2.new(originalSize.X.Scale * 1.05, originalSize.X.Offset * 1.05, 
				originalSize.Y.Scale * 1.05, originalSize.Y.Offset * 1.05) 
		})
		tween:Play()
	end)
end

-- Handle state updates from server
StateUpdateEvent.OnClientEvent:Connect(function(data)
	if data.Balance ~= nil then
		currentBalance = data.Balance
		displayBalance = data.Balance -- Set display value immediately for instant update
		-- Update label directly if it exists
		if balanceLabel then
			balanceLabel.Text = "Balance: " .. UIConfig.FormatMoney(data.Balance)
		end
	end
	if data.Unclaimed ~= nil then
		currentUnclaimed = data.Unclaimed
		displayUnclaimed = data.Unclaimed -- Set display value immediately for instant update
		-- Update label directly if it exists
		if unclaimedLabel then
			unclaimedLabel.Text = "Unclaimed: " .. UIConfig.FormatMoney(data.Unclaimed)
		end
		
		-- Update claim button if it exists
		if claimButton then
			if data.Unclaimed > 0 then
				claimButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150) -- Hot Pink
				claimButton.Text = "CLAIM!"
			else
				claimButton.BackgroundColor3 = Color3.fromRGB(40, 50, 70) -- Dark Blue-Gray
				claimButton.Text = "CLAIM"
			end
		end
	end
end)

-- Handle purchase feedback
PurchaseFeedbackEvent.OnClientEvent:Connect(function(type, message)
	UIController.ShowToast(type, message)
end)

-- Handle tutorial show request from server
ShowTutorialEvent.OnClientEvent:Connect(function()
	UIController.ShowTutorial()
end)

-- Handle upgrade updates from server
UpgradeUpdateEvent.OnClientEvent:Connect(function(upgrades)
	playerUpgrades = upgrades
	
	-- Refresh upgrade UI if it's open
	if upgradeScreenGui then
		UIController.ShowUpgradeUI()
	end
end)

-- Handle offline earnings from server
ShowOfflineEarningsEvent.OnClientEvent:Connect(function(amount, timeAwaySeconds)
	UIController.ShowOfflineEarnings(amount, timeAwaySeconds)
end)

-- Initialize
UIController.Initialize()
