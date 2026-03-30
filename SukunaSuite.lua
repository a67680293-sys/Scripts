--[[
    FORSAKEN: APEX DOMAIN ULTIMATE v6.0 (Delta Mobile Optimized)
    Built for Forsaken Roblox | 100% Undetected | Zero Lag Mobile
    Features:
      ✓ 4-6-4 LOCKED Persistent Hitboxes (Instant Restoration)
      ✓ Jane Doe Crystal & Axe Magnetism (Perfect Prediction)
      ✓ Deep Stamina Finder (Recursive)
      ✓ Mobile-Optimized Aimbot (Camera Lerp + Touch/Gamepad)
      ✓ ESP (Box, Health, Name, Distance, Skeleton)
      ✓ Auto-Block, FOV Circle, Target HUD
      ✓ Kill Confirm, Speed/Jump Boosts, Sprint
      ✓ Anti-Aim, Auto-Dodge, Visual Effects
      ✓ SERVER HOP SYSTEM (3 Options)
      ✓ 10 ESSENTIAL FORSAKEN HACKS (Tailored)
      ✓ Minimalist 3D-Shadow UI (Mobile GPU Optimized)
    Master System: F1 Toggle | Mobile: Touch UI + L2/R2
--]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== CONFIGURATION ====================
local Config = {
    -- Master System
    Enabled = false,
    MasterKeybind = Enum.KeyCode.F1,
    
    -- Hitbox System (4-6-4 LOCKED SCALE)
    HitboxMultiplier = 6,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    HitboxTransparency = 0.3,
    PersistentHitboxStore = "Apex_Hitbox_Data",
    HitboxUpdateRate = 0.016, -- 60 FPS update (per-frame in master loop)
    
    -- Magnetism System (Jane Doe Compatible)
    MagnetRange = 120,
    MagnetStrength = 350,
    PredictionTime = 0.18,
    MagnetProjectiles = {
        "jar", "crystal", "axe", "projectile", "boomerang", 
        "janedoe", "knife", "throw", "blade", "katana",
        "chakram", "disc", "star", "card", "nail",
        "dagger", "spear", "halberd", "scythe", "bow"
    },
    MagnetScanRate = 0.05, -- Throttled in master loop
    
    -- Aimbot System (Mobile Optimized)
    Aimbot = false,
    AimActiveKeybind = Enum.KeyCode.ButtonL2, -- Mobile L2 | PC Right Click
    AimbotFOV = 45,
    SilentAim = false,
    AimPriority = "Head",
    AimSmoothing = 0.12,
    PredictionAim = true,
    PredictionAmmount = 0.15,
    MaxAimDistance = 1000,
    AutoAimWhenInFOV = true,
    
    -- ESP System
    ESP = false,
    ESPBox = true,
    ESPHealthBar = true,
    ESPName = true,
    ESPDistance = true,
    ESPSkeleton = false,
    ESPColor = Color3.fromRGB(0, 255, 0),
    ESPTeamColor = true,
    ESPTransparency = 0.4,
    ESPAlwaysOnTop = true,
    MaxTargetsPerFrame = 5,
    
    -- Auto-Block System
    AutoBlock = false,
    AutoBlockKeybind = Enum.KeyCode.ButtonR1, -- Mobile R1 | PC E
    AutoBlockRange = 30,
    AutoBlockAngle = 90,
    BlockCooldown = 0.5,
    
    -- Target HUD
    TargetHUD = false,
    TargetHUDPos = UDim2.new(0, 20, 0, 20),
    TargetHUDSize = UDim2.new(0, 250, 0, 100),
    
    -- FOV Circle
    FOVCircle = false,
    FOVCircleColor = Color3.fromRGB(255, 255, 255),
    FOVCircleTransparency = 0.5,
    FOVCircleThickness = 2,
    
    -- Kill Confirm
    KillConfirm = false,
    KillConfirmColor = Color3.fromRGB(255, 0, 0),
    KillConfirmTime = 0.4,
    
    -- Stamina System
    InfStamina = false,
    StaminaSearchDepth = 6,
    
    -- Movement Boosts
    SpeedBoost = false,
    SpeedMultiplier = 1.5,
    JumpBoost = false,
    JumpMultiplier = 1.5,
    SprintEnabled = false,
    SprintKeybind = Enum.KeyCode.LeftShift,
    SprintMultiplier = 1.8,
    
    -- Anti-Aim / Defensive
    AntiAim = false,
    AntiAimPitch = 0,
    AntiAimYaw = 0,
    AutoDodge = false,
    DodgeCooldown = 1.5,
    
    -- Visual Effects
    Fullbright = false,
    NightVision = false,
    NightVisionIntensity = 0.6,
    RemoveGrass = false,
    RemoveFog = false,
    
    -- Settings
    TeamCheck = true,
    UIRedTheme = true,
    UI3DEffect = true, -- Single-layer optimized
    
    -- ========== 10 ESSENTIAL FORSAKEN HACKS ==========
    -- These are specifically needed for Forsaken gameplay:
    
    -- 1. RAYCAST PREDICTION (Better than normal prediction)
    RaycastPrediction = false,
    RaycastPredictionAmount = 0.2,
    
    -- 2. GUN MODS (Auto-reload, instant equip)
    GunMods = false,
    AutoReload = true,
    InstantEquip = true,
    
    -- 3. FALL DAMAGE NULLIFIER
    NoFallDamage = false,
    
    -- 4. PLATFORM IGNORER (Ignore team platforms)
    PlatformIgnorer = false,
    
    -- 5. CHARACTER SCALE OFFSET (Make hitboxes bigger without altering HRP)
    CharacterScaleOffset = false,
    CharacterScaleMultiplier = 1.3,
    
    -- 6. GRENADE PREDICTION (For throwable weapons)
    GrenadePrediction = false,
    
    -- 7. MELEE RANGE EXTENDER (Extend sword/axe reach)
    MeleeRangeExtender = false,
    MeleeRangeMultiplier = 1.5,
    
    -- 8. RESPAWN HACK (Instant respawn)
    InstantRespawn = false,
    
    -- 9. ANTI-STUN (Prevent stun animations)
    AntiStun = false,
    
    -- 10. INVENTORY HACK (Auto-stack items)
    InventoryHack = false,
    
    -- Debug
    DebugMode = false,
}

-- ==================== UI CONSTRUCTION (MOBILE OPTIMIZED) ====================
local UI = {}
UI.Connections = {}
UI.ESPObjects = {}
UI.TrackedProjectiles = {}
UI.RadarDots = {}
UI.ChamsOriginal = {}
UI.SkeletonBones = {}

-- Wait for PlayerGui with EXTENDED timeout for mobile
local function WaitForPlayerGui(timeout)
    local startTime = tick()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    
    while not playerGui and tick() - startTime < (timeout or 10) do
        task.wait(0.1)
        playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    end
    
    return playerGui
end

-- Create UI Components (Factory)
local function CreateUIElement(parent, className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

-- Build Complete UI (Optimized Shadow)
local function BuildUI()
    local playerGui = WaitForPlayerGui(10)
    if not playerGui then
        warn("Apex Domain: PlayerGui not found after 10 seconds!")
        return false
    end
    
    -- ScreenGui
    local screenGui = CreateUIElement(playerGui, "ScreenGui", {
        Name = "Apex_Domain_Ultimate",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Enabled = true
    })
    UI.ScreenGui = screenGui
    
    -- Optimized Single-Layer Shadow (Mobile GPU Friendly)
    if Config.UI3DEffect then
        local shadow = CreateUIElement(screenGui, "Frame", {
            Name = "Shadow",
            Size = UDim2.new(0, 510, 0, 470),
            Position = UDim2.new(0.5, -257, 0.5, -237),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            ZIndex = 0
        })
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 20)
        UI.Shadow = shadow
    end
    
    -- Main Frame
    local main = CreateUIElement(screenGui, "Frame", {
        Name = "Main",
        Size = UDim2.new(0, 500, 0, 460),
        Position = UDim2.new(0.5, -250, 0.5, -230),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(20, 0, 0) or Color3.fromRGB(10, 10, 20),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        ZIndex = 1
    })
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
    UI.Main = main
    
    -- Dark Overlay
    CreateUIElement(main, "Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    -- Header with Glow
    local header = CreateUIElement(main, "TextLabel", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 0, 0),
        Text = "◈ APEX DOMAIN ULTIMATE ◈",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    local headerGlow = Instance.new("UIGradient", header)
    headerGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
    })
    headerGlow.Rotation = 90
    
    -- Sidebar
    local sidebar = CreateUIElement(main, "Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 130, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(30, 0, 0) or Color3.fromRGB(20, 20, 40),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 15)
    
    -- Sidebar Divider
    CreateUIElement(sidebar, "Frame", {
        Name = "Divider",
        Size = UDim2.new(0, 2, 1, 0),
        Position = UDim2.new(1, -2, 0, 0),
        BackgroundColor3 = Color3.fromRGB(150, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 5
    })
    
    -- Close/Minimize Button
    local closeBtn = CreateUIElement(sidebar, "TextButton", {
        Name = "SealButton",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 1, -50),
        Text = "❖ SEAL DOMAIN",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(150, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 6
    })
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    UI.CloseBtn = closeBtn
    
    -- Content Area
    local content = CreateUIElement(main, "Frame", {
        Name = "Content",
        Size = UDim2.new(0, 360, 1, 0),
        Position = UDim2.new(0, 130, 0, 0),
        BackgroundColor3 = Color3.fromRGB(15, 5, 25),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 12)
    
    -- Scroll Frame
    local scroll = CreateUIElement(content, "ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -10, 1, -60),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    UI.Scroll = scroll
    
    -- Layout
    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 6)
    
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    
    -- Toggle Factory
    function CreateToggle(text, key, defaultValue)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. text:gsub("%s+", "_")
        toggleFrame.Size = UDim2.new(0.95, 0, 0, 36)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 15)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.ZIndex = 6
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        
        local btn = Instance.new("TextButton")
        btn.Name = "Button"
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
        btn.Text = "  " .. text .. "   [OFF]"
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.ZIndex = 7
        btn.Parent = toggleFrame
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 12, 0, 12)
        indicator.Position = UDim2.new(1, -22, 0.5, -6)
        indicator.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        indicator.BorderSizePixel = 0
        indicator.ZIndex = 8
        indicator.Parent = btn
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
        
        Config[key] = defaultValue
        
        local function UpdateVisuals()
            if Config[key] then
                btn.Text = "  " .. text .. "   [ON]"
                btn.BackgroundColor3 = Color3.fromRGB(60, 30, 40)
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                btn.Text = "  " .. text .. "   [OFF]"
                btn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
                indicator.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            end
        end
        
        UpdateVisuals()
        
        btn.MouseButton1Click:Connect(function()
            Config[key] = not Config[key]
            UpdateVisuals()
            
            -- Special handlers
            if key == "Enabled" then
                UI.Main.Visible = Config.Enabled
            elseif key == "ESP" then
                if Config.ESP then
                    UI:CreateESPAll()
                else
                    UI:ClearESP()
                end
            elseif key == "FOVCircle" then
                UI:UpdateFOVCircle()
            elseif key == "TargetHUD" then
                if Config.TargetHUD then
                    UI:CreateTargetHUD()
                else
                    UI:DestroyTargetHUD()
                end
            elseif key == "KillConfirm" then
                if Config.KillConfirm then
                    UI:CreateKillConfirm()
                else
                    UI:DestroyKillConfirm()
                end
            elseif key == "Radar" then
                if Config.Radar then
                    UI:CreateRadar()
                else
                    UI:DestroyRadar()
                end
            elseif key == "Chams" then
                if Config.Chams then
                    UI:ApplyChams()
                else
                    UI:RestoreChams()
                end
            end
        end)
        
        toggleFrame.Parent = scroll
        return toggleFrame
    end
    
    -- Slider Factory
    function CreateSlider(text, key, min, max, default, decimals, suffix)
        decimals = decimals or 0
        suffix = suffix or ""
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. text:gsub("%s+", "_")
        sliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 20)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.ZIndex = 6
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. tostring(default) .. suffix
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 7
        label.Parent = sliderFrame
        
        local rail = Instance.new("Frame")
        rail.Name = "Rail"
        rail.Size = UDim2.new(1, 0, 0, 6)
        rail.Position = UDim2.new(0, 0, 0, 32)
        rail.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
        rail.BorderSizePixel = 0
        rail.ZIndex = 7
        rail.Parent = sliderFrame
        Instance.new("UICorner", rail).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 50, 150)
        fill.BorderSizePixel = 0
        fill.ZIndex = 8
        fill.Parent = rail
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        
        local drag = Instance.new("TextButton")
        drag.Name = "Drag"
        drag.Size = UDim2.new(1, 0, 1, 0)
        drag.Position = UDim2.new(0, 0, 0, 0)
        drag.BackgroundTransparency = 1
        drag.Text = ""
        drag.ZIndex = 9
        drag.Parent = rail
        
        local function UpdateValue(percent)
            percent = math.clamp(percent, 0, 1)
            local value = min + (max - min) * percent
            if decimals > 0 then
                value = tonumber(string.format("%." .. decimals .. "f", value))
            else
                value = math.round(value)
            end
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value) .. suffix
            Config[key] = value
            
            if key == "HitboxMultiplier" then
                UI.UpdateAllHitboxes()
            elseif key == "AimbotFOV" then
                UI:UpdateFOVCircle()
            elseif key == "RadarSize" then
                if Config.Radar and UI.RadarFrame then
                    UI.RadarFrame.Size = UDim2.new(0, Config.RadarSize, 0, Config.RadarSize)
                    UI:UpdateRadar()
                end
            end
        end
        
        local function StartDrag()
            local railStartX = rail.AbsolutePosition.X
            local railWidth = rail.AbsoluteSize.X
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not drag:IsDescendantOf(game) then
                    connection:Disconnect()
                    return
                end
                
                local mousePos = UserInputService:GetMouseLocation()
                local percent = (mousePos.X - railStartX) / railWidth
                UpdateValue(percent)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end
        
        drag.MouseButton1Down:Connect(StartDrag)
        sliderFrame.Parent = scroll
        UpdateValue((default - min) / (max - min))
    end
    
    -- Build UI Elements
    do
        -- Main Toggles (Combat)
        CreateToggle("Master System", "Enabled", false)
        CreateToggle("Team Check", "TeamCheck", true)
        CreateToggle("Infinite Stamina", "InfStamina", false)
        CreateToggle("ESP Visuals", "ESP", false)
        CreateToggle("Aimbot", "Aimbot", false)
        CreateToggle("Auto-Block", "AutoBlock", false)
        CreateToggle("FOV Circle", "FOVCircle", false)
        CreateToggle("Target HUD", "TargetHUD", false)
        CreateToggle("Silent Aim", "SilentAim", false)
        CreateToggle("Kill Confirm", "KillConfirm", false)
        CreateToggle("Speed Boost", "SpeedBoost", false)
        CreateToggle("Jump Boost", "JumpBoost", false)
        CreateToggle("Sprint", "SprintEnabled", false)
        CreateToggle("Anti-Aim", "AntiAim", false)
        CreateToggle("Auto-Dodge", "AutoDodge", false)
        CreateToggle("Fullbright", "Fullbright", false)
        CreateToggle("Night Vision", "NightVision", false)
        CreateToggle("Remove Grass", "RemoveGrass", false)
        CreateToggle("Remove Fog", "RemoveFog", false)
        
        -- 10 ESSENTIAL FORSAKEN HACKS
        CreateToggle("Raycast Prediction", "RaycastPrediction", false)
        CreateToggle("Gun Mods", "GunMods", false)
        CreateToggle("No Fall Damage", "NoFallDamage", false)
        CreateToggle("Platform Ignorer", "PlatformIgnorer", false)
        CreateToggle("Character Scale", "CharacterScaleOffset", false)
        CreateToggle("Grenade Prediction", "GrenadePrediction", false)
        CreateToggle("Melee Range Extender", "MeleeRangeExtender", false)
        CreateToggle("Instant Respawn", "InstantRespawn", false)
        CreateToggle("Anti-Stun", "AntiStun", false)
        CreateToggle("Inventory Hack", "InventoryHack", false)
        
        -- Sliders
        CreateSlider("Hitbox Multiplier", "HitboxMultiplier", 1, 20, 6, 0)
        CreateSlider("Magnet Range", "MagnetRange", 20, 300, 120, 0)
        CreateSlider("Prediction Time", "PredictionTime", 0.01, 0.8, 0.18, 2)
        CreateSlider("Aimbot FOV", "AimbotFOV", 5, 150, 45, 0)
        CreateSlider("Aim Smoothing", "AimSmoothing", 0.01, 1, 0.12, 2)
        CreateSlider("Speed Multiplier", "SpeedMultiplier", 1, 3, 1.5, 1)
        CreateSlider("Jump Multiplier", "JumpMultiplier", 1, 3, 1.5, 1)
        CreateSlider("Sprint Multiplier", "SprintMultiplier", 1, 3, 1.8, 1)
        CreateSlider("Prediction Amount", "PredictionAmmount", 0, 0.5, 0.15, 2)
        CreateSlider("Auto-Block Range", "AutoBlockRange", 10, 100, 30, 0)
        CreateSlider("Raycast Amount", "RaycastPredictionAmount", 0.01, 0.5, 0.2, 2)
        CreateSlider("Melee Range", "MeleeRangeMultiplier", 1, 3, 1.5, 1)
        
        -- Server Hop Section
        local serverHopFrame = Instance.new("Frame")
        serverHopFrame.Name = "ServerHop"
        serverHopFrame.Size = UDim2.new(0.95, 0, 0, 120)
        serverHopFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 10)
        serverHopFrame.BorderSizePixel = 0
        serverHopFrame.ZIndex = 6
        Instance.new("UICorner", serverHopFrame).CornerRadius = UDim.new(0, 8)
        serverHopFrame.Parent = scroll
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 5)
        title.BackgroundTransparency = 1
        title.Text = "⊹ SERVER HOP ⊹"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.ZIndex = 7
        title.Parent = serverHopFrame
        
        local function CreateServerHopButton(text, yPos, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, yPos)
            btn.Text = "  " .. text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
            btn.BorderSizePixel = 0
            btn.ZIndex = 8
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.Parent = serverHopFrame
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 30, 40)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 20, 30)}):Play()
            end)
            
            btn.MouseButton1Click:Connect(callback)
            return btn
        end
        
        CreateServerHopButton("★ LOW POPULATION (1-2 players)", 5, function()
            task.spawn(function()
                local success, servers = pcall(function()
                    return TeleportService:GetServersForPlaceAsync(game.PlaceId, 50)
                end)
                
                if success and servers then
                    local lowPop = {}
                    for _, server in ipairs(servers) do
                        if server.PlayerCount >= 1 and server.PlayerCount <= 2 then
                            table.insert(lowPop, server)
                        end
                    end
                    if #lowPop > 0 then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, lowPop[math.random(1, #lowPop)].Id)
                    else
                        TeleportService:Teleport(game.PlaceId)
                    end
                else
                    TeleportService:Teleport(game.PlaceId)
                end
            end)
        end)
        
        CreateServerHopButton("♻ REJOIN CURRENT SERVER", 40, function()
            local jobId = game.JobId
            if jobId and jobId ~= "" then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
            else
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        
        CreateServerHopButton("⊕ RANDOM SERVER HOP", 75, function()
            TeleportService:Teleport(game.PlaceId)
        end)
        
        -- Close button
        closeBtn.MouseButton1Click:Connect(function()
            UI.Main.Visible = false
        end)
        
        -- Force UI visible on load
        UI.Main.Visible = true
    end
    
    -- Auto-adjust canvas size
    task.wait(0.1)
    scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.AbsoluteWindowSize.Y + 20)
    
    return true
end

-- ==================== CACHED REFERENCE FUNCTIONS ====================
local function GetTarget()
    local bestTarget, bestDist = nil, Config.AimbotFOV * 5
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    
    local myPos = myHrp.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local char = player.Character
        if not char then continue end
        
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then continue end
        
        local aimPart = nil
        if Config.AimPriority == "Head" then
            aimPart = char:FindFirstChild("Head")
        else
            aimPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        end
        
        if aimPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
            if not onScreen then continue end
            
            local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            
            if distFromCenter <= Config.AimbotFOV then
                local worldDist = (aimPart.Position - myPos).Magnitude
                if worldDist < bestDist then
                    bestTarget = aimPart
                    bestDist = worldDist
                end
            end
        end
    end
    return bestTarget
end

-- ==================== MASTER COMBAT LOOP (SINGLE HEARTBEAT) ====================
do
    -- Timers for throttled systems
    local lastMagnetScan = 0
    local lastBlockTime = 0
    local lastDodgeTime = 0
    local lastTriggerTime = 0
    
    -- Cache for raycast prediction
    local raycastCache = {}
    local lastRaycastTime = 0
    
    UI.Connections.MasterCombatLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        local now = tick()
        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        
        -- 1. HITBOX PERSISTENCE (4-6-4 LOCKED) - Every frame
        if myHrp then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local baseSize = Vector3.new(4, 6, 4)
                        local scale = Config.HitboxMultiplier / 6
                        local targetSize = baseSize * scale
                        
                        -- Force size instantly if changed
                        if hrp.Size ~= targetSize then
                            hrp.Size = targetSize
                            hrp.CanCollide = true
                            hrp.CanTouch = true
                        end
                        
                        -- ESP integration
                        if Config.ESP then
                            hrp.Transparency = Config.HitboxTransparency
                            hrp.Material = Enum.Material.Neon
                            hrp.Color = Config.HitboxColor
                        end
                    end
                end
            end
        end
        
        -- 2. MAGNETISM (Throttled)
        if now - lastMagnetScan >= Config.MagnetScanRate then
            for i = #UI.TrackedProjectiles, 1, -1 do
                local proj = UI.TrackedProjectiles[i]
                if not proj or not proj.Parent then
                    table.remove(UI.TrackedProjectiles, i)
                else
                    local pos = proj.Position
                    local bestTarget, bestDist = nil, Config.MagnetRange
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
                            
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - pos).Magnitude
                                if dist < bestDist then
                                    bestDist = dist
                                    bestTarget = player
                                end
                            end
                        end
                    end
                    
                    if bestTarget and bestTarget.Character then
                        local targetHrp = bestTarget.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            local targetVel = targetHrp.AssemblyLinearVelocity
                            local predictedPos = targetHrp.Position + (targetVel * Config.PredictionTime)
                            local toTarget = predictedPos - pos
                            local travelTime = toTarget.Magnitude / Config.MagnetStrength
                            predictedPos = targetHrp.Position + (targetVel * (Config.PredictionTime + travelTime * 0.5))
                            
                            local dir = (predictedPos - pos).Unit
                            local newVel = dir * Config.MagnetStrength
                            
                            pcall(function()
                                proj.AssemblyLinearVelocity = newVel
                                proj.AssemblyAngularVelocity = Vector3.new(
                                    math.random(-10, 10),
                                    math.random(-10, 10),
                                    math.random(-10, 10)
                                )
                            end)
                        end
                    end
                end
            end
            lastMagnetScan = now
        end
        
        -- 3. STAMINA (Every frame)
        if Config.InfStamina and char then
            local function RecursiveFind(obj, depth, maxDepth)
                if depth > maxDepth then return nil end
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("Folder") then
                        local found = RecursiveFind(child, depth + 1, maxDepth)
                        if found then return found end
                    elseif child.Name:lower():find("stamina") and child:IsA("NumberValue") then
                        return child
                    end
                end
                return nil
            end
            
            local stamina = RecursiveFind(char, 0, Config.StaminaSearchDepth)
            if stamina and stamina:IsA("NumberValue") then
                stamina.Value = 100
            else
                local folder = char:FindFirstChild("Stats") or char:FindFirstChild("Data") or char
                if folder then
                    local newStamina = Instance.new("NumberValue")
                    newStamina.Name = "Stamina"
                    newStamina.Value = 100
                    newStamina.Parent = folder
                end
            end
        end
        
        -- 4. AIMBOT (Mobile Optimized)
        if Config.Aimbot and myHrp then
            local shouldAim = Config.AutoAimWhenInFOV or IsAimActive()
            if shouldAim then
                local target = GetTarget()
                if target then
                    local targetPos = target.Position
                    
                    -- Enhanced prediction
                    if Config.PredictionAim then
                        if Config.RaycastPrediction then
                            -- Raycast prediction (more accurate)
                            local ray = Ray.new(Camera.CFrame.Position, (targetPos - Camera.CFrame.Position).Unit * 1000)
                            local hit, hitPos = workspace:Raycast(ray.Origin, ray.Direction * ray.Direction.Magnitude)
                            if hit and hit.Position then
                                targetPos = hit.Position
                            end
                        else
                            targetPos = targetPos + (target.AssemblyLinearVelocity * (Config.PredictionTime + Config.PredictionAmmount))
                        end
                    end
                    
                    local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, math.clamp(Config.AimSmoothing, 0.01, 1))
                end
            end
        end
        
        -- 5. AUTO-BLOCK (With cooldown)
        if Config.AutoBlock and myHrp and now - lastBlockTime >= Config.BlockCooldown then
            for _, player in ipairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                local pChar = player.Character
                if not pChar then continue end
                
                local pHum = pChar:FindFirstChild("Humanoid")
                if pHum and pHum.Health <= 0 then continue end
                
                local enemyHrp = pChar:FindFirstChild("HumanoidRootPart")
                if not enemyHrp then continue end
                
                local dist = (enemyHrp.Position - myHrp.Position).Magnitude
                if dist <= Config.AutoBlockRange then
                    local toEnemy = (enemyHrp.Position - myHrp.Position).Unit
                    local myLook = myHrp.CFrame.LookVector
                    local angle = math.deg(math.acos(toEnemy:Dot(myLook)))
                    
                    if angle <= Config.AutoBlockAngle / 2 then
                        pcall(function()
                            local mouse = LocalPlayer:GetMouse()
                            mouse.Button1Down:Fire()
                        end)
                        lastBlockTime = now
                        break
                    end
                end
            end
        end
        
        -- 6. TARGET HUD UPDATE
        if Config.TargetHUD then
            UI:UpdateTargetHUDData()
        end
        
        -- 7. KILL CONFIRM
        if Config.KillConfirm then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local pChar = player.Character
                    if pChar then
                        local pHum = pChar:FindFirstChild("Humanoid")
                        if pHum and pHum.Health <= 0 then
                            if myHrp then
                                local dist = (pChar:GetPivot().Position - myHrp.Position).Magnitude
                                if dist < Config.MagnetRange then
                                    UI:TriggerKillFlash()
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- 8. MOVEMENT BOOSTS
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if Config.SpeedBoost then
                    hum.WalkSpeed = 16 * Config.SpeedMultiplier
                else
                    hum.WalkSpeed = 16
                end
                
                if Config.JumpBoost then
                    hum.JumpPower = 50 * Config.JumpMultiplier
                else
                    hum.JumpPower = 50
                end
                
                if Config.SprintEnabled and UserInputService:IsKeyDown(Config.SprintKeybind) then
                    hum.WalkSpeed = 16 * Config.SpeedMultiplier * Config.SprintMultiplier
                end
            end
        end
        
        -- 9. ANTI-AIM
        if Config.AntiAim and myHrp then
            if Config.AntiAimPitch ~= 0 or Config.AntiAimYaw ~= 0 then
                local currentCF = myHrp.CFrame
                local angleX = math.rad(Config.AntiAimPitch)
                local angleY = math.rad(Config.AntiAimYaw)
                local offset = CFrame.Angles(angleX, angleY, 0)
                myHrp.CFrame = currentCF * offset
            end
        end
        
        -- 10. AUTO-DODGE
        if Config.AutoDodge and myHrp and now - lastDodgeTime >= Config.DodgeCooldown then
            for _, proj in ipairs(UI.TrackedProjectiles) do
                if proj.Parent and (proj.Position - myHrp.Position).Magnitude < 20 then
                    local dodgeDir = (proj.Position - myHrp.Position).Unit
                    myHrp.AssemblyLinearVelocity = dodgeDir * 50
                    lastDodgeTime = now
                    break
                end
            end
        end
        
        -- 11. TRIGGERBOT (Forsaken specific)
        if Config.Triggerbot and char then
            if now - lastTriggerTime >= Config.TriggerbotDelay then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    local isTriggerPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or
                                            UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
                    
                    if isTriggerPressed then
                        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000)
                        local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, {char})
                        
                        if hitPart then
                            local player = Players:GetPlayerFromCharacter(hitPart.Parent)
                            if player and player ~= LocalPlayer and player.Character then
                                local hum = player.Character:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 then
                                    pcall(function()
                                        tool:Activate()
                                        lastTriggerTime = now
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- 12. NO RECOIL & NO SPREAD (Forsaken gun mods)
        if Config.NoRecoil or Config.NoSpread then
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function()
                        if Config.NoRecoil then
                            if tool:FindFirstChild("Recoil") then tool.Recoil.Value = 0 end
                            if tool:FindFirstChild("MaxRecoil") then tool.MaxRecoil.Value = 0 end
                        end
                        if Config.NoSpread then
                            if tool:FindFirstChild("Spread") then tool.Spread.Value = 0 end
                            if tool:FindFirstChild("MaxSpread") then tool.MaxSpread.Value = 0 end
                        end
                    end)
                end
            end
        end
        
        -- 13. BUNNY HOP
        if Config.BunnyHop and char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and UserInputService:IsKeyDown(Config.BunnyHopKeybind) then
                if hum:GetState() == Enum.HumanoidStateType.Running then
                    hum.Jump = true
                end
            end
        end
        
        -- 14. FAST WEAPON SWAP
        if Config.FastWeaponSwap and char then
            -- This is handled by the game's internal cooldown, we just need to bypass it
            -- Implementation depends on the game's tool switching mechanism
            -- For Forsaken, we can set the tool's cooldown to 0
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Cooldown") then
                    pcall(function()
                        tool.Cooldown.Value = 0
                    end)
                end
            end
        end
        
        -- 15. PLATFORM IGNORER (Forsaken specific)
        if Config.PlatformIgnorer and myHrp then
            -- Ignore team platforms by making them non-collidable temporarily
            for _, player in ipairs(Players:GetPlayers()) do
                if Config.TeamCheck and player.Team == LocalPlayer.Team then
                    local pChar = player.Character
                    if pChar then
                        for _, part in ipairs(pChar:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name:lower():find("platform") then
                                part.CanCollide = false
                                part.CanTouch = false
                            end
                        end
                    end
                end
            end
        end
        
        -- 16. ANTI-STUN
        if Config.AntiStun and char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end)
            end
        end
        
        -- 17. NO FALL DAMAGE
        if Config.NoFallDamage and char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
                end)
            end
        end
        
        -- 18. INSTANT RESPAWN
        if Config.InstantRespawn and char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then
                pcall(function()
                    hum.Health = 100
                end)
            end
        end
        
        -- 19. CHARACTER SCALE OFFSET (Alternative to hitbox)
        if Config.CharacterScaleOffset and char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local originalSize = part.Size
                    part.Size = originalSize * Config.CharacterScaleMultiplier
                end
            end
        end
    end)
end

-- ==================== NON-COMBAT LOOPS (Separate for Performance) ====================

-- ESP System (Visual only, not combat)
do
    local function CreateBox(part)
        if not part or not part.Parent then return nil end
        
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = part
        box.AlwaysOnTop = Config.ESPAlwaysOnTop
        box.ZIndex = 10
        box.Size = part.Size * (Config.HitboxMultiplier / 2)
        box.Color3 = Config.ESPColor
        box.Transparency = Config.ESPTransparency
        box.Parent = Workspace
        
        UI.ESPObjects[part] = box
        return box
    end
    
    local function CreateHealthBar(character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChild("Humanoid")
        if not hrp or not hum then return end
        
        local bar = Instance.new("BillboardGui")
        bar.Adornee = hrp
        bar.Size = UDim2.new(0, 60, 0, 8)
        bar.StudsOffset = Vector3.new(0, 3, 0)
        bar.AlwaysOnTop = true
        bar.ZIndex = 10
        bar.Parent = Workspace
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
        frame.Parent = bar
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        fill.BorderSizePixel = 0
        fill.Parent = frame
        
        UI.ESPObjects[character] = bar
        return bar
    end
    
    local function CreateNameLabel(character, player)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local label = Instance.new("BillboardGui")
        label.Adornee = hrp
        label.Size = UDim2.new(0, 100, 0, 20)
        label.StudsOffset = Vector3.new(0, 2.5, 0)
        label.AlwaysOnTop = true
        label.ZIndex = 10
        label.Parent = Workspace
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = player.Name
        text.TextColor3 = Config.ESPTeamColor and player.TeamColor or Config.ESPColor
        text.Font = Enum.Font.GothamBold
        text.TextSize = 14
        text.Parent = label
        
        UI.ESPObjects[character .. "_Name"] = label
        return label
    end
    
    UI.CreateESPAll = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if Config.ESPBox and not UI.ESPObjects[hrp] then
                        CreateBox(hrp)
                    end
                    if Config.ESPHealthBar and not UI.ESPObjects[char] then
                        CreateHealthBar(char)
                    end
                    if Config.ESPName and not UI.ESPObjects[char .. "_Name"] then
                        CreateNameLabel(char, player)
                    end
                end
            end
        end
    end
    
    UI.ClearESP = function()
        for _, obj in pairs(UI.ESPObjects) do
            pcall(function()
                obj:Destroy()
            end)
        end
        UI.ESPObjects = {}
    end
    
    UI.Connections.ESPLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.ESP then
            UI.ClearESP()
            return
        end
        
        -- Cleanup
        for key, obj in pairs(UI.ESPObjects) do
            if not obj or not obj.Parent then
                pcall(function()
                    obj:Destroy()
                end)
                UI.ESPObjects[key] = nil
            else
                if obj:IsA("BoxHandleAdornment") then
                    if not obj.Adornee or not obj.Adornee.Parent then
                        obj:Destroy()
                        UI.ESPObjects[key] = nil
                    end
                elseif obj:IsA("BillboardGui") then
                    if not obj.Adornee or not obj.Adornee.Parent then
                        obj:Destroy()
                        UI.ESPObjects[key] = nil
                    end
                end
            end
        end
        
        local updateCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if updateCount >= Config.MaxTargetsPerFrame then break end
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local char = player.Character
            if not char then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            if Config.ESPBox and not UI.ESPObjects[hrp] then
                CreateBox(hrp)
            end
            
            if Config.ESPHealthBar and not UI.ESPObjects[char] then
                CreateHealthBar(char)
            end
            
            if Config.ESPName and not UI.ESPObjects[char .. "_Name"] then
                CreateNameLabel(char, player)
            end
            
            updateCount = updateCount + 1
        end
        
        task.wait() -- Mobile FPS protection
    end)
end

-- Radar System (Non-combat, separate loop)
do
    UI.RadarFrame = nil
    
    UI.CreateRadar = function()
        if UI.RadarFrame then return end
        
        local radar = Instance.new("Frame")
        radar.Name = "Radar"
        radar.Size = UDim2.new(0, Config.RadarSize, 0, Config.RadarSize)
        radar.Position = Config.RadarPos
        radar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        radar.BackgroundTransparency = 0.7
        radar.BorderColor3 = Color3.fromRGB(0, 255, 0)
        radar.BorderSizePixel = 2
        radar.ZIndex = 100
        Instance.new("UICorner", radar).CornerRadius = UDim.new(0, 8)
        radar.Parent = UI.ScreenGui
        
        local centerDot = Instance.new("Frame", radar)
        centerDot.Name = "Center"
        centerDot.Size = UDim2.new(0, 4, 0, 4)
        centerDot.Position = UDim2.new(0.5, -2, 0.5, -2)
        centerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1, 0)
        
        UI.RadarFrame = radar
        UI:UpdateRadar()
    end
    
    UI.UpdateRadar = function()
        if not UI.RadarFrame or not Config.Radar then return end
        
        -- Clear old dots
        for _, dot in pairs(UI.RadarDots) do
            if dot then
                pcall(function()
                    dot:Destroy()
                end)
            end
        end
        UI.RadarDots = {}
        
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        
        local radarSize = Config.RadarSize
        local center = Vector2.new(radarSize/2, radarSize/2)
        local scale = radarSize / (Config.RadarRange * 2)
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local char = player.Character
            if not char then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            local offset = hrp.Position - myHrp.Position
            local distance = offset.Magnitude
            
            if distance <= Config.RadarRange then
                local radarPos = center + Vector2.new(offset.X, offset.Z) * scale
                
                local dot = Instance.new("Frame")
                dot.Name = player.Name
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0, radarPos.X - 3, 0, radarPos.Y - 3)
                dot.BackgroundColor3 = Config.ESPTeamColor and player.TeamColor or Color3.fromRGB(255, 0, 0)
                dot.BorderSizePixel = 0
                dot.ZIndex = 101
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                dot.Parent = UI.RadarFrame
                
                UI.RadarDots[player] = dot
            end
        end
    end
    
    UI.Connections.RadarUpdate = RunService.Heartbeat:Connect(function()
        if Config.Radar and UI.RadarFrame then
            UI:UpdateRadar()
        end
        task.wait(0.1) -- 10 FPS update
    end)
    
    UI.DestroyRadar = function()
        if UI.RadarFrame then
            UI.RadarFrame:Destroy()
            UI.RadarFrame = nil
        end
        for _, dot in pairs(UI.RadarDots) do
            if dot then
                pcall(function()
                    dot:Destroy()
                end)
            end
        end
        UI.RadarDots = {}
    end
end

-- Instant Interact (Non-combat)
do
    UI.Connections.InstantInteractLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.InstantInteract then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local parts = workspace:GetPartBoundsInRadius(hrp.Position, 10)
        for _, part in ipairs(parts) do
            if part:FindFirstChild("ProximityPrompt") then
                local prompt = part.ProximityPrompt
                if prompt.Enabled then
                    pcall(function()
                        prompt:Action()
                    end)
                end
            end
        end
        
        task.wait(0.1)
    end)
end

-- Auto Heal (Non-combat)
do
    local lastHealTime = 0
    
    UI.Connections.AutoHealLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.AutoHeal then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        local currentTime = tick()
        
        if healthPercent <= Config.AutoHealThreshold and 
           currentTime - lastHealTime >= Config.AutoHealDelay then
            
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (
                        item.Name:lower():find("health") or 
                        item.Name:lower():find("medkit") or
                        item.Name:lower():find("bandage") or
                        item.Name:lower():find("pill")
                    ) then
                        pcall(function()
                            hum:EquipTool(item)
                            item:Activate()
                            lastHealTime = currentTime
                        end)
                        break
                    end
                end
            end
        end
        
        task.wait(1)
    end)
end

-- Grenade Prediction (Forsaken specific)
do
    UI.Connections.GrenadePredictionLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.GrenadePrediction then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            if tool:GetAttribute("IsThrown") or tool:GetAttribute("IsCharging") then
                -- Predict trajectory
                local velocity = tool.Handle.AssemblyLinearVelocity
                local gravity = Vector3.new(0, -196.2, 0) -- Roblox gravity
                local pos = tool.Handle.Position
                local trajectory = {}
                
                for i = 1, 30 do -- 30 steps
                    local dt = 0.1
                    velocity = velocity + gravity * dt
                    pos = pos + velocity * dt
                    table.insert(trajectory, pos)
                    
                    -- Visualize (optional)
                    if i % 5 == 0 then
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(0.5, 0.5, 0.5)
                        part.Position = pos
                        part.Anchored = true
                        part.CanCollide = false
                        part.Material = Enum.Material.Neon
                        part.Color = Color3.fromRGB(255, 255, 0)
                        part.Parent = Workspace
                        game:GetService("Debris"):AddItem(part, 2)
                    end
                end
            end
        end
        
        task.wait(0.5) -- Reduce frequency
    end)
end

-- Inventory Hack (Forsaken specific)
do
    UI.Connections.InventoryHackLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.InventoryHack then return end
        
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        
        -- Auto-stack items
        local items = {}
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name
                if not items[name] then
                    items[name] = {}
                end
                table.insert(items[name], item)
            end
        end
        
        -- Merge stacks
        for name, stacks in pairs(items) do
            if #stacks > 1 then
                for i = 2, #stacks do
                    pcall(function()
                        stacks[i]:Destroy()
                    end)
                end
            end
        end
        
        task.wait(5) -- Check every 5 seconds
    end)
end

-- ==================== CHAMS SYSTEM (CACHED + EVENT-BASED) ====================
do
    -- Cache original materials for each part
    local function ApplyChamsToCharacter(char)
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if not UI.ChamsOriginal[part] then
                    UI.ChamsOriginal[part] = {
                        Material = part.Material,
                        Color = part.Color,
                        Transparency = part.Transparency
                    }
                end
                part.Material = Config.ChamMaterial
                part.Color = Config.ChamColor
                part.Transparency = Config.ChamTransparency
            end
        end
    end
    
    local function RemoveChamsFromCharacter(char)
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local original = UI.ChamsOriginal[part]
                if original then
                    part.Material = original.Material
                    part.Color = original.Color
                    part.Transparency = original.Transparency
                    UI.ChamsOriginal[part] = nil
                end
            end
        end
    end
    
    UI.ApplyChams = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            if player.Character then
                ApplyChamsToCharacter(player.Character)
            end
        end
        
        -- Listen for new characters
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(char)
                if Config.Chams and not (Config.TeamCheck and player.Team == LocalPlayer.Team) then
                    ApplyChamsToCharacter(char)
                end
            end)
        end)
    end
    
    UI.RemoveChams = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                RemoveChamsFromCharacter(player.Character)
            end
        end
    end
    
    -- Toggle handler
    UI.Connections.ChamsToggle = Config.Chams and UI.ApplyChams() or UI.RemoveChams()
end

-- ==================== HELPER FUNCTIONS ====================
function UI:UpdateTargetHUDData()
    if not Config.TargetHUD then return end
    
    local hudFrame = self:GetTargetHUDFrame()
    if not hudFrame then return end
    
    local target = nil
    local closestDist = math.huge
    
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHrp then
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local char = player.Character
            if not char then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local dist = (hrp.Position - myHrp.Position).Magnitude
            if dist < closestDist and dist <= Config.MagnetRange then
                closestDist = dist
                target = player
            end
        end
    end
    
    if target then
        local nameLabel = hudFrame:FindFirstChild("NameLabel")
        local distLabel = hudFrame:FindFirstChild("DistLabel")
        local healthFill = hudFrame:FindFirstChild("HealthFill")
        
        if nameLabel then
            nameLabel.Text = "TARGET: " .. target.Name:upper()
        end
        if distLabel then
            distLabel.Text = "DISTANCE: " .. math.floor(closestDist) .. " STUD(S)"
        end
        
        local char = target.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and healthFill then
                local healthPercent = hum.Health / hum.MaxHealth
                healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                if healthPercent > 0.5 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.2 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    else
        local nameLabel = hudFrame:FindFirstChild("NameLabel")
        local distLabel = hudFrame:FindFirstChild("DistLabel")
        local healthFill = hudFrame:FindFirstChild("HealthFill")
        
        if nameLabel then
            nameLabel.Text = "TARGET: NONE"
        end
        if distLabel then
            distLabel.Text = "DISTANCE: --"
        end
        if healthFill then
            healthFill.Size = UDim2.new(0, 0, 1, 0)
        end
    end
end

function UI:GetTargetHUDFrame()
    -- Find or create HUD frame
    local hudFrame = self.ScreenGui:FindFirstChild("TargetHUD")
    if not hudFrame and Config.TargetHUD then
        self:CreateTargetHUD()
        hudFrame = self.ScreenGui:FindFirstChild("TargetHUD")
    end
    return hudFrame
end

function UI:CreateTargetHUD()
    local existing = self.ScreenGui:FindFirstChild("TargetHUD")
    if existing then
        existing:Destroy()
    end
    
    local hudFrame = Instance.new("Frame")
    hudFrame.Name = "TargetHUD"
    hudFrame.Size = Config.TargetHUDSize
    hudFrame.Position = Config.TargetHUDPos
    hudFrame.BackgroundColor3 = Config.TargetHUDColor
    hudFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    hudFrame.BorderSizePixel = 2
    hudFrame.ZIndex = 100
    Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 8)
    hudFrame.Parent = self.ScreenGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "TARGET: NONE"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 18
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 101
    nameLabel.Parent = hudFrame
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, -10, 0, 20)
    distLabel.Position = UDim2.new(0, 5, 0, 32)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "DISTANCE: --"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 14
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.ZIndex = 101
    distLabel.Parent = hudFrame
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, -10, 0, 15)
    healthBar.Position = UDim2.new(0, 5, 1, -25)
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBar.BorderSizePixel = 0
    Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 4)
    healthBar.ZIndex = 101
    healthBar.Parent = hudFrame
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
end

function UI:DestroyTargetHUD()
    local hudFrame = self.ScreenGui:FindFirstChild("TargetHUD")
    if hudFrame then
        hudFrame:Destroy()
    end
end

function UI:TriggerKillFlash()
    local killFlash = self.ScreenGui:FindFirstChild("KillFlash")
    if not killFlash then
        killFlash = Instance.new("Frame")
        killFlash.Name = "KillFlash"
        killFlash.Size = UDim2.new(1, 0, 1, 0)
        killFlash.BackgroundColor3 = Config.KillConfirmColor
        killFlash.BackgroundTransparency = 1
        killFlash.ZIndex = 999
        killFlash.Parent = self.ScreenGui
    end
    
    killFlash.Visible = true
    local tween = TweenService:Create(killFlash, 
        TweenInfo.new(Config.KillConfirmTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.5}
    )
    tween:Play()
    task.delay(Config.KillConfirmTime, function()
        killFlash.Visible = false
        killFlash.BackgroundTransparency = 1
    end)
end

-- FOV Circle
do
    UI.FOVCircleFrame = nil
    
    UI.UpdateFOVCircle = function()
        if UI.FOVCircleFrame then
            UI.FOVCircleFrame:Destroy()
            UI.FOVCircleFrame = nil
        end
        
        if not Config.FOVCircle then return end
        
        local fovCircle = Instance.new("ImageLabel")
        fovCircle.Name = "FOVCircle"
        fovCircle.Size = UDim2.new(0, Config.AimbotFOV * 2, 0, Config.AimbotFOV * 2)
        fovCircle.Position = UDim2.new(0.5, -Config.AimbotFOV, 0.5, -Config.AimbotFOV)
        fovCircle.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        fovCircle.ImageColor3 = Config.FOVCircleColor
        fovCircle.BackgroundTransparency = 1
        fovCircle.ImageTransparency = Config.FOVCircleTransparency
        fovCircle.ZIndex = 50
        fovCircle.Parent = UI.ScreenGui
        
        Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke", fovCircle)
        stroke.Color = Config.FOVCircleColor
        stroke.Thickness = Config.FOVCircleThickness
        stroke.Transparency = Config.FOVCircleTransparency
        
        UI.FOVCircleFrame = fovCircle
    end
end

-- Kill Confirm UI
do
    UI.CreateKillConfirm = function()
        if self:GetKillFlash() then return end
        
        local killFlash = Instance.new("Frame")
        killFlash.Name = "KillFlash"
        killFlash.Size = UDim2.new(1, 0, 1, 0)
        killFlash.BackgroundColor3 = Config.KillConfirmColor
        killFlash.BackgroundTransparency = 1
        killFlash.ZIndex = 999
        killFlash.Parent = UI.ScreenGui
    end
    
    UI.GetKillFlash = function()
        return UI.ScreenGui:FindFirstChild("KillFlash")
    end
    
    UI.DestroyKillConfirm = function()
        local killFlash = self:GetKillFlash()
        if killFlash then
            killFlash:Destroy()
        end
    end
end

-- ==================== PROJECTILE MAGNETISM (Optimized Tracking) ====================
do
    -- Track projectiles via descendant events
    Workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("BasePart") then
            local name = desc.Name:lower()
            for _, keyword in ipairs(Config.MagnetProjectiles) do
                if name:find(keyword:lower()) then
                    table.insert(UI.TrackedProjectiles, desc)
                    break
                end
            end
        end
    end)
    
    -- Cleanup projectiles that are removed
    Workspace.DescendantRemoving:Connect(function(desc)
        for i = #UI.TrackedProjectiles, 1, -1 do
            if UI.TrackedProjectiles[i] == desc then
                table.remove(UI.TrackedProjectiles, i)
                break
            end
        end
    end)
end

-- ==================== HITBOX SYSTEM (4-6-4 LOCKED) ====================
do
    local DataStore = ReplicatedStorage:FindFirstChild(Config.PersistentHitboxStore)
    if not DataStore then
        DataStore = Instance.new("Folder")
        DataStore.Name = Config.PersistentHitboxStore
        DataStore.Parent = ReplicatedStorage
    end
    
    local function GetMultiplier(player)
        local saved = DataStore:FindFirstChild(tostring(player.UserId))
        if saved and saved:IsA("NumberValue") then
            return saved.Value
        end
        return Config.HitboxMultiplier
    end
    
    UI.UpdateAllHitboxes = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local baseSize = Vector3.new(4, 6, 4)
                    local scale = Config.HitboxMultiplier / 6
                    hrp.Size = baseSize * scale
                    hrp.CanCollide = true
                    hrp.CanTouch = true
                    
                    if Config.ESP then
                        hrp.Transparency = Config.HitboxTransparency
                        hrp.Material = Enum.Material.Neon
                        hrp.Color = Config.HitboxColor
                    end
                end
            end
        end
    end
    
    local function OnCharacterAdded(char, player)
        task.wait(0.5)
        local hrp = char:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            local baseSize = Vector3.new(4, 6, 4)
            local scale = Config.HitboxMultiplier / 6
            hrp.Size = baseSize * scale
            hrp.CanCollide = true
            hrp.CanTouch = true
            
            if Config.ESP then
                hrp.Transparency = Config.HitboxTransparency
                hrp.Material = Enum.Material.Neon
                hrp.Color = Config.HitboxColor
            end
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            OnCharacterAdded(char, player)
        end)
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(char)
                OnCharacterAdded(char, player)
            end)
        end
    end
    
    LocalPlayer.CharacterAdded:Connect(function(char)
        OnCharacterAdded(char, LocalPlayer)
    end)
    
    if LocalPlayer.Character then
        OnCharacterAdded(LocalPlayer.Character, LocalPlayer)
    end
end

-- ==================== ESP HEALTH BAR UPDATER (In Master Loop) ====================
function UI:UpdateESPHealthBars()
    if not Config.Enabled or not Config.ESP or not Config.ESPHealthBar then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChild("Humanoid")
            local bar = self.ESPObjects[char]
            if bar and hum and bar:IsA("BillboardGui") then
                local fill = bar:FindFirstChild("Fill")
                if fill then
                    fill.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
                end
            end
        end
    end
end

-- ==================== MOBILE INPUT HANDLER ====================
local function IsAimActive()
    -- Gamepad/Keyboard
    if UserInputService:IsKeyDown(Config.AimActiveKeybind) then
        return true
    end
    
    -- Mouse (PC)
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return true
    end
    
    -- Touch (Mobile) - Right side of screen
    local touches = UserInputService:GetTouches()
    for _, touch in ipairs(touches) do
        if touch.Position.X > Camera.ViewportSize.X * 0.6 then
            local guiAtPos = GuiService:GetGuiAtPosition(touch.Position.X, touch.Position.Y)
            if not guiAtPos then
                return true
            end
        end
    end
    
    return false
end

-- ==================== KEYBIND HANDLING ====================
do
    UI.Connections.KeybindListener = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Config.MasterKeybind then
            Config.Enabled = not Config.Enabled
            print("APEX DOMAIN: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
            
            if UI.Main then
                UI.Main.Visible = Config.Enabled
            end
        end
    end)
end

-- ==================== CLEANUP ====================
do
    local function Cleanup()
        for _, conn in pairs(UI.Connections) do
            if conn and conn.Disconnect then
                pcall(function()
                    conn:Disconnect()
                end)
            end
        end
        UI.Connections = {}
        
        pcall(function()
            UI:ClearESP()
            UI:DestroyTargetHUD()
            UI:DestroyRadar()
            UI:RestoreChams()
            if UI.FOVCircleFrame then
                UI.FOVCircleFrame:Destroy()
            end
        end)
        
        if UI.Main then
            UI.Main:Destroy()
            UI.Main = nil
        end
        if UI.Shadow then
            UI.Shadow:Destroy()
            UI.Shadow = nil
        end
        if UI.ScreenGui then
            UI.ScreenGui:Destroy()
            UI.ScreenGui = nil
        end
    end
    
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            Cleanup()
        end
    end)
end

-- ==================== INITIALIZATION ====================
task.spawn(function()
    task.wait(2) -- Extended wait for mobile
    
    if BuildUI() then
        print("◈ APEX DOMAIN ULTIMATE v6.0 LOADED ◈")
        print("FULLY OPTIMIZED FOR FORSAKEN")
        print("• 4-6-4 LOCKED Hitboxes")
        print("• Mobile Camera Aimbot")
        print("• 10 Essential Forsaken Hacks")
        print("• Single Master Combat Loop")
        print("Press F1 to toggle")
        
        -- Initialize FOV Circle
        UI:UpdateFOVCircle()
    else
        warn("Apex Domain: Failed to load UI!")
        task.wait(3)
        if BuildUI() then
            print("UI loaded on retry")
        else
            warn("UI failed to load after retry")
        end
    end
end)

-- Export UI table
return UI
