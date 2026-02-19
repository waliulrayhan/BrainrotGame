# 📋 HANDOVER CHECKLIST

Use this checklist to ensure everything is ready before handing over the project.

---

## PRE-HANDOVER TASKS

### 1️⃣ Code & Documentation
- [ ] All code files present in `src/` folder
- [ ] No obvious errors in Output window when testing
- [ ] All documentation files included:
  - [ ] README.md (UI guide)
  - [ ] QUICKSTART.md (setup guide)
  - [ ] PROJECT_HANDOVER.md (master handover doc)
  - [ ] TESTING_GUIDE.md (test procedures)
  - [ ] WORKSPACE_SETUP.md (3D world setup)
  - [ ] COMPLIANCE.md (requirements checklist)

### 2️⃣ Build the Place File
```powershell
# Run this command in the project directory:
rojo build -o BrainrotGame.rbxl
```
- [ ] `BrainrotGame.rbxl` file created successfully
- [ ] No build errors in terminal
- [ ] File size > 0 KB (not corrupted)

### 3️⃣ Studio Setup Verification
Open `BrainrotGame.rbxl` in Roblox Studio and verify:

**Workspace:**
- [ ] ShopLane folder exists with LanePath part
- [ ] PurchaseZone part exists (green transparent part)
- [ ] BasePads folder exists with 5 parts:
  - [ ] BasePad_T1
  - [ ] BasePad_T2
  - [ ] BasePad_T3
  - [ ] BasePad_T4
  - [ ] BasePad_T5

**StarterGui:**
- [ ] MainHUD ScreenGui exists
- [ ] TopBar with Balance and Unclaimed displays
- [ ] ClaimButton visible and functional
- [ ] Toast notification system configured

**ReplicatedStorage** (auto-created by Rojo):
- [ ] Shared → Config → CharacterConfig
- [ ] Shared → Config → UIConfig
- [ ] Shared → Remotes (all 6 RemoteEvents)

**ServerScriptService** (auto-created by Rojo):
- [ ] Services folder with all 7 service files
- [ ] MainServer script

---

## 4️⃣ FUNCTIONAL TESTING

Run each test and check the box when it passes:

### Test A: Basic Gameplay
- [ ] Press F5 in Studio → Test starts without errors
- [ ] Characters spawn and move on shop lane
- [ ] UI displays Balance and Unclaimed correctly
- [ ] Player can walk around freely

### Test B: Purchase System
- [ ] Walk to green PurchaseZone
- [ ] Click a moving character
- [ ] Character disappears from lane
- [ ] Character appears on appropriate basepad
- [ ] Balance decreases by correct amount
- [ ] Toast notification appears

### Test C: Earnings System
- [ ] Wait ~5-10 seconds after buying a character
- [ ] Unclaimed value increases automatically
- [ ] Click CLAIM button
- [ ] Unclaimed resets to $0
- [ ] Balance increases by claimed amount

### Test D: Saving System
- [ ] Buy 1-2 characters and let them earn money
- [ ] Note current Balance and Unclaimed values
- [ ] Stop the test (press Shift+F5)
- [ ] Start a new test (F5)
- [ ] Verify Balance and Unclaimed match previous values
- [ ] Verify characters are still on basepads

### Test E: Multi-Player Isolation
- [ ] Start "Server & Clients" test (not single player)
- [ ] Buy character on Player1 → goes to Player1's base only
- [ ] Buy character on Player2 → goes to Player2's base only
- [ ] Earnings and claims are separate for each player

### Test F: Anti-Exploit Checks
- [ ] Spam-click characters → only 1 purchase per 0.3s succeeds
- [ ] Try buying with $0 balance → shows "Not enough money" message
- [ ] Try buying while outside PurchaseZone → fails silently

---

## 5️⃣ FINAL PACKAGE PREPARATION

### Files to Include in Handover
Create a folder with these items:

- [ ] **BrainrotGame.rbxl** - Built place file
- [ ] **src/** folder - All source code
- [ ] **default.project.json** - Rojo configuration
- [ ] **aftman.toml** - Tool versions
- [ ] **All documentation .md files** (9 files total)
- [ ] **PROJECT_HANDOVER.md** - Master handover guide
- [ ] **HANDOVER_CHECKLIST.md** - This file
- [ ] **Mini_Project_Specification_2.pdf** - Original requirements

### Optional but Recommended
- [ ] **README.txt** - Plain text quick start guide
- [ ] **CHANGELOG.md** - Version history (if applicable)
- [ ] **.gitignore** - If using Git
- [ ] **Screenshots/** folder - In-game screenshots showing features

---

## 6️⃣ HANDOVER MEETING PREPARATION

Prepare to demonstrate these during handover:

- [ ] **Project structure walkthrough** (5 min)
  - Show folder organization
  - Explain Rojo workflow
  - Point out key files

- [ ] **Live demo in Studio** (10 min)
  - Start Rojo server: `rojo serve`
  - Connect Studio to Rojo
  - Show gameplay loop
  - Demonstrate purchase → earn → claim

- [ ] **Code tour** (10 min)
  - Open CharacterConfig.lua → show how to add characters
  - Open MainServer.server.lua → explain service initialization
  - Open UIController.client.lua → show client/server separation

- [ ] **Testing walkthrough** (5 min)
  - Show how to run tests from TESTING_GUIDE.md
  - Demonstrate save/load persistence
  - Show Output window for debugging

---

## 7️⃣ KNOWLEDGE TRANSFER

### Key Concepts to Explain
- [ ] **Rojo workflow**: VS Code → Rojo → Studio sync
- [ ] **Service architecture**: Each service has a specific job
- [ ] **Client/Server separation**: Client requests, server validates
- [ ] **RemoteEvents**: How client and server communicate
- [ ] **DataStore saving**: How player data persists

### Delivery Method Decision
- [ ] **Recommended:** Use dual delivery (GitHub + Roblox) - Follow [DUAL_DELIVERY_GUIDE.md](DUAL_DELIVERY_GUIDE.md)
  - [ ] GitHub Repository created with Release + .rbxl attachment
  - [ ] Published to Roblox with public play link
  - [ ] Both links tested and ready to share
- [ ] Alternative: Single delivery method
  - [ ] If GitHub only: Follow [GITHUB_DELIVERY_GUIDE.md](GITHUB_DELIVERY_GUIDE.md)
  - [ ] If Roblox only: Publish and share link
  - [ ] If file sharing: Zip entire project folder

### Common Maintenance Tasks
- [ ] How to add a new character (edit CharacterConfig.lua)
- [ ] How to change starting balance (edit CurrencyService.lua)
- [ ] How to reset player data (change DataStore version)
- [ ] How to adjust earn rates (edit CharacterConfig.lua)

---

## 8️⃣ FINAL CHECKLIST

Before official handover:

- [ ] All tests passing
- [ ] No errors in Output window
- [ ] Place file builds successfully
- [ ] Documentation is complete and accurate
- [ ] Known limitations documented in PROJECT_HANDOVER.md
- [ ] Contact information provided (if needed)
- [ ] All deliverables packaged in folder/zip
- [ ] Backup copy made for your records

---

## ✅ SIGN-OFF

**Developer:**  
Name: Rayhan  
Date: _______________  
Signature: _______________

**Recipient:**  
Name: _______________  
Date: _______________  
Signature: _______________

---

## 📞 POST-HANDOVER SUPPORT

If support is needed after handover:
- **Documentation:** Start with PROJECT_HANDOVER.md
- **Common Issues:** See Troubleshooting section
- **Code Questions:** Reference API documentation in handover guide

**Support Period:** [Define if applicable]  
**Support Method:** [Email/Discord/etc - if applicable]

---

*Use this checklist to ensure a smooth and complete handover process.*
