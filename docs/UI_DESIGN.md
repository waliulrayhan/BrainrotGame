# UI Design & Workspace Setup

Complete guide for setting up the game world (Workspace) and customizing the user interface (ScreenGui).

---

## Workspace Setup

### Required Structure

```
Workspace
├── BasePads (Folder)
│   ├── BasePad_T1 (Part) - Tier 1 characters
│   ├── BasePad_T2 (Part) - Tier 2 characters
│   ├── BasePad_T3 (Part) - Tier 3 characters
│   ├── BasePad_T4 (Part) - Tier 4 characters
│   └── BasePad_T5 (Part) - Tier 5 characters
├── ShopLane (Folder)
│   └── LanePath (Part) - Path for moving characters
└── PurchaseZone (Part) - Green zone where players buy
```

### Step-by-Step Setup

#### 1. Create BasePads Folder
1. In Roblox Studio Explorer, right-click **Workspace**
2. Insert Object → **Folder**
3. Rename to `BasePads`

#### 2. Create Tier 1 BasePad
1. Insert **Part** into BasePads folder
2. Rename to `BasePad_T1`
3. Set properties:
   - **Size:** `20, 1, 20`
   - **Position:** `10, 0.5, 10` (adjust as needed)
   - **Anchored:** true
   - **CanCollide:** true
   - **Color:** `RGB(120, 140, 160)` - Blue-Gray
   - **Material:** SmoothPlastic

#### 3. Create Remaining BasePads
Duplicate BasePad_T1 four times and rename:
- **BasePad_T2** → Position: `40, 0.5, 10` → Color: `RGB(100, 220, 150)` Mint Green
- **BasePad_T3** → Position: `70, 0.5, 10` → Color: `RGB(50, 150, 255)` Bright Blue
- **BasePad_T4** → Position: `100, 0.5, 10` → Color: `RGB(180, 100, 255)` Soft Purple
- **BasePad_T5** → Position: `130, 0.5, 10` → Color: `RGB(255, 150, 100)` Soft Coral

**Layout:**
```
[BasePad_T1] [BasePad_T2] [BasePad_T3] [BasePad_T4] [BasePad_T5]
 Blue-Gray    Mint Green  Bright Blue  Soft Purple  Soft Coral
```

**Tips:**
- Space basepads **30 studs apart**
- Each basepad holds ~16 characters (4x4 grid)
- Consider elevating higher tiers for visual hierarchy

#### 4. Create ShopLane
1. Insert **Folder** into Workspace
2. Rename to `ShopLane`
3. Insert **Part** into ShopLane folder
4. Rename to `LanePath`
5. Set properties:
   - **Size:** `100, 1, 10` (long horizontal path)
   - **Position:** Center of your map
   - **Anchored:** true
   - **CanCollide:** false
   - **Color:** `RGB(45, 60, 80)` - Light Blue-Gray
   - **Material:** SmoothPlastic
   - **Transparency:** 0.3

#### 5. Create PurchaseZone
1. Insert **Part** into Workspace (not in folder)
2. Rename to `PurchaseZone`
3. Set properties:
   - **Size:** `25, 5, 25` (covers shop area)
   - **Position:** Near ShopLane
   - **Anchored:** true
   - **CanCollide:** false (players can walk through)
   - **Color:** `RGB(50, 150, 255)` - Bright Blue
   - **Material:** Neon
   - **Transparency:** 0.6

---

## UI Color Palette

### Primary Colors
- **Bright Blue:** `RGB(50, 150, 255)` - Main accent
- **Light Blue:** `RGB(70, 170, 255)` - Hover/highlight
- **Accent Blue:** `RGB(100, 200, 255)` - Titles
- **Dark Blue-Gray:** `RGB(25, 25, 35)` - Dark backgrounds
- **Medium Blue-Gray:** `RGB(35, 45, 60)` - Medium backgrounds
- **Light Blue-Gray:** `RGB(45, 60, 80)` - Light backgrounds

### Money Colors
- **Soft Gold:** `RGB(255, 200, 80)` - Balance display
- **Mint Green:** `RGB(100, 220, 150)` - Unclaimed/earnings

### Status Colors
- **Success Green:** `RGB(80, 200, 120)`
- **Warning Orange:** `RGB(255, 180, 50)`
- **Danger Red:** `RGB(255, 100, 100)`

### Tier Colors (Characters/Billboards)
- **Tier 1:** `RGB(120, 140, 160)` - Blue-Gray
- **Tier 2:** `RGB(100, 220, 150)` - Mint Green
- **Tier 3:** `RGB(50, 150, 255)` - Bright Blue
- **Tier 4:** `RGB(180, 100, 255)` - Soft Purple
- **Tier 5:** `RGB(255, 150, 100)` - Soft Coral

---

## UI Structure

### MainHUD (ScreenGui in StarterGui)
```
MainHUD (ScreenGui)
├── TopBar (Frame) - Top currency display
│   ├── UIGradient
│   ├── UIStroke (border)
│   ├── UICorner
│   ├── BalanceContainer (Frame)
│   │   ├── UIGradient
│   │   ├── UICorner
│   │   └── BalanceLabel (TextLabel)
│   │       └── UIStroke
│   └── UnclaimedContainer (Frame)
│       ├── UIGradient
│       ├── UICorner
│       └── UnclaimedLabel (TextLabel)
│           └── UIStroke
└── ClaimSection (Frame) - Bottom claim button
    └── ClaimButton (TextButton)
        ├── UIGradient
        ├── UIStroke
        └── UICorner
```

---

## TopBar Styling

### TopBar (Main Container)
```
Properties:
├── Size: {0.8, 0}, {0, 80}
├── Position: {0.1, 0}, {0, 20}
├── AnchorPoint: 0, 0
├── BackgroundColor3: RGB(35, 45, 60) - Medium Blue-Gray
└── BorderSizePixel: 0
```

### TopBar UIGradient
```
Color Keypoints:
├── 0.0 → RGB(35, 45, 60) Medium Blue-Gray
├── 0.5 → RGB(45, 60, 80) Light Blue-Gray
└── 1.0 → RGB(35, 45, 60) Medium Blue-Gray
Rotation: 90
```

### TopBar UIStroke (Border)
```
Properties:
├── Color: RGB(50, 150, 255) - Bright Blue
├── Thickness: 3
└── Transparency: 0.5
```

### TopBar UICorner
```
CornerRadius: 0, 12
```

---

## BalanceContainer Styling

### BalanceContainer
```
Properties:
├── Size: {0.4, 0}, {0.8, 0}
├── Position: {0.05, 0}, {0.1, 0}
├── BackgroundColor3: RGB(255, 200, 80) - Soft Gold
└── BorderSizePixel: 0
```

### BalanceContainer UIGradient
```
Color Keypoints:
├── 0.0 → RGB(255, 200, 80) Soft Gold
├── 0.5 → RGB(255, 220, 120) Light Gold
└── 1.0 → RGB(255, 200, 80) Soft Gold
Rotation: 45
```

### BalanceContainer UICorner
```
CornerRadius: 0, 10
```

### BalanceLabel
```
Properties:
├── Size: {1, 0}, {1, 0}
├── BackgroundTransparency: 1
├── Text: "Balance: $0"
├── TextColor3: RGB(25, 25, 35) - Dark Blue-Gray
├── TextSize: 32
├── Font: GothamBold
└── TextXAlignment: Center
```

### BalanceLabel UIStroke
```
Properties:
├── Color: RGB(255, 255, 255) - White
├── Thickness: 2
└── Transparency: 0.3
```

---

## UnclaimedContainer Styling

### UnclaimedContainer
```
Properties:
├── Size: {0.4, 0}, {0.8, 0}
├── Position: {0.55, 0}, {0.1, 0}
├── BackgroundColor3: RGB(100, 220, 150) - Mint Green
└── BorderSizePixel: 0
```

### UnclaimedContainer UIGradient
```
Color Keypoints:
├── 0.0 → RGB(100, 220, 150) Mint Green
├── 0.5 → RGB(120, 240, 170) Light Mint
└── 1.0 → RGB(100, 220, 150) Mint Green
Rotation: 45
```

### UnclaimedContainer UICorner
```
CornerRadius: 0, 10
```

### UnclaimedLabel
```
Properties:
├── Size: {1, 0}, {1, 0}
├── BackgroundTransparency: 1
├── Text: "Unclaimed: $0"
├── TextColor3: RGB(25, 25, 35) - Dark Blue-Gray
├── TextSize: 32
├── Font: GothamBold
└── TextXAlignment: Center
```

### UnclaimedLabel UIStroke
```
Properties:
├── Color: RGB(255, 255, 255) - White
├── Thickness: 2
└── Transparency: 0.3
```

---

## ClaimButton Styling

### ClaimSection
```
Properties:
├── Size: {1, 0}, {0, 100}
├── Position: {0, 0}, {1, -120}
├── AnchorPoint: 0, 0
└── BackgroundTransparency: 1
```

### ClaimButton (Default State)
```
Properties:
├── Size: {0.5, 0}, {0, 80}
├── Position: {0.25, 0}, {0, 10}
├── BackgroundColor3: RGB(50, 150, 255) - Bright Blue
├── Text: "CLAIM"
├── TextColor3: RGB(255, 255, 255) - White
├── TextSize: 38
├── Font: GothamBold
└── AutoButtonColor: true
```

### ClaimButton UIGradient
```
Color Keypoints:
├── 0.0 → RGB(50, 150, 255) Bright Blue
├── 0.5 → RGB(70, 170, 255) Light Blue
└── 1.0 → RGB(50, 150, 255) Bright Blue
Rotation: 90
```

### ClaimButton UIStroke
```
Properties:
├── Color: RGB(100, 200, 255) - Accent Blue
├── Thickness: 4
└── Transparency: 0.3
```

### ClaimButton UICorner
```
CornerRadius: 0, 15
```

### ClaimButton Active State (Has Money)
**Note:** Script automatically changes these when `Unclaimed > 0`:
```
BackgroundColor3: RGB(180, 100, 255) - Soft Purple (auto-changed)
Text: "CLAIM!" (auto-changed)
```

---

## Quick Update Checklist

### ScreenGui Elements:
- [ ] TopBar background + gradient + stroke
- [ ] BalanceContainer color + gradient
- [ ] BalanceLabel text color + stroke
- [ ] UnclaimedContainer color + gradient
- [ ] UnclaimedLabel text color + stroke
- [ ] ClaimButton color + gradient + stroke + text

### Workspace Elements:
- [ ] BasePad_T1 (Blue-Gray)
- [ ] BasePad_T2 (Mint Green)
- [ ] BasePad_T3 (Bright Blue)
- [ ] BasePad_T4 (Soft Purple)
- [ ] BasePad_T5 (Soft Coral)
- [ ] LanePath (Light Blue-Gray, transparent)
- [ ] PurchaseZone (Bright Blue, Neon, transparent)

---

## Character Billboards (Auto-Generated)

Each character on basepads gets an auto-generated nametag:

```lua
-- Structure created by BasePadService:
BillboardGui
├── Size: UDim2.new(0, 150, 0, 50)
├── StudsOffset: Vector3.new(0, 3, 0)
└── NameLabel (TextLabel)
    ├── Text: "Epic Brainrot\n10 EPS"
    ├── TextColor3: RGB(255, 255, 255)
    ├── TextSize: 18
    ├── Font: GothamBold
    ├── BackgroundColor3: RGB(0, 0, 0)
    └── BackgroundTransparency: 0.5
```

Colors match character tier automatically.

---

## Design Tips

### Visual Hierarchy
1. **Primary Actions** (Claim button) - Largest, brightest
2. **Important Info** (Balance, Unclaimed) - Medium, colored
3. **Secondary Info** (Character nametags) - Smallest

### Color Usage
- **Gold** for money you can spend (Balance)
- **Green** for money you haven't claimed (Unclaimed)
- **Blue** for actions and interactive elements
- **Gradients** add depth without clutter

### Contrast
- Dark text on light backgrounds (Balance/Unclaimed labels)
- Light text on dark backgrounds (TopBar if dark themed)
- Always test readability

### Consistency
- All buttons use 15px corner radius
- All containers use 10-12px corner radius
- All strokes use 0.3-0.5 transparency
- Spacing between elements: 10-20px

---

## Testing Your UI

After setting up:

1. **Stop** current play test
2. **Press F5** in Roblox Studio
3. Check that:
   - [ ] TopBar appears at top
   - [ ] Balance shows "Balance: $0"
   - [ ] Unclaimed shows "Unclaimed: $0"
   - [ ] Claim button visible at bottom
   - [ ] All colors match the palette
   - [ ] Text is readable
   - [ ] BasePads visible in workspace
   - [ ] PurchaseZone is green and transparent

4. **Test gameplay:**
   - [ ] Walk into green PurchaseZone
   - [ ] Click a moving character
   - [ ] Character appears on basepad
   - [ ] Unclaimed money increases
   - [ ] Claim button changes to purple when money available
   - [ ] Clicking Claim adds money to Balance

---

## Color Comparison (Old vs New)

| Element | Old Color | New Color |
|---------|-----------|-----------|
| TopBar | Purple gradient | Blue-gray gradient |
| Balance | Bright gold | Soft gold |
| Unclaimed | Bright green | Mint green |
| Claim Button | Hot pink | Bright blue |
| Tier 1 | Gray | Blue-gray |
| Tier 2 | Green | Mint green |
| Tier 3 | Blue | Bright blue |
| Tier 4 | Orange | Soft purple |
| Tier 5 | Purple | Soft coral |

---

## 📐 Advanced Customization

### Custom Fonts
Replace `GothamBold` with any Roblox font:
- **GothamBlack** - Extra bold
- **SourceSansBold** - Classic Roblox
- **FredokaOne** - Playful/cartoony
- **Roboto** - Modern/clean

### Custom Sizes
Adjust for different screen sizes:
```lua
-- TopBar responsive sizing:
TopBar.Size = UDim2.new(0.9, 0, 0, 70) -- Mobile
TopBar.Size = UDim2.new(0.8, 0, 0, 80) -- Desktop (default)
```

### Custom Animations
Add button hover effects:
```lua
-- In LocalScript:
ClaimButton.MouseEnter:Connect(function()
    ClaimButton:TweenSize(UDim2.new(0.52, 0, 0, 85), "Out", "Quad", 0.2)
end)
ClaimButton.MouseLeave:Connect(function()
    ClaimButton:TweenSize(UDim2.new(0.5, 0, 0, 80), "Out", "Quad", 0.2)
end)
```

---

## ✨ Final Result

Your game will have:
- Professional blue-gray color scheme
- Clear visual hierarchy
- Excellent text contrast
- Cohesive design across all elements
- Modern gradient effects
- Responsive and accessible UI

---

**Happy Designing!**
