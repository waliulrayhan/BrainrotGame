# Documentation

Clean and simple documentation for BrainrotGame.

---

## Documentation Files

### [BACKEND_API.md](BACKEND_API.md)
**Complete backend reference for developers**

Contains:
- All 8 server services (Currency, Purchase, Base, BasePad, ShopLane, Saving, Upgrade, Tutorial)
- Complete API methods with parameters and return types
- Architecture overview and data flows
- Testing procedures and anti-exploit strategies
- Remote Events documentation
- Configuration files (CharacterConfig, UpgradeConfig)

**Use this when:**
- Writing server-side code
- Debugging gameplay logic
- Adding new features
- Understanding how services communicate

---

### [UI_DESIGN.md](UI_DESIGN.md)
**Complete UI and workspace setup guide**

Contains:
- Workspace structure (BasePads, ShopLane, PurchaseZone)
- Complete color palette (16 colors defined)
- UI component styling (TopBar, BalanceContainer, ClaimButton)
- Step-by-step setup instructions
- Character billboard styling
- Design tips and best practices

**Use this when:**
- Setting up the game world
- Customizing UI colors
- Creating new UI elements
- Understanding workspace structure

---

## Quick Start

**New to the project?**
1. Start with main [README.md](../README.md) (in parent folder)
2. Read [BACKEND_API.md](BACKEND_API.md) for server logic
3. Read [UI_DESIGN.md](UI_DESIGN.md) for UI/workspace setup

**Need to modify the game?**
- **Backend changes** → [BACKEND_API.md](BACKEND_API.md)
- **UI/Workspace changes** → [UI_DESIGN.md](UI_DESIGN.md)
- **Character/Upgrade config** → See [BACKEND_API.md](BACKEND_API.md) "Config Files" section

---

## Documentation Philosophy

This documentation follows a **"2-file rule"**:
- Everything backend-related in ONE file
- Everything frontend-related in ONE file
- No redundancy, no scattered information
- Easy to search, easy to maintain

---

**Version:** 1.1 | **Last Updated:** February 20, 2026
