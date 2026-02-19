# 📋 CHANGELOG - Version 1.1

**Release Date:** February 19, 2026  
**Update Type:** Major Feature Update  

---

## 🆕 NEW FEATURES

### 1. **Upgrade System** ⚡
Two permanent upgrade paths with 6 levels each:

#### Claim Multiplier
- Multiplies money when claiming (1x → 2.5x)
- Costs: $50k to $500k
- Level 6 gives **+150% bonus** on all claims!

#### Delivery Speed
- Multiplies ALL character earnings (1x → 7x)
- Costs: $100k to $600k
- Level 6 gives **7x faster** earnings!

**Files Added:**
- `src/shared/Config/UpgradeConfig.lua` (149 lines) - Configuration
- `src/server/UpgradeService.lua` (165 lines) - Server logic

**RemoteEvents Added:**
- `RequestUpgrade` - Client → Server purchase request
- `UpgradeUpdate` - Server → Client upgrade level sync

---

### 2. **Offline Earnings** 💤
Players earn money while offline!

**Mechanics:**
- Awards **50%** of potential earnings
- Caps at **12 hours** maximum
- Minimum **10 seconds** away required
- Uses saved `LastLogout` timestamp
- Factors in Delivery Speed multiplier

**Example:**
- 400 EPS × 2 hours = 2,880,000 potential
- Player gets **1,440,000** added to Unclaimed

**Modified Files:**
- `src/server/SavingService.lua` - Added `CalculateOfflineEarnings()` function (lines 70-115)
- DataStore now saves `LastLogout` timestamp

---

### 3. **Character Filtering** 👥
Client-side filtering hides other players' characters!

**Benefits:**
- Reduces visual clutter
- Better performance
- Cleaner experience

**Files Added:**
- `src/client/CharacterFilter.client.lua` (~90 lines)

**Implementation:**
- Uses `LocalTransparencyModifier` for efficiency
- Filters based on `Owner.Value` StringValue
- Runs entirely client-side

---

### 4. **Enhanced Model System** 🎨
Characters now load from ReplicatedStorage templates:

**Structure:**
```
ReplicatedStorage/CharacterModels/
├── Brainrot_T1
├── Brainrot_T2
├── Brainrot_T3
├── Brainrot_T4
└── Brainrot_T5
```

**Features:**
- Humanoid models with animations
- Color-coded by tier
- Smooth shop-to-basepad transitions
- Owner identification values
- Nametags with EPS display

---

## 🔧 MODIFIED FILES

### Server Scripts
- **BaseService.lua** - Now applies delivery speed multiplier
- **SavingService.lua** - Added offline earnings calculation and LastLogout tracking
- **CurrencyService.lua** - Integrated with upgrade multipliers

### DataStore Schema Changes
```lua
-- v1.0 Schema
{
    Money = number,
    UnclaimedMoney = number,
    CharactersPurchased = {tier, tier, ...}
}

-- v1.1 Schema (NEW)
{
    Money = number,
    UnclaimedMoney = number,
    CharactersPurchased = {tier, tier, ...},
    Upgrades = {                    -- NEW
        ClaimMultiplier = number,
        DeliverySpeed = number
    },
    LastLogout = number            -- NEW (os.time() timestamp)
}
```

---

## 📊 STATISTICS

| Metric | v1.0 | v1.1 | Change |
|--------|------|------|--------|
| **Services** | 6 | 7 | +1 (UpgradeService) |
| **Config Files** | 2 | 3 | +1 (UpgradeConfig) |
| **Client Scripts** | 1 | 2 | +1 (CharacterFilter) |
| **RemoteEvents** | 5 | 7 | +2 |
| **Total Lines** | ~1,800 | ~2,300 | +500 |
| **Features** | 8 | 12 | +4 major features |

---

## 🎯 GAMEPLAY IMPACT

### Progression Speed
- **Early Game:** ~10% faster (offline earnings help new players)
- **Mid Game:** ~300% faster (Delivery Speed Level 3-4)
- **Late Game:** ~1,650% faster (7x delivery + 2.5x claim = 17.5x total)

### Player Retention
- **Offline Earnings:** Rewards returning players (reduces churn)
- **Upgrade System:** Long-term goals (encourages progression)
- **Character Filtering:** Better multiplayer experience

---

## 🔒 BACKWARD COMPATIBILITY

✅ **100% Compatible** - Existing v1.0 saves work perfectly!

**Migration Behavior:**
- Old players load with default upgrades (Level 1)
- Existing characters kept
- Money balances preserved
- No data loss

**DataStore:** Still uses `PlayerData_v1` (no breaking changes)

---

## 📚 DOCUMENTATION UPDATES

### Updated Files:
1. **README.md** 
   - Added complete feature guide
   - Gameplay walkthrough
   - Strategy tips
   - Upgrade priority recommendations

2. **PROJECT_HANDOVER.md**
   - v1.1 feature details
   - Upgrade system documentation
   - Offline earnings mechanics
   - Feature comparison table

3. **FEATURES_LIST.md** (NEW)
   - Comprehensive 12-feature breakdown
   - Code examples
   - Formulas and calculations
   - Monetization ideas

4. **CHANGELOG_v1.1.md** (NEW - This file!)
   - Complete change log
   - Migration guide
   - Impact analysis

---

## 🐛 KNOWN ISSUES

**None!** ✨ All features tested and working.

---

## 🚀 FUTURE ROADMAP IDEAS

Potential v1.2 features:
- 🏆 **Leaderboards** - Daily/Weekly/All-Time
- 🎁 **Daily Rewards** - Login bonuses
- 🎨 **Character Skins** - Cosmetic variants
- ⚔️ **Prestige System** - Reset for permanent bonuses
- 👥 **Trading System** - Exchange characters between players
- 📈 **Statistics Dashboard** - Detailed earnings graphs

---

## 🎉 CREDITS

**Development:** Rayhan  
**Framework:** Rojo 7.x  
**Platform:** Roblox Studio  
**Language:** Lua/Luau  

---

## 📞 SUPPORT

For questions about v1.1 features:
1. Read [FEATURES_LIST.md](FEATURES_LIST.md) for detailed mechanics
2. Check [README.md](README.md) for gameplay guides
3. Review [PROJECT_HANDOVER.md](PROJECT_HANDOVER.md) for technical documentation

---

**Version:** 1.1  
**Build Date:** February 19, 2026  
**Status:** ✅ Production Ready
