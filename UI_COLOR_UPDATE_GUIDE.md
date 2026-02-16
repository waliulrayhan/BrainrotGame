# 🎨 UI Color Update Guide - Blue-Gray Professional Theme

## 📋 Overview
This guide provides the exact color values to update your manually created ScreenGui components in Roblox Studio to match the new professional blue-gray theme.

---

## 🌈 New Color Palette

### Primary Colors:
- **Bright Blue**: `RGB(50, 150, 255)` - Main accent color
- **Light Blue**: `RGB(70, 170, 255)` - Hover/highlight color
- **Accent Blue**: `RGB(100, 200, 255)` - Titles and important text
- **Dark Blue-Gray**: `RGB(25, 25, 35)` - Dark backgrounds
- **Medium Blue-Gray**: `RGB(35, 45, 60)` - Medium backgrounds
- **Light Blue-Gray**: `RGB(45, 60, 80)` - Light backgrounds

### Money Colors:
- **Soft Gold**: `RGB(255, 200, 80)` - Balance display
- **Mint Green**: `RGB(100, 220, 150)` - Unclaimed/earnings

### Status Colors:
- **Success Green**: `RGB(80, 200, 120)` - Success messages
- **Warning Orange**: `RGB(255, 180, 50)` - Warnings
- **Danger Red**: `RGB(255, 100, 100)` - Errors

### Tier Colors (for characters/billboards):
- **Tier 1**: `RGB(120, 140, 160)` - Blue-Gray
- **Tier 2**: `RGB(100, 220, 150)` - Mint Green
- **Tier 3**: `RGB(50, 150, 255)` - Bright Blue
- **Tier 4**: `RGB(180, 100, 255)` - Soft Purple
- **Tier 5**: `RGB(255, 150, 100)` - Soft Coral

---

## 🎯 TopBar Update

### TopBar (Main Container)
1. Select **TopBar** in StarterGui → MainHUD
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundColor3** | `RGB(35, 45, 60)` - Medium Blue-Gray |
| **BorderSizePixel** | 0 |

### TopBar UIGradient
1. Select **UIGradient** inside TopBar
2. Click **Color** to edit the ColorSequence
3. Update keypoints:
   - **0.0** → `RGB(35, 45, 60)` - Medium Blue-Gray
   - **0.5** → `RGB(45, 60, 80)` - Light Blue-Gray
   - **1.0** → `RGB(35, 45, 60)` - Medium Blue-Gray
4. Set **Rotation** to `90`

### TopBar UIStroke (Border)
1. Select **UIStroke** inside TopBar
2. Update properties:

| Property | New Value |
|----------|-----------|
| **Color** | `RGB(50, 150, 255)` - Bright Blue |
| **Thickness** | 3 |
| **Transparency** | 0.5 |

---

## 💰 BalanceContainer & BalanceLabel Update

### BalanceContainer
1. Select **BalanceContainer** in TopBar
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundColor3** | `RGB(255, 200, 80)` - Soft Gold |
| **BorderSizePixel** | 0 |

### BalanceContainer UIGradient
1. Select **UIGradient** inside BalanceContainer
2. Update Color keypoints:
   - **0.0** → `RGB(255, 200, 80)` - Soft Gold
   - **0.5** → `RGB(255, 220, 120)` - Light Gold
   - **1.0** → `RGB(255, 200, 80)` - Soft Gold
3. Set **Rotation** to `45`

### BalanceLabel
1. Select **BalanceLabel** inside BalanceContainer
2. Update properties:

| Property | New Value |
|----------|-----------|
| **TextColor3** | `RGB(25, 25, 35)` - Dark Blue-Gray (for contrast) |
| **TextSize** | 32 |
| **Font** | GothamBold |

### BalanceLabel UIStroke
1. Select **UIStroke** inside BalanceLabel
2. Update properties:

| Property | New Value |
|----------|-----------|
| **Color** | `RGB(255, 255, 255)` - White |
| **Thickness** | 2 |
| **Transparency** | 0.3 |

---

## 💵 UnclaimedContainer & UnclaimedLabel Update

### UnclaimedContainer
1. Select **UnclaimedContainer** in TopBar
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundColor3** | `RGB(100, 220, 150)` - Mint Green |
| **BorderSizePixel** | 0 |

### UnclaimedContainer UIGradient
1. Select **UIGradient** inside UnclaimedContainer
2. Update Color keypoints:
   - **0.0** → `RGB(100, 220, 150)` - Mint Green
   - **0.5** → `RGB(120, 240, 170)` - Light Mint
   - **1.0** → `RGB(100, 220, 150)` - Mint Green
3. Set **Rotation** to `45`

### UnclaimedLabel
1. Select **UnclaimedLabel** inside UnclaimedContainer
2. Update properties:

| Property | New Value |
|----------|-----------|
| **TextColor3** | `RGB(25, 25, 35)` - Dark Blue-Gray (for contrast) |
| **TextSize** | 32 |
| **Font** | GothamBold |

### UnclaimedLabel UIStroke
1. Select **UIStroke** inside UnclaimedLabel
2. Update properties:

| Property | New Value |
|----------|-----------|
| **Color** | `RGB(255, 255, 255)` - White |
| **Thickness** | 2 |
| **Transparency** | 0.3 |

---

## 🎁 ClaimSection & ClaimButton Update

### ClaimSection
1. Select **ClaimSection** in MainHUD
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundTransparency** | 1 (invisible) |

### ClaimButton
1. Select **ClaimButton** inside ClaimSection
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundColor3** | `RGB(50, 150, 255)` - Bright Blue |
| **Text** | `CLAIM` (remove emojis) |
| **TextColor3** | `RGB(255, 255, 255)` - White |
| **TextSize** | 38 |
| **Font** | GothamBold |
| **AutoButtonColor** | ✅ true |

### ClaimButton UIGradient
1. Select **UIGradient** inside ClaimButton (or create one)
2. Update Color keypoints:
   - **0.0** → `RGB(50, 150, 255)` - Bright Blue
   - **0.5** → `RGB(70, 170, 255)` - Light Blue
   - **1.0** → `RGB(50, 150, 255)` - Bright Blue
3. Set **Rotation** to `90`

### ClaimButton UIStroke
1. Select **UIStroke** inside ClaimButton
2. Update properties:

| Property | New Value |
|----------|-----------|
| **Color** | `RGB(100, 200, 255)` - Accent Blue |
| **Thickness** | 4 |
| **Transparency** | 0.3 |

### ClaimButton UICorner
1. Select **UICorner** inside ClaimButton
2. Update properties:

| Property | New Value |
|----------|-----------|
| **CornerRadius** | `0, 15` |

---

## 🎨 When Claim Button Has Money (Dynamic Colors)

**Note:** The script automatically changes these colors when `Unclaimed > 0`:

### Active State (has money):
- **BackgroundColor3**: `RGB(180, 100, 255)` - Soft Purple (auto-changed by script)
- **Text**: `CLAIM!` (auto-changed by script)

### Inactive State (no money):
- **BackgroundColor3**: `RGB(50, 150, 255)` - Bright Blue (auto-changed by script)
- **Text**: `CLAIM` (auto-changed by script)

---

## 📐 Notifications Frame (Optional if exists)

If you have a **Notifications** frame:

### Notifications Frame
1. Select **Notifications** in MainHUD
2. Update properties:

| Property | New Value |
|----------|-----------|
| **BackgroundTransparency** | 1 |
| **ZIndex** | 10 |

---

## 🎯 Basepad Colors (in Workspace)

If you want to update your basepads to match the theme:

### Tier 1 Basepad:
- **Color**: `RGB(120, 140, 160)` - Blue-Gray
- **Material**: SmoothPlastic

### Tier 2 Basepad:
- **Color**: `RGB(100, 220, 150)` - Mint Green
- **Material**: SmoothPlastic

### Tier 3 Basepad:
- **Color**: `RGB(50, 150, 255)` - Bright Blue
- **Material**: SmoothPlastic

### Tier 4 Basepad:
- **Color**: `RGB(180, 100, 255)` - Soft Purple
- **Material**: SmoothPlastic

### Tier 5 Basepad:
- **Color**: `RGB(255, 150, 100)` - Soft Coral
- **Material**: SmoothPlastic

---

## 🛣️ LinePath Colors (in Workspace)

If you have a **LinePath** or shop lane path:

### LinePath Part:
- **Color**: `RGB(45, 60, 80)` - Light Blue-Gray
- **Material**: SmoothPlastic
- **Transparency**: 0.3

### Alternative (glowing path):
- **Color**: `RGB(50, 150, 255)` - Bright Blue
- **Material**: Neon
- **Transparency**: 0.5

---

## 🏬 PurchaseZone Colors (in Workspace)

If you have a **PurchaseZone** part:

### PurchaseZone:
- **Color**: `RGB(50, 150, 255)` - Bright Blue
- **Material**: Neon
- **Transparency**: 0.6

### Alternative (subtle):
- **Color**: `RGB(100, 200, 255)` - Accent Blue
- **Material**: ForceField
- **Transparency**: 0.7

---

## ⚡ Quick Update Checklist

Use this checklist to ensure you've updated everything:

### ScreenGui Elements:
- [ ] TopBar background color
- [ ] TopBar gradient
- [ ] TopBar stroke/border
- [ ] BalanceContainer color
- [ ] BalanceContainer gradient
- [ ] BalanceLabel text color
- [ ] UnclaimedContainer color
- [ ] UnclaimedContainer gradient
- [ ] UnclaimedLabel text color
- [ ] ClaimButton color
- [ ] ClaimButton gradient
- [ ] ClaimButton stroke
- [ ] ClaimButton text

### Workspace Elements:
- [ ] Basepad Tier 1 color
- [ ] Basepad Tier 2 color
- [ ] Basepad Tier 3 color
- [ ] Basepad Tier 4 color
- [ ] Basepad Tier 5 color
- [ ] LinePath color (if exists)
- [ ] PurchaseZone color (if exists)

---

## 🎨 Color Comparison (Old vs New)

| Element | Old Color | New Color |
|---------|-----------|-----------|
| **TopBar** | Purple gradient | Blue-gray gradient |
| **Balance** | Bright gold | Soft gold |
| **Unclaimed** | Bright green | Mint green |
| **Claim Button** | Hot pink | Bright blue |
| **Tier 1 Character** | Gray | Blue-gray |
| **Tier 2 Character** | Green | Mint green |
| **Tier 3 Character** | Blue | Bright blue |
| **Tier 4 Character** | Orange | Soft purple |
| **Tier 5 Character** | Purple | Soft coral |

---

## 💡 Pro Tips

1. **Use UIGradients**: Add gradients to all containers for depth
2. **Match Transparency**: Keep similar elements at same transparency (0.15-0.3)
3. **Corner Radius**: Use 12-15 for buttons, 8-10 for containers
4. **Text Contrast**: Dark text on light backgrounds, light text on dark backgrounds
5. **Stroke Effects**: Use semi-transparent strokes (0.3-0.5) for subtle borders

---

## 🔄 Testing Your Changes

After updating colors:

1. **Stop** current play test
2. **Restart Rojo** if needed
3. Press **Play (F5)** in Studio
4. Check that all colors look consistent
5. Verify text is readable
6. Test claim button color changes

---

## ✨ Result

Your game will now have a cohesive, professional blue-gray color scheme that:
- Looks modern and polished
- Is easy on the eyes
- Has good contrast for readability
- Matches the tutorial UI perfectly
- Creates a premium gaming experience

---

**Happy Designing! 🎨✨**
