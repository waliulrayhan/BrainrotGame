# Testing Guide for BrainrotGame

## Overview
This guide provides step-by-step instructions for testing critical game systems before release.

---

## Test 1: Multi-Player Base Isolation

**What to Test:** Each player gets their own base and purchases go to the correct owner.

### Setup:
1. Open two Roblox Studio windows or use one Studio + one Roblox client
2. Start the game with "Rojo: Serve" task or publish to Roblox and enable Team Test

### Test Steps:
1. Join with **Player 1**
   - Note the starting balance (should be 0 or saved value)
   - Buy a character from the shop lane (click on moving character)
   - Verify character moves to your basepad
   - Check that character has your username in its name

2. Join with **Player 2** 
   - Note their independent starting balance
   - Buy a different character
   - Verify it goes to Player 2's basepad, NOT Player 1's

3. Verify each player's earnings are independent:
   - Wait for Unclaimed to increase for both players
   - Player 1 claims money - only Player 1's balance should increase
   - Player 2 claims money - only Player 2's balance should increase

### Expected Results:
- ✅ Each player has separate Balance/Unclaimed values
- ✅ Characters purchased by Player 1 only appear on Player 1's basepads
- ✅ Characters purchased by Player 2 only appear on Player 2's basepads
- ✅ Earnings are player-specific (check [BasePadService.lua](src/server/BasePadService.lua#L326-L338))

### How to Debug:
- **If characters go to wrong basepad:** Check `character.owner` in BasePadCharacters table
- **If earnings are shared:** Check `PlayerData[player.UserId]` in CurrencyService
- Open Output window (View > Output) and look for logs from BasePadService and CurrencyService

---

## Test 2: Spam Buy Protection

**What to Test:** Server cooldown prevents rapid purchases and negative money.

### Test Steps:
1. Give yourself enough money to buy multiple characters:
   - Open server console in Studio (View > Output > Command Bar)
   - Run: `game.ReplicatedStorage.Shared.Remotes.StateUpdate:FireAllClients(10000, 0)`
   - OR: Wait for earnings and claim

2. Rapidly click on 3-5 shop characters in quick succession (spam click)

3. Observe the behavior:
   - Count how many actually get purchased
   - Check your balance - should never go negative
   - Look for "Slow down!" message in notifications

### Expected Results:
- ✅ Purchase cooldown of **0.3 seconds** enforced ([PurchaseService.lua](src/server/PurchaseService.lua#L16))
- ✅ Only 1 purchase every 0.3s succeeds
- ✅ Balance never goes below 0
- ✅ Feedback message appears on failed attempts
- ✅ DeductBalance checks balance BEFORE deducting ([PurchaseService.lua](src/server/PurchaseService.lua#L89-L99))

### How to Debug:
- Print `LastPurchaseTime[player.UserId]` in PurchaseService
- Check Output for "[PurchaseService] Slow down!" warnings
- Verify `CurrencyService.DeductBalance` returns `false` when insufficient funds

---

## Test 3: Disconnect with Unclaimed Money

**What to Test:** Unclaimed money persists correctly on rejoin.

### Test Steps:
1. **Setup earning:**
   - Join the game
   - Buy 1-2 characters so you earn money passively
   - Wait until Unclaimed > 100 (don't claim it yet!)
   - Note the exact Unclaimed value

2. **Disconnect:**
   - Close the game window or kick yourself from server
   - Wait 10 seconds (allow save to complete)

3. **Rejoin:**
   - Rejoin the same server or start a new one
   - Immediately check your UI

### Expected Results:
- ✅ Unclaimed value should match what you had before disconnect
- ✅ Balance should match previous value
- ✅ Characters should be on your basepads
- ✅ Data saves both Balance AND Unclaimed ([SavingService.lua](src/server/SavingService.lua#L56-L61))

### Alternative Design Choice:
If you prefer, you could reset Unclaimed to 0 on load and only save Balance. Update [SavingService.lua](src/server/SavingService.lua) to not save Unclaimed.

### How to Debug:
- Check Output for "[SavingService] Saved data for [YourName]"
- Check Output for "[SavingService] Loaded data for [YourName]"
- Enable Studio Output logging: File > Studio Settings > Diagnostics > Enable API Logging
- Print loaded data in MainServer after calling `SavingService.LoadPlayerData(player)`

---

## Test 4: Server Performance (Lane Movement)

**What to Test:** Lane movement uses efficient single-character loops, not global loops.

### Current State:
⚠️ **ISSUE DETECTED:** Each character spawned creates its own Heartbeat connection ([ShopLaneService.lua](src/server/ShopLaneService.lua#L75-L100))

### Performance Test:
1. Let the game run for 2-3 minutes
2. Press **F9** in Roblox Studio to open Developer Console
3. Go to **MicroProfiler** tab (or press Ctrl+F6)
4. Look for Heartbeat usage

### Expected State After Fix:
- ✅ Should see ONE Heartbeat loop for all characters
- ✅ CPU usage should be ~1-5% even with 20+ characters
- ❌ Currently: 50 characters = 50 Heartbeat connections (inefficient!)

### Recommended Fix:
Create a single RunService.Heartbeat loop that updates ALL active shop characters:

```lua
-- In ShopLaneService.lua
local ActiveCharacters = {} -- Store all moving characters

function ShopLaneService.Initialize()
    -- ... existing code ...
    
    -- Single Heartbeat loop for all characters
    game:GetService("RunService").Heartbeat:Connect(function()
        for i = #ActiveCharacters, 1, -1 do
            local data = ActiveCharacters[i]
            if ShopLaneService.UpdateCharacterMovement(data) then
                table.remove(ActiveCharacters, i)
            end
        end
    end)
end

function ShopLaneService.SpawnCharacter()
    -- ... create character ...
    
    -- Add to active list instead of creating new Heartbeat
    table.insert(ActiveCharacters, {
        model = characterModel,
        startTime = tick(),
        startX = startX,
        endX = endX,
        -- ... other data
    })
end

function ShopLaneService.UpdateCharacterMovement(data)
    -- Returns true if movement is complete
    -- ... movement logic here ...
end
```

### How to Measure:
- Use MicroProfiler to see Heartbeat count
- Check script activity: Developer Console > Scripts
- Monitor server memory: Stats > Memory

---

## Test 5: UI Correctness

**What to Test:** Balance and Unclaimed always match server state.

### Test Steps:
1. **Test UI sync on join:**
   - Join game
   - UI should show Balance and Unclaimed immediately
   - Check Output for "[UIController] UI not found" errors

2. **Test purchase updates:**
   - Buy a character
   - Balance should decrease smoothly (animated)
   - Final value must match server state

3. **Test earnings updates:**
   - Wait for characters to earn money
   - Unclaimed should increase
   - Numbers should animate smoothly

4. **Test claim button:**
   - When Unclaimed > 0: button should be MAGENTA and say "CLAIM!"
   - When Unclaimed = 0: button should be gray and say "CLAIM"
   - Click to claim: Unclaimed → 0, Balance increases

5. **Test across network:**
   - Publish to Roblox
   - Play from Roblox app (not Studio)
   - Verify all above behaviors work with network latency

### Expected Results:
- ✅ UI updates via StateUpdate event ([UIController.client.lua](src/client/UIController.client.lua#L17))
- ✅ Smooth animations (lerping) for visual polish
- ✅ Server is authoritative - client displays server values
- ✅ No exploits possible (all logic on server)

### How to Debug:
- Check if StateUpdate event is firing: add print in UIController
- Verify RemoteEvent path: `ReplicatedStorage.Shared.Remotes.StateUpdate`
- Test in both Studio and published game
- Use Remote Event logger: `game:GetService("LogService").MessageOut:Connect(print)`

---

## Quick Testing Commands

### Give Money (Server Console):
```lua
local CurrencyService = require(game.ServerScriptService.Server.CurrencyService)
local player = game.Players.YourUsername
CurrencyService.AddBalance(player, 10000)
```

### Check Player Data (Server Console):
```lua
local CurrencyService = require(game.ServerScriptService.Server.CurrencyService)
local player = game.Players.YourUsername
print(CurrencyService.GetPlayerData(player))
```

### Force Save (Server Console):
```lua
local SavingService = require(game.ServerScriptService.Server.SavingService)
SavingService.SavePlayerData(game.Players.YourUsername)
```

### Clear DataStore (Testing Only!):
```lua
-- Studio API Services must be enabled (Game Settings > Security)
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore("PlayerData_v1")
store:RemoveAsync("Player_" .. game.Players.YourUsername.UserId)
```

---

## Testing Checklist Summary

- [ ] **Multi-player:** 2 players have separate bases and earnings
- [ ] **Spam protection:** Cooldown works, no negative money
- [ ] **Disconnect:** Unclaimed persists on rejoin
- [ ] **Performance:** Fix lane movement to use single loop (current issue!)
- [ ] **UI sync:** Balance/Unclaimed match server, smooth updates

---

## Additional Notes

**Testing in Studio vs Published:**
- Studio has better debugging tools (Output, MicroProfiler)
- Published game tests real network latency
- Use Team Test for multiplayer in Studio (limited to 4 players)

**DataStore Testing:**
- Studio must have API Services enabled: Home > Game Settings > Security > Enable Studio Access to API Services
- Published games automatically have DataStore access

**Common Issues:**
- UI not updating: Check RemoteEvent connections
- Money not saving: Enable API Services in Studio
- Characters not spawning: Check ReplicatedStorage.CharacterModels folder exists
- Performance lag: Fix the Heartbeat issue in ShopLaneService!
