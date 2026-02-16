--[[
	UIController.client.lua
	Client-side controller that handles UI updates and user interactions.
	Communicates with server via RemoteEvents.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local UIConfig = require(ReplicatedStorage.Shared.Config.UIConfig)

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
			-- Make button bright and pulsing when money is available!
			claimButton.BackgroundColor3 = UIConfig.Colors.Magenta
			claimButton.Text = "CLAIM!"
		else
			claimButton.BackgroundColor3 = UIConfig.Colors.Secondary
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
		notificationsFrame.BackgroundTransparency = 1
		notificationsFrame.ZIndex = 10
		notificationsFrame.Parent = mainHud
		notifications = notificationsFrame -- Cache it
		print("[UIController] Created Notifications frame")
	end
	
	-- Final check
	if not notificationsFrame then 
		print("[Toast] No MainHUD found -", type, "-", message)
		return 
	end
	
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, 350, 0, UIConfig.Toast.Height)
	toast.Position = UDim2.new(0.5, -175, 0, -100) -- Start off screen
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
	local slideIn = TweenService:Create(
		toast,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.new(0.5, -175, 0, 30) }
	)

	slideIn:Play()
	slideIn.Completed:Wait()

	-- Wait
	task.wait(UIConfig.Toast.Duration)

	-- Slide out
	local slideOut = TweenService:Create(
		toast,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ Position = UDim2.new(0.5, -175, 0, -100) }
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

-- Initialize controller
function UIController.Initialize()
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
				claimButton.BackgroundColor3 = UIConfig.Colors.Magenta
				claimButton.Text = "CLAIM!"
			else
				claimButton.BackgroundColor3 = UIConfig.Colors.Secondary
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

-- Initialize
UIController.Initialize()
