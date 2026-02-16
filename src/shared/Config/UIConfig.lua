--[[
	UIConfig.lua
	Contains UI theme settings, colors, fonts, animations, and formatting functions.
]]

local UIConfig = {}

-- Color Palette (Professional Blue-Gray Theme)
UIConfig.Colors = {
	-- Main UI Colors
	Primary = Color3.fromRGB(50, 150, 255), -- Bright Blue
	Secondary = Color3.fromRGB(70, 170, 255), -- Light Blue
	Accent = Color3.fromRGB(100, 200, 255), -- Accent Blue
	Success = Color3.fromRGB(80, 200, 120), -- Soft Green
	Warning = Color3.fromRGB(255, 180, 50), -- Soft Orange
	Danger = Color3.fromRGB(255, 100, 100), -- Soft Red
	Text = Color3.fromRGB(255, 255, 255), -- Pure White
	TextDim = Color3.fromRGB(180, 200, 220), -- Light Blue-Gray
	
	-- UI Element Colors
	DarkBackground = Color3.fromRGB(25, 25, 35), -- Dark Blue-Gray
	MediumBackground = Color3.fromRGB(35, 45, 60), -- Medium Blue-Gray
	LightBackground = Color3.fromRGB(45, 60, 80), -- Light Blue-Gray
	
	-- Money/Balance Colors
	MoneyGold = Color3.fromRGB(255, 200, 80), -- Soft Gold
	MoneyGreen = Color3.fromRGB(100, 220, 150), -- Mint Green
	
	-- Special Colors (kept for legacy compatibility)
	Gold = Color3.fromRGB(255, 200, 80),
	Magenta = Color3.fromRGB(180, 100, 255), -- Soft Purple
	HotPink = Color3.fromRGB(255, 120, 180), -- Soft Pink
	SpringGreen = Color3.fromRGB(100, 220, 150),
	Yellow = Color3.fromRGB(255, 220, 100),
}

-- Fonts
UIConfig.Fonts = {
	Header = Enum.Font.GothamBold,
	Body = Enum.Font.Gotham,
	Money = Enum.Font.GothamBold,
	Button = Enum.Font.GothamMedium,
}

-- Animation Settings
UIConfig.Animations = {
	CounterSpeed = 0.3, -- Duration for money counter animations
	ButtonHover = 0.15, -- Button hover effect duration
	FadeIn = 0.2, -- Fade in duration
	FadeOut = 0.15, -- Fade out duration
	EasingStyle = Enum.EasingStyle.Quad,
	EasingDirection = Enum.EasingDirection.Out,
}

-- Money Formatting
local Suffixes = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

function UIConfig.FormatMoney(amount: number): string
	if amount < 1000 then
		return "$" .. tostring(math.floor(amount))
	end

	local index = 1
	local value = amount

	while value >= 1000 and index < #Suffixes do
		value = value / 1000
		index += 1
	end

	-- Round to 2 decimal places
	local rounded = math.floor(value * 100) / 100
	return string.format("$%.2f%s", rounded, Suffixes[index])
end

-- Format for compact display (no $ sign, shorter)
function UIConfig.FormatMoneyCompact(amount: number): string
	return UIConfig.FormatMoney(amount):gsub("%$", "")
end

-- Format EPS (Earnings Per Second)
function UIConfig.FormatEPS(eps: number): string
	if eps < 1000 then
		return "+" .. tostring(eps) .. "/s"
	end

	local index = 1
	local value = eps

	while value >= 1000 and index < #Suffixes do
		value = value / 1000
		index += 1
	end

	local rounded = math.floor(value * 100) / 100
	return string.format("+%.2f%s/s", rounded, Suffixes[index])
end

-- Toast Notification Settings (Modern Blue Theme)
UIConfig.Toast = {
	Duration = 2.5, -- Seconds to show toast
	Height = 60,
	Padding = 10,
	SuccessColor = Color3.fromRGB(80, 200, 120), -- Soft Green
	ErrorColor = Color3.fromRGB(255, 100, 100), -- Soft Red
	InfoColor = Color3.fromRGB(50, 150, 255), -- Bright Blue
}

-- UI Measurements
UIConfig.Layout = {
	TopBarHeight = 60,
	ClaimButtonSize = UDim2.new(0, 200, 0, 60),
	Padding = 10,
	CornerRadius = UDim.new(0, 8),
}

-- Tutorial Settings
UIConfig.Tutorial = {
	Title = "HOW TO PLAY",
	Instructions = {
		"1. Click on shop characters to buy them",
		"2. Characters will earn money for you automatically",
		"3. Better characters = more money per second",
		"4. Claim your earnings with the CLAIM button",
		"5. Keep buying to grow your empire",
	},
	BackgroundColor = Color3.fromRGB(25, 25, 35), -- Dark Blue-Gray
	TitleColor = Color3.fromRGB(100, 200, 255), -- Bright Blue
	TextColor = Color3.fromRGB(230, 230, 230), -- Light Gray
	ButtonColor = Color3.fromRGB(50, 150, 255), -- Blue
	ButtonHoverColor = Color3.fromRGB(70, 170, 255), -- Lighter Blue
	OverlayTransparency = 0.6, -- Semi-transparent overlay
}

return UIConfig
