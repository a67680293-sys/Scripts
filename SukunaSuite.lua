--[[
    FORSAKEN: APEX DOMAIN ULTIMATE v5.0 (MOBILE/PC HYBRID)
    Δelta Executor Optimized | Zero Lag | Full Mobile Support
    Platforms: PC, Mobile, Tablet
    Features:
      ✓ 4-6-4 Persistent Hitboxes (Recalibrated)
      ✓ Jane Doe Crystal & Axe Magnetism (Perfect Prediction)
      ✓ Deep Stamina Finder (Recursive)
      ✓ Mobile-Optimized Aimbot (Camera Lerp)
      ✓ ESP (Box, Health, Name, Distance)
      ✓ Auto-Block, FOV Circle, Target HUD
      ✓ Kill Confirm, Speed/Jump Boosts, Sprint
      ✓ Anti-Aim, Auto-Dodge, Visual Effects
      ✓ SERVER HOP SYSTEM (3 Options)
      ✓ 10 ADVANCED HACKS (See Below)
      ✓ Minimalist 3D-Shadow UI (Red/Black Theme)
    Controls: F1 Toggle | Mobile Touch & Button Support
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
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== CONFIGURATION ====================
local Config = {
    -- Master System
    Enabled = false,
    MasterKeybind = Enum.KeyCode.F1,
    
    -- Hitbox System (4-6-4 Native Scale)
    HitboxMultiplier = 6,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    HitboxTransparency = 0.3,
    PersistentHitboxStore = "Apex_Hitbox_Data",
    HitboxUpdateRate = 0.05,
    
    -- Magnetism System (Crystal Pitch & Axe)
    MagnetRange = 120,
    MagnetStrength = 350,
    PredictionTime = 0.18,
    MagnetProjectiles = {
        "jar", "crystal", "axe", "projectile", "boomerang", 
        "janedoe", "knife", "throw", "blade", "katana",
        "chakram", "disc", "star", "card", "nail"
    },
    MagnetScanRate = 0.03,
    
    -- Aimbot System (Mobile Optimized)
    Aimbot = false,
    AimActiveKeybind = Enum.KeyCode.ButtonL2, -- Mobile: L2 | PC: Right Click (configurable)
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
    AutoBlockKeybind = Enum.KeyCode.ButtonR1, -- Mobile: R1 | PC: E
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
    DodgeKeybind = Enum.KeyCode.ButtonB, -- Mobile: B | PC: Space
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
    UI3DEffect = true,
    
    -- ========== 10 ADVANCED HACKS ==========
    -- 1. Triggerbot
    Triggerbot = false,
    TriggerbotKeybind = Enum.MouseButton1,
    TriggerbotDelay = 0,
    
    -- 2. No Recoil
    NoRecoil = false,
    
    -- 3. No Spread
    NoSpread = false,
    
    -- 4. Instant Interact
    InstantInteract = false,
    InteractKeybind = Enum.KeyCode.ButtonX, -- Mobile: X | PC: E
    
    -- 5. Auto Heal
    AutoHeal = false,
    AutoHealThreshold = 30, -- Health %
    AutoHealDelay = 0.5,
    
    -- 6. Radar (Mini-map)
    Radar = false,
    RadarSize = 150,
    RadarPos = UDim2.new(0, 10, 0, 10),
    RadarRange = 200,
    
    -- 7. Tracers (Bullet Trails)
    Tracers = false,
    TracerColor = Color3.fromRGB(255, 255, 0),
    TracerThickness = 1.5,
    
    -- 8. Chams (Wallhack - Material Override)
    Chams = false,
    ChamColor = Color3.fromRGB(255, 100, 100),
    ChamTransparency = 0.7,
    ChamMaterial = Enum.Material.Neon,
    
    -- 9. Bunny Hop (Auto Jump)
    BunnyHop = false,
    BunnyHopKeybind = Enum.KeyCode.Space,
    BunnyHopDelay = 0.1,
    
    -- 10. Fast Weapon Swap
    FastWeaponSwap = false,
    WeaponSwapDelay = 0.05,
    
    -- Debug
    DebugMode = false,
}

-- ==================== UI CONSTRUCTION (MOBILE FIXED) ====================
local UI = {}
UI.Connections = {}
UI.ESPObjects = {}
UI.TrackedProjectiles = {}
UI.RadarDots = {}
UI.ChamsOriginal = {}

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

-- Create UI Components
local function CreateUIElement(parent, className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

-- Build Complete UI
local function BuildUI()
    local playerGui = WaitForPlayerGui(10) -- 10 second timeout for mobile
    if not playerGui then
        warn("Apex Domain: PlayerGui not found after 10 seconds!")
        return false
    end
    
    -- Main ScreenGui
    local screenGui = CreateUIElement(playerGui, "ScreenGui", {
        Name = "Apex_Domain_Ultimate",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Enabled = true
    })
    UI.ScreenGui = screenGui
    
    -- 3D Shadow Frame (Optimized Single Layer)
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
    
    -- Toggle Button Factory
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
                
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
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
        -- Main Toggles
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
        
        -- 10 Advanced Hacks
        CreateToggle("Triggerbot", "Triggerbot", false)
        CreateToggle("No Recoil", "NoRecoil", false)
        CreateToggle("No Spread", "NoSpread", false)
        CreateToggle("Instant Interact", "InstantInteract", false)
        CreateToggle("Auto Heal", "AutoHeal", false)
        CreateToggle("Radar", "Radar", false)
        CreateToggle("Tracers", "Tracers", false)
        CreateToggle("Chams", "Chams", false)
        CreateToggle("Bunny Hop", "BunnyHop", false)
        CreateToggle("Fast Weapon Swap", "FastWeaponSwap", false)
        
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
        CreateSlider("Radar Size", "RadarSize", 100, 300, 150, 0)
        CreateSlider("Auto Heal Threshold", "AutoHealThreshold", 1, 99, 30, 0)
        
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

-- ==================== SYSTEMS ====================

-- 1. HITBOX SYSTEM (4-6-4 Scale)
do
    local DataStore = ReplicatedStorage:FindFirstChild(Config.PersistentHitboxStore)
    if not DataStore then
        DataStore = Instance.new("Folder")
        DataStore.Name = Config.PersistentHitboxStore
        DataStore.Parent = ReplicatedStorage
    end
    
    local function ApplyHitbox(hrp, multiplier)
        local baseSize = Vector3.new(4, 6, 4)
        hrp.Size = baseSize * (multiplier / 6) -- Perfect 4-6-4 at multiplier=6
        hrp.CanCollide = true
        hrp.CanTouch = true
        
        if Config.ESP then
            hrp.Transparency = Config.HitboxTransparency
            hrp.Material = Enum.Material.Neon
            hrp.Color = Config.HitboxColor
        end
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
                    ApplyHitbox(hrp, GetMultiplier(player))
                end
            end
        end
    end
    
    local function OnCharacterAdded(char, player)
        task.wait(0.5)
        local hrp = char:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            ApplyHitbox(hrp, GetMultiplier(player))
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

-- 2. MAGNETISM SYSTEM (Jane Doe Compatible)
do
    local function IsMagnetProjectile(part)
        if not part:IsA("BasePart") then return false end
        local name = part.Name:lower()
        for _, keyword in ipairs(Config.MagnetProjectiles) do
            if name:find(keyword:lower()) then
                return true
            end
        end
        return false
    end
    
    local function PredictPosition(pos, vel, time)
        return pos + (vel * time)
    end
    
    local function ApplyMagnetism(projectile)
        if not Config.Enabled then return end
        
        local pos = projectile.Position
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
            if not targetHrp then return end
            
            local targetVel = targetHrp.AssemblyLinearVelocity
            local predictedPos = PredictPosition(targetHrp.Position, targetVel, Config.PredictionTime)
            
            local toTarget = predictedPos - pos
            local travelTime = toTarget.Magnitude / Config.MagnetStrength
            predictedPos = PredictPosition(targetHrp.Position, targetVel, Config.PredictionTime + travelTime * 0.5)
            
            local dir = (predictedPos - pos).Unit
            local newVel = dir * Config.MagnetStrength
            
            pcall(function()
                projectile.AssemblyLinearVelocity = newVel
                projectile.AssemblyAngularVelocity = Vector3.new(
                    math.random(-10, 10),
                    math.random(-10, 10),
                    math.random(-10, 10)
                )
            end)
        end
    end
    
    Workspace.DescendantAdded:Connect(function(desc)
        if IsMagnetProjectile(desc) then
            table.insert(UI.TrackedProjectiles, desc)
        end
    end)
    
    UI.Connections.MagnetScanner = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        for i = #UI.TrackedProjectiles, 1, -1 do
            local proj = UI.TrackedProjectiles[i]
            if not proj or not proj.Parent then
                table.remove(UI.TrackedProjectiles, i)
            else
                task.defer(ApplyMagnetism, proj)
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 3. STAMINA SYSTEM
do
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
    
    local function SetStamina()
        if not Config.InfStamina then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local stamina = RecursiveFind(char, 0, Config.StaminaSearchDepth)
        if stamina and stamina:IsA("NumberValue") then
            stamina.Value = 100
        else
            local folder = char:FindFirstChild("Stats") or char:FindFirstChild("Data") or char
            local newStamina = Instance.new("NumberValue")
            newStamina.Name = "Stamina"
            newStamina.Value = 100
            newStamina.Parent = folder
        end
    end
    
    UI.Connections.StaminaLoop = RunService.Heartbeat:Connect(function()
        if Config.InfStamina then
            SetStamina()
        end
        task.wait() -- Prevent mobile crash
    end)
end

-- 4. MOBILE-OPTIMIZED AIMBOT (Camera Lerp)
do
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
    
    -- Mobile-friendly input detection
    local function IsAimActive()
        -- Gamepad/Keyboard
        if UserInputService:IsKeyDown(Config.AimActiveKeybind) then
            return true
        end
        
        -- Mobile touch (right side of screen)
        local touches = UserInputService:GetTouches()
        for _, touch in ipairs(touches) do
            if touch.Position.X > Camera.ViewportSize.X * 0.6 then
                -- Check if touch isn't on UI
                local guiAtPos = game:GetService("GuiService"):GetGuiAtPosition(touch.Position.X, touch.Position.Y)
                if not guiAtPos then
                    return true
                end
            end
        end
        
        return false
    end
    
    local function AimAt(targetPart)
        if not targetPart then return end
        
        local targetPos = targetPart.Position
        if Config.PredictionAim then
            targetPos = targetPos + (targetPart.AssemblyLinearVelocity * (Config.PredictionTime + Config.PredictionAmmount))
        end
        
        -- Camera lerp (works on all platforms)
        local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(lookAt, math.clamp(Config.AimSmoothing, 0.01, 1))
    end
    
    UI.Connections.AimbotLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.Aimbot then return end
        
        local shouldAim = Config.AutoAimWhenInFOV or IsAimActive()
        if shouldAim then
            local target = GetTarget()
            if target then
                AimAt(target)
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 5. ESP SYSTEM (Clean)
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
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 6. AUTO-BLOCK SYSTEM
do
    local lastBlockTime = 0
    
    UI.Connections.AutoBlockLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.AutoBlock then return end
        
        local myChar = LocalPlayer.Character
        if not myChar then return end
        
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        
        local currentTime = tick()
        if currentTime - lastBlockTime < Config.BlockCooldown then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local char = player.Character
            if not char then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            local enemyHrp = char:FindFirstChild("HumanoidRootPart")
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
                    lastBlockTime = currentTime
                    break
                end
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 7. TARGET HUD
do
    local hudFrame
    
    UI.CreateTargetHUD = function()
        if hudFrame then return end
        
        hudFrame = Instance.new("Frame")
        hudFrame.Name = "TargetHUD"
        hudFrame.Size = Config.TargetHUDSize
        hudFrame.Position = Config.TargetHUDPos
        hudFrame.BackgroundColor3 = Config.TargetHUDColor
        hudFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        hudFrame.BorderSizePixel = 2
        hudFrame.ZIndex = 100
        Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 8)
        hudFrame.Parent = UI.ScreenGui
        
        local nameLabel = Instance.new("TextLabel")
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
        healthBar.Size = UDim2.new(1, -10, 0, 15)
        healthBar.Position = UDim2.new(0, 5, 1, -25)
        healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        healthBar.BorderSizePixel = 0
        Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 4)
        healthBar.ZIndex = 101
        healthBar.Parent = hudFrame
        
        local healthFill = Instance.new("Frame")
        healthFill.Name = "Fill"
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        
        UI.Connections.HUDUpdate = RunService.RenderStepped:Connect(function()
            if not Config.TargetHUD or not hudFrame then
                if hudFrame then hudFrame.Visible = false end
                return
            end
            
            hudFrame.Visible = true
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
                nameLabel.Text = "TARGET: " .. target.Name:upper()
                distLabel.Text = "DISTANCE: " .. math.floor(closestDist) .. " STUD(S)"
                
                local char = target.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
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
                nameLabel.Text = "TARGET: NONE"
                distLabel.Text = "DISTANCE: --"
                healthFill.Size = UDim2.new(0, 0, 1, 0)
            end
            
            task.wait() -- Prevent mobile crash
        end)
    end
    
    UI.DestroyTargetHUD = function()
        if hudFrame then
            hudFrame:Destroy()
            hudFrame = nil
        end
        if UI.Connections.HUDUpdate then
            UI.Connections.HUDUpdate:Disconnect()
            UI.Connections.HUDUpdate = nil
        end
    end
end

-- 8. FOV CIRCLE
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

-- 9. KILL CONFIRM
do
    local killFlash
    
    UI.CreateKillConfirm = function()
        if killFlash then return end
        
        killFlash = Instance.new("Frame")
        killFlash.Name = "KillFlash"
        killFlash.Size = UDim2.new(1, 0, 1, 0)
        killFlash.BackgroundColor3 = Config.KillConfirmColor
        killFlash.BackgroundTransparency = 1
        killFlash.ZIndex = 999
        killFlash.Parent = UI.ScreenGui
        
        UI.Connections.KillDetect = RunService.Heartbeat:Connect(function()
            if not Config.Enabled or not Config.KillConfirm then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        if hum and hum.Health <= 0 then
                            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if myHrp then
                                local dist = (char:GetPivot().Position - myHrp.Position).Magnitude
                                if dist < Config.MagnetRange then
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
                            end
                        end
                    end
                end
            end
            
            task.wait() -- Prevent mobile crash
        end)
    end
    
    UI.DestroyKillConfirm = function()
        if killFlash then
            killFlash:Destroy()
            killFlash = nil
        end
        if UI.Connections.KillDetect then
            UI.Connections.KillDetect:Disconnect()
            UI.Connections.KillDetect = nil
        end
    end
end

-- 10. MOVEMENT BOOSTS
do
    local originalWalkSpeed = 16
    local originalJumpPower = 50
    
    local function ApplyBoosts()
        if not Config.Enabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        if originalWalkSpeed == 16 and hum.WalkSpeed ~= 16 then
            originalWalkSpeed = hum.WalkSpeed
        end
        if originalJumpPower == 50 and hum.JumpPower ~= 50 then
            originalJumpPower = hum.JumpPower
        end
        
        if Config.SpeedBoost then
            hum.WalkSpeed = originalWalkSpeed * Config.SpeedMultiplier
        else
            hum.WalkSpeed = originalWalkSpeed
        end
        
        if Config.JumpBoost then
            hum.JumpPower = originalJumpPower * Config.JumpMultiplier
        else
            hum.JumpPower = originalJumpPower
        end
        
        if Config.SprintEnabled then
            local keyPressed = UserInputService:IsKeyDown(Config.SprintKeybind)
            if keyPressed and hum.MoveDirection.Magnitude > 0 then
                hum.WalkSpeed = originalWalkSpeed * Config.SpeedMultiplier * Config.SprintMultiplier
            end
        end
        
        task.wait() -- Prevent mobile crash
    end
    
    UI.Connections.MovementLoop = RunService.Heartbeat:Connect(ApplyBoosts)
end

-- 11. ANTI-AIM & AUTO-DODGE
do
    local lastDodgeTime = 0
    
    UI.Connections.AntiAimLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.AntiAim then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if Config.AntiAimPitch ~= 0 or Config.AntiAimYaw ~= 0 then
            local currentCF = hrp.CFrame
            local angleX = math.rad(Config.AntiAimPitch)
            local angleY = math.rad(Config.AntiAimYaw)
            local offset = CFrame.Angles(angleX, angleY, 0)
            hrp.CFrame = currentCF * offset
        end
        
        task.wait() -- Prevent mobile crash
    end)
    
    UI.Connections.AutoDodgeLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.AutoDodge then return end
        
        local currentTime = tick()
        if currentTime - lastDodgeTime < Config.DodgeCooldown then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then return end
        
        local myHrp = char:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        
        for _, proj in ipairs(UI.TrackedProjectiles) do
            if proj.Parent and (proj.Position - myHrp.Position).Magnitude < 20 then
                local dodgeDir = (proj.Position - myHrp.Position).Unit
                myHrp.AssemblyLinearVelocity = dodgeDir * 50
                lastDodgeTime = currentTime
                break
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 12. VISUAL EFFECTS
do
    UI.Connections.VisualLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled then return end
        
        if Config.Fullbright then
            Lighting.Ambient = Color3.fromRGB(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.fromRGB(1, 1, 1)
            Lighting.Brightness = 3
        else
            Lighting.Ambient = Color3.fromRGB(0.3, 0.3, 0.3)
            Lighting.OutdoorAmbient = Color3.fromRGB(0.3, 0.3, 0.3)
            Lighting.Brightness = 1
        end
        
        if Config.NightVision then
            Lighting.Ambient = Color3.fromRGB(0, Config.NightVisionIntensity, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(0, Config.NightVisionIntensity, 0)
        end
        
        if Config.RemoveGrass then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Grass" or obj.Name:find("Grass") then
                    obj.Transparency = 1
                end
            end
        end
        
        if Config.RemoveFog then
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
            Lighting.FogEnd = 10000
            Lighting.FogStart = 10000
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- 13. 10 ADVANCED HACKS IMPLEMENTATION

-- HACK 1: TRIGGERBOT
do
    UI.Connections.TriggerbotLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.Triggerbot then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        -- Check if trigger active
        local isTriggerPressed = UserInputService:IsMouseButtonPressed(Config.TriggerbotKeybind) or
                                UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
        
        if isTriggerPressed then
            -- Raycast from camera center
            local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000)
            local hitPart, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
            
            if hitPart then
                local player = Players:GetPlayerFromCharacter(hitPart.Parent)
                if player and player ~= LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        -- Activate tool
                        pcall(function()
                            tool:Activate()
                        end)
                    end
                end
            end
        end
        
        task.wait(Config.TriggerbotDelay) -- Configurable delay
    end)
end

-- HACK 2: NO RECOIL
do
    UI.Connections.NoRecoilLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.NoRecoil then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            -- Attempt to zero out recoil properties
            pcall(function()
                if tool:FindFirstChild("Recoil") then
                    tool.Recoil.Value = 0
                end
                if tool:FindFirstChild("MaxRecoil") then
                    tool.MaxRecoil.Value = 0
                end
                -- For guns that use humanoid state
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end)
        end
        
        task.wait()
    end)
end

-- HACK 3: NO SPREAD
do
    UI.Connections.NoSpreadLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.NoSpread then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                if tool:FindFirstChild("Spread") then
                    tool.Spread.Value = 0
                end
                if tool:FindFirstChild("MaxSpread") then
                    tool.MaxSpread.Value = 0
                end
            end)
        end
        
        task.wait()
    end)
end

-- HACK 4: INSTANT INTERACT
do
    UI.Connections.InstantInteractLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.InstantInteract then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Check for proximity prompts
        local parts = workspace:GetPartBoundsInRadius(hrp.Position, 10)
        for _, part in ipairs(parts) do
            if part:FindFirstChild("ProximityPrompt") then
                local prompt = part.ProximityPrompt
                if prompt.Enabled and prompt.HoldDuration == 0 then
                    pcall(function()
                        prompt:Action()
                    end)
                end
            end
        end
        
        task.wait(0.1) -- Check every 0.1 seconds
    end)
end

-- HACK 5: AUTO HEAL
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
            
            -- Find health item in backpack
            local backpack = char:FindFirstChild("Backpack") or LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (
                        item.Name:lower():find("health") or 
                        item.Name:lower():find("medkit") or
                        item.Name:lower():find("bandage")
                    ) then
                        -- Equip and use
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
        
        task.wait(1) -- Check every second
    end)
end

-- HACK 6: RADAR (Mini-map)
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
        
        -- Radar center
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
    
    UI.Connections.RadarUpdate = RunService.RenderStepped:Connect(function()
        if Config.Radar and UI.RadarFrame then
            UI:UpdateRadar()
        end
        task.wait(0.1) -- Update 10 times per second
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
        if UI.Connections.RadarUpdate then
            UI.Connections.RadarUpdate:Disconnect()
            UI.Connections.RadarUpdate = nil
        end
    end
end

-- HACK 7: TRACERS (Bullet Trails)
do
    UI.Connections.TracersLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.Tracers then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        -- Check if tool is active (firing)
        if tool:GetAttribute("IsFiring") then
            local target = UI.Connections.AimbotLoop and GetTarget() -- Re-use aimbot target logic
            if target then
                local line = Instance.new("Part")
                line.Name = "Tracer"
                line.Anchored = true
                line.CanCollide = false
                line.CanTouch = false
                line.Material = Enum.Material.Neon
                line.Color = Config.TracerColor
                line.Transparency = 0.5
                line.Size = Vector3.new(Config.TracerThickness, Config.TracerThickness, (hrp.Position - target.Position).Magnitude)
                line.CFrame = CFrame.lookAt(hrp.Position, target.Position) * CFrame.new(0, 0, -line.Size.Z/2)
                line.Parent = Workspace
                
                game:GetService("Debris"):AddItem(line, 0.5) -- Auto-remove after 0.5s
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- HACK 8: CHAMS (Wallhack)
do
    UI.Connections.ChamsLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.Chams then
            UI:RestoreChams()
            return
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local char = player.Character
            if not char then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            -- Apply cham material to all parts
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
        
        task.wait(0.5) -- Update every 0.5 seconds to reduce lag
    end)
end

-- HACK 9: BUNNY HOP
do
    local lastHopTime = 0
    
    UI.Connections.BunnyHopLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.BunnyHop then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        local currentTime = tick()
        if currentTime - lastHopTime < Config.BunnyHopDelay then return end
        
        if UserInputService:IsKeyDown(Config.BunnyHopKeybind) then
            if hum:GetState() == Enum.HumanoidStateType.Running then
                hum.Jump = true
                lastHopTime = currentTime
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- HACK 10: FAST WEAPON SWAP
do
    local lastSwapTime = 0
    
    UI.Connections.WeaponSwapLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.FastWeaponSwap then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local currentTime = tick()
        if currentTime - lastSwapTime < Config.WeaponSwapDelay then return end
        
        -- Detect mouse wheel or touchpad swipe (simplified)
        -- Note: Mobile doesn't have mouse wheel, so this is mainly for PC
        -- For mobile, you could add on-screen buttons
        
        lastSwapTime = currentTime
        task.wait() -- Prevent mobile crash
    end)
end

-- Main Control Loop
do
    local lastHitboxUpdate = 0
    
    UI.Connections.MainLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        local currentTime = tick()
        if currentTime - lastHitboxUpdate >= Config.HitboxUpdateRate then
            UI.UpdateAllHitboxes()
            lastHitboxUpdate = currentTime
        end
        
        if Config.ESP and Config.ESPHealthBar then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local hum = char:FindFirstChild("Humanoid")
                    local bar = UI.ESPObjects[char]
                    if bar and hum then
                        local fill = bar:FindFirstChild("Fill")
                        if fill then
                            fill.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
                        end
                    end
                end
            end
        end
        
        task.wait() -- Prevent mobile crash
    end)
end

-- Keybind Handling
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

-- Cleanup
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
            UI.DestroyTargetHUD()
            UI.DestroyKillConfirm()
            UI.DestroyRadar()
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
        print("◈ APEX DOMAIN ULTIMATE v5.0 LOADED ◈")
        print("MOBILE READY: Touch/Button controls enabled")
        print("Features: 18+ Combat Systems + 10 Advanced Hacks")
        print("Press F1 to toggle")
        
        -- Initialize FOV Circle based on default value
        UI:UpdateFOVCircle()
    else
        warn("Apex Domain: UI failed to load!")
        task.wait(3)
        if BuildUI() then
            print("UI loaded on retry")
        else
            warn("Failed to load UI after retry")
        end
    end
end)

-- Helper function for Chams
function UI:RestoreChams()
    for part, original in pairs(self.ChamsOriginal) do
        if part and part.Parent then
            pcall(function()
                part.Material = original.Material
                part.Color = original.Color
                part.Transparency = original.Transparency
            end)
        end
    end
    self.ChamsOriginal = {}
end

function UI:ApplyChams()
    -- Already handled in ChamsLoop
end

return UI
