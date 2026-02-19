# BrainrotGame - Idle Progression Game

An idle/tycoon game where you buy characters, place them on your basepad, and earn money automatically!

**Version:** 1.1 | **Framework:** Rojo + Roblox Studio

---

## What You Get

- **5-Tier Character System** - Buy characters from $0 (free starter) → $3,500
- **Automatic Earnings** - Characters earn 1 → 120 per second
- **Upgrade System** - 2.5x claim multiplier + 7x speed multiplier (6 levels each)
- **Offline Earnings** - Get 50% while away (12hr cap)
- **Auto-Save** - Everything persists via DataStore
- **Multi-Player Ready** - Isolated basepads per player

---

## Complete Setup Guide (From Zero to Play)

Follow these steps in order to set up and run the game:

### **Step 1: Download and Install Required Software**

Download and install these in order:

1. **Roblox Studio** - [Download here](https://www.roblox.com/create)
   - If you don't have a Roblox account, create one or login

2. **VS Code** - [Download here](https://code.visualstudio.com/)
   - Install with default settings

3. **Git** - [Download here](https://git-scm.com/downloads)
   - Install with default settings

### **Step 2: Download Aftman and Rojo**

1. **Download Aftman:**
   - Go to: https://github.com/LPGhatguy/aftman/releases/tag/v0.3.0
   - Download the Windows version
   - Extract to `C:\aftman`

2. **Download Rojo:**
   - Go to: https://github.com/rojo-rbx/rojo/releases/tag/v7.6.1
   - Download `rojo.exe` for Windows
   - Place it in `C:\rojo`

### **Step 3: Add to System PATH**

1. Press **Windows Key** and search **"Edit environment variables"**
2. Click **"Edit the system environment variables"**
3. Click **"Environment Variables"** button

**For System Variables:**
- Find **"Path"** → Click **"Edit"**
- Click **"New"** → Type `C:\aftman` → Press Enter
- Click **"New"** → Type `C:\rojo` → Press Enter
- Click **"OK"**

**For User Variables:**
- Find **"Path"** → Click **"Edit"**
- Click **"New"** → Type `C:\aftman` → Press Enter
- Click **"New"** → Type `C:\rojo` → Press Enter
- Click **"OK"**

4. Click **"OK"** on all windows

### **Step 4: Verify Installation**

1. **Close all open terminals and command prompts**
2. Open a **new PowerShell** window
3. Run these commands:
   ```powershell
   aftman --version
   rojo --version
   ```
4. If you see version numbers, installation is successful!

### **Step 5: Clone Project from GitHub**

1. Open **VS Code**
2. Press **Ctrl + Shift + P**
3. Type **"Git: Clone"** and press Enter
4. Paste: `https://github.com/waliulrayhan/BrainrotGame.git`
5. Choose a folder to save the project
6. Click **"Open"** when prompted

### **Step 6: Open in Roblox Studio**

1. In the project folder, find `BrainrotGame-Template.rbxl`
2. **Double-click** the file (it will open in Roblox Studio automatically)

### **Step 7: Install Rojo Plugin in Studio**

1. In Roblox Studio, click **"Plugins"** tab
2. Click **"Manage Plugins"**
3. Click the **"+"** (Add) icon
4. Search for **"Rojo"**
5. Click **"Install"** on the official Rojo plugin
6. Close the plugins window

### **Step 8: Connect VS Code to Roblox Studio**

1. In **VS Code**, open a new terminal (**Ctrl + `**)
2. Run this command:
   ```powershell
   rojo serve
   ```
3. You should see: `Rojo server listening on port 34872`

4. In **Roblox Studio**, click **"Plugins"** → **"Rojo"** → **"Connect"**
5. Click **"Connect"** in the Rojo popup
6. Wait for "Connected successfully!" message

### **Step 9: Play the Game!**

1. In Roblox Studio, press **F5**
2. **Boom! Enjoy the game!**

### **Gameplay Quick Guide:**
- Walk to the **green PurchaseZone**
- Click on **moving characters** to buy them
- They spawn on your basepad and earn money automatically
- Watch your **"Unclaimed"** money grow
- Click the big **"CLAIM"** button to collect earnings
- Buy better characters with your money!

---

## Character Tiers & Strategy

### **Character Tiers:**
| Tier | Name | Cost | Earnings/Second |
|------|------|------|------------------|
| T1 | Tiny Brainrot | $0 (Free) | 1 EPS |
| T2 | Better Brainrot | $25 | 3 EPS |
| T3 | Epic Brainrot | $150 | 10 EPS |
| T4 | Mythic Brainrot | $800 | 40 EPS |
| T5 | Legend Brainrot | $3,500 | 120 EPS |

### **Upgrade Tiers:**

**Claim Multiplier** (Multiply all claimed earnings):
- Level 1: Free (1x default)
- Level 2: $50,000 (1.25x)
- Level 3: $100,000 (1.5x)
- Level 4: $200,000 (1.75x)
- Level 5: $300,000 (2x)
- Level 6: $500,000 (2.5x MAX)

**Delivery Speed** (Increase earning speed):
- Level 1: Free (1x default)
- Level 2: $100,000 (2x)
- Level 3: $150,000 (3x)
- Level 4: $250,000 (4x)
- Level 5: $400,000 (5x)
- Level 6: $600,000 (7x MAX)

### **Recommended Strategy:**
1. Start with **free T1 character** (Tiny Brainrot)
2. Buy **T2 ($25)** and **T3 ($150)** characters first
3. Save for **Delivery Speed Level 2** ($100k) - doubles all earnings!
4. Buy more **T4 characters** ($800 each)
5. Keep upgrading **Delivery Speed** for massive income boosts
6. Late game: Max everything and collect **T5 Legend Brainrots**

### **Offline Earnings:**
- Earn **50%** of potential earnings while offline (max 12 hours)
- Always **claim before leaving** to save your money!

---

## Project Structure

```
BrainrotGame/
├── BrainrotGame-Template.rbxl            # Pre-built game file (open & play!)
├── src/                                  # Source code (syncs via Rojo)
│   ├── MainServer.server.lua             # Server entry point
│   ├── server/                           # Server services (7 files)
│   │   ├── BasePadService.lua            # Basepad management
│   │   ├── BaseService.lua               # Earnings system
│   │   ├── CurrencyService.lua           # Money management
│   │   ├── PurchaseService.lua           # Purchase validation
│   │   ├── SavingService.lua             # DataStore + offline earnings
│   │   ├── ShopLaneService.lua           # Shop spawning
│   │   └── TutorialService.lua           # Tutorial system
│   ├── client/                           # Client scripts (2 files)
│   │   ├── UIController.client.lua       # UI updates
│   │   └── CharacterFilter.client.lua    # Multiplayer filtering (not implemented yet)
│   └── shared/Config/                    # Configuration (3 files)
│       ├── CharacterConfig.lua           # Character tiers (5 tiers)
│       ├── UIConfig.lua                  # UI styling
│       └── UpgradeConfig.lua             # Upgrade levels (2 upgrades)
├── docs/                                 # Detailed documentation
├── default.project.json                  # Rojo configuration
├── aftman.toml                           # Tool versions
├── selene.toml                           # Linter config
├── stylua.toml                           # Formatter config
└── README.md                             # This file
```

---

## Game Features (v1.1)

- **5-Tier Character System** - Free starter → $3,500 legendary (Tiny → Legend Brainrot)
- **Dual Upgrade System** - Claim Multiplier (2.5x) + Delivery Speed (7x)
- **6 Upgrade Levels** - Each upgrade has 6 levels ($0 → $600,000)
- **Offline Earnings** - Earn 50% while away (12 hour cap)
- **Auto-Save System** - DataStore saves every 2 minutes + on leave
- **Multi-Player Ready** - Separate basepads & currency per player
- **Weighted Character Spawning** - Rare characters spawn less often
- **Anti-Exploit Protection** - Server-authoritative, 0.3s cooldown
- **Tutorial System** - Automatic for new players
- **Config-Driven Design** - Easy to add new characters/upgrades

---

## Contact & Support

**Developer:** Md. Waliul Islam Rayhan

- **GitHub:** [github.com/waliulrayhan](https://github.com/waliulrayhan)
- **LinkedIn:** [linkedin.com/in/waliulrayhan](https://linkedin.com/in/waliulrayhan)
- **Email:** [b190305034@cse.jnu.ac.bd](mailto:b190305034@cse.jnu.ac.bd)

---

**Built with:** Rojo 7.4.4 | Roblox Studio | Lua/Luau  
**Version:** 1.1 | **Last Updated:** February 20, 2026
