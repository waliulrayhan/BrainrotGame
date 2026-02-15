# 🌳 ENVIRONMENT SETUP GUIDE - BRAINROT GAME
## Make Your World Come Alive! 🏡🌲🛣️

This guide will help you create a **beautiful, realistic, and fun environment** for your game! We'll add trees, houses, roads, rivers, and much more! 🎨✨

---

## 🖥️ UNDERSTANDING YOUR STUDIO INTERFACE

Before we start, let's identify the important parts of Roblox Studio:

### Top of Screen:
- **Top Menu Bar**: File, Edit, View, Plugins, Test, Window, Help
- **Tab Bar**: Home, Avatar, UI, Script, Model, Plugins (← These are important!)
- **Toolbar**: Shows different buttons depending on which tab is selected

### Main Work Area (Center):
- **3D Viewport**: Where you see and build your game world
- **Play Button (▶)**: At the very top - click to test your game

### Right Side Panels:
- **Explorer**: Shows all objects in your game (tree view)
- **Properties**: Shows settings for selected object

### Bottom:
- **Toolbox**: Opens when you click Toolbox button - search for free models
- **Output**: Shows messages and errors

**💡 Tip:** If you don't see Explorer or Properties, go to **View** tab → click **Explorer** and **Properties**

### Where Things Are (Quick Reference):

| What You Want | Where to Find It |
|---------------|------------------|
| Insert a part | **Home** tab → Click **Part** button |
| Open terrain editor | **Home** tab → Click **Terrain** button |
| Find free models | **Home** tab → Click **Toolbox** button |
| Move an object | **Home** tab → Click **Move** button |
| Rotate an object | **Home** tab → Click **Rotate** button |
| Scale/resize object | **Home** tab → Click **Scale** button |
| Change object settings | Select it, look at **Properties** panel (right) |
| See what's in your game | Look at **Explorer** panel (right) |
| Test your game | Click **▶ Play** button at very top |
| Union/combine parts | Select parts → **Model** tab → **Union** |
| Group parts together | Select parts → Right-click → **Group** |

---

## 🎯 What We're Building

An amazing 3D world with:
- 🌳 **Trees & Bushes** - Lush vegetation everywhere!
- 🏡 **Houses & Buildings** - Places for characters to live!
- 🛣️ **Roads & Paths** - Connect different areas!
- 🌊 **Rivers & Water** - Natural water features!
- 🪨 **Rocks & Terrain** - Natural landscape elements!
- 💡 **Street Lights** - Light up the night!
- 🚧 **Fences & Barriers** - Define property boundaries!
- ⛰️ **Hills & Valleys** - Sculpted terrain for depth!

---

## 📐 GETTING STARTED

### Understanding the Workspace
In Roblox Studio, the **Workspace** is where all your 3D objects live. Think of it as your game world!

### Studio Interface (Top Tabs):
You'll see these main tabs at the top of Studio:
1. **Home** → Basic tools (Part, Terrain, Select, Move, etc.)
2. **Model** → Advanced building tools (Union, Negate, etc.)
3. **Avatar** → Character customization
4. **UI** → User interface design
5. **Script** → Scripting tools
6. **Plugins** → Installed plugins

### Essential Tools (Home Tab):
- **Select** → Click to select objects
- **Move** → Move objects around
- **Scale** → Resize objects
- **Rotate** → Rotate objects
- **Part** → Insert new parts
- **Terrain** → Open terrain editor
- **Material** → Change part materials
- **Color** → Change part colors
- **Toolbox** → Free models and assets
- **Explorer** → See all objects (right side)
- **Properties** → Edit object properties (right side)

### Keyboard Shortcuts:
- **Select Tool**: Click "Select" button in Home tab
- **Move Tool**: Click "Move" button in Home tab  
- **Scale Tool**: Click "Scale" button in Home tab
- **Rotate Tool**: Click "Rotate" button in Home tab
- **Copy**: Ctrl+C
- **Paste**: Ctrl+V
- **Duplicate**: Ctrl+D
- **Delete**: Delete key
- **Undo**: Ctrl+Z
- **Play Test**: F5 or click ▶ button at top

---

## 🗂️ STEP 1: Organize Your Workspace

### 1.1 Create Environment Folders
Keep everything organized! Create these folders in **Workspace**:

1. Look at **Explorer** panel (right side of screen)
2. Find **Workspace** in the tree
3. Right-click **Workspace**
4. Select **Insert Object** → **Folder**
5. Name it "Environment"
6. Create more folders inside Environment:

```
Workspace
├── Environment (Main folder)
│   ├── Terrain (Hills, ground)
│   ├── Trees
│   ├── Buildings
│   ├── Roads
│   ├── Water
│   ├── Decorations
│   └── Lighting
└── (Your existing game objects)
```

**Why organize?** Makes it easy to find and edit things later! 📁

---

## �� STEP 2: Create Beautiful Terrain

### 2.1 Open Terrain Editor
1. Go to **Home** tab
2. Click **Editor** button
3. Select **Terrain Editor**

### 2.2 Create Base Terrain
1. In Terrain Editor, select **Generate**
2. Set these values:

| Setting | Value |
|---------|-------|
| **Size** | 512 x 512 (large area) |
| **Position** | 0, 0, 0 (center) |
| **Material** | Grass |
| **Biome** | Plains or Hills |
| **Seed** | Any number (try different seeds!) |

3. Click **Generate** button

### 2.3 Paint Terrain Materials
1. In Terrain Editor, click the **Edit** tab at the top
2. Click **Paint** option
3. Choose a material from the grid that appears:
   - **Grass**: Main ground (green icon)
   - **Sand**: Near water, paths (tan icon)
   - **Rock**: Mountains, cliffs (grey icon)
   - **Ground**: Dirt areas (brown icon)
   - **Mud**: Swampy areas (dark brown icon)

4. Adjust **Brush Settings**:
   - **Base Size**: 12-20 (how big the brush is)
   - **Strength**: 0.5-1.0 (how strong the effect)
5. Click and drag in the 3D viewport to paint!

**Pro Tips:**
- **Grow** tool: Click Edit tab → Grow (raises terrain into hills)
- **Erode** tool: Click Edit tab → Erode (lowers terrain into valleys)
- **Smooth** tool: Click Edit tab → Smooth (blends rough edges)

### 2.4 Add Water Features
1. In Terrain Editor, click **Edit** tab → **Paint**
2. Choose **Water** material from the material grid (blue icon)
3. Paint in the 3D viewport!

**For a River:**
1. Use Edit → **Paint** with Water material
2. Paint a long, winding path (5-10 studs wide)
3. Use Edit → **Smooth** tool to blend the banks

**For a Lake:**
1. First use Edit → **Erode** to create a low depression
2. Then use Edit → **Paint** with Water material to fill it
3. Use Edit → **Smooth** on edges for natural look!

---

## 🌳 STEP 3: Add Trees

### 3.1 Method 1: Build Your Own Tree

**Create a Simple Tree:**

1. **Make the Trunk:**
   - Go to **Home** tab at the top
   - Click the **Part** button (looks like a brick)
   - A grey part appears in the world
   - Look at **Properties** panel (right side)
   - At the top of Properties, change Name to "TreeTrunk"
   - Set these properties in the Properties panel:
     - Size: `2, 15, 2` (width, height, depth)
     - Material: **Wood**
     - BrickColor: **Brown** (CFrame.Brown or RGB 101, 67, 33)
     - Anchored: ✅ **true**
   - Click **Part** button again in Home tab
   - In Properties panel, rename to "TreeLeaves"
   - Set thesee the Leaves:**
   - Insert **Part**
   - Rename to "TreeLeaves"
   - Set properties:
     - Size: `10, 10, 10`
     - Shape: **Ball**
     - Material: **Grass** or **Leafy Grass**
     - BrickColor: **Dark green** (RGB 34, 139, 34)
     - Anchored: ✅ **true**
     - CanCollide: ❌ **false**
   - Position at `X: 0, Y: 18, Z: 0` (top of trunk)

3. **Group Them:**
   - Click the **Select** button (Home tab)
   - Click the trunk, then hold **Ctrl** and click the leaves
   - Right-click one of them → **Group**
   - In Properties, rename the Model to "Tree"
   - In **Explorer** panel, drag the "Tree" into **Environment/Trees** folder

4. **Duplicate:**
   - Select the tree in Explorer or in the 3D view
   - Press **Ctrl+D** to duplicate
   - Click the **Move** tool (Home tab)
   - Drag the copy to a new location
   - Click **Rotate** tool to rotate it
   - Repeat to create a forest!
Click **Toolbox** button in Home tab (or click View tab → Toolbox)
2. The Toolbox panel opens (usually bottom of screen)
3. In the search box at top, type "tree"
4. You'll see tabs: **Marketplace**, **Inventory**, **Recent**, etc.
5. Click **Marketplace** tab
6. Click on a free tree model (look for ones with no Robux price)
7. Click it once - it inserts into your game!
8. In Explorer, drag it into **Environment/Trees** folder
9. Use Move tool to position it
10. Press Ctrl+D to duplicate and create more trees
4. Click on a free tree model to insert
5. Move it to your **Trees** folder
6. Duplicate and place around map!

**Recommended searches:**
- "low poly tree"
- "cartoon tree"
- "palm tree"
- "pine tree"

**Pro Tips:**
- Mix different tree types!
- Create "forests" by grouping many trees
- Use Scale tool (Ctrl+3) for different sizes
- Rotate trees randomly for natural look

---

## Click **Part** button in Home tab
2. In **Properties** panel (right side), rename to "HouseFloor"
3. Set these p4.1 Build a Simple House

**Foundation:**
1. Insert **Part**
2. Rename to "HouseFloor"
3. Properties:
   - Size: `20, 1, 20`
   Click **Part** button 4 times to create 4 parts
2. In Properties, rename them: "Wall_Front", "Wall_Back", "Wall_Left", "Wall_Right"
3. For each wall, set these properties **true**

**Walls:**
1. Insert 4 **Parts** for walls
2. Name them "Wall_Front", "Wall_Back", "Wall_Left", "Wall_Right"
3. For each wall:
   - Size: `20, 12, 1` (or `1, 12, 20` for sides)
   - Material: **Brick** or **Concrete**
   Use **Move** tool to position walls around the floor edges

**Door (on front wall):**
1. Click **Part** button again
2. In Properties, rename to "Door"
3. Set pnsert **Part**
2. Name "Door"
3. Properties:
   - Size: `4, 8, 0.5`
   - Material: **Wood**
   - BrickColor: **Brown**
   - Anchored: ✅ **true**
4. Position in center of front wall
Click **Part** button
2. In Properties, name it "Window"  
3. Set pnsert **Part**
2. Name "Window"
3. Properties:
   - Size: `3, 3, 0.5`
   - Material: **Glass**
   - BrickColor: **Light blue** (RGB 173, 216, 230)
   - Transparency: **0.5**
   - Anchored: ✅ **true**
4. Duplicate for multiple windows
5. Place 2-3 on each wall

**Roof:**
1. Click **Part** button
2. In Properties, name it "Roof_Base"
3. Set properties:
   - Size: `22, 1, 22` (slightly bigger than floor)
   - Material: **Slate**
   - BrickColor: **Dark red** (RGB 139, 69, 19)
   - Anchored: ✅ **true**
4. Position on top of walls

5. In Home tab, click the small **arrow** next to Part button
6. Select **Wedge** from the dropdown menu
7. In Properties, name it "Roof_Peak"
8. Set properties:
   - Size: `1, 11, 22`
   - Material: **Slate**
   - BrickColor: **Dark red**
   - Anchored: ✅ **true**
   - Orientation: `0, 0, -90`
8. Position on top of roof base

**FClick **Select** tool (Home tab)
2. Click first part, then hold **Ctrl** and click each other part
3. Right-click any selected part → **Group**
4. In Properties, rename the new Model to "House"
5. In Explorer, drag "House" into **Environment/Buildings** folder
6. Now you can move the whole house as one object!ed edges)
5. Move to **Environment/Buildings** folder

### 4.2 Add Interior Details (Optional)

**Floor inside:**
- Different colored part
- Material: **Wood Planks** or **Marble**

**Furniture:**
- Simple parts for table, chairs, bed
- Or use Toolbox: Search "furniture"

**Lighting:**
- Insert **PointLight** inside
- Color: Warm yellow `255, 244, 214`
- Brightness: 2
- Range: 30

###Click **Toolbox** button (Home tab) or View → Toolbox
2. In the Toolbox search box, type:
   - "small house"
   - "cartoon house"
   - "low poly building"
   - "store" or "shop"
3. Click **Marketplace** tab to see available models
4. Click a free model to insert it
5. Use **Move** and **Rotate** tools to customize position"
   - "store" or "shop"
3. Insert and customize!

**Pro Tips:**
- Build 5-8 houses for a neighborhood
- Vary house colors and sizes
- Add chimneys (small cylinders on roof)
- Add fences around properties

---

## 🛣️ STEP 5: Create Roads
Click **Part** button (Home tab)
2. In Properties, rename to "MainRoad"
3. Set these p
**Main Road:**
1. Insert **Part**
2. Rename to "MainRoad"
3. Properties:
   - Size: `12, 0.5, 200` (width, height, length)
   - Material: **Asphalt**
   - BrickColor: **Really black** or **Dark grey** (RGB 60, 60, 60)
   Click **Part** button again
2. In Properties, rename to "RoadLine"
3. Set p
**Road Lines (center markings):**
1. Insert **Part**
2. Rename to "RoadLine"
3. Properties:
   - Size: `0.3, 0.6, 10` (dashed line piece)
   - Material: **SmoothPlastic**
   - BrickColor: **White**
   - Anchored: ✅ **true**
4. Position on road center
5. Duplicate every 15 studs along road

**Or create continuous line:**
- Size: `0.3, 0.6, 200` (same length as road)
- Position at `Y: 0.6` (on top of road)

### 5.2 Create Intersections

**Cross Road:**
1. Duplicate main road
2. Rotate 90 degrees
3. Position perpendicular to main road

**Sidewalks (optional):**
1. Insert **Part** on each side of road
2. Size: `3, 0.7, 200`
3. Material: **Concrete**
4. BrickColor: **Light grey**
5. Position higher than road (Y: 0.35)

### 5.3 Road Decorations

**Road Signs:**
- Use Toolbox: Search "road sign"
- Or build with cylinder (pole) + flat part (sign)

**Crosswalks:**
- White **Decals** on road
- Or white stripes (parts)

**Pro Tips:**
- Roads should be 12-16 studs wide
- Make roads connect houses to main areas
- Add curves by rotating segments

---

## 💡 STEP 6: Add Street Lights

### 6.1 Build a Street Light

**Light Pole:**
1. Insert **Part**
2. Rename to "LightPole"
3. Properties:
   - Size: `0.5, 12, 0.5`
   - Material: **Metal**
   - BrickColor: **Dark grey** (RGB 70, 70, 70)
   - Anchored: ✅ **true**

**Light Fixture:**
1. Insert **Part**
2. Rename to "LightFixture"
3. Properties:
   - Size: `2, 0.5, 2`
   - Shape: **Cylinder**
   - Material: **SmoothPlastic**
   - BrickColor: **Black**
   - Orientation: `0, 0, 90`
   In **Explorer**, click on the **LightFixture** part
2. Right-click it → **Insert Object** → **PointLight**
3. With PointLight selected, set these p
**Light Source:**
1. Click on **LightFixture** part
2. Insert **PointLight** (not a part!)
3. Properties:
   - Brightness: **2**
   - Range: **40**
   - Color: **Warm white** (RGB 255, 244, 214)
   - Shadows: ✅ **true**

**Base (optional):**
1. Insert **Part**
2. Size: `1.5, 0.5, 1.5`
3. Position at bottom of pole

**Final:**
1. Group all parts
2. Rename to "StreetLight"
3. Move to **Environment/Lighting**
4. Duplicate along roads (every 30-40 studs)

### 6.2 Alternative: Use Toolbox

Search: "street light", "lamp post", "street lamp"

**Pro Tips:**
- Place street lights on both sides of road
- Add lights near houses
- Use **SpotLight** for directional beams

---

## 🪨 STEP 7: Add Rocks & Natural Elements

### 7.1 Create Rocks

**Simple Rock:**
1. Insert **Part**
2. Properties:
   - Size: `4, 3, 4` (vary sizes!)
   - Shape: **Ball** or **Block**
   - Material: **Rock** or **Slate**
   - BrickColor: **Grey** (RGB 128, 128, 128)
   - Anchored: ✅ **true**
3. Rotate randomly
4. Duplicate and scatter around

**For variety:**
- Use different sizes (2-8 studs)
- Try **Cobblestone** material
- Mix **Basalt** and **Rock**
- Place near water, on hills

### 7.2 Create Bushes

**Simple Bush:**
1. Insert **Part**
2. Properties:
   - Size: `3, 2, 3`
   - Shape: **Ball**
   - Material: **Grass** or **Leafy Grass**
   - BrickColor: **Dark green** (RGB 46, 125, 50)
   - Anchored: ✅ **true**
   - CanCollide: ❌ **false** (players walk through)
3. Scatter around trees and houses

### 7.3 Add Flowers (Optional)

Use Toolbox: Search "flower", "plant", "grass patch"

**Pro Tips:**
- Cluster rocks together
- Place bushes near buildings
- Use **Foliage** material for leaves
- Add variety with different sizes

---

## 🚧 STEP 8: Build Fences

### 8.1 Create Wooden Fence

**Fence Post:**
1. Insert **Part**
2. Properties:
   - Size: `0.5, 4, 0.5`
   - Material: **Wood**
   - BrickColor: **Brown** (RGB 139, 90, 43)
   - Anchored: ✅ **true**
3. Duplicate every 3-5 studs in a line

**Horizontal Rails:**
1. Insert **Part**
2. Properties:
   - Size: `0.3, 0.3, 4.5` (connects two posts)
   - Material: **Wood**
   - BrickColor: **Brown**
   - Anchored: ✅ **true**
3. Position between posts
4. Create 2-3 horizontal rails per section

**Final:**
1. Group all fence parts
2. Rename to "Fence_Section"
3. Duplicate for longer fences

### 8.2 Alternative Fences

**Stone Wall:**
- Material: **Brick** or **Cobblestone**
- BrickColor: Grey
- Taller (5-6 studs)

**Modern Fence:**
- Material: **Metal**
- BrickColor: Black or white
- Thin posts (0.2 stud width)

### 8.3 Use Toolbox

Search: "fence", "wall", "barrier", "hedge"

**Pro Tips:**
- Place fences around houses
- Use fences to block certain areas
- Mix fence types for variety

---

## 🌊 STEP 9: Advanced Water Features

### 9.1 Create a Swimming Pool

1. Use **Erode** tool in Terrain Editor
2. Create rectangular depression
3. Paint inside with **Water** material
4. Add **Concrete** or **Slate** border

### 9.2 Create a Pond

1. **Erode** a circular area
2. Fill with **Water**
3. Add rocks around edge
4. Place lily pads (green disks)

### 9.3 Create Waterfall (Advanced)

1. Create elevated water source (pool on hill)
2. Use multiple water parts cascading down
3. Add **ParticleEmitter** for splash effect
4. Properties:
   - Texture: Water droplet
   - Rate: 50
   - Lifetime: 1-2 seconds

### 9.4 Beach Area

1. Use **Smooth** tool for gentle slope
2. Paint **Sand** on shore
3. Paint **Water** in deeper area
4. Add shells (small white parts)

**Pro Tips:**
- Water terrain is semi-transparent
- Add blue **PointLights** underwater
- Use **Coral** material for reef areas

---

## ⛰️ STEP 10: Sculpt Hills & Mountains

### 10.1 Create Hills

1. Click **Terrain** button (Home tab)
2. In Terrain Editor, click **Edit** tab
3. Select **Grow** tool
4. Set brush size: 20-30 in the settings
5. Click and drag in the 3D viewport to raise terrain
6. Click **Smooth** tool to round the tops

### 10.2 Create Valleys

1. In Terrain Editor, click **Edit** tab
2. Select **Erode** tool
3. Set brush size: 15-25
4. Click and drag to lower terrain
5. Use **Smooth** tool on edges

### 10.3 Create Mountains

1. In Terrain Editor → **Edit** tab → **Grow** tool
2. Click many times in same spot to build up layers
3. Switch to **Paint** tool
4. Select **Rock** material and paint the peaks
5. Select **Grass** material and paint lower slopes
6. Select **Snow** material for the very top (optional)

**Pro Tips:**
- Mountains in background create depth
- Hills block line of sight (more interesting)
- Vary terrain height for natural look
- Use **Pivot** tool to add cliffs (Region → Select → Move)

---

## 🎨 STEP 11: Add Details & Polish

### 11.1 Atmospheric Lighting

**Change Time of Day:**
1. In **Explorer** (right side), find and click **Lighting**
2. In **Properties** panel, scroll to find **ClockTime**
3. Change the value:
   - 12 = Noon (bright)
   - 6 = Sunrise (orange)
   - 18 = Sunset (red)
   - 0 = Midnight (dark)

**Add Atmosphere:**
1. In **Explorer**, right-click **Lighting**
2. Select **Insert Object** → **Atmosphere**
3. With Atmosphere selected, set these in **Properties**:
   - Density: 0.3
   - Offset: 0.5
   - Color: Click the color box → Light blue
   - Glare: 0.3
   - Haze: 1.5

**Add Bloom:**
1. In **Explorer**, right-click **Lighting**
2. Select **Insert Object** → **BloomEffect**
3. In **Properties**, set:
   - Intensity: 0.4
   - Size: 24
   - Threshold: 1

**Add Color Correction:**
1. Right-click **Lighting** → **Insert Object** → **ColorCorrectionEffect**
2. In **Properties**, adjust:
   - Brightness: 0.02
   - Contrast: 0.1
   - Saturation: 0.1
   - TintColor: Click color → Choose slight orange/warm tone

### 11.2 Sky & Clouds

**Change Skybox:**
1. In **Explorer**, find **Lighting**
2. Some games have a **Sky** object inside Lighting already
3. If not, right-click **Lighting** → **Insert Object** → **Sky**
4. In **Properties**, you can set:
   - SkyboxBk, SkyboxDn, SkyboxFt, SkyboxLf, SkyboxRt, SkyboxUp
   - Upload custom skybox images or use default

**Add Clouds:**
1. Right-click **Lighting** → **Insert Object** → **Clouds**
2. In **Properties**, adjust:
   - Cover: 0.5 (how much sky is covered)
   - Density: 0.5 (how thick they are)
   - Color: White or light grey

### 11.3 Sound Effects

**Ambient Nature Sounds:**
1. In **Explorer**, right-click **Workspace**
2. Select **Insert Object** → **Sound**
3. In **Properties**, set:
   - SoundId: Click → Search for "birds", "wind", "water"
   - Looped: ✅ Check the box
   - Playing: ✅ Check the box
   - Volume: 0.3-0.5

**Positional Sounds:**
1. In **Explorer**, find a specific object (like a waterfall part)
2. Right-click it → **Insert Object** → **Sound**
3. Set sound properties for that location

Examples:
- Sound in waterfall part → water rushing
- Sound near road → traffic sounds
- Sound in tree → birds chirping

### 11.4 Particle Effects

**Fireflies (night time):**
1. Click **Part** button (Home tab)
2. In Properties, set Transparency = 1 (invisible)
3. Right-click the part → **Insert Object** → **ParticleEmitter**
4. In **Properties**, set:
   - Texture: rbxasset://textures/particles/sparkles_main.dds
   - Color: Click → Yellow-green color
   - Rate: 10
   - Lifetime: NumberRange (2, 4)
   - Speed: NumberRange (1, 3)

**Leaves Falling:**
1. In **Explorer**, find a tree's leaves part
2. Right-click it → **Insert Object** → **ParticleEmitter**
3. In **Properties**, set:
   - Texture: Upload a leaf image or use default
   - Rate: 5
   - Lifetime: NumberRange (5, 8)
   - Speed: NumberRange (1, 1)
   - Rotation: NumberRange (0, 360)

---

## ✨ STEP 12: Final Organization & Testing
Look at the **Explorer** panel (right side) and c
### 12.1 Clean Up Workspace

Check that everything is organized:
```
Workspace
└── Environment
    ├── Terrain (all terrain)
    ├── Trees (all tree models)
    ├── Buildings (houses, shops)
    ├── Roads (road parts)
    ├── Water (rivers, ponds)
    ├── Decorations (rocks, bushes, flowers)
    ├── Lighting (street lights)
    └── Fences (fence sections)
```

### 12.2 Anchor Everything!
**Method 1 - Anchor button:**
1. In **Explorer**, click on Environment folder
2. Press **Ctrl+A** to select all inside
3. Look at **Home** tab
4. Find and click the **Anchor** button (anchor icon)

**Method 2 - Properties:**
1. Select an object
2. In **Properties** panel (right side)
3. Scroll down to find **Anchored**
4. Check the box: ✅ **true**

**Why?** Prevents objects from falling or movi properly:

For each object, select it and check **CanCollide** in Properties:
- Trees: Trunk = CanCollide ✅ checked | Leaves = CanCollide ❌ unchecked
- Bushes: CanCollide ❌ unchecked (walk through them)
- Rocks: CanCollide ✅ checked (can't walk through)
- Fences: CanCollide ✅ checked (blocks players)
### 12.3 Test Collision

Make sure players can walk through decorations:
- Trees: Trunk = CanCollide ✅ | Leaves = CanCollide ❌
- Bushes: CanCollide ❌
- Rocks: Usually CanC from Toolbox
3. Remove unnecessary details

**Enable Streaming (for large worlds):**
1. In **Explorer**, click **Workspace**
2. In **Properties**, scroll down
3. Find **StreamingEnabled**
4. Check the box: ✅ true
5. This loads only nearby objects, improving performance

**Optimize:**
- Use **Model** tab → **Union** to combine nearby parts
- DLook at the very top of Studio 
2. Find the **▶ Play** button (or press **F5**)
3. Click it to start testing
4. Use **WASD** to walk around your world!
5. Check:
   - ✅ Can see all objects?
   - ✅ Can walk on terrain?
   - ✅ Lights working at night?
   - ✅ No floating objects?
   - ✅ Houses accessible?
   - ✅ Water looks good?
6. Press **Shift+F5** (or click **Stop** ⬛ button) to exit test modent
Controls

| Action | How To Do It |
|--------|----------|
| Select Tool | Click "Select" in Home tab |
| Move Tool | Click "Move" in Home tab |
| Scale Tool | Click "Scale" in Home tab |
| Rotate Tool | Click "Rotate" in Home tab |
| Insert Part | Click "Part" in Home tab |
| Open Terrain | Click "Terrain" in Home tab |
| Open Toolbox | Click "Toolbox" in Home tab |
| Duplicate | Select object, press Ctrl+D |
| Group Parts | Select multiple, right-click → Group |
| Ungroup | Right-click group → Ungroup |
| Copy | Ctrl+C |
| Paste | Ctrl+V |
| Delete | Select object, press Delete |
| Undo | Ctrl+Z |
| Redo | Ctrl+Y |
| Play Test | Press F5 or click ▶ button |
| Stop Test | Press Shift+F5 or click ⬛ button
|--------|----------|
| Select Tool | Ctrl+1 |
| Move Tool | Ctrl+2 |
| Scale Tool | Ctrl+3 |
| Rotate Tool | Ctrl+4 |
| Duplicate | Ctrl+D |
| Group | Ctrl+G |
| Ungroup | Ctrl+U |
| Copy | Ctrl+C |
| Paste | Ctrl+V |
| Delete | Delete key |
| Undo | Ctrl+Z |
| Redo | Ctrl+Y |
| Play Test | F5 |
| Stop Test | Shift+F5 |

---

## 🎨 Color Palettes for Natural Environments

### Trees & Nature
- **Trunk Brown**: RGB(101, 67, 33)
- **Dark Green Leaves**: RGB(34, 139, 34)
- **Light Green**: RGB(144, 238, 144)
- **Bush Green**: RGB(46, 125, 50)

### Buildings
- **Tan Walls**: RGB(205, 133, 63)
- **Red Roof**: RGB(139, 69, 19)
- **Brown Door**: RGB(101, 67, 33)
- **Light Blue Window**: RGB(173, 216, 230)

### Roads & Infrastructure
- **Dark Grey Road**: RGB(60, 60, 60)
- **White Lines**: RGB(255, 255, 255)
- **Grey Pole**: RGB(70, 70, 70)
- **Light Grey Sidewalk**: RGB(180, 180, 180)

### Water & Sky
- **River Blue**: RGB(70, 130, 180)
- **Light Water**: RGB(100, 160, 200)
- **Sand**: RGB(238, 214, 175)

### Rocks & Ground
- **Grey Rock**: RGB(128, 128, 128)
- **Dark Rock**: RGB(80, 80, 80)
- **Brown Ground**: RGB(139, 90, 43)

---
1. Click **Plugins** tab at the top
2. Click **Plugin Management** or search in Toolbox
3. Search for helpful plugins:
   - **Archimedes**: Curve and bend parts
   - **Building Tools**: Advanced move/rotate
   - **Terrain Tools**: Better terrain editing

### Union & Negate
Combine parts for complex shapes:
1. Click **Select** tool (Home tab)
2. Select 2 or more parts (hold Ctrl and click each)
3. Go to **Model** tab (at the top)
4. Click **Union** (combine into one) or **Negate** (subtract one from another
### Union & Negate
Combine parts for complex shapes:
1. Select 2+ parts
2. **Home** → **Union** (combine) or **Negate** (cut)

### Materials Matter!
Experiment with:
- **Grass**: Vegetation
- **Slate**: Roofs, rocks
- **Brick**: Walls
- **Wood Planks**: Floors
- **Asphalt**: Roads
- **Concrete**: Buildings
- **Metal**: Modern structures

### Lighting is Everything!
- Warm lights (yellow) for houses
- Cool lights (white/blue) for street lights
- Blue lights underwater
- Orange lights for sunset atmosphere

---

## 📋 Environment Checklist

Before finishing, make sure you have:

### Terrain
- [ ] Base ground terrain created
- [ ] Hills and valleys sculpted
- [ ] Different materials painted (grass, sand, rock)
- [ ] Terrain edges smoothed

### Nature
- [ ] Trees placed (at least 10-20)
- [ ] Bushes scattered around
- [ ] Rocks placed naturally
- [ ] Variety in sizes and types

### Buildings
- [ ] Houses built (3-5 minimum)
- [ ] Buildings have doors and windows
- [ ] Roofs properly placed
- [ ] Buildings anchored

### Infrastructure
- [ ] Main road created
- [ ] Road markings added
- [ ] Sidewalks (optional)
- [ ] Roads connect important areas

### Water
- [ ] River or lake added
- [ ] Water looks natural
- [ ] Banks/shores defined

### Lighting
- [ ] Street lights placed
- [ ] Lights have PointLights
- [ ] Atmosphere configured
- [ ] Time of day set

### Details
- [ ] Fences around properties
- [ ] Decorations added
- [ ] Sound effects (optional)
- [ ] Particle effects (optional)

### Organization
- [ ] All objects in folders
- [ ] Everything anchored
- [ ] CanCollide properly set
- [ ] Workspace clean

### Testing
- [ ] Played test (F5)
- [ ] Can walk around
- [ ] No lag/performance issues
- [ ] Looks good!

---

## 🎉 Example World Layout

Here's a suggested layout for your game world:

```
     NORTH
       ↑
    [Forest]
    🌲🌲🌲
       |
   [Main Road]═══════[Houses]
       |            🏡🏡
    [River]
    ≈≈≈≈≈≈        [Your Game]
       |           [Play Area]
   [Park Area]     [Bases]
    🌳🪨🌳         [ShopLane]
       |
   [Buildings]
    🏢🏡
       ↓
     SOUTH
```

**Tips for Layout:**
- Put houses away from main gameplay area
- Roads should connect all zones
- River as natural boundary
- Trees in clusters (forests)
- Open space in center for gameplay

---

## 🆘 Common Problems & Solutions

### Problem: Objects Falling Through Terrain
**Solution:** 
- Select the object
- In **Properties** panel (right side), scroll down
- Find **Anchored** → Check the box ✅
- This makes objects stay in place!

### Problem: Can't Walk on Terrain
**Solution:**
- Terrain should work by default
- Make sure you generated terrain (Home → Terrain → Create → Generate)
- If using Parts as ground, make sure they're Anchored

### Problem: Too Laggy
**Solution:**
- Reduce number of objects in your world
- Use simpler models from Toolbox (search "low poly")
- In **Explorer**, click **Workspace** → In **Properties**, enable **StreamingEnabled**

### Problem: Objects Look Flat/Boring
**Solution:**
- In **Explorer**, click **Lighting**
- In **Properties**, make sure **GlobalShadows** = ✅ true
- Add Atmosphere effect (see Step 11)
- Vary object heights and sizes

### Problem: Water Not Showing
**Solution:**
- Make sure you used Terrain Editor to paint Water material
- Check Lighting → Brightness is not 0
- Water is semi-transparent - paint it deeper for better visibility

### Problem: Lights Not Working
**Solution:**
- Select the light → In **Properties** check **Brightness** > 0
- Set **Range** to 40 or higher
- Lights only show in dark - change **Lighting** → **ClockTime** to 0 (midnight)
- Make sure **Lighting.GlobalShadows** = true

### Problem: Can't See Far Away
**Solution:**
- In **Explorer**, click **Lighting**
- In **Properties**, find **FogEnd**
- Set it to a high number like **100000**

### Problem: Can't Find Toolbox
**Solution:**
- Look at **Home** tab (top of screen)
- Find **Toolbox** button on the right side of the toolbar
- Or go to **View** tab → Click **Toolbox**

### Problem: Properties/Explorer Panel Missing
**Solution:**
- Go to **View** tab at the top
- Click **Explorer** and **Properties** buttons
- They should appear on the right side

### Problem: Don't Know How to Insert Objects
**Solution:**
- For Parts: **Home** tab → Click **Part** button
- For Special Objects: In **Explorer**, right-click where you want it → **Insert Object** → Choose type
- For Free Models: **Home** tab → **Toolbox** → Search → Click to insert

---

## 🌟 Inspiration & Ideas

### Themed Environments

**Tropical Paradise:**
- Palm trees
- Sandy beaches
- Bright blue water
- Tiki torches
- Beach houses

**Medieval Village:**
- Stone buildings
- Cobblestone roads
- Torches instead of street lights
- Castles
- Market stalls

**Modern City:**
- Tall buildings
- Asphalt roads with markings
- Street lights everywhere
- Cars (static models)
- Skyscrapers

**Fantasy Forest:**
- Glowing mushrooms
- Magical trees (colorful)
- Floating islands
- Sparkle effects
- Bright colors

**Desert Oasis:**
- Sand terrain
- Cacti
- Small water pool
- Palm trees
- Rock formations

**Winter Wonderland:**
- Snow terrain material
- Pine trees
- Ice (glacier material)
- Snowmen
- Frozen lake

---

## 📚 Resources

### Where to Find Free Models
1. **Roblox Toolbox**
   - Click **Toolbox** button in Home tab
   - Search for what you need
   - Look at **Marketplace** tab for free models
   - Check creator reputation (hover over creator name)
   - Be careful with models that have scripts

2. **Roblox Library**
   - Built-in Roblox assets
   - 100% safe
   - Professional quality

3. **Creator Marketplace**
   - Some free items
   - High quality
   - Vetted by Roblox

### Learning More
- **Roblox Developer Hub**: create.roblox.com
- **YouTube Tutorials**: Search "Roblox building tutorial"
- **Roblox DevForum**: devforum.roblox.com

---

## 🎊 Final Tips for Amazing Environments

1. **Variety is Key!** 
   - Don't use same tree everywhere
   - Mix colors and materials
   - Different sizes create interest

2. **Think About Scale!**
   - Humans are about 5-6 studs tall
   - Doors should be 7-8 studs tall
   - House ceilings 10-12 studs

3. **Layer Your World!**
   - Background (mountains, sky)
   - Midground (buildings, trees)
   - Foreground (player area, details)

4. **Guide Players!**
   - Roads show where to go
   - Lights draw attention
   - Open paths = "go this way"

5. **Performance Balance!**
   - More objects = more lag
   - Find sweet spot
   - Test on different devices

6. **Tell a Story!**
   - Why is that house there?
   - What's in the forest?
   - Where does the road go?

7. **Iterate and Improve!**
   - Build, test, modify, repeat
   - Get feedback from friends
   - Keep refining

---

## 🎮 Ready to Build?

You now have EVERYTHING you need to create an amazing environment!

**Start Simple:**
1. Create base terrain (10 min)
2. AdHome tab** → Click **Terrain** → Create → Generate → Size 512 → Grass → Generate button
2. **Home tab** → Click **Toolbox** → Search "tree" → Click 5 different trees to insert
3. **Toolbox** → Search "house" → Click 2 houses to insert
4. **Home tab** → Click **Part** → In Properties: Size = 12, 0.5, 100 | Material = Asphalt | Anchored = ✅
5. **Press F5** (or click ▶) → Walk around your world!
6. **Press Shift+F5** to stop testing
**Total time:** About 45 minutes for a good start!

**Then Expand:**
- Add more details each day
- Test and refine
- Get creative!

---

**NOW GO BUILD AN AMAZING WORLD!** 🌍✨🎮

---

## 💡 Quick Start Summary

### The 5-Minute Environment:
1. **Terrain Editor** → Generate → Size 512 → Material: Grass
2. **Toolbox** → Search "tree" → Insert 5 trees
3. **Toolbox** → Search "house" → Insert 2 houses  
4. **Insert Part** → Size 12×0.5×100 → Material: Asphalt → Anchored
5. **Press F5** → You have a world!

### Then Keep Adding:
- More trees and bushes
- Build custom buildings
- Add water features
- Place street lights
- Scatter decorations
- Configure lighting
- Add sounds
- Test and refine!

---

**Made with ❤️ for creative world builders! Keep building! 🌳🏡✨**
