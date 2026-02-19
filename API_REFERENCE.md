# 📘 API REFERENCE GUIDE
## BrainrotGame Server Services

Quick reference for all server ModuleScript APIs.

---

## 🪙 CurrencyService

**Purpose:** Manages player money (Balance and Unclaimed)  
**File:** [src/server/CurrencyService.lua](src/server/CurrencyService.lua)

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
- **player:** Player instance
- **savedBalance:** Optional starting balance (default: 0)
- **savedUnclaimed:** Optional starting unclaimed (default: 0)

#### `CurrencyService.AddBalance(player, amount)`
Adds money to player's spendable balance.
```lua
CurrencyService.AddBalance(player, 500) -- Give player $500
```
- **player:** Player instance
- **amount:** Amount to add (will be clamped and rounded)

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
- **player:** Player instance
- **amount:** Amount to deduct
- **Returns:** `true` if successful, `false` if insufficient funds

#### `CurrencyService.AddUnclaimed(player, amount)`
Adds money to player's unclaimed earnings pool.
```lua
CurrencyService.AddUnclaimed(player, 10) -- Add $10 to unclaimed
```
- **player:** Player instance
- **amount:** Amount to add

#### `CurrencyService.ClaimUnclaimed(player)`
Moves all unclaimed money to spendable balance.
```lua
CurrencyService.ClaimUnclaimed(player) -- Transfer unclaimed → balance
```
- **player:** Player instance

#### `CurrencyService.GetPlayerData(player) --> table`
Retrieves player's currency data.
```lua
local data = CurrencyService.GetPlayerData(player)
print(data.Balance, data.Unclaimed) -- e.g., 1000, 250
```
- **player:** Player instance
- **Returns:** `{Balance = number, Unclaimed = number}` or `nil` if player not found

#### `CurrencyService.SyncPlayer(player)`
Sends current currency state to client via StateUpdate event.
```lua
CurrencyService.SyncPlayer(player) -- Force UI update
```
- **player:** Player instance

---

## 🛒 PurchaseService

**Purpose:** Validates and processes character purchases  
**File:** [src/server/PurchaseService.lua](src/server/PurchaseService.lua)

### Methods

#### `PurchaseService.Initialize(currencyService, baseService)`
Initializes the service with dependencies.
```lua
PurchaseService.Initialize(CurrencyService, BaseService)
```
- **currencyService:** Reference to CurrencyService
- **baseService:** Reference to BaseService

#### `PurchaseService.HandlePurchaseRequest(player, characterModel)`
Processes a purchase request from a player. (Internal - called by RemoteEvent)
```lua
-- Usually called automatically via RemoteEvent
PurchaseService.HandlePurchaseRequest(player, characterModel)
```
- **player:** Player instance
- **characterModel:** Model instance of the character to purchase

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
- **player:** Player instance
- **Returns:** `true` if in zone, `false` otherwise

---

## 🏠 BasePadService

**Purpose:** Manages tier-based basepads and character placement  
**File:** [src/server/BasePadService.lua](src/server/BasePadService.lua)

### Methods

#### `BasePadService.Initialize()`
Initializes basepads and starts earnings loop.
```lua
BasePadService.Initialize()
```
**Auto-detects:** BasePad_T1, BasePad_T2, BasePad_T3, BasePad_T4, BasePad_T5 in Workspace.BasePads

#### `BasePadService.AddCharacterToBase(player, characterId)`
Places a purchased character on appropriate tier basepad.
```lua
BasePadService.AddCharacterToBase(player, 3) -- Add Tier 3 character
```
- **player:** Player instance
- **characterId:** Character ID from CharacterConfig

**What it does:**
- Creates character model on tier-specific basepad
- Arranges characters in grid (4 per row, 5 studs apart)
- Adds nametag showing character name and EPS
- Starts earning money for player

#### `BasePadService.GetPlayerEarners(player) --> array`
Gets list of all characters owned by player (for saving).
```lua
local earners = BasePadService.GetPlayerEarners(player)
-- Returns: {{characterId = 1, BasePadRef = "T1"}, {characterId = 2, BasePadRef = "T2"}, ...}
```
- **player:** Player instance
- **Returns:** Array of `{characterId, BasePadRef}` tables

#### `BasePadService.LoadPlayerEarners(player, savedData)`
Restores player's characters from saved data.
```lua
local savedEarners = {
    {characterId = 1, BasePadRef = "T1"},
    {characterId = 3, BasePadRef = "T3"}
}
BasePadService.LoadPlayerEarners(player, savedEarners)
```
- **player:** Player instance
- **savedData:** Array of earner tables from DataStore

#### `BasePadService.CalculatePlayerTotalEPS(player) --> number`
Calculates total earnings per second for all player's characters.
```lua
local totalEPS = BasePadService.CalculatePlayerTotalEPS(player)
print("Player earns", totalEPS, "per second") -- e.g., 45
```
- **player:** Player instance
- **Returns:** Total EPS (earnings per second)

#### `BasePadService.CleanupPlayer(player)`
Removes all player's characters from basepads (on disconnect).
```lua
BasePadService.CleanupPlayer(player)
```
- **player:** Player instance

---

## 🏪 ShopLaneService

**Purpose:** Spawns and moves characters on shop lane  
**File:** [src/server/ShopLaneService.lua](src/server/ShopLaneService.lua)

### Methods

#### `ShopLaneService.Initialize()`
Initializes lane and starts spawning characters.
```lua
ShopLaneService.Initialize()
```
**Requirements:** Workspace.ShopLane.LanePath part must exist

#### `ShopLaneService.SpawnRandomCharacter()`
Spawns a random character from CharacterConfig.
```lua
ShopLaneService.SpawnRandomCharacter() -- Spawn based on weighted probability
```
**Spawn System:**
- Uses `spawnWeight` from CharacterConfig
- Lower weight = rarer characters
- Characters move left → right automatically
- Respawns after 30s or when purchased

---

## 💾 SavingService

**Purpose:** Loads and saves player data to DataStore  
**File:** [src/server/SavingService.lua](src/server/SavingService.lua)

### Methods

#### `SavingService.Initialize(currencyService, baseService)`
Initializes service and starts auto-save loop.
```lua
SavingService.Initialize(CurrencyService, BaseService)
```
- **currencyService:** Reference to CurrencyService
- **baseService:** Reference to BaseService

**Auto-save:** Runs every 120 seconds for all online players

#### `SavingService.LoadPlayerData(player) --> table`
Loads player data from DataStore.
```lua
local data = SavingService.LoadPlayerData(player)
if data then
    print("Loaded balance:", data.Balance)
    print("Loaded unclaimed:", data.Unclaimed)
    print("Loaded characters:", #data.Earners)
else
    print("New player - no saved data")
end
```
- **player:** Player instance
- **Returns:** Data table or `nil` if no saved data

**Data Structure:**
```lua
{
    Balance = 1000,
    Unclaimed = 250,
    Earners = {
        {characterId = 1, BasePadRef = "T1"},
        {characterId = 2, BasePadRef = "T2"}
    },
    HasSeenTutorial = true,
    LastSave = 1234567890
}
```

#### `SavingService.SavePlayerData(player) --> boolean`
Saves player data to DataStore.
```lua
local success = SavingService.SavePlayerData(player)
if success then
    print("Save successful!")
else
    warn("Save failed - will retry")
end
```
- **player:** Player instance
- **Returns:** `true` if successful, `false` if all retries failed

**Retry Logic:** 3 attempts with 0.5s delay between attempts

---

## 🎓 TutorialService

**Purpose:** Shows first-time tutorial to new players  
**File:** [src/server/TutorialService.lua](src/server/TutorialService.lua)

### Methods

#### `TutorialService.Initialize()`
Sets up tutorial system.
```lua
TutorialService.Initialize()
```

#### `TutorialService.ShowTutorialIfNeeded(player)`
Shows tutorial if player hasn't seen it.
```lua
TutorialService.ShowTutorialIfNeeded(player) -- Called automatically on join
```
- **player:** Player instance

---

## 📦 CharacterConfig (Shared)

**Purpose:** Defines all available characters  
**File:** [src/shared/Config/CharacterConfig.lua](src/shared/Config/CharacterConfig.lua)

### Methods

#### `CharacterConfig.GetCharacterById(id) --> table`
Gets character data by ID.
```lua
local char = CharacterConfig.GetCharacterById(3)
print(char.name) -- "Epic Brainrot"
print(char.price) -- 150
print(char.earningsPerSecond) -- 10
```
- **id:** Character ID (1-5)
- **Returns:** Character data table or `nil`

#### `CharacterConfig.GetAllCharacters() --> array`
Gets array of all characters.
```lua
local allChars = CharacterConfig.GetAllCharacters()
for _, char in allChars do
    print(char.name, char.price)
end
```
- **Returns:** Array of all character tables

### Character Data Structure
```lua
{
    id = 1,
    tier = 1,
    name = "Tiny Brainrot",
    price = 0,
    earningsPerSecond = 1,
    color = Color3.fromRGB(128, 128, 128),
    size = Vector3.new(3, 3, 3),
    spawnWeight = 100, -- Higher = more common in shop
    modelKey = "Brainrot_T1" -- For future model integration
}
```

---

## 🌐 Remote Events

All RemoteEvents are in `ReplicatedStorage.Shared.Remotes`

### Client → Server

#### `RequestBuy`
```lua
-- CLIENT SIDE:
ReplicatedStorage.Shared.Remotes.RequestBuy:FireServer(characterModel)
```
Requests to purchase a character. Server validates and processes.

#### `RequestClaim`
```lua
-- CLIENT SIDE:
ReplicatedStorage.Shared.Remotes.RequestClaim:FireServer()
```
Requests to claim unclaimed earnings.

#### `TutorialCompleted`
```lua
-- CLIENT SIDE:
ReplicatedStorage.Shared.Remotes.TutorialCompleted:FireServer(step)
```
Notifies server that player completed tutorial step.

### Server → Client

#### `StateUpdate`
```lua
-- SERVER SIDE:
StateUpdateEvent:FireClient(player, balance, unclaimed)

-- CLIENT RECEIVES:
-- balance (number), unclaimed (number)
```
Updates client UI with current currency values.

#### `PurchaseFeedback`
```lua
-- SERVER SIDE:
PurchaseFeedbackEvent:FireClient(player, "success", "Bought Tiny Brainrot!")
PurchaseFeedbackEvent:FireClient(player, "error", "Not enough money!")

-- CLIENT RECEIVES:
-- type ("success" or "error"), message (string)
```
Shows toast notification to player.

#### `ShowTutorial`
```lua
-- SERVER SIDE:
ShowTutorialEvent:FireClient(player, step)

-- CLIENT RECEIVES:
-- step (number): Which tutorial step to show
```
Triggers tutorial display on client.

---

## 🔄 Typical Usage Patterns

### Complete Purchase Flow
```lua
-- 1. Player clicks character (Client)
script.Parent.ClickDetector.MouseClick:Connect(function(player)
    ReplicatedStorage.Shared.Remotes.RequestBuy:FireServer(script.Parent)
end)

-- 2. Server validates (PurchaseService)
local success = CurrencyService.DeductBalance(player, price)
if success then
    BasePadService.AddCharacterToBase(player, characterId)
    PurchaseFeedbackEvent:FireClient(player, "success", "Purchased!")
end
```

### Earnings Loop
```lua
-- Server heartbeat (BasePadService)
RunService.Heartbeat:Connect(function(deltaTime)
    for _, player in Players:GetPlayers() do
        local totalEPS = BasePadService.CalculatePlayerTotalEPS(player)
        local earned = totalEPS * deltaTime
        CurrencyService.AddUnclaimed(player, earned)
    end
end)
```

### Save/Load Flow
```lua
-- On player join (MainServer)
local savedData = SavingService.LoadPlayerData(player)
if savedData then
    CurrencyService.InitPlayer(player, savedData.Balance, savedData.Unclaimed)
    BasePadService.LoadPlayerEarners(player, savedData.Earners)
else
    CurrencyService.InitPlayer(player) -- New player
end

-- On player leave (MainServer)
SavingService.SavePlayerData(player)
BasePadService.CleanupPlayer(player)
```

---

## 🚨 Important Notes

### Anti-Exploit Considerations
- ✅ **Never trust client input** - all purchases validated server-side
- ✅ **Always check balance before deducting** - use `DeductBalance()` return value
- ✅ **Rate limiting enforced** - 0.3s cooldown on purchases
- ✅ **Clamping/rounding** - prevents float drift and overflow exploits

### Performance Tips
- Earnings calculated every 0.1s (Heartbeat) - efficient for many players
- Characters arranged in grid automatically - no manual positioning needed
- Auto-save every 120s - reduces DataStore API calls

### DataStore Limits
- Max 60 + player count requests per minute
- Auto-save uses 1 request per player every 2 minutes
- Manual save on disconnect uses 1 request per player
- Well within limits for typical games

---

*For implementation examples, see the actual service files in `src/server/`*
