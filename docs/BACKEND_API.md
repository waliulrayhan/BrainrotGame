# Backend API & Server Logic

Complete reference for all server-side systems, services, and APIs in BrainrotGame.

---

## Architecture Overview

BrainrotGame uses a **modular service-based architecture** where each service handles a specific responsibility:

```
MainServer.server.lua (Entry point)
├── CurrencyService      → Money management (Balance/Unclaimed)
├── PurchaseService      → Purchase validation & processing
├── BaseService          → Earnings calculation & loop
├── BasePadService       → Character placement on basepads
├── ShopLaneService      → Shop character spawning
├── SavingService        → DataStore & offline earnings
├── UpgradeService       → Upgrade system (v1.1)
└── TutorialService      → First-time player tutorial
```

**Key Principles:**
- **Server-authoritative** - Client cannot modify game state
- **Service isolation** - Each service has clear responsibilities
- **Clear APIs** - Every service exposes documented public methods
- **Anti-exploit** - Validation, cooldowns, and sanity checks everywhere

---

## CurrencyService

**Purpose:** Manages player money (Balance and Unclaimed)  
**File:** `src/server/CurrencyService.lua`

### Methods

#### `CurrencyService.Initialize()`
Initializes the service and sets up RemoteEvents.
```lua
CurrencyService.Initialize()
```

#### `CurrencyService.InitPlayer(player, savedBalance?, savedUnclaimed?)`
Sets up currency data for a new player.
```lua
CurrencyService.InitPlayer(player, 100, 50) -- Start with $100 balance, $50 unclaimed
CurrencyService.InitPlayer(player) -- Start with $0/$0
```

#### `CurrencyService.AddBalance(player, amount)`
Adds money to player's spendable balance.
```lua
CurrencyService.AddBalance(player, 500) -- Give player $500
```

#### `CurrencyService.DeductBalance(player, amount) --> boolean`
Attempts to deduct money from player's balance.
```lua
local success = CurrencyService.DeductBalance(player, 100)
if success then
    print("Purchase successful!")
else
    print("Not enough money!")
end
```
**Returns:** `true` if successful, `false` if insufficient funds

#### `CurrencyService.AddUnclaimed(player, amount)`
Adds money to player's unclaimed earnings pool.
```lua
CurrencyService.AddUnclaimed(player, 10) -- Add $10 to unclaimed
```

#### `CurrencyService.ClaimUnclaimed(player)`
Moves all unclaimed money to spendable balance (applies claim multiplier).
```lua
CurrencyService.ClaimUnclaimed(player) -- Transfer unclaimed → balance
```

#### `CurrencyService.GetPlayerData(player) --> table`
Retrieves player's currency data.
```lua
local data = CurrencyService.GetPlayerData(player)
print(data.Balance, data.Unclaimed) -- e.g., 1000, 250
```
**Returns:** `{Balance = number, Unclaimed = number}` or `nil`

#### `CurrencyService.SyncPlayer(player)`
Sends current currency state to client via StateUpdate event.
```lua
CurrencyService.SyncPlayer(player) -- Force UI update
```

---

## PurchaseService

**Purpose:** Validates and processes character purchases  
**File:** `src/server/PurchaseService.lua`

### Methods

#### `PurchaseService.Initialize(currencyService, baseService)`
Initializes the service with dependencies.
```lua
PurchaseService.Initialize(CurrencyService, BaseService)
```

#### `PurchaseService.HandlePurchaseRequest(player, characterModel)`
Processes a purchase request (called by RemoteEvent).
```lua
PurchaseService.HandlePurchaseRequest(player, characterModel)
```

**Validation Checks:**
- Character still exists in workspace
- Player is in PurchaseZone
- Player has sufficient balance
- 0.3s cooldown since last purchase
- Character data is valid

#### `PurchaseService.IsPlayerInPurchaseZone(player) --> boolean`
Checks if player's character is touching the PurchaseZone.
```lua
if PurchaseService.IsPlayerInPurchaseZone(player) then
    print("Player is in shop area!")
end
```

---

## BaseService

**Purpose:** Manages earnings calculation loop and EPS tracking  
**File:** `src/server/BaseService.lua`

### Methods

#### `BaseService.Initialize(currencyService, upgradeService)`
Initializes earning system and starts the 1-second earning loop.
```lua
BaseService.Initialize(CurrencyService, UpgradeService)
```

#### `BaseService.AssignBase(player) --> boolean`
Assigns a base to a player (legacy function, now uses tier-based basepads).
```lua
local success = BaseService.AssignBase(player)
```

#### `BaseService.AddEarner(player, characterData, characterModel)`
Adds a purchased character to player's base for earnings.
```lua
BaseService.AddEarner(player, {tier = 2, eps = 5, id = 2}, characterModel)
```

**Behavior:**
- Delegates to BasePadService for placement on correct tier basepad
- Updates total EPS calculation
- Logs new total EPS

#### `BaseService.GetTotalEPS(player) --> number`
Calculates total earnings per second for a player across all earners.
```lua
local eps = BaseService.GetTotalEPS(player) -- Returns sum of all character EPS
```

#### `BaseService.GetPlayerEarners(player) --> array`
Returns serializable earner data for saving to DataStore.
```lua
local earners = BaseService.GetPlayerEarners(player)
-- Returns: {{id = 1, tier = 1}, {id = 2, tier = 2}, ...}
```

#### `BaseService.RestoreEarners(player, savedEarners)`
Restores purchased characters from saved data on player join.
```lua
BaseService.RestoreEarners(player, savedData.Earners)
```

#### `BaseService.StartEarningLoop()`
Starts the 1-second Heartbeat loop that adds unclaimed currency based on EPS.
```lua
BaseService.StartEarningLoop() -- Called automatically by Initialize
```

**Loop Behavior:**
- Runs every 1 second
- Applies delivery speed multiplier from UpgradeService
- Adds earnings to unclaimed currency (CurrencyService)
- Logs every 10 seconds to avoid spam

#### `BaseService.CleanupPlayer(player)`
Cleans up player's earners when they leave.
```lua
BaseService.CleanupPlayer(player)
```

---

## BasePadService

**Purpose:** Manages tier-based basepads and character placement  
**File:** `src/server/BasePadService.lua`

### Methods

#### `BasePadService.Initialize()`
Initializes basepads and starts earnings loop.
```lua
BasePadService.Initialize()
```
**Auto-detects:** BasePad_T1 through BasePad_T5 in `Workspace.BasePads`

#### `BasePadService.AddCharacterToBase(player, characterId)`
Places a purchased character on appropriate tier basepad.
```lua
BasePadService.AddCharacterToBase(player, 3) -- Add Tier 3 character
```

**What it does:**
- Creates character model on tier-specific basepad
- Arranges characters in grid (4 per row, 5 studs apart)
- Adds nametag showing character name and EPS
- Starts earning money for player

#### `BasePadService.GetPlayerEarners(player) --> array`
Gets list of all characters owned by player (for saving).
```lua
local earners = BasePadService.GetPlayerEarners(player)
-- Returns: {{characterId = 1, BasePadRef = "T1"}, {characterId = 2, BasePadRef = "T2"}}
```

#### `BasePadService.LoadPlayerEarners(player, savedData)`
Restores player's characters from saved data.
```lua
local savedEarners = {
    {characterId = 1, BasePadRef = "T1"},
    {characterId = 3, BasePadRef = "T3"}
}
BasePadService.LoadPlayerEarners(player, savedEarners)
```

#### `BasePadService.CalculatePlayerTotalEPS(player) --> number`
Calculates total earnings per second for all player's characters.
```lua
local totalEPS = BasePadService.CalculatePlayerTotalEPS(player)
print("Player earns", totalEPS, "per second")
```

#### `BasePadService.CleanupPlayer(player)`
Removes all player's characters from basepads (on disconnect).

---

## ShopLaneService

**Purpose:** Spawns and moves characters on shop lane  
**File:** `src/server/ShopLaneService.lua`

### Methods

#### `ShopLaneService.Initialize()`
Initializes lane and starts spawning characters.
```lua
ShopLaneService.Initialize()
```
**Requirements:** `Workspace.ShopLane.LanePath` part must exist

#### `ShopLaneService.SpawnRandomCharacter()`
Spawns a random character from CharacterConfig.
```lua
ShopLaneService.SpawnRandomCharacter()
```

**Spawn System:**
- Uses `spawnWeight` from CharacterConfig (lower weight = rarer)
- Characters move left → right using TweenService
- Respawns after 30s or when purchased

---

## SavingService

**Purpose:** Loads and saves player data to DataStore  
**File:** `src/server/SavingService.lua`

### Methods

#### `SavingService.Initialize(currencyService, basePadService, upgradeService)`
Initializes service and starts auto-save loop (every 120 seconds).
```lua
SavingService.Initialize(CurrencyService, BasePadService, UpgradeService)
```

#### `SavingService.LoadPlayerData(player) --> table`
Loads player data from DataStore.
```lua
local data = SavingService.LoadPlayerData(player)
if data then
    print("Loaded balance:", data.Balance)
    print("Loaded characters:", #data.Earners)
else
    print("New player - no saved data")
end
```

**Data Structure:**
```lua
{
    Balance = 1000,
    Unclaimed = 250,
    Earners = {{characterId = 1, BasePadRef = "T1"}},
    Upgrades = {ClaimMultiplier = 1, DeliverySpeed = 1},
    HasSeenTutorial = true,
    LastLogout = 1234567890,
    LastSave = 1234567890
}
```

#### `SavingService.SavePlayerData(player) --> boolean`
Saves player data to DataStore with retry logic (3 attempts).
```lua
local success = SavingService.SavePlayerData(player)
```

#### `SavingService.CalculateOfflineEarnings(player, savedData) --> number`
Calculates 50% of potential earnings while player was offline (12hr cap).
```lua
local offlineEarnings = SavingService.CalculateOfflineEarnings(player, savedData)
```

**Formula:**
```lua
timeAwaySeconds = min(currentTime - LastLogout, 43200) -- 12hr cap
totalEPS = CalculatePlayerTotalEPS(player) * deliverySpeedMultiplier
offlineEarnings = totalEPS * timeAwaySeconds * 0.5 -- 50% rate
```

---

## UpgradeService (v1.1)

**Purpose:** Manages two upgrade systems (Claim Multiplier & Delivery Speed)  
**File:** `src/server/UpgradeService.lua`

### Methods

#### `UpgradeService.Initialize(currencyService)`
Initializes upgrade system and RemoteEvents.
```lua
UpgradeService.Initialize(CurrencyService)
```

#### `UpgradeService.InitPlayer(player, savedUpgrades)`
Sets up player's upgrade levels (default Level 1 for both).
```lua
UpgradeService.InitPlayer(player, {ClaimMultiplier = 2, DeliverySpeed = 3})
```

#### `UpgradeService.PurchaseUpgrade(player, upgradeId) --> boolean`
Attempts to purchase next level of an upgrade.
```lua
local success = UpgradeService.PurchaseUpgrade(player, "DeliverySpeed")
```

**Validation:**
- Checks if already at max level
- Deducts cost from balance
- Applies new multiplier
- Saves to DataStore

#### `UpgradeService.GetPlayerUpgrades(player) --> table`
Gets player's current upgrade levels.
```lua
local upgrades = UpgradeService.GetPlayerUpgrades(player)
-- Returns: {ClaimMultiplier = 2, DeliverySpeed = 3}
```

#### `UpgradeService.GetClaimMultiplier(player) --> number`
Gets current claim multiplier (1x → 2.5x).
```lua
local multiplier = UpgradeService.GetClaimMultiplier(player) -- e.g., 1.5
```

#### `UpgradeService.GetDeliverySpeedMultiplier(player) --> number`
Gets current delivery speed multiplier (1x → 7x).
```lua
local multiplier = UpgradeService.GetDeliverySpeedMultiplier(player) -- e.g., 3
```

---

## TutorialService

**Purpose:** Shows first-time tutorial to new players  
**File:** `src/server/TutorialService.lua`

### Methods

#### `TutorialService.Initialize()`
Sets up tutorial system.

#### `TutorialService.ShowTutorialIfNeeded(player)`
Shows tutorial if player hasn't seen it (checks `HasSeenTutorial` flag).
```lua
TutorialService.ShowTutorialIfNeeded(player)
```

---

## CharacterConfig (Shared)

**Purpose:** Defines all 5 character tiers  
**File:** `src/shared/Config/CharacterConfig.lua`

### Methods

#### `CharacterConfig.GetCharacterById(id) --> table`
Gets character data by ID (1-5).
```lua
local char = CharacterConfig.GetCharacterById(3)
print(char.name)  -- "Epic Brainrot"
print(char.price) -- 150
print(char.earningsPerSecond) -- 10
```

#### `CharacterConfig.GetRandomCharacter() --> table`
Gets random character based on spawn weights.
```lua
local char = CharacterConfig.GetRandomCharacter()
```

### Character Data Structure
```lua
{
    id = 1,
    tier = 1,
    name = "Tiny Brainrot",
    price = 0,
    earningsPerSecond = 1,
    color = Color3.fromRGB(80, 100, 120),
    size = Vector3.new(2, 2, 2),
    spawnWeight = 40, -- Higher = more common
    modelKey = "Brainrot_T1"
}
```

---

## UpgradeConfig (Shared)

**Purpose:** Defines upgrade levels and costs  
**File:** `src/shared/Config/UpgradeConfig.lua`

### Upgrade Types

#### Claim Multiplier
| Level | Cost | Multiplier | Effect |
|-------|------|------------|--------|
| 1 | Free | 1x | Default |
| 2 | $50,000 | 1.25x | +25% claim bonus |
| 3 | $100,000 | 1.5x | +50% claim bonus |
| 4 | $200,000 | 1.75x | +75% claim bonus |
| 5 | $300,000 | 2x | +100% claim bonus |
| 6 | $500,000 | 2.5x | +150% claim bonus |

#### Delivery Speed
| Level | Cost | Multiplier | Effect |
|-------|------|------------|--------|
| 1 | Free | 1x | Default speed |
| 2 | $100,000 | 2x | +100% faster |
| 3 | $150,000 | 3x | +200% faster |
| 4 | $250,000 | 4x | +300% faster |
| 5 | $400,000 | 5x | +400% faster |
| 6 | $600,000 | 7x | +600% faster |

### Methods

#### `UpgradeConfig.GetUpgrade(upgradeId) --> table`
Gets upgrade definition.
```lua
local upgrade = UpgradeConfig.GetUpgrade("ClaimMultiplier")
```

#### `UpgradeConfig.GetLevelData(upgradeId, level) --> table`
Gets data for specific upgrade level.
```lua
local levelData = UpgradeConfig.GetLevelData("DeliverySpeed", 3)
print(levelData.cost) -- 150000
print(levelData.multiplier) -- 3
```

---

## Remote Events

All RemoteEvents are in `ReplicatedStorage.Shared.Remotes`

### Client → Server

| RemoteEvent | Purpose | Parameters |
|-------------|---------|------------|
| `RequestBuy` | Purchase character | `characterModel` |
| `RequestClaim` | Claim unclaimed earnings | None |
| `RequestUpgrade` | Purchase upgrade | `upgradeId` (string) |
| `TutorialCompleted` | Mark tutorial step done | `step` (number) |

### Server → Client

| RemoteEvent | Purpose | Parameters |
|-------------|---------|------------|
| `StateUpdate` | Update UI currency | `balance, unclaimed` |
| `PurchaseFeedback` | Show notification | `type, message` |
| `ShowTutorial` | Display tutorial | `step` |
| `ShowOfflineEarnings` | Display offline popup | `amount` |
| `UpgradeUpdate` | Update upgrade UI | `upgradeData` |

---

## Complete Flows

### Purchase Flow
```lua
-- 1. Player clicks character (Client)
RequestBuy:FireServer(characterModel)

-- 2. Server validates (PurchaseService)
→ Check cooldown (0.3s)
→ Validate player in PurchaseZone
→ Get character data
→ Deduct balance (CurrencyService)
→ Add to basepad (BasePadService)
→ Send feedback (PurchaseFeedback event)
```

### Earnings Loop (Heartbeat)
```lua
-- Server (BasePadService)
for player in Players do
    totalEPS = CalculatePlayerTotalEPS(player)
    speedMultiplier = UpgradeService.GetDeliverySpeedMultiplier(player)
    earned = totalEPS * speedMultiplier * deltaTime
    CurrencyService.AddUnclaimed(player, earned)
    CurrencyService.SyncPlayer(player) -- Update UI
end
```

### Save/Load Flow
```lua
-- On player join (MainServer)
savedData = SavingService.LoadPlayerData(player)
if savedData then
    -- Returning player
    CurrencyService.InitPlayer(player, savedData.Balance, savedData.Unclaimed)
    BasePadService.LoadPlayerEarners(player, savedData.Earners)
    UpgradeService.InitPlayer(player, savedData.Upgrades)
    
    -- Calculate offline earnings
    offlineAmount = SavingService.CalculateOfflineEarnings(player, savedData)
    if offlineAmount > 0 then
        CurrencyService.AddUnclaimed(player, offlineAmount)
        ShowOfflineEarnings:FireClient(player, offlineAmount)
    end
else
    -- New player
    CurrencyService.InitPlayer(player)
    UpgradeService.InitPlayer(player)
    TutorialService.ShowTutorialIfNeeded(player)
end

-- On player leave (MainServer)
SavingService.SavePlayerData(player)
BasePadService.CleanupPlayer(player)
```

---

## Testing Guide

### Test 1: Multi-Player Isolation
**What:** Verify each player has independent game state.

**Steps:**
1. Join with Player 1, buy a character
2. Join with Player 2, buy a different character
3. Verify characters go to correct basepads
4. Verify earnings are independent

**Expected:** No data leaks between players

---

### Test 2: Purchase Cooldown
**What:** Verify 0.3s anti-spam protection.

**Steps:**
1. Rapidly click 5 characters in shop
2. Observe "Slow down!" notification
3. Check balance never goes negative

**Expected:** Only 1 purchase per 0.3s succeeds

---

### Test 3: Data Persistence
**What:** Verify save/load works correctly.

**Steps:**
1. Buy characters, earn money, upgrade
2. Leave game
3. Rejoin immediately
4. Verify all characters, money, and upgrades restored

**Expected:** All data persists correctly

---

### Test 4: Offline Earnings
**What:** Verify 50% offline earnings calculation.

**Steps:**
1. Buy characters (e.g., 10 EPS total)
2. Note logout time
3. Wait 1 hour
4. Rejoin
5. Should receive ~1800 (10 EPS × 3600s × 0.5)

**Expected:** Popup shows correct offline earnings (capped at 12hr)

---

### Test 5: Upgrade Multipliers
**What:** Verify upgrades actually increase earnings/claims.

**Steps:**
1. Note current EPS (e.g., 10 EPS)
2. Buy Delivery Speed Level 2 (2x multiplier)
3. Verify earnings double (20 EPS observed in Unclaimed)
4. Claim with Claim Multiplier Level 2 (1.25x)
5. Verify claimed amount is 1.25x unclaimed

**Expected:** Upgrades apply correctly

---

## Anti-Exploit Checklist

- **Server-authoritative** - All game logic on server
- **Balance validation** - Always check before deducting
- **Purchase cooldown** - 0.3s rate limit
- **Zone checking** - Must be in PurchaseZone
- **Clamping** - Prevent integer overflow
- **Rounding** - Prevent float drift
- **Retry logic** - DataStore failure handling
- **Sanity checks** - Validate all client input

---

## Performance Notes

**Earnings Calculation:**
- Runs every Heartbeat (~0.017s)
- O(n) complexity per player
- Efficient for hundreds of players

**DataStore Usage:**
- Auto-save every 120s (1 request/player)
- Disconnect save (1 request/player)
- Well within 60 + playerCount/minute limit

**Character Spawning:**
- Weighted random O(n) where n = 5 characters
- TweenService handles animation efficiently

---

## Debugging Tips

**Enable detailed logging:**
```lua
-- Add to service Initialize():
local DEBUG = true
if DEBUG then
    print("[ServiceName] Initialized")
end
```

**Check Output window for:**
- `[CurrencyService]` - Money transactions
- `[PurchaseService]` - Purchase validation
- `[BasePadService]` - Character placement
- `[SavingService]` - Save/load operations

**Common Issues:**
- **"Character not found"** → Check CharacterConfig IDs
- **"Not in PurchaseZone"** → Verify PurchaseZone exists in Workspace
- **"DataStore fail"** → Enable Studio API Services
- **"Slow down!"** → Working as intended (0.3s cooldown)

---

*For implementation examples, see actual service files in `src/server/`*
