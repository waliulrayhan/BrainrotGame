# Tutorial UI - Roblox Studio Setup Guide

## 📋 Overview
This guide explains the **"How to Play"** tutorial system that automatically shows to new players when they first join your game.

## ✨ Features Implemented
- ✅ **Automatic Display**: Shows only to first-time players
- ✅ **Persistent Tracking**: Uses DataStore to remember if player has seen it
- ✅ **Beautiful UI**: Animated, modern design with emojis
- ✅ **Two ways to close**: "I Understand" button OR close button (X)
- ✅ **Smooth Animations**: Slides in and out with bounce effect

---

## 🎮 How It Works

### System Flow:
1. **Player Joins Game** → Server loads their saved data
2. **Check Tutorial Status** → If `HasSeenTutorial` is false/nil, show tutorial
3. **Display Tutorial** → Server fires `ShowTutorial` event to client
4. **Client Shows UI** → Full-screen overlay with instructions appears
5. **Player Closes Tutorial** → Client notifies server via `TutorialCompleted` event
6. **Data Saved** → `HasSeenTutorial = true` is saved to DataStore

---

## 📂 Files Modified/Created

### New Files:
- `src/server/TutorialService.lua` - Server-side tutorial management

### Modified Files:
- `src/MainServer.server.lua` - Initializes TutorialService
- `src/client/UIController.client.lua` - Creates and displays tutorial UI
- `src/shared/Config/UIConfig.lua` - Tutorial styling configuration
- `src/server/SavingService.lua` - Tracks HasSeenTutorial in DataStore

---

## 🎨 UI Design Specifications

### Tutorial Panel:
- **Size**: 600x500 pixels
- **Position**: Center of screen
- **Background**: Dark purple (`RGB(40, 0, 80)`)
- **Border**: Gold glow effect (`RGB(255, 215, 0)`)
- **Corners**: 20px rounded

### Elements:
1. **Title**: "HOW TO PLAY" (Gold, 42px, Bold)
2. **Instructions**: 5 lines with emojis (White, 22px)
   - 🎮 Click on shop characters to buy them!
   - 💰 Characters will earn money for you!
   - 📈 Better characters = more money per second!
   - 💵 Claim your earnings with the CLAIM button!
   - 🚀 Keep buying to grow your empire!
3. **"I Understand" Button**: Green (300x60px) at bottom
4. **Close Button (X)**: Red-orange (50x50px) at top-right

### Overlay:
- **Full screen**: Semi-transparent black (50% opacity)
- **Blocks interaction**: Player must close tutorial first

---

## 🛠️ Testing the Tutorial

### Test as New Player:
1. **Start Rojo**: Run `rojo serve` in your project folder
2. **Open Roblox Studio**: Connect to Rojo (View → Rojo → Connect)
3. **Clear Your Data**: 
   - Open `View` → `Game Settings` → `Security`
   - Enable `Studio Access to API Services`
   - In DataStoreService, clear your test player data OR use different account
4. **Play Test**: Press Play (F5)
5. **Result**: Tutorial should appear after ~0.5 seconds

### Test as Returning Player:
1. Close the tutorial using "I Understand" button
2. Stop the game and play again
3. **Result**: Tutorial should NOT appear (you've already seen it)

### Force Tutorial to Show Again:
You can reset your tutorial status by:
- Using a different Roblox account in Studio
- Clearing DataStore data
- Creating a test button that fires `ShowTutorialEvent:FireClient(player)`

---

## 🎯 Customization Options

### Change Tutorial Text:
Edit `src/shared/Config/UIConfig.lua`:
```lua
UIConfig.Tutorial = {
	Title = "YOUR TITLE HERE",
	Instructions = {
		"Your instruction 1",
		"Your instruction 2",
		"Your instruction 3",
		-- Add more lines as needed
	},
	-- ... colors below
}
```

### Change Colors:
In the same file, modify:
```lua
BackgroundColor = Color3.fromRGB(40, 0, 80),     -- Panel background
TitleColor = Color3.fromRGB(255, 215, 0),        -- Title text
TextColor = Color3.fromRGB(255, 255, 255),       -- Instruction text
ButtonColor = Color3.fromRGB(0, 255, 127),       -- "I Understand" button
CloseButtonColor = Color3.fromRGB(255, 69, 0),   -- Close X button
```

### Change Tutorial Size:
Edit `src/client/UIController.client.lua`, find:
```lua
tutorialPanel.Size = UDim2.new(0, 600, 0, 500)
```
Change `600` (width) and `500` (height) to your desired values.

### Change Delay Before Showing:
Edit `src/server/TutorialService.lua`, find:
```lua
task.wait(0.5)  -- Change this value (in seconds)
```

---

## 🚨 Troubleshooting

### Tutorial Doesn't Appear:
1. **Check Console**: Look for `[TutorialService] Showing tutorial to new player`
2. **Verify RemoteEvents**: Ensure `ShowTutorial` and `TutorialCompleted` exist in `ReplicatedStorage.Shared.Remotes`
3. **Check DataStore**: Make sure you're a new player (no saved data)
4. **API Services**: Enable Studio API access in Game Settings

### Tutorial Appears Every Time:
1. **DataStore Not Saving**: Check `[SavingService]` logs for save errors
2. **API Services Disabled**: Enable in Game Settings → Security
3. **Different Account**: You might be using different accounts each time

### UI Looks Wrong:
1. **Check PlayerGui**: During play test, check if `TutorialOverlay` exists
2. **Console Errors**: Look for any red errors in Output
3. **Verify UIConfig**: Make sure your UIConfig.lua changes are saved

### Close Button Not Working:
1. **Check ZIndex**: Tutorial should have very high ZIndex (100+)
2. **Button Overlap**: Make sure no other UI is blocking clicks
3. **Console Output**: Check if `[UIController] Tutorial closed` appears when clicking

---

## 📊 DataStore Schema

### Player Data Structure:
```lua
{
	Balance = 100,           -- Player's money
	Unclaimed = 50,          -- Money not yet claimed
	Earners = {...},         -- Purchased characters
	HasSeenTutorial = true,  -- NEW: Tutorial status
	LastSave = 1234567890,   -- Timestamp
}
```

---

## 🔧 Advanced Features

### Manual Tutorial Trigger:
Create a button to manually show tutorial for testing:
```lua
-- In a Script or LocalScript
local ShowTutorialEvent = game.ReplicatedStorage.Shared.Remotes.ShowTutorial

-- On button click:
ShowTutorialEvent:FireClient(player)  -- Server-side
-- or
ShowTutorialEvent:FireServer()  -- Client-side doesn't work (server must trigger)
```

### Add More Instructions:
Simply add more lines to the `Instructions` table in UIConfig.lua. The UI will automatically adjust the spacing.

### Change Animation:
Edit the tweens in `UIController.ShowTutorial()`:
```lua
-- Panel slide in animation
TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
-- Change 0.5 = duration, Back = animation style
```

---

## 🎬 Animation Details

### Opening Animation:
- **Panel**: Scales from 0 → full size with bounce effect
- **Duration**: 0.5 seconds
- **Style**: Back easing (overshoot effect)

### Closing Animation:
- **Panel**: Scales from full size → 0
- **Overlay**: Fades to transparent
- **Duration**: 0.3 seconds
- **Style**: Smooth quad easing

---

## ✅ Quality Checklist

Before publishing your game, verify:
- [ ] Tutorial shows for new players
- [ ] Tutorial doesn't show for returning players
- [ ] Both buttons (I Understand & X) close the tutorial
- [ ] Tutorial saves completion status to DataStore
- [ ] UI looks good on different screen sizes
- [ ] No console errors when tutorial opens/closes
- [ ] Instructions are clear and easy to understand
- [ ] Colors match your game's theme

---

## 🎨 Design Philosophy

The tutorial UI follows your game's vibrant, kid-friendly design:
- **Bright Colors**: Purple, gold, green - matches existing UI
- **Emojis**: Makes instructions fun and easy to scan
- **Clean Layout**: Clear hierarchy with title → instructions → button
- **Non-intrusive**: Players can quickly close it if needed
- **First-time only**: Doesn't annoy returning players

---

## 💡 Tips

1. **Keep Instructions Short**: 5-7 lines max for readability
2. **Use Emojis**: Makes text more engaging for younger players
3. **Test Both Buttons**: Ensure both closing methods work
4. **Clear DataStore**: During testing, clear data to see tutorial again
5. **Check Mobile**: If your game supports mobile, test UI scaling

---

## 🆘 Need Help?

If something isn't working:
1. Check the Output window in Roblox Studio for errors
2. Look for `[TutorialService]` and `[UIController]` logs
3. Verify all RemoteEvents exist in ReplicatedStorage
4. Ensure Rojo sync is working properly
5. Check that Services folder contains TutorialService.lua

---

## 📝 Notes

- **No Roblox Studio UI Creation Required**: Everything is created programmatically via Lua scripts
- **Zero Manual UI Setup**: No need to create ScreenGuis or Frames in Studio
- **Fully Automated**: Just sync with Rojo and play!
- **Data Persistence**: Uses your existing DataStore system

---

## 🚀 You're All Set!

The tutorial system is now fully integrated into your game. New players will see helpful instructions on their first play, and returning players will jump right into the action!

**Next Steps:**
1. Test in Studio as a new player
2. Customize colors/text if desired
3. Publish and let real players experience it!

Happy developing! 🎮✨
