# 🎮 BrainrotGame - Idle Progression Game

An idle/tycoon game where you buy characters, place them on your basepad, and earn money automatically!

**Version:** 1.1 | **Framework:** Rojo + Roblox Studio | **Status:** ✅ Production Ready

---

## 🎯 What You Get

- 🛒 **5-Tier Character System** - Buy characters from $50 → $500,000
- 📍 **Automatic Earnings** - Characters earn 1 → 30,000 per second
- ⚡ **Upgrade System** - Permanent 2.5x claim + 7x speed multipliers
- 💤 **Offline Earnings** - Get 50% while away (12hr cap)
- 💾 **Auto-Save** - Everything persists via DataStore
- 👥 **Multi-Player Ready** - Isolated basepads per player

---

## ⚡ Quick Start (For Players)

### **1. Clone Repository**
```powershell
git clone https://github.com/waliulrayhan/BrainrotGame.git
cd BrainrotGame
```

### **2. Open Pre-Built Template**
```powershell
# Just open the template file:
start BrainrotGame-Template.rbxlx
```

### **3. Play!**
- Press **F5** in Roblox Studio
- **That's it!** 🎉 Everything is ready!

**No manual setup needed** - Workspace, UI, everything is pre-configured!

---

## 🛠️ For Developers (Live Code Editing)

Want to modify the code and see changes instantly?

### **Prerequisites**
1. **Roblox Studio** - [Download here](https://www.roblox.com/create)
2. **Git** - [Download here](https://git-scm.com/downloads)
3. **Aftman** - Install via PowerShell:
   ```powershell
   irm https://raw.githubusercontent.com/LPGhatguy/aftman/main/installers/windows.ps1 | iex
   ```

### **Setup Once**
```powershell
# Clone repo (if not already)
git clone https://github.com/waliulrayhan/BrainrotGame.git
cd BrainrotGame

# Install tools
aftman install
```

### **Development Workflow**
```powershell
# Terminal 1: Start Rojo server
rojo serve

# Terminal 2: (Optional) Open VS Code
code .
```

**In Roblox Studio:**
1. Open `BrainrotGame-Template.rbxlx`
2. **Plugins** → **Rojo** → **Connect**
3. ✅ Code syncs automatically from `src/` folder!
4. Edit `.lua` files in VS Code → Changes appear in Studio instantly

**Recommended VS Code Extensions:**
- **Roblox LSP** (by Nightrains)
- **Luau Language Server** (by JohnnyMorganz)
3. Click **Plugins** → **Rojo** → **Connect**
4. Click **Connect** in the Rojo window

You should see: "Connected to Rojo" + code appears in Explorer

---

## 🏗️ World Setup (First Time Only)

Your code is ready, but you need to create the 3D world:

### **Required Objects in Workspace:**

---

## ▶️ How to Play

**Press F5** in Roblox Studio and you're ready!

### **Gameplay:**
1. **Walk to the green PurchaseZone** (transparent green platform)
2. **Click on moving characters** in the shop lane to buy them
3. **Characters appear on basepads** and start earning automatically
4. **Watch "Unclaimed" money grow** (top-right UI)
5. **Click the big CLAIM button** (bottom) to collect earnings
6. **Buy better characters** with your money!

### **Character Tiers:**
| Tier | Cost | Earnings/Second | ROI |
|------|------|-----------------|-----|
| T1 | $50 | 1 EPS | 50s |
| T2 | $500 | 15 EPS | 33s |
| T3 | $5,000 | 200 EPS | 25s |
| T4 | $50,000 | 2,500 EPS | 20s |
| T5 | $500,000 | 30,000 EPS | 17s |

### **Upgrade Strategy:**
1. **First $100k** → **Delivery Speed Level 2** (2x ALL earnings!)
2. **Next $200k** → **Delivery Speed Level 3** (3x earnings)
3. **Keep buying T3-T4** until you can afford T5
4. **Late game** → Max Delivery Speed (7x) then Claim Multiplier (2.5x)

### **Offline Earnings:**
- Earn **50%** of potential earnings while offline (max 12 hours)
- Always **claim before leaving** to save your money!

---

## 🛠️ Troubleshooting

### **Template file missing?**
If you don't see `BrainrotGame-Template.rbxlx`:
1. The maintainer needs to create it once (instructions in [docs/SETUP_TEMPLATE.md](docs/SETUP_TEMPLATE.md))
2. Or use the legacy build: `rojo build -o BrainrotGame.rbxl` (requires manual setup)

### **Characters don't spawn?**
- Check **Output window** (View → Output) for errors
- Verify template file has **ShopLane → LanePath** in workspace

### **Can't buy characters?**
- Stand **inside the green PurchaseZone** (the green transparent platform)
- Make sure you have **enough money**
- Click **directly on the character** (colored cube)

### **UI doesn't show?**
- Template should have everything ready
- Press **Shift+F5** to stop, then **F5** to restart

### **"Rojo command not found" (for developers)?**
```powershell
# Reinstall tools:
aftman install
```

### **Need to modify workspace/UI?**
See [docs/WORKSPACE_SETUP.md](docs/WORKSPACE_SETUP.md) for detailed manual setup instructions.

---

## 📁 Project Structure

```
BrainrotGame/
├── BrainrotGame-Template.rbxlx  # ⭐ Pre-built game (just open & play!)
├── src/                         # Source code (syncs via Rojo)
│   ├── MainServer.server.lua    # Server entry point
│   ├── server/                  # 7 server services
│   │   ├── CurrencyService.lua
│   │   ├── UpgradeService.lua
│   │   ├── SavingService.lua
│   │   └── ...
│   ├── client/                  # 2 client scripts
│   │   ├── UIController.client.lua
│   │   └── CharacterFilter.client.lua
│   └── shared/Config/           # 3 config files
│       ├── CharacterConfig.lua
│       ├── UpgradeConfig.lua
│       └── UIConfig.lua
├── docs/                        # Detailed documentation
├── default.project.json         # Rojo configuration
├── aftman.toml                 # Tool versions
└── README.md                   # This file
```

---

## 🎮 Game Features (v1.1)

- ✅ **5-Tier Character System** - $50 starter → $500k legendary
- ✅ **Upgrade System** - 2.5x claim + 7x speed multipliers
- ✅ **Offline Earnings** - Earn 50% while away (12hr cap)
- ✅ **Auto-Save** - DataStore saves every 2 minutes
- ✅ **Multi-Player** - Separate basepads & money per player
- ✅ **Character Filtering** - Only see your own characters
- ✅ **Anti-Exploit** - Server-authoritative, cooldown protection
- ✅ **Tutorial System** - Automatic for new players

---

## 🚀 Publishing to Roblox

1. Open `BrainrotGame-Template.rbxlx` in Studio
2. **File** → **Publish to Roblox**
3. Choose **Create New Game** or update existing
4. Fill in details and publish
5. Share the game link!

---

## 📚 Additional Documentation

See [docs/](docs/) folder for:
- **[PROJECT_HANDOVER.md](docs/PROJECT_HANDOVER.md)** - Complete technical overview
- **[FEATURES_LIST.md](docs/FEATURES_LIST.md)** - All 12 features explained
- **[API_REFERENCE.md](docs/API_REFERENCE.md)** - Service APIs
- **[TESTING_GUIDE.md](docs/TESTING_GUIDE.md)** - Testing procedures
- **[WORKSPACE_SETUP.md](docs/WORKSPACE_SETUP.md)** - Manual setup (if needed)

---

### **UI doesn't show?**
- Verify **MainHUD** exists in **StarterGui**
- Check all UI elements created correctly
- Press **Shift+F5** to stop, then **F5** to restart

### **"Rojo command not found"?**
```powershell
# Reinstall Aftman and tools:
aftman install
```

### **Data not saving in Studio?**
- Use **"Local Server"** test mode (not single player)
- Or publish to Roblox and test there

---

## 📁 Project Structure

```
BrainrotGame/
├── src/
│   ├── MainServer.server.lua           # Server entry point
│   ├── server/                         # Server services (7 files)
│   │   ├── CurrencyService.lua         # Money management
│   │   ├── UpgradeService.lua          # Upgrade system ⭐
│   │   ├── SavingService.lua           # DataStore + offline earnings
│   │   ├── BaseService.lua             # Earnings system
│   │   ├── PurchaseService.lua         # Purchase validation
│   │   ├── ShopLaneService.lua         # Shop spawning
│   │   └── TutorialService.lua         # Tutorial system
│   ├── client/                         # Client scripts (2 files)
│   │   ├── UIController.client.lua     # UI updates
│   │   └── CharacterFilter.client.lua  # Multiplayer filtering
│   └── shared/Config/                  # Configuration (3 files)
│       ├── CharacterConfig.lua         # Character tiers
│       ├── UpgradeConfig.lua           # Upgrade levels
│       └── UIConfig.lua                # UI styling
├── default.project.json                # Rojo configuration
├── aftman.toml                         # Tool versions
├── build.bat                           # Build script (Windows)
├── start.bat                           # Development server script
├── README.md                           # This file
└── docs/                               # Detailed documentation
    ├── PROJECT_HANDOVER.md             # Technical handover
    ├── API_REFERENCE.md                # Service APIs
    ├── FEATURES_LIST.md                # Complete feature list
    └── TESTING_GUIDE.md                # Testing procedures
```

---

## 📚 Detailed Documentation

For in-depth information, see the [docs/](docs/) folder:

- **[PROJECT_HANDOVER.md](docs/PROJECT_HANDOVER.md)** - Complete technical overview
- **[FEATURES_LIST.md](docs/FEATURES_LIST.md)** - All 12 features explained
- **[API_REFERENCE.md](docs/API_REFERENCE.md)** - All service APIs
- **[TESTING_GUIDE.md](docs/TESTING_GUIDE.md)** - How to test systems
- **[CHANGELOG_v1.1.md](docs/CHANGELOG_v1.1.md)** - Version history

---

## 🎮 Game Features (v1.1)

- ✅ **5-Tier Character System** - Free starter → $500k legendary
- ✅ **Upgrade System** - 2.5x claim multiplier + 7x speed multiplier
- ✅ **Offline Earnings** - Earn 50% while away (12hr cap)
- ✅ **Auto-Save** - DataStore saves every 2 minutes
- ✅ **Multi-Player** - Each player has separate basepads and money
- ✅ **Character Filtering** - Only see your own characters
- ✅ **Anti-Exploit** - Server-authoritative, 0.3s purchase cooldown
- ✅ **Tutorial System** - Automatic for new players
- ✅ **Toast Notifications** - Purchase feedback

---

## 🔧 Development Commands

```powershell
# Start development server (live sync):
rojo serve

# Build place file:
rojo build -o BrainrotGame.rbxl

# Format code:
stylua src/

# Lint code:
selene src/
```

---

## 🚀 Publishing to Roblox
---

## 📞 Support

**Issues?**
1. Check **Output window** in Studio (View → Output)
2. Read **[Troubleshooting](#-troubleshooting)** section above
3. See [docs/TESTING_GUIDE.md](docs/TESTING_GUIDE.md) for testing help

---

## 📄 License

This project is open source. Feel free to learn from and modify it!

---

**Built with:** Rojo 7.4.4 | Roblox Studio | Lua/Luau  
**Version:** 1.1 | **Last Updated:** February 20, 2026
