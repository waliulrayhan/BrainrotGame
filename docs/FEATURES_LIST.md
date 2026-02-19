# 🎮 BrainrotGame - Complete Features List

## ✅ Core Features (v1.0)

### 1. **5-Tier Character System**
- **Tiny Brainrot** ($0, 1 EPS) - Free starter
- **Better Brainrot** ($25, 3 EPS) - First upgrade
- **Epic Brainrot** ($150, 10 EPS) - Mid-game
- **Mythic Brainrot** ($800, 40 EPS) - Late-game
- **Legend Brainrot** ($3,500, 120 EPS) - Endgame

Each character:
- Unique color scheme
- Animated 3D models
- Earns money automatically
- Tier-specific basepads

---

### 2. **Purchase & Earnings System**
- **Shop Lane**: Characters continuously spawn and move left → right
- **Purchase Zone**: Players must stand in green zone to buy
- **Instant Delivery**: Characters smoothly tween to basepads
- **Real-time Earnings**: Money accumulates every second into Unclaimed pool
- **Claim Mechanic**: Large animated button to collect earnings

**Anti-Exploit Protection:**
- 0.3s cooldown between purchases
- Server validates all transactions
- Balance checks before deduction
- Client cannot modify money values

---

### 3. **🆕 Upgrade System** (v1.1)
Two upgrade types with 6 levels each:

#### **💰 Claim Multiplier**
Multiplies all claimed earnings:
- Level 1: 1x (default, free)
- Level 2: 1.25x (+25%) - $50,000
- Level 3: 1.5x (+50%) - $100,000
- Level 4: 1.75x (+75%) - $200,000
- Level 5: 2x (+100%) - $300,000
- Level 6: 2.5x (+150%) - $500,000

#### **⚡ Delivery Speed** (Earning Speed)
Increases earning rate for ALL characters:
- Level 1: 1x (default, free)
- Level 2: 2x (+100% faster) - $100,000
- Level 3: 3x (+200% faster) - $150,000
- Level 4: 4x (+300% faster) - $250,000
- Level 5: 5x (+400% faster) - $400,000
- Level 6: 7x (+600% faster) - $600,000

**How Upgrades Work:**
- Purchased with in-game money (Balance)
- Permanent upgrades (saved to DataStore)
- Apply globally to all characters
- Stack with character EPS
- Cannot downgrade or reset

**Example:** 
- Player has 3 characters: 1 EPS, 3 EPS, 10 EPS = 14 total EPS
- With Delivery Speed Level 3 (3x): 14 × 3 = **42 EPS**
- With Claim Multiplier Level 2 (1.25x): Claiming $100 gives **$125**

---

### 4. **🆕 Offline Earnings** (v1.1)
Players earn money even when not playing!

**How It Works:**
1. Game saves `LastLogout` timestamp when player leaves
2. On rejoin, calculates time away
3. Awards 50% of potential earnings
4. Capped at 12 hours maximum
5. Minimum 10 seconds offline required

**Calculation Formula:**
```
Base EPS × Delivery Speed Multiplier × Time Away × 50%
```

**Example:**
- Player has 100 total EPS
- Delivery Speed Level 4 (4x multiplier) = 400 actual EPS
- Offline for 2 hours (7200 seconds)
- Potential: 400 × 7200 = 2,880,000
- Offline Award: 2,880,000 × 50% = **1,440,000** added to Unclaimed

**Features:**
- Displayed on rejoin as notification
- Added to Unclaimed pool (not auto-claimed)
- Respects upgrade multipliers
- Prevents AFK farming abuse (50% penalty)
- Caps at 12 hours (encourages daily play)

---

### 5. **🆕 Multi-Player Character Filtering** (v1.1)
Each player only sees their own characters!

**Client-Side Filtering:**
- Hides other players' basepad characters
- Uses `LocalTransparencyModifier` (efficient)
- Nametags hidden for other players
- Reduces visual clutter
- Better performance

**Why This Matters:**
- Prevents confusion ("Whose character is that?")
- Cleaner basepad view
- Better for screenshots/videos
- Reduces lag in crowded servers

---

### 6. **Currency System**
Two-currency system for better gameplay:

#### **Balance** (💰)
- Spendable money for purchases
- Displayed as gold text (left side of UI)
- Never goes negative (server validates)
- Clamped to prevent overflow exploits

#### **Unclaimed** (⏰)
- Earned money waiting to be collected
- Displayed as green text (right side of UI)
- Updates every second
- Must be manually claimed

**Why Two Currencies?**
- Creates engagement (players return to claim)
- Prevents instant spending of all earnings
- Makes progression more visible
- Adds strategic "when to claim" decision

---

### 7. **Data Persistence (DataStore)**
All player progress saves automatically!

**What's Saved:**
- Balance (spendable money)
- Unclaimed money
- Owned characters (by ID)
- Upgrade levels (Claim Multiplier & Delivery Speed)
- Tutorial completion status
- Last logout time (for offline earnings)

**Saving Features:**
- Auto-save every 2 minutes
- Manual save on player disconnect
- Retry logic (3 attempts with backoff)
- Shutdown handler (saves all online players)
- Version-controlled DataStore (`PlayerData_v1`)

**Data Structure:**
```lua
{
    Balance = 1000,
    Unclaimed = 250,
    Earners = {{id = 1}, {id = 3}, {id = 5}},
    Upgrades = {
        ClaimMultiplier = 2,
        DeliverySpeed = 3
    },
    HasSeenTutorial = true,
    LastSave = 1708392847,
    LastLogout = 1708392847
}
```

---

### 8. **Multi-Player Support**
Full multi-player functionality:

- **Isolated Bases**: Each player has separate character collections
- **Independent Currency**: Balance/Unclaimed per player
- **Separate Earnings**: Your characters only earn for you
- **Concurrent Purchases**: Multiple players can buy simultaneously
- **Per-Player Tutorial**: Tutorial state saved individually
- **Visual Filtering**: Only see your own characters (client-side)

**Server Architecture:**
- Player data stored by `UserId`
- All operations server-authoritative
- No player-to-player interference
- Supports unlimited concurrent players

---

### 9. **User Interface**
Beautiful gradient-based UI with animations:

#### **TopBar** (Purple gradient)
- Balance display (gold, left side)
- Unclaimed display (green, right side)
- Smooth number animations
- Emoji icons for visual appeal

#### **CLAIM Button** (Pink gradient, bottom center)
- Large, prominent button
- Glowing yellow border
- Pulse animation when money available
- Satisfying click feedback

#### **Toast Notifications**
- Success messages (green) - "Bought Tiny Brainrot!"
- Error messages (red) - "Not enough money!"
- Slide-in animation from top
- Auto-dismiss after 3 seconds

#### **Visual Effects:**
- Multiple UIGradients for depth
- Rounded corners (UICorner)
- Glowing borders (UIStroke)
- Smooth number count-ups
- Color-coded feedback

---

### 10. **Tutorial System**
Optional first-time player guide:

- Detects new players (no saved data)
- Step-by-step instructions
- Can be skipped
- Completion saved to DataStore
- Never shows again after completion

---

### 11. **Character Models & Animation**
Full character system on basepads:

**Character Properties:**
- Color-coded by tier (gray → green → blue → purple → coral)
- Animated humanoid models
- Nametags showing character name + EPS
- Owner identification
- Tier values stored

**Basepad Management:**
- 5 tier-specific basepads (BasePad_T1 to T5)
- Grid layout (4 characters per row, 5 studs apart)
- Smooth movement from shop lane to basepad
- Tween animations (1.5s duration)
- Automatic positioning

---

### 12. **Shop Lane System**
Dynamic character spawning:

**Weighted Spawn System:**
- Higher tier = rarer spawn (lower weight)
- Tier 1: 40% chance
- Tier 2: 30% chance  
- Tier 3: 20% chance
- Tier 4: 15% chance
- Tier 5: 8% chance

**Movement:**
- Smooth TweenService movement
- Left to right across lane path
- Auto-despawn after reaching end
- Respawn after 30 seconds or purchase
- Click detection while moving

---

## 🎯 Technical Features

### Server Architecture
- **6 ModuleScript Services:**
  1. CurrencyService - Money management
  2. PurchaseService - Purchase validation
  3. BasePadService - Character placement & management
  4. ShopLaneService - Shop spawning
  5. SavingService - DataStore operations
  6. UpgradeService - Upgrade management *(NEW)*
- **1 Main Server Script:** Service initialization & lifecycle
- **2 Config Modules:** CharacterConfig, UpgradeConfig *(NEW)*

### Client Architecture
- **UIController:** UI updates & button handling
- **CharacterFilter:** Client-side character visibility *(NEW)*
- **RemoteEvent Communication:** Secure server-client messaging

### Security Features
- ✅ Server-authoritative (all money operations)
- ✅ Purchase cooldown (0.3s anti-spam)
- ✅ Balance validation (no negative money)
- ✅ Input sanitization (clamp, round to int)
- ✅ Rate limiting on purchases
- ✅ Client cannot modify saved data
- ✅ Upgrade costs validated server-side

---

## 📊 Progression System

### Early Game (Minutes 0-5)
- Start with $0
- Get free Tiny Brainrot (1 EPS)
- Save up for Better Brainrot ($25, 3 EPS)
- Learn mechanics (buy, earn, claim)

### Mid Game (Minutes 5-15)
- Buy Epic Brainrot ($150, 10 EPS)
- Start considering first upgrade
- Begin to understand claim multiplier value
- Build character collection

### Late Game (Minutes 15+)
- Unlock Mythic Brainrot ($800, 40 EPS)
- Purchase delivery speed upgrades (huge EPS boost)
- Work toward Legend Brainrot ($3,500, 120 EPS)
- Max out upgrade levels

### Endgame (Minutes 30+)
- Multiple Legend Brainrots
- Max Delivery Speed (7x multiplier)
- Max Claim Multiplier (2.5x)
- Optimize for offline earnings
- Daily check-ins for offline rewards

**Example Progression:**
```
Time 0: $0, 0 EPS
↓ Get free Tiny Brainrot
Time 1: $0, 1 EPS (1 per second)
↓ After 25 seconds, buy Better Brainrot
Time 2: $0, 4 EPS (4 per second)
↓ After ~40 seconds, buy Epic Brainrot
Time 3: $0, 14 EPS (14 per second)
↓ After ~60 seconds, buy Delivery Speed x2
Time 4: Earning 28 per second (14 × 2)
↓ Scale exponentially...
Endgame: 500+ EPS × 7 multiplier = 3,500+ per second!
```

---

## 🔄 Feature Development Timeline

### v1.0 (Initial Release)
- 5-tier character system
- Purchase & earnings system
- Basic DataStore saving
- Multi-player support
- UI with gradients
- Tutorial system

### v1.1 (Current - Feature Update)
- ✅ **Upgrade system** (Claim Multiplier & Delivery Speed)
- ✅ **Offline earnings** (50%, 12-hour cap)
- ✅ **Character filtering** (client-side visibility)
- ✅ **Enhanced saving** (upgrades, logout time, EPS values)
- ✅ **Improved basepads** (tier-specific, grid layout)
- ✅ **Model integration** (character templates in ReplicatedStorage)

### Future Potential (Ideas)
- Trading system between players
- VIP game passes (double earnings, skip cooldowns)
- Daily quests and rewards
- Character skins/cosmetics
- Prestige system (reset for permanent bonuses)
- Leaderboards (richest players)
- Rebirth mechanic
- More character tiers (6-10)

---

## 🎮 Gameplay Loop Summary

```
1. Player joins → Offline earnings calculated & added to Unclaimed
2. Buy characters from shop lane → Added to tier basepad
3. Characters earn money → Added to Unclaimed every second
4. Upgrades boost earnings → Delivery Speed multiplies EPS
5. Click CLAIM button → Move Unclaimed to Balance (with Claim Multiplier)
6. Spend Balance on more characters or upgrades
7. Progress through tiers → Higher EPS, faster progression
8. Player leaves → LastLogout saved for offline earnings
9. Return later → Receive offline earnings + continue loop
```

---

## 📈 Monetization Potential (Future)

While current version is free-to-play with no monetization:

**Potential Game Passes:**
- 2x Earnings (permanent)
- Offline Cap Extended (24 hours instead of 12)
- VIP Status (exclusive chat tag, sparkle effect)
- Instant Claim (auto-claims every minute)
- Character Slots (own more characters per tier)

**Developer Products:**
- Currency packs (buy Balance with Robux)
- Time skip (instant offline earnings for X hours)
- Upgrade booster (reduce upgrade costs by 25%)

**Current Design:** No pay-to-win, purely skill/time-based progression

---

## 🏆 Achievements (Not Yet Implemented, Ideas)

Potential achievement system:
- First Purchase - "Welcome to Brainrot!"
- 10 Characters - "Small Business Owner"
- 50 Characters - "Brainrot Tycoon"
- Max Upgrade - "Peak Performance"
- 1 Million Balance - "Millionaire"
- 100 Hours Played - "Dedicated Player"
- Max Offline Earnings - "Sleep Rich"

---

**Total Features Implemented:** 12 major systems, 30+ subsystems  
**Lines of Code:** ~2,000+ Lua  
**Configuration Files:** 3 (Character, UI, Upgrade)  
**Services:** 7 ModuleScripts  
**Version:** 1.1 (February 2026)
