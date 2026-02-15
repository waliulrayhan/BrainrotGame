# 🎮 QUICK START - Get Your Game Running FAST!

## ⚡ 3-Step Setup

### Step 1️⃣: Start Rojo (1 minute)
```powershell
# Open terminal in this folder
rojo serve
```
✅ You should see: `Rojo server listening on port 34872`

---

### Step 2️⃣: Connect Studio (2 minutes)
1. Open **Roblox Studio**
2. Create **"Village"** or **"Baseplate"** template
3. Click **Rojo** plugin button
4. Click **Connect**

✅ Check Explorer:
- `ReplicatedStorage → Shared` (appears automatically)
- `ServerScriptService → Services` (appears automatically)
- `StarterPlayer → StarterPlayerScripts → Client` (appears automatically)

---

### Step 3️⃣: Build UI + World (15 minutes)

#### A. Build the UI 🎨
Follow the **[README.md](README.md)** - Complete UI Guide
- Create MainHUD in StarterGui
- Add TopBar with money displays
- Add giant CLAIM button
- Takes ~15 minutes to build all the colorful UI!

#### B. Build the 3D World 🌍

**In Workspace, create:**

**1. ShopLane (Folder)**
- Add `LanePath` part inside
  - Size: `150, 1, 10`
  - Position: `0, 13, 0`
  - Anchored: ✅ true

**2. PurchaseZone (Part)**
- Size: `15, 5, 15`
- Position: `0, 12.5, -14`
- Transparency: `0.5`
- BrickColor: Bright green
- Anchored: ✅ true
- CanCollide: ❌ false

**3. BasePads (Folder) - NEW TIER-BASED SYSTEM**
- Create 5 parts for tier-specific basepads:
  - `BasePad_T1` - Tier 1 (Tiny Brainrot)
    - Size: `20, 1, 20`
    - Position: `10, 0.5, 10`
    - Anchored: ✅ true
  - `BasePad_T2` - Tier 2 (Better Brainrot)
    - Size: `20, 1, 20`
    - Position: `40, 0.5, 10`
    - Anchored: ✅ true
  - `BasePad_T3` - Tier 3 (Epic Brainrot)
    - Size: `20, 1, 20`
    - Position: `70, 0.5, 10`
    - Anchored: ✅ true
  - `BasePad_T4` - Tier 4 (Mythic Brainrot)
    - Size: `20, 1, 20`
    - Position: `100, 0.5, 10`
    - Anchored: ✅ true
  - `BasePad_T5` - Tier 5 (Legend Brainrot)
    - Size: `20, 1, 20`
    - Position: `130, 0.5, 10`
    - Anchored: ✅ true

See [WORKSPACE_SETUP.md](WORKSPACE_SETUP.md) for detailed setup instructions.

---

### Step 4️⃣: TEST! 🎮

Press **F5** in Studio

**You should see:**
- ✨ Purple gradient top bar
- 💰 Gold "Balance: $50" (left)
- ⏰ Green "Unclaimed: $0" (right)
- 🎁 HUGE pink CLAIM button (bottom)
- Characters spawning and moving on lane!

**Try it:**
1. Stand on green PurchaseZone
2. Click a moving character
3. It goes to your base!
4. Watch Unclaimed money grow!
5. Click CLAIM button!

---

## 🆘 Troubleshooting

**"Unknown require" errors in VS Code?**
- ✅ IGNORE THEM! They're false positives
- Rojo creates the modules in Studio
- Game will work perfectly!

**Characters don't spawn?**
- Check ShopLane folder exists
- Check LanePath part is inside it
- Check Output window for errors

**Can't buy characters?**
- Stand on the green PurchaseZone part
- Click directly on the character (colored cube)
- Make sure you have $50 starting balance

**UI doesn't show?**
- Make sure MainHUD is in StarterGui
- Check all elements are created (see README.md)
- Press F5 to restart game

---

## 📚 Files in This Project

**Your Code (edit in VS Code):**
- `src/server/` - 5 server services
- `src/client/` - UI controller  
- `src/shared/Config/` - Character & UI configs
- `src/MainServer.server.lua` - Entry point

**Config Files:**
- `default.project.json` - Rojo sync config
- `aftman.toml` - Tool versions

**Documentation:**
- **README.md** ← Complete UI guide (read this!)

---

## 🎨 Want to Customize?

**Change Colors:**
- Edit `src/shared/Config/UIConfig.lua`
- Change RGB values in Colors table

**Change Characters:**
- Edit `src/shared/Config/CharacterConfig.lua`
- Modify prices, earnings, colors, names

**Change Spawn Speed:**
- Edit `src/server/ShopLaneService.lua`
- Change `SpawnInterval` (default: 3 seconds)

---

## ✅ Verification Checklist

Before you start playing:

**Rojo:**
- [ ] `rojo serve` running without errors
- [ ] Studio connected to Rojo
- [ ] Code synced to Studio (check Explorer)

**3D World:**
- [ ] ShopLane folder with LanePath part
- [ ] PurchaseZone (green glowing part)
- [ ] BasePads folder with 5 tier-specific basepads (BasePad_T1 through BasePad_T5)

**UI (in StarterGui):**
- [ ] MainHUD ScreenGui
- [ ] TopBar with purple gradient
- [ ] BalanceContainer (gold) with BalanceLabel
- [ ] UnclaimedContainer (green) with UnclaimedLabel
- [ ] ClaimSection with ClaimButton (pink)
- [ ] Notifications frame

**Test:**
- [ ] Press F5 - game starts
- [ ] Characters spawn and move
- [ ] UI shows money ($50 balance)
- [ ] Can buy characters
- [ ] Money increases over time
- [ ] CLAIM button works

---

## 🚀 You're Ready!

**Everything works!** Now:
1. ✨ Customize colors and characters
2. 🎮 Add more features
3. 🎨 Make it your own!

**The game is fully functional with:**
- ✅ Character spawning & movement
- ✅ Purchase system
- ✅ Earning system
- ✅ Data saving
- ✅ Beautiful UI
- ✅ Anti-exploit protection

---

**HAVE FUN CREATING! 🎉**
