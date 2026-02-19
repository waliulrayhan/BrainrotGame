# 🛠️ Creating the Template File (For Maintainers)

This guide is for **project maintainers** who need to create the `BrainrotGame-Template.rbxlx` file **ONE TIME**.

After you create this file and commit it to GitHub, **all users can just open it and play** - no manual setup needed!

---

## ⚡ Quick Steps

### **1. Build the Base Game**
```powershell
rojo build -o BrainrotGame.rbxl
```

### **2. Open in Roblox Studio**
```powershell
start BrainrotGame.rbxl
```

### **3. Create the 3D World**

#### **A. ShopLane (Folder)**
1. In **Workspace**, insert **Folder** → Name: `ShopLane`
2. Inside ShopLane, insert **Part** → Name: `LanePath`
3. Set LanePath properties:
   - **Size:** `150, 1, 10`
   - **Position:** `25, 10, -30`
   - **Anchored:** ✅ true
   - **Material:** Plastic or SmoothPlastic

#### **B. PurchaseZone (Part)**
1. In **Workspace**, insert **Part** → Name: `PurchaseZone`
2. Set properties:
   - **Size:** `15, 5, 15`
   - **Position:** `0, 12.5, -14`
   - **BrickColor:** Bright green
   - **Transparency:** `0.5`
   - **Anchored:** ✅ true
   - **CanCollide:** ❌ false

#### **C. BasePads (Folder with 5 Parts)**
1. In **Workspace**, insert **Folder** → Name: `BasePads`
2. Create 5 parts inside BasePads:

| Name | Size | Position | Color | Anchored |
|------|------|----------|-------|----------|
| `BasePad_T1` | 20, 1, 20 | 10, 0.5, 10 | Gray (163, 162, 165) | ✅ |
| `BasePad_T2` | 20, 1, 20 | 40, 0.5, 10 | Green (75, 151, 75) | ✅ |
| `BasePad_T3` | 20, 1, 20 | 70, 0.5, 10 | Blue (13, 105, 172) | ✅ |
| `BasePad_T4` | 20, 1, 20 | 100, 0.5, 10 | Orange (218, 133, 65) | ✅ |
| `BasePad_T5` | 20, 1, 20 | 130, 0.5, 10 | Purple (180, 128, 255) | ✅ |

**Quick Tip:** Create one basepad with all properties, then duplicate 4 times and just change Name, Position, and Color.

---

### **4. Create the UI**

#### **A. Create MainHUD**
1. In **StarterGui**, insert **ScreenGui** → Name: `MainHUD`
2. Set properties:
   - **ResetOnSpawn:** ❌ false
   - **ZIndexBehavior:** Sibling

#### **B. Create TopBar**
1. Inside MainHUD, insert **Frame** → Name: `TopBar`
2. Set properties:
   - **Size:** `{1, 0}, {0, 80}` (full width, 80px tall)
   - **Position:** `{0, 0}, {0, 0}`
   - **AnchorPoint:** `0, 0`
   - **BackgroundColor3:** `RGB(35, 45, 60)`
   - **BorderSizePixel:** `0`
3. Add **UICorner** inside TopBar:
   - **CornerRadius:** `0, 15`
4. Add **UIStroke** inside TopBar:
   - **Color:** `RGB(50, 150, 255)`
   - **Thickness:** `3`
   - **Transparency:** `0.5`

#### **C. Create BalanceContainer**
1. Inside TopBar, insert **Frame** → Name: `BalanceContainer`
2. Set properties:
   - **Size:** `{0, 300}, {0, 60}`
   - **Position:** `{0, 20}, {0, 10}`
   - **BackgroundColor3:** `RGB(255, 200, 80)` (gold)
   - **BorderSizePixel:** `0`
3. Add **UICorner** (CornerRadius: `0, 12`)

#### **D. Create BalanceLabel**
1. Inside BalanceContainer, insert **TextLabel** → Name: `BalanceLabel`
2. Set properties:
   - **Size:** `{1, 0}, {1, 0}` (fill parent)
   - **Text:** `Balance: $0`
   - **TextScaled:** ✅ true
   - **Font:** GothamBold
   - **TextColor3:** `RGB(25, 25, 35)` (dark)
   - **BackgroundTransparency:** `1`

#### **E. Create UnclaimedContainer**
1. Inside TopBar, insert **Frame** → Name: `UnclaimedContainer`
2. Set properties:
   - **Size:** `{0, 300}, {0, 60}`
   - **Position:** `{1, -320}, {0, 10}`
   - **AnchorPoint:** `1, 0` (right-aligned)
   - **BackgroundColor3:** `RGB(100, 220, 150)` (green)
   - **BorderSizePixel:** `0`
3. Add **UICorner** (CornerRadius: `0, 12`)

#### **F. Create UnclaimedLabel**
1. Inside UnclaimedContainer, insert **TextLabel** → Name: `UnclaimedLabel`
2. Set properties:
   - **Size:** `{1, 0}, {1, 0}`
   - **Text:** `Unclaimed: $0`
   - **TextScaled:** ✅ true
   - **Font:** GothamBold
   - **TextColor3:** `RGB(25, 25, 35)`
   - **BackgroundTransparency:** `1`

#### **G. Create ClaimSection**
1. Inside MainHUD, insert **Frame** → Name: `ClaimSection`
2. Set properties:
   - **Size:** `{0, 400}, {0, 150}`
   - **Position:** `{0.5, -200}, {1, -200}` (bottom center)
   - **AnchorPoint:** `0, 0`
   - **BackgroundTransparency:** `1`

#### **H. Create ClaimButton**
1. Inside ClaimSection, insert **TextButton** → Name: `ClaimButton`
2. Set properties:
   - **Size:** `{1, 0}, {1, 0}`
   - **Text:** `💰 CLAIM 💰`
   - **TextScaled:** ✅ true
   - **Font:** GothamBlack
   - **BackgroundColor3:** `RGB(50, 150, 255)` (blue)
   - **TextColor3:** `RGB(255, 255, 255)` (white)
   - **BorderSizePixel:** `0`
3. Add **UICorner** (CornerRadius: `0, 20`)
4. Add **UIStroke**:
   - **Color:** `RGB(255, 255, 255)`
   - **Thickness:** `3`

#### **I. Create Notifications**
1. Inside MainHUD, insert **Frame** → Name: `Notifications`
2. Set properties:
   - **Size:** `{0, 350}, {0, 600}`
   - **Position:** `{1, -370}, {0, 100}`
   - **AnchorPoint:** `0, 0`
   - **BackgroundTransparency:** `1`
3. Add **UIListLayout**:
   - **FillDirection:** Vertical
   - **HorizontalAlignment:** Right
   - **VerticalAlignment:** Top
   - **Padding:** `0, 10`

---

### **5. Test the Game**

1. Press **F5** to test
2. Verify:
   - ✅ Characters spawn and move on lane
   - ✅ UI shows Balance and Unclaimed
   - ✅ PurchaseZone is visible (green transparent)
   - ✅ BasePads are arranged in a row
   - ✅ CLAIM button works

---

### **6. Save as .rbxlx (XML Format)**

**IMPORTANT:** Save as **.rbxlx** (NOT .rbxl)

1. **File** → **Save to File**
2. Choose location: Your project root folder
3. **File name:** `BrainrotGame-Template.rbxlx`
4. **Save as type:** `Places (*.rbxlx)` ← **XML format**
5. Click **Save**

✅ **.rbxlx** is text-based and git-friendly!  
❌ **.rbxl** is binary and causes merge conflicts

---

### **7. Commit to GitHub**

```powershell
git add BrainrotGame-Template.rbxlx
git commit -m "Add pre-built template file for zero-setup experience"
git push
```

---

## ✅ Done!

Now anyone can:
```powershell
git clone https://github.com/YOUR_USERNAME/BrainrotGame.git
cd BrainrotGame
start BrainrotGame-Template.rbxlx
# Press F5 in Studio - DONE! 🎉
```

**Zero manual setup required!** 🚀

---

## 🔄 Updating the Template

Whenever you add new features:

1. Open `BrainrotGame-Template.rbxlx`
2. Start Rojo: `rojo serve`
3. Connect in Studio: **Plugins** → **Rojo** → **Connect**
4. Make changes to code in VS Code
5. Test in Studio
6. **File** → **Save to File** → Overwrite the .rbxlx
7. Commit changes:
   ```powershell
   git add BrainrotGame-Template.rbxlx
   git commit -m "Update template with new features"
   git push
   ```

---

## 📝 Notes

- **Always use .rbxlx** (XML) not .rbxl (binary)
- Keep template file in project root for easy access
- Test template after any major changes
- The template includes workspace + UI, Rojo syncs the code

---

**Last Updated:** February 20, 2026
