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
	
	if currentUnclaimed > 0 then
		RequestClaimEvent:FireServer()

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
	-- Check if notifications frame exists NOW, not at script start
	if not notifications then 
		print("[Toast]", type, "-", message)
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
	toast.Parent = notifications

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

-- Initialize
UIController.Initialize()
