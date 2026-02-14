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
local balanceLabel = topBar and topBar:WaitForChild("BalanceLabel", 10)
local unclaimedLabel = topBar and topBar:WaitForChild("UnclaimedLabel", 10)
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
	-- Skip if UI doesn't exist yet
	if not mainHud or not balanceLabel then
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

		-- Update labels
		balanceLabel.Text = "💰 " .. UIConfig.FormatMoney(displayBalance)
		unclaimedLabel.Text = "⏰ " .. UIConfig.FormatMoney(displayUnclaimed)

		-- Highlight claim button if unclaimed > 0
		if currentUnclaimed > 0 then
			-- Make button bright and pulsing when money is available!
			claimButton.BackgroundColor3 = UIConfig.Colors.Magenta
			claimButton.Text = "🎁 CLAIM " .. UIConfig.FormatMoney(currentUnclaimed) .. "! 🎁"
		else
			claimButton.BackgroundColor3 = UIConfig.Colors.Secondary
			claimButton.Text = "🎁 CLAIM! 🎁"
		end
	end)
end

-- Handle claim button click
function UIController.OnClaimClicked()
	if not claimButton then return end
	
	if currentUnclaimed > 0 then
		RequestClaimEvent:FireServer()

		-- Animate button
		local originalSize = claimButton.Size
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
		local tween = TweenService:Create(claimButton, tweenInfo, { Size = originalSize * 1.1 })
		tween:Play()
	end
end

-- Setup character clicking for purchases
function UIController.SetupCharacterClicking()
	local mouse = player:GetMouse()

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

	-- Add emoji icon based on type
	local emoji = if type == "success" then "✅" elseif type == "error" then "❌" else "ℹ️"

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = emoji .. " " .. message
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
	
	-- Setup claim button
	claimButton.MouseButton1Click:Connect(function()
		UIController.OnClaimClicked()
	end)

	-- Setup character clicking
	UIController.SetupCharacterClicking()

	-- Start UI update loop
	UIController.StartUpdateLoop()

	print("[UIController] Initialized")
end

-- Handle state updates from server
StateUpdateEvent.OnClientEvent:Connect(function(data)
	if data.Balance then
		currentBalance = data.Balance
		-- Update label directly if it exists
		if balanceLabel then
			balanceLabel.Text = "💰 " .. UIConfig.FormatMoney(data.Balance)
		end
	end
	if data.Unclaimed then
		currentUnclaimed = data.Unclaimed
		-- Update label directly if it exists
		if unclaimedLabel then
			unclaimedLabel.Text = "⏰ " .. UIConfig.FormatMoney(data.Unclaimed)
		end
		
		-- Update claim button if it exists
		if claimButton then
			if data.Unclaimed > 0 then
				claimButton.BackgroundColor3 = UIConfig.Colors.Magenta
				claimButton.Text = "🎁 CLAIM " .. UIConfig.FormatMoney(data.Unclaimed) .. "! 🎁"
			else
				claimButton.BackgroundColor3 = UIConfig.Colors.Secondary
				claimButton.Text = "🎁 CLAIM! 🎁"
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
