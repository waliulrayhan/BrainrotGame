# Workspace Setup Guide - 5 Tier Basepads

This guide explains how to set up your Roblox workspace for the 5-character tier system.

## Updated Character System

The game now features 5 characters based on tiers:

| Tier | Name | Price | EPS | ModelKey |
|------|------|-------|-----|----------|
| 1 | Tiny Brainrot | 0 | 1 | Brainrot_T1 |
| 2 | Better Brainrot | 25 | 3 | Brainrot_T2 |
| 3 | Epic Brainrot | 150 | 10 | Brainrot_T3 |
| 4 | Mythic Brainrot | 800 | 40 | Brainrot_T4 |
| 5 | Legend Brainrot | 3500 | 120 | Brainrot_T5 |

## Workspace Structure

### Required Folders and Parts

You need to create the following structure in your Roblox workspace:

```
Workspace
├── BasePads (Folder)
│   ├── BasePad_T1 (Part) - For Tier 1 characters
│   ├── BasePad_T2 (Part) - For Tier 2 characters
│   ├── BasePad_T3 (Part) - For Tier 3 characters
│   ├── BasePad_T4 (Part) - For Tier 4 characters
│   └── BasePad_T5 (Part) - For Tier 5 characters
└── ShopLane (Folder) - Existing
    └── LanePath (Part) - Existing
```

## Step-by-Step Setup

### 1. Create BasePads Folder

1. In Roblox Studio, open your workspace
2. In the Explorer panel, right-click on `Workspace`
3. Select `Insert Object` > `Folder`
4. Rename the folder to `BasePads`

### 2. Create Tier 1 BasePad

1. Insert a `Part` into the `BasePads` folder
2. Rename it to `BasePad_T1`
3. Set the following properties:
   - **Size**: `20, 1, 20` (or adjust to your preference)
   - **Position**: Choose a location in your map (e.g., `10, 0.5, 10`)
   - **Anchored**: `true`
   - **CanCollide**: `true`
   - **Color**: Gray (150, 150, 150) or any color you prefer
   - **Material**: `Slate` or `Concrete`

### 3. Create Tier 2 BasePad

1. Duplicate `BasePad_T1` (Ctrl+D)
2. Rename it to `BasePad_T2`
3. Move it to a different position (e.g., `40, 0.5, 10`)
4. (Optional) Change the color to Green (100, 200, 100)

### 4. Create Tier 3 BasePad

1. Duplicate `BasePad_T1` again
2. Rename it to `BasePad_T3`
3. Move it to position (e.g., `70, 0.5, 10`)
4. (Optional) Change the color to Blue (100, 100, 255)

### 5. Create Tier 4 BasePad

1. Duplicate `BasePad_T1` again
2. Rename it to `BasePad_T4`
3. Move it to position (e.g., `100, 0.5, 10`)
4. (Optional) Change the color to Orange (255, 165, 0)

### 6. Create Tier 5 BasePad

1. Duplicate `BasePad_T1` again
2. Rename it to `BasePad_T5`
3. Move it to position (e.g., `130, 0.5, 10`)
4. (Optional) Change the color to Purple (200, 0, 200)

## Recommended Layout

Here's a suggested layout for your basepads:

```
[BasePad_T1] [BasePad_T2] [BasePad_T3] [BasePad_T4] [BasePad_T5]
   (Gray)      (Green)      (Blue)     (Orange)    (Purple)
```

### Layout Tips:

- Space basepads **30 studs apart** to give each tier enough room
- Place them in a row for easy viewing
- Each basepad should be large enough to hold multiple characters (recommended: 20x1x20 studs minimum)
- Consider elevating higher tier basepads slightly for visual hierarchy
- Add labels or signs above each basepad indicating the tier

## How It Works

### Character Placement

When players purchase characters:

1. **Tier 1 characters** (Tiny Brainrot) will spawn on `BasePad_T1`
2. **Tier 2 characters** (Better Brainrot) will spawn on `BasePad_T2`
3. **Tier 3 characters** (Epic Brainrot) will spawn on `BasePad_T3`
4. **Tier 4 characters** (Mythic Brainrot) will spawn on `BasePad_T4`
5. **Tier 5 characters** (Legend Brainrot) will spawn on `BasePad_T5`

### Character Arrangement

Characters automatically arrange in a grid pattern (4 per row) on their designated basepad.

## Optional Enhancements

### 1. Add Tier Labels

Create TextLabels above each basepad:

1. Insert a `Part` above each basepad
2. Add a `SurfaceGui` to the part
3. Add a `TextLabel` to the SurfaceGui
4. Set the text to "Tier 1", "Tier 2", etc.

### 2. Add Decorative Borders

- Place wall parts around each basepad
- Use different materials for each tier
- Add lights or particle effects

### 3. Create Elevated Platforms

- Place higher tier basepads on elevated platforms
- Add stairs or ramps between tiers
- Create a visual progression from Tier 1 to Tier 5

## Testing

After setting up:

1. Start the Rojo server: `rojo serve`
2. Connect in Roblox Studio
3. Test the game
4. Purchase characters and verify they spawn on the correct basepads
5. Check that each tier's characters stay on their designated pad

## Troubleshooting

### Characters not spawning?

- Verify each basepad is named exactly: `BasePad_T1`, `BasePad_T2`, etc.
- Check that all basepads are inside the `BasePads` folder
- Ensure basepads are anchored and have collision enabled

### Console shows warnings?

- Look for messages like `[BasePadService] Missing basepad: BasePad_T1`
- This means you need to create that specific basepad

### Characters falling through?

- Make sure `CanCollide` is set to `true` on all basepads
- Verify basepads are anchored

## Summary

You now have a complete 5-tier basepad system where:
- Each of the 5 character types has its own dedicated basepad
- Characters automatically spawn on their tier-specific pad
- Players can see all their characters organized by tier
- The system supports multiple characters per tier per player

Enjoy your organized Brainrot Game!
