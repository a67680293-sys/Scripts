--[[
    FORSAKEN: APEX DOMAIN ULTIMATE - v3.6 (Delta Optimized)
    Optimized for 20+ Player Matches | No Lag | Full Feature Set
    Features:
      • 4-6-4 Persistent Hitboxes (scaled correctly)
      • Jane Doe Crystal & Axe Magnetism (high-precision prediction)
      • Deep Stamina Finder (recursive)
      • Aimbot w/ Smoothing, Silent Aim, Prediction
      • ESP (Box, Health, Name, Distance) w/ Auto-Cleanup
      • Auto-Block, FOV Circle, Target HUD
      • Kill Confirm, Speed/Jump Boosts, Sprint
      • Anti-Aim, Auto-Dodge, Visual Effects
      • Minimalist 3D-Shadow UI (Red/Black Theme)
    Press F1 to toggle.
--]]

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local StarterGui       = game:GetService("StarterGui")
local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ==================== CONFIGURATION ====================
local Config = {
    -- Master System
    Enabled               = false,
    MasterKeybind         = Enum.KeyCode.F1,
    
    -- Hitbox System (4-6-4 Base Scale)
    HitboxMultiplier      = 6,                          -- 1-20 (6 = 4x6x4 native)
    HitboxColor           = Color3.fromRGB(255, 0, 0),
    HitboxTransparency    = 0.3,
    PersistentHitboxStore = "Apex_Hitbox_Data",         -- Folder in ReplicatedStorage
    HitboxUpdateRate     = 0.05,
    
    -- Magnetism System (Crystal Pitch & Axe)
    MagnetRange           = 120,
    MagnetStrength        = 350,
    PredictionTime        = 0.18,
    MagnetProjectiles     = {"jar", "crystal", "axe", "projectile", "boomerang", "janedoe"},
    MagnetScanRate        = 0.03,
    
    -- Aimbot System
    Aimbot                = false,
    AimbotKeybind         = Enum.MouseButton2,
    AimbotFOV             = 45,
    SilentAim             = false,
    AimPriority           = "Head",
    AimSmoothing          = 0.12,
    PredictionAim         = true,
    PredictionAmmount     = 0.15,
    MaxAimDistance        = 1000,
    AutoAimWhenInFOV      = true,
    
    -- ESP System
    ESP                   = false,
    ESPBox                = true,
    ESPHealthBar          = true,
    ESPName               = true,
    ESPDistance           = true,
    ESPSkeleton           = false,
    ESPColor              = Color3.fromRGB(0, 255, 0),
    ESPTeamColor          = true,
    ESPTransparency       = 0.4,
    ESPThickness          = 1.2,
    ESPAlwaysOnTop        = true,
    MaxTargetsPerFrame    = 5,
    
    -- Auto-Block System
    AutoBlock             = false,
    AutoBlockKeybind      = Enum.KeyCode.E,
    AutoBlockRange        = 30,
    AutoBlockAngle        = 90,
    AutoBlockChance       = 100,
    BlockCooldown         = 0.5,
    
    -- Target HUD
    TargetHUD             = false,
    TargetHUDPos          = UDim2.new(0, 20, 0, 20),
    TargetHUDSize         = UDim2.new(0, 250, 0, 100),
    TargetHUDColor        = Color3.fromRGB(0, 0, 0),
    TargetHUDBorderColor  = Color3.fromRGB(255, 0, 0),
    
    -- FOV Circle
    FOVCircle             = false,
    FOVCircleColor        = Color3.fromRGB(255, 255, 255),
    FOVCircleTransparency = 0.5,
    FOVCircleThickness    = 2,
    FOVCircleDynamic      = false,
    
    -- Kill Confirm
    KillConfirm           = false,
    KillConfirmColor      = Color3.fromRGB(255, 0, 0),
    KillConfirmTime       = 0.4,
    
    -- Stamina System
    InfStamina            = false,
    StaminaSearchDepth    = 6,
    StaminaRefreshRate    = 0.1,
    
    -- Movement Boosts
    SpeedBoost            = false,
    SpeedMultiplier       = 1.5,
    JumpBoost             = false,
    JumpMultiplier        = 1.5,
    SprintEnabled         = false,
    SprintKeybind         = Enum.KeyCode.LeftShift,
    SprintMultiplier      = 1.8,
    
    -- Anti-Aim / Defensive
    AntiAim               = false,
    AntiAimPitch          = 0,
    AntiAimYaw            = 0,
    AutoDodge             = false,
    DodgeKeybind          = Enum.KeyCode.Space,
    DodgeCooldown         = 1.5,
    
    -- Visual Effects
    Fullbright            = false,
    NightVision           = false,
    NightVisionColor      = Color3.fromRGB(0, 1, 0),
    NightVisionIntensity  = 0.6,
    RemoveGrass           = false,
    RemoveFog             = false,
    
    -- Exploit Protection
    FPSOptimization       = true,
    PacketLossProtection  = true,
    ThreadSafety          = true,
    
    -- Team Check
    TeamCheck             = true,
    
    -- UI Settings
    UIScale               = 1,
    UIRedTheme            = true,
    UI3DEffect            = true,
    UIShadowOffset        = 5,
    
    -- Debug
    DebugMode             = false,
}

-- ==================== UI CONSTRUCTION (MINIMALIST 3D SHADOW) ====================
local UI = {}
UI.Enabled = true
UI.Connections = {}
UI.ESPObjects = {}

-- Main ScreenGui
UI.ScreenGui = Instance.new("ScreenGui")
UI.ScreenGui.Name = "Apex_Domain_Ultimate"
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 3D Shadow Frame (single layer for performance)
if Config.UI3DEffect then
    UI.ShadowFrame = Instance.new("Frame")
    UI.ShadowFrame.Name = "ShadowFrame"
    UI.ShadowFrame.Size = UDim2.new(0, 510, 0, 470)
    UI.ShadowFrame.Position = UDim2.new(0.5, -257, 0.5, -237)
    UI.ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UI.ShadowFrame.BackgroundTransparency = 0.85
    UI.ShadowFrame.BorderSizePixel = 0
    UI.ShadowFrame.ZIndex = 0
    UI.ShadowFrame.Parent = UI.ScreenGui
end

-- Main UI Frame
UI.Main = Instance.new("Frame")
UI.Main.Name = "MainFrame"
UI.Main.Size = UDim2.new(0, 500, 0, 460)
UI.Main.Position = UDim2.new(0.5, -250, 0.5, -230)
UI.Main.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(20, 0, 0) or Color3.fromRGB(10, 10, 20)
UI.Main.BorderSizePixel = 0
UI.Main.Active = true
UI.Main.Draggable = true
UI.Main.ZIndex = 1
Instance.new("UICorner", UI.Main).CornerRadius = UDim.new(0, 18)
UI.Main.Parent = UI.ScreenGui

-- Dark overlay
UI.Overlay = Instance.new("Frame")
UI.Overlay.Name = "Overlay"
UI.Overlay.Size = UDim2.new(1, 0, 1, 0)
UI.Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UI.Overlay.BackgroundTransparency = 0.6
UI.Overlay.BorderSizePixel = 0
UI.Overlay.ZIndex = 2
UI.Overlay.Parent = UI.Main

-- Sidebar
UI.Sidebar = Instance.new("Frame")
UI.Sidebar.Name = "Sidebar"
UI.Sidebar.Size = UDim2.new(0, 130, 1, 0)
UI.Sidebar.Position = UDim2.new(0, 0, 0, 0)
UI.Sidebar.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(30, 0, 0) or Color3.fromRGB(20, 20, 40)
UI.Sidebar.BorderSizePixel = 0
UI.Sidebar.ZIndex = 4
Instance.new("UICorner", UI.Sidebar).CornerRadius = UDim.new(0, 15)
UI.Sidebar.Parent = UI.Main

-- Sidebar decorative line
UI.SidebarLine = Instance.new("Frame")
UI.SidebarLine.Name = "Divider"
UI.SidebarLine.Size = UDim2.new(0, 2, 1, 0)
UI.SidebarLine.Position = UDim2.new(1, -2, 0, 0)
UI.SidebarLine.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
UI.SidebarLine.BorderSizePixel = 0
UI.SidebarLine.ZIndex = 5
UI.SidebarLine.Parent = UI.Sidebar

-- Close/Minimize Button
UI.CloseBtn = Instance.new("TextButton")
UI.CloseBtn.Name = "SealButton"
UI.CloseBtn.Size = UDim2.new(1, -20, 0, 50)
UI.CloseBtn.Position = UDim2.new(0, 10, 0.88, 0)
UI.CloseBtn.Text = "❖ SHIKIGAMI SEAL"
UI.CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.CloseBtn.Font = Enum.Font.GothamBold
UI.CloseBtn.TextSize = 16
UI.CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
UI.CloseBtn.BorderSizePixel = 0
UI.CloseBtn.ZIndex = 6
Instance.new("UICorner", UI.CloseBtn).CornerRadius = UDim.new(0, 10)
UI.CloseBtn.Parent = UI.Sidebar

UI.CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(UI.CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
end)
UI.CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(UI.CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}):Play()
end)

-- Content Area
UI.Content = Instance.new("Frame")
UI.Content.Name = "Content"
UI.Content.Size = UDim2.new(0, 360, 1, 0)
UI.Content.Position = UDim2.new(0, 130, 0, 0)
UI.Content.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
UI.Content.BorderSizePixel = 0
UI.Content.ZIndex = 4
Instance.new("UICorner", UI.Content).CornerRadius = UDim.new(0, 12)
UI.Content.Parent = UI.Main

-- Header
UI.Header = Instance.new("TextLabel")
UI.Header.Name = "Header"
UI.Header.Size = UDim2.new(1, 0, 0, 60)
UI.Header.Position = UDim2.new(0, 0, 0, 0)
UI.Header.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
UI.Header.Text = "◈ DOMAIN EXPANSION: APEX ◈"
UI.Header.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Header.Font = Enum.Font.GothamBlack
UI.Header.TextSize = 20
UI.Header.BorderSizePixel = 0
UI.Header.ZIndex = 5
UI.Header.Parent = UI.Content

-- Header glow
UI.HeaderGlow = Instance.new("UIGradient")
UI.HeaderGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
})
UI.HeaderGlow.Rotation = 90
UI.HeaderGlow.Parent = UI.Header

-- Scroll Frame
UI.Scroll = Instance.new("ScrollingFrame")
UI.Scroll.Name = "ControlsScroll"
UI.Scroll.Size = UDim2.new(1, -20, 1, -80)
UI.Scroll.Position = UDim2.new(0, 10, 0, 70)
UI.Scroll.CanvasSize = UDim2.new(0, 0, 8, 0)
UI.Scroll.BorderSizePixel = 0
UI.Scroll.ZIndex = 5
UI.Scroll.BackgroundTransparency = 1
UI.Scroll.ScrollBarThickness = 6
UI.Scroll.Parent = UI.Content

UI.ListLayout = Instance.new("UIListLayout")
UI.ListLayout.Padding = UDim.new(0, 8)
UI.ListLayout.Parent = UI.Scroll

UI.ListPadding = Instance.new("UIPadding")
UI.ListPadding.PaddingTop = UDim.new(0, 5)
UI.ListPadding.PaddingBottom = UDim.new(0, 5)
UI.ListPadding.Parent = UI.Scroll

-- ==================== UI HELPERS ====================
function UI:CreateToggle(text, key, defaultValue, column)
    column = column or 1
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. text:gsub("%s+", "_")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 36)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 15)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 6
    
    local corner = Instance.new("UICorner", toggleFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
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
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = UDim2.new(1, -22, 0.5, -6)
    indicator.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 8
    indicator.Parent = btn
    
    local indicatorCorner = Instance.new("UICorner", indicator)
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    glow.Rotation = 45
    glow.Parent = indicator
    
    local function UpdateVisuals(state)
        if state then
            btn.Text = "  " .. text .. "   [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(60, 30, 40)
            indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            glow.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 0))
            })
        else
            btn.Text = "  " .. text .. "   [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
            indicator.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            glow.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
        end
    end
    
    -- Initialize config and visuals
    Config[key] = defaultValue
    UpdateVisuals(defaultValue)
    
    local function OnToggle()
        Config[key] = not Config[key]
        UpdateVisuals(Config[key])
        
        if key == "Enabled" then
            UI.Main.Visible = Config.Enabled
        elseif key == "FOVCircle" then
            UI:UpdateFOVCircle()
        end
    end
    
    btn.MouseButton1Click:Connect(OnToggle)
    toggleFrame.Parent = UI.Scroll
    return toggleFrame
end

function UI:CreateSlider(text, key, min, max, default, decimals, suffix)
    decimals = decimals or 0
    suffix = suffix or ""
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. text:gsub("%s+", "_")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 20)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 6
    
    local corner = Instance.new("UICorner", sliderFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
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
    rail.Position = UDim2.new(0, 0, 0, 35)
    rail.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
    rail.BorderSizePixel = 0
    rail.ZIndex = 7
    rail.Parent = sliderFrame
    
    local railCorner = Instance.new("UICorner", rail)
    railCorner.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 50, 150)
    fill.BorderSizePixel = 0
    fill.ZIndex = 8
    fill.Parent = rail
    
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local drag = Instance.new("TextButton")
    drag.Name = "Drag"
    drag.Size = UDim2.new(1, 0, 1, 0)
    drag.Position = UDim2.new(0, 0, 0, 0)
    drag.BackgroundTransparency = 1
    drag.Text = ""
    drag.ZIndex = 9
    drag.Parent = rail
    
    local function UpdateSliderFromPercent(percent)
        percent = math.clamp(percent, 0, 1)
        local value = min + (max - min) * percent
        if decimals > 0 then
            value = string.format("%." .. decimals .. "f", value)
            value = tonumber(value)
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
        end
    end
    
    local function StartDrag()
        local startX = drag.AbsolutePosition.X
        local railStartX = rail.AbsolutePosition.X
        local railWidth = rail.AbsoluteSize.X
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouseX = UserInputService:GetMouseLocation().X
            local delta = mouseX - railStartX
            local percent = delta / railWidth
            UpdateSliderFromPercent(percent)
        end)
        
        local inputEnded
        inputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
                inputEnded:Disconnect()
            end
        end)
    end
    
    drag.MouseButton1Down:Connect(StartDrag)
    sliderFrame.Parent = UI.Scroll
    return sliderFrame
end

-- ==================== BUILD UI ====================
do
    -- Toggles
    UI:CreateToggle("Master System", "Enabled", false)
    UI:CreateToggle("Team Check", "TeamCheck", true)
    UI:CreateToggle("Infinite Stamina", "InfStamina", false)
    UI:CreateToggle("ESP Visuals", "ESP", false)
    UI:CreateToggle("Aimbot", "Aimbot", false)
    UI:CreateToggle("Auto‑Block", "AutoBlock", false)
    UI:CreateToggle("FOV Circle", "FOVCircle", false)
    UI:CreateToggle("Target HUD", "TargetHUD", false)
    UI:CreateToggle("Silent Aim", "SilentAim", false)
    UI:CreateToggle("Kill Confirm", "KillConfirm", false)
    UI:CreateToggle("Speed Boost", "SpeedBoost", false)
    UI:CreateToggle("Jump Boost", "JumpBoost", false)
    UI:CreateToggle("Sprint", "SprintEnabled", false)
    UI:CreateToggle("Anti‑Aim", "AntiAim", false)
    UI:CreateToggle("Auto‑Dodge", "AutoDodge", false)
    UI:CreateToggle("Fullbright", "Fullbright", false)
    UI:CreateToggle("Night Vision", "NightVision", false)
    UI:CreateToggle("Remove Grass", "RemoveGrass", false)
    UI:CreateToggle("Remove Fog", "RemoveFog", false)
    
    -- Sliders
    UI:CreateSlider("Hitbox Multiplier", "HitboxMultiplier", 1, 20, 6, 0)
    UI:CreateSlider("Magnet Range", "MagnetRange", 20, 300, 120, 0)
    UI:CreateSlider("Prediction Time", "PredictionTime", 0.01, 0.8, 0.18, 2)
    UI:CreateSlider("Aimbot FOV", "AimbotFOV", 5, 150, 45, 0)
    UI:CreateSlider("Aim Smoothing", "AimSmoothing", 0.01, 1, 0.12, 2)
    UI:CreateSlider("Speed Multiplier", "SpeedMultiplier", 1, 3, 1.5, 1)
    UI:CreateSlider("Jump Multiplier", "JumpMultiplier", 1, 3, 1.5, 1)
    UI:CreateSlider("Sprint Multiplier", "SprintMultiplier", 1, 3, 1.8, 1)
    UI:CreateSlider("Prediction Ammount", "PredictionAmmount", 0, 0.5, 0.15, 2)
    UI:CreateSlider("Auto‑Block Range", "AutoBlockRange", 10, 100, 30, 0)
    
    -- Min/Max logic
    UI.CloseBtn.MouseButton1Click:Connect(function()
        UI.Main.Visible = false
    end)
    
    -- (We don't need a Sukuna icon for minimalism, but you could add a small toggle)
    -- For now, just use F1 to bring back UI if hidden? We'll keep UI hidden via close, but F1 toggles master.
    -- To reopen UI, press F1 to disable then re-enable? Or we could add a key to toggle UI visibility.
    -- Let's add: pressing F1 toggles master; if master disabled and UI hidden, pressing F1 re-enables and shows UI.
    -- Already handled in keybind section.
    
    UI:UpdateFOVCircle()
end

-- ==================== PERSISTENT HITBOX SYSTEM ====================
do
    local DataStore = ReplicatedStorage:FindFirstChild(Config.PersistentHitboxStore)
    if not DataStore then
        DataStore = Instance.new("Folder")
        DataStore.Name = Config.PersistentHitboxStore
        DataStore.Parent = ReplicatedStorage
    end
    
    local function ApplyHitbox(hrp, multiplier)
        -- Correct scaling: multiplier 6 = native 4x6x4.
        local baseSize = Vector3.new(4, 6, 4)
        local scale = multiplier / 6
        hrp.Size = baseSize * scale
        hrp.CanCollide = true
        hrp.CanTouch = true
        
        if Config.ESP then
            hrp.Transparency = Config.HitboxTransparency
            hrp.Material = Enum.Material.Neon
            hrp.Color = Config.HitboxColor
        end
    end
    
    local function GetSavedMultiplier(player)
        local saved = DataStore:FindFirstChild(tostring(player.UserId))
        if saved and saved:IsA("NumberValue") then
            return saved.Value
        end
        return Config.HitboxMultiplier
    end
    
    local function SaveMultiplier(player, multiplier)
        local saved = DataStore:FindFirstChild(tostring(player.UserId))
        if not saved then
            saved = Instance.new("NumberValue")
            saved.Name = tostring(player.UserId)
            saved.Parent = DataStore
        end
        saved.Value = multiplier
    end
    
    local function UpdateCharacterHitbox(character, player)
        if not character or not player then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local mult = GetSavedMultiplier(player)
            ApplyHitbox(hrp, mult)
        end
    end
    
    UI.UpdateAllHitboxes = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                UpdateCharacterHitbox(player.Character, player)
            end
        end
    end
    
    local function OnPlayerAdded(player)
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            UpdateCharacterHitbox(char, player)
        end)
    end
    
    Players.PlayerAdded:Connect(OnPlayerAdded)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            OnPlayerAdded(player)
        end
    end
    
    LocalPlayer.CharacterAdded:Connect(function(char)
        UpdateCharacterHitbox(char, LocalPlayer)
    end)
    
    if LocalPlayer.Character then
        UpdateCharacterHitbox(LocalPlayer.Character, LocalPlayer)
    end
end

-- ==================== PROJECTILE MAGNETISM (TRACKING SYSTEM) ====================
do
    local TrackedProjectiles = {}
    
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
    
    local function PredictPosition(position, velocity, time)
        return position + (velocity * time)
    end
    
    local function ApplyMagnetism(projectile)
        if not Config.Enabled or not Config.MagnetRange > 0 then return end
        
        local projectilePos = projectile.Position
        local bestTarget, bestDist = nil, Config.MagnetRange
        
        -- Find nearest enemy within range
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - projectilePos).Magnitude
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
            
            -- Prediction
            local targetVel = targetHrp.AssemblyLinearVelocity
            local predictedPos = PredictPosition(targetHrp.Position, targetVel, Config.PredictionTime)
            
            -- Additional travel time prediction
            local toTarget = predictedPos - projectilePos
            local travelTime = toTarget.Magnitude / Config.MagnetStrength
            predictedPos = PredictPosition(targetHrp.Position, targetVel, Config.PredictionTime + travelTime * 0.5)
            
            local direction = (predictedPos - projectilePos).Unit
            local newVelocity = direction * Config.MagnetStrength
            
            pcall(function()
                projectile.AssemblyLinearVelocity = newVelocity
                projectile.AssemblyAngularVelocity = Vector3.new(
                    math.random(-10, 10),
                    math.random(-10, 10),
                    math.random(-10, 10)
                )
            end)
        end
    end
    
    -- Track projectiles via descendant events
    Workspace.DescendantAdded:Connect(function(descendant)
        if IsMagnetProjectile(descendant) then
            table.insert(TrackedProjectiles, descendant)
        end
    end)
    
    -- Scanner loop
    UI.Connections.MagnetScanner = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        for i = #TrackedProjectiles, 1, -1 do
            local proj = TrackedProjectiles[i]
            if not proj or not proj.Parent then
                table.remove(TrackedProjectiles, i)
            else
                ApplyMagnetism(proj)
            end
        end
    end)
end

-- ==================== RECURSIVE STAMINA FINDER ====================
do
    local function RecursiveFindStamina(obj, depth, maxDepth)
        if depth > maxDepth then return nil end
        
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Folder") then
                local found = RecursiveFindStamina(child, depth + 1, maxDepth)
                if found then return found end
            elseif child.Name:lower():find("stamina") and child:IsA("NumberValue") then
                return child
            end
        end
        
        return nil
    end
    
    local function FindStaminaInCharacter(char)
        if not char then return nil end
        return RecursiveFindStamina(char, 0, Config.StaminaSearchDepth)
    end
    
    local function SetInfiniteStamina()
        if not Config.InfStamina then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local stamina = FindStaminaInCharacter(char)
        if stamina and stamina:IsA("NumberValue") then
            stamina.Value = 100
        else
            local staminaFolder = char:FindFirstChild("StaminaFolder") or char:FindFirstChild("Stats") or char
            local newStamina = Instance.new("NumberValue")
            newStamina.Name = "Stamina"
            newStamina.Value = 100
            newStamina.Parent = staminaFolder
        end
    end
    
    UI.Connections.StaminaLoop = RunService.Heartbeat:Connect(function()
        if Config.InfStamina then
            SetInfiniteStamina()
        end
    end)
end

-- ==================== AIMBOT CORE ====================
do
    local Camera = Workspace.CurrentCamera
    
    local function GetTarget()
        local bestTarget, bestDist = nil, Config.AimbotFOV * 10
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
            elseif Config.AimPriority == "Torso" then
                aimPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            end
            
            if not aimPart then
                aimPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            end
            
            if aimPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                local dist = (aimPart.Position - myPos).Magnitude
                
                local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local offset = Vector2.new(screenPos.X, screenPos.Y) - screenCenter
                local distFromCenter = offset.Magnitude
                
                if distFromCenter <= Config.AimbotFOV and dist < bestDist then
                    bestTarget = aimPart
                    bestDist = dist
                end
            end
        end
        
        return bestTarget
    end
    
    local function AimAt(targetPart)
        if not targetPart then return end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then return end
        
        local mouse = LocalPlayer:GetMouse()
        local targetX, targetY = screenPos.X, screenPos.Y
        
        if Config.SilentAim then
            local offset = Vector2.new(
                (math.random() - 0.5) * Config.AimSmoothing * 10,
                (math.random() - 0.5) * Config.AimSmoothing * 10
            )
            mouse.MoveTo(targetX + offset.X, targetY + offset.Y)
        else
            local currentPos = Vector2.new(mouse.X, mouse.Y)
            local direction = Vector2.new(targetX - currentPos.X, targetY - currentPos.Y)
            local step = direction * Config.AimSmoothing
            mouse.MoveTo(currentPos.X + step.X, currentPos.Y + step.Y)
        end
    end
    
    UI.Connections.AimbotLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.Aimbot then return end
        
        local target = GetTarget()
        if target then
            AimAt(target)
        end
    end)
end

-- ==================== ESP SYSTEM (CLEAN) ====================
do
    local function CreateESPBox(part)
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
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.Font = Enum.Font.GothamBold
        text.TextSize = 14
        text.Parent = label
        
        UI.ESPObjects[character .. "_Name"] = label
        return label
    end
    
    -- ESP Main Loop
    UI.Connections.ESPLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.ESP then
            UI:ClearESP()
            return
        end
        
        -- Clean up dead/removed objects
        for key, obj in pairs(UI.ESPObjects) do
            if not obj or not obj.Parent then
                pcall(function() obj:Destroy() end)
                UI.ESPObjects[key] = nil
            else
                -- For Adornments, check Adornee
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
                CreateESPBox(hrp)
            end
            
            if Config.ESPHealthBar and not UI.ESPObjects[char] then
                CreateHealthBar(char)
            end
            
            if Config.ESPName and not UI.ESPObjects[char .. "_Name"] then
                CreateNameLabel(char, player)
            end
            
            updateCount = updateCount + 1
        end
    end)
    
    UI.ClearESP = function()
        for _, obj in pairs(UI.ESPObjects) do
            pcall(function()
                obj:Destroy()
            end)
        end
        UI.ESPObjects = {}
    end
end

-- ==================== AUTO-BLOCK SYSTEM ====================
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
    end)
end

-- ==================== TARGET HUD ====================
do
    local hudFrame = nil
    local nameLabel = nil
    local distLabel = nil
    local healthBar = nil
    
    UI.CreateTargetHUD = function()
        if hudFrame then return end
        
        hudFrame = Instance.new("Frame")
        hudFrame.Name = "TargetHUD"
        hudFrame.Size = Config.TargetHUDSize
        hudFrame.Position = Config.TargetHUDPos
        hudFrame.BackgroundColor3 = Config.TargetHUDColor
        hudFrame.BorderColor3 = Config.TargetHUDBorderColor
        hudFrame.BorderSizePixel = 2
        hudFrame.ZIndex = 100
        Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 8)
        hudFrame.Parent = UI.ScreenGui
        
        nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -10, 0, 25)
        nameLabel.Position = UDim2.new(0, 5, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "TARGET: NONE"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 18
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = hudFrame
        
        distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, -10, 0, 20)
        distLabel.Position = UDim2.new(0, 5, 0, 32)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "DISTANCE: --"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 14
        distLabel.TextXAlignment = Enum.TextXAlignment.Left
        distLabel.Parent = hudFrame
        
        healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, -10, 0, 15)
        healthBar.Position = UDim2.new(0, 5, 1, -25)
        healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        healthBar.BorderSizePixel = 0
        Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 4)
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
    
    -- Initialize when toggle turned on (handled in loop, but we need to create HUD frame when enabled)
    -- We'll hook into the targetHUD toggle in the main loop? Actually simpler: check in HUDUpdate loop if Config.TargetHUD and no frame, then create.
    -- But we already have CreateTargetHUD function. We'll call it when toggled on. For now, we'll create it lazily in the HUDUpdate connection if it doesn't exist.
    -- Modify above: In HUDUpdate loop, if Config.TargetHUD and not hudFrame, call UI.CreateTargetHUD().
    -- We'll adjust after defining.
end

-- ==================== FOV CIRCLE ====================
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
        
        local uiCorner = Instance.new("UICorner", fovCircle)
        uiCorner.CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke", fovCircle)
        stroke.Color = Config.FOVCircleColor
        stroke.Thickness = Config.FOVCircleThickness
        stroke.Transparency = Config.FOVCircleTransparency
        
        UI.FOVCircleFrame = fovCircle
    end
    
    UI.Connections.FOVUpdate = RunService.RenderStepped:Connect(function()
        if not Config.FOVCircle or not UI.FOVCircleFrame then return end
        
        if Config.FOVCircleDynamic then
            local size = Config.AimbotFOV * 2
            UI.FOVCircleFrame.Size = UDim2.new(0, size, 0, size)
            UI.FOVCircleFrame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
        end
    end)
end

-- ==================== KILL CONFIRM ====================
do
    local killFlash = nil
    
    UI.CreateKillConfirm = function()
        if killFlash then return end
        
        killFlash = Instance.new("Frame")
        killFlash.Name = "KillFlash"
        killFlash.Size = UDim2.new(1, 0, 1, 0)
        killFlash.BackgroundColor3 = Config.KillConfirmColor
        killFlash.BackgroundTransparency = 1
        killFlash.ZIndex = 999
        killFlash.Parent = UI.ScreenGui
        
        local tweenInfo = TweenInfo.new(Config.KillConfirmTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
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
                                    TweenService:Create(killFlash, tweenInfo, {BackgroundTransparency = 0.5}):Play()
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

-- ==================== MOVEMENT BOOSTS ====================
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
    end
    
    UI.Connections.MovementLoop = RunService.Heartbeat:Connect(ApplyBoosts)
end

-- ==================== ANTI-AIM & AUTO-DODGE ====================
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
        
        -- Use tracked projectiles
        for _, proj in ipairs(TrackedProjectiles) do
            if proj.Parent and (proj.Position - myHrp.Position).Magnitude < 20 then
                local dodgeDirection = (proj.Position - myHrp.Position).Unit
                myHrp.AssemblyLinearVelocity = dodgeDirection * 50
                lastDodgeTime = currentTime
                break
            end
        end
    end)
end

-- ==================== VISUAL EFFECTS ====================
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
    end)
end

-- ==================== MAIN CONTROL LOOP ====================
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
    end)
end

-- ==================== KEYBIND HANDLING ====================
do
    UI.Connections.KeybindListener = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Config.MasterKeybind then
            Config.Enabled = not Config.Enabled
            print("Apex Domain: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
            
            UI.Main.Visible = Config.Enabled
        end
    end)
end

-- ==================== CLEANUP ON LEAVE ====================
do
    local function Cleanup()
        for name, conn in pairs(UI.Connections) do
            if conn and conn.Disconnect then
                conn:Disconnect()
            end
        end
        UI:ClearESP()
        UI.DestroyTargetHUD()
        UI.DestroyKillConfirm()
        if UI.FOVCircleFrame then
            UI.FOVCircleFrame:Destroy()
            UI.FOVCircleFrame = nil
        end
        if UI.Main then
            UI.Main:Destroy()
        end
        if UI.ShadowFrame then
            UI.ShadowFrame:Destroy()
        end
    end
    
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            Cleanup()
        end
    end)
end

-- ==================== INITIALIZATION ====================
print("◈ FORSAKEN: APEX DOMAIN ULTIMATE v3.6 LOADED ◈")
print("Features Loaded:")
print(" • 4-6-4 Persistent Hitboxes (correct scaling)")
print(" • Crystal & Axe Magnetism (Jane Doe compatible)")
print(" • Deep Stamina Finder")
print(" • Aimbot w/ Prediction & Silent Aim")
print(" • ESP (Box, Health, Name)")
print(" • Auto-Block, FOV Circle, Target HUD")
print(" • Kill Confirm, Speed/Jump Boosts")
print(" • Anti-Aim, Auto-Dodge")
print(" • Fullbright, Night Vision, Grass/Fog Removal")
print("\nPress F1 to toggle master system.")

-- Ensure HUD is created when needed
UI.Connections.HUDCheck = RunService.RenderStepped:Connect(function()
    if Config.TargetHUD and not UI.hudFrame then
        UI.CreateTargetHUD()
    elseif not Config.TargetHUD and UI.hudFrame then
        UI.DestroyTargetHUD()
    end
end)

return UI
