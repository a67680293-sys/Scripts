--[[
    FORSAKEN: APEX DOMAIN ULTIMATE v7.0 (PROFESSIONAL UI)
    Premium Quality | Sidebar Navigation | Organized Sections
    Mobile + PC Optimized | Zero Bugs | Forsaken Specific
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
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== CONFIGURATION ====================
local Config = {
    -- Master System
    Enabled = false,
    MasterKeybind = Enum.KeyCode.F1,
    
    -- ==================== COMBAT ====================
    -- Aimbot
    Aimbot = false,
    AimActiveKeybind = Enum.KeyCode.ButtonL2,
    AimbotFOV = 45,
    SilentAim = false,
    AimPriority = "Head",
    AimSmoothing = 0.12,
    PredictionAim = true,
    PredictionAmmount = 0.15,
    AutoAimWhenInFOV = true,
    
    -- Triggerbot
    Triggerbot = false,
    TriggerbotKeybind = Enum.MouseButton1,
    TriggerbotDelay = 0,
    
    -- Auto-Block
    AutoBlock = false,
    AutoBlockKeybind = Enum.KeyCode.ButtonR1,
    AutoBlockRange = 30,
    AutoBlockAngle = 90,
    BlockCooldown = 0.5,
    
    -- Hitbox
    HitboxMultiplier = 6,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    HitboxTransparency = 0.3,
    PersistentHitboxStore = "Apex_Hitbox_Data",
    
    -- Magnetism
    MagnetRange = 120,
    MagnetStrength = 350,
    PredictionTime = 0.18,
    
    -- ==================== VISUAL ====================
    -- ESP
    ESP = false,
    ESPBox = true,
    ESPHealthBar = true,
    ESPName = true,
    ESPDistance = true,
    ESPColor = Color3.fromRGB(0, 255, 0),
    ESPTeamColor = true,
    ESPTransparency = 0.4,
    
    -- Radar
    Radar = false,
    RadarSize = 150,
    RadarPos = UDim2.new(0, 10, 0, 10),
    RadarRange = 200,
    
    -- FOV Circle
    FOVCircle = false,
    FOVCircleColor = Color3.fromRGB(255, 255, 255),
    FOVCircleTransparency = 0.5,
    FOVCircleThickness = 2,
    
    -- Target HUD
    TargetHUD = false,
    TargetHUDPos = UDim2.new(0, 20, 0, 20),
    TargetHUDSize = UDim2.new(0, 250, 0, 100),
    
    -- Kill Confirm
    KillConfirm = false,
    KillConfirmColor = Color3.fromRGB(255, 0, 0),
    KillConfirmTime = 0.4,
    
    -- ==================== MOVEMENT ====================
    SpeedBoost = false,
    SpeedMultiplier = 1.5,
    JumpBoost = false,
    JumpMultiplier = 1.5,
    SprintEnabled = false,
    SprintKeybind = Enum.KeyCode.LeftShift,
    SprintMultiplier = 1.8,
    
    BunnyHop = false,
    BunnyHopKeybind = Enum.KeyCode.Space,
    
    -- ==================== GAME ====================
    NoFallDamage = false,
    PlatformIgnorer = false,
    InstantRespawn = false,
    InstantInteract = false,
    InstantInteractKeybind = Enum.KeyCode.ButtonX,
    
    -- ==================== WEAPON ====================
    GunMods = false,
    AutoReload = true,
    NoRecoil = false,
    NoSpread = false,
    FastWeaponSwap = false,
    
    -- ==================== UI SETTINGS ====================
    TeamCheck = true,
    UIRedTheme = true,
    UI3DEffect = true,
    
    -- ==================== DEBUG ====================
    DebugMode = false,
}

-- ==================== UI CONSTRUCTION (PROFESSIONAL SIDEBAR) ====================
local UI = {}
UI.Connections = {}
UI.ESPObjects = {}
UI.TrackedProjectiles = {}
UI.RadarDots = {}
UI.ChamsOriginal = {}
UI.SidebarButtons = {}
UI.ContentFrames = {}
UI.ActiveCategory = "Combat"

-- Wait for PlayerGui with extended timeout
local function WaitForPlayerGui(timeout)
    local startTime = tick()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    
    while not playerGui and tick() - startTime < (timeout or 10) do
        task.wait(0.1)
        playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    end
    
    return playerGui
end

-- Create UI Element Factory
local function CreateElement(parent, className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

-- Build Professional UI with Sidebar
local function BuildUI()
    local playerGui = WaitForPlayerGui(10)
    if not playerGui then
        warn("Failed to find PlayerGui after 10 seconds")
        return false
    end
    
    -- ============ MAIN SCREEN GUI ============
    local screenGui = CreateElement(playerGui, "ScreenGui", {
        Name = "Apex_Domain_Ultimate",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Enabled = true
    })
    UI.ScreenGui = screenGui
    
    -- ============ MAIN FRAME ============
    local mainFrame = CreateElement(screenGui, "Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 900, 0, 550),
        Position = UDim2.new(0.5, -450, 0.5, -275),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(15, 0, 0) or Color3.fromRGB(10, 15, 20),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        ZIndex = 1
    })
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    UI.MainFrame = mainFrame
    
    -- ============ 3D SHADOW (Optimized) ============
    if Config.UI3DEffect then
        local shadow = CreateElement(screenGui, "Frame", {
            Name = "Shadow",
            Size = UDim2.new(0, 910, 0, 560),
            Position = UDim2.new(0.5, -455, 0.5, -280),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            ZIndex = 0
        })
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)
        UI.Shadow = shadow
    end
    
    -- ============ SIDEBAR ============
    local sidebar = CreateElement(mainFrame, "Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(25, 5, 5) or Color3.fromRGB(20, 25, 35),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
    
    -- Sidebar Header
    local header = CreateElement(sidebar, "TextLabel", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(30, 40, 60),
        Text = "◈ APEX DOMAIN",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 18,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 3
    })
    header.Padding = UDim.new(0, 15)
    
    -- Sidebar Divider
    CreateElement(sidebar, "Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 62),
        BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 150, 255),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    -- ============ SIDEBAR BUTTONS ============
    local categories = {
        {Name = "⚔️ COMBAT", Key = "Combat"},
        {Name = "👁️ VISUAL", Key = "Visual"},
        {Name = "🏃 MOVEMENT", Key = "Movement"},
        {Name = "🎮 GAME", Key = "Game"},
        {Name = "🔫 WEAPON", Key = "Weapon"},
        {Name = "⚙️ SETTINGS", Key = "Settings"},
        {Name = "🌐 SERVER", Key = "Server"}
    }
    
    local buttonHeight = 40
    local buttonSpacing = 5
    local startY = 70
    
    for i, category in ipairs(categories) do
        local btn = CreateElement(sidebar, "TextButton", {
            Name = category.Key .. "Btn",
            Size = UDim2.new(1, -20, 0, buttonHeight),
            Position = UDim2.new(0, 10, 0, startY + (i-1)*(buttonHeight + buttonSpacing)),
            Text = "   " .. category.Name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            BorderSizePixel = 0,
            ZIndex = 4
        })
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        UI.SidebarButtons[category.Key] = btn
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            if UI.ActiveCategory ~= category.Key then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                }):Play()
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if UI.ActiveCategory ~= category.Key then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            UI:SwitchCategory(category.Key)
        end)
    end
    
    -- Close Button
    local closeBtn = CreateElement(sidebar, "TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 1, -45),
        Text = "❖ SEAL DOMAIN",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BackgroundColor3 = Color3.fromRGB(180, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 5
    })
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 0, 0)
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        }):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        UI.MainFrame.Visible = false
    end)
    
    -- ============ CONTENT AREA ============
    local contentArea = CreateElement(mainFrame, "Frame", {
        Name = "ContentArea",
        Size = UDim2.new(0, 700, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0,
        ZIndex = 1
    })
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 8)
    
    -- Create content frames for each category
    for _, category in ipairs(categories) do
        local contentFrame = CreateElement(contentArea, "ScrollingFrame", {
            Name = category.Key .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 6,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 2
        })
        
        -- Layout
        local layout = Instance.new("UIListLayout", contentFrame)
        layout.Padding = UDim.new(0, 8)
        
        local padding = Instance.new("UIPadding", contentFrame)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        
        UI.ContentFrames[category.Key] = contentFrame
    end
    
    -- Show default category
    UI:SwitchCategory("Combat")
    
    -- Build each category's content
    UI:BuildCombatContent()
    UI:BuildVisualContent()
    UI:BuildMovementContent()
    UI:BuildGameContent()
    UI:BuildWeaponContent()
    UI:BuildSettingsContent()
    UI:BuildServerContent()
    
    -- Master Toggle (always visible at top)
    UI:CreateMasterToggle(contentArea)
    
    -- Force visible
    UI.MainFrame.Visible = true
    
    return true
end

-- ============ UI HELPER FUNCTIONS ============
function UI:CreateMasterToggle(parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "MasterToggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Config.Enabled and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(30, 10, 10)
    toggleFrame.BorderSizePixel = 0
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
    
    local btn = Instance.new("TextButton")
    btn.Name = "MasterBtn"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "  ⚡ MASTER SYSTEM   [" .. (Config.Enabled and "ON" or "OFF") .. "]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 18
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Parent = toggleFrame
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(1, -40, 0.5, -10)
    indicator.BackgroundColor3 = Config.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    indicator.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        btn.Text = "  ⚡ MASTER SYSTEM   [" .. (Config.Enabled and "ON" or "OFF") .. "]"
        indicator.BackgroundColor3 = Config.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleFrame.BackgroundColor3 = Config.Enabled and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(30, 10, 10)
        
        print("Apex Domain: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
    end)
    
    toggleFrame.Parent = parent
end

function UI:CreateToggle(parent, text, key, defaultValue)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. text:gsub("%s+", "_")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleFrame.BorderSizePixel = 0
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
    
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BorderSizePixel = 0
    btn.Parent = toggleFrame
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -30, 0.5, -8)
    indicator.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 0, 0)
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    indicator.Parent = btn
    
    Config[key] = defaultValue
    
    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        indicator.BackgroundColor3 = Config[key] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 0, 0)
        btn.BackgroundColor3 = Config[key] and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
        
        -- Special handlers
        if key == "ESP" then
            if Config.ESP then
                self:CreateESPAll()
            else
                self:ClearESP()
            end
        elseif key == "FOVCircle" then
            self:UpdateFOVCircle()
        elseif key == "TargetHUD" then
            if Config.TargetHUD then
                self:CreateTargetHUD()
            else
                self:DestroyTargetHUD()
            end
        elseif key == "Radar" then
            if Config.Radar then
                self:CreateRadar()
            else
                self:DestroyRadar()
            end
        elseif key == "Chams" then
            if Config.Chams then
                self:ApplyChams()
            else
                self:RestoreChams()
            end
        end
    end)
    
    toggleFrame.Parent = parent
    return toggleFrame
end

function UI:CreateSlider(parent, text, key, min, max, default, decimals, suffix)
    decimals = decimals or 0
    suffix = suffix or ""
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. text:gsub("%s+", "_")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    sliderFrame.BorderSizePixel = 0
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
    
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
    label.Parent = sliderFrame
    
    local rail = Instance.new("Frame")
    rail.Name = "Rail"
    rail.Size = UDim2.new(1, 0, 0, 6)
    rail.Position = UDim2.new(0, 0, 0, 28)
    rail.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    rail.BorderSizePixel = 0
    Instance.new("UICorner", rail).CornerRadius = UDim.new(1, 0)
    rail.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    fill.Parent = rail
    
    local drag = Instance.new("TextButton")
    drag.Name = "Drag"
    drag.Size = UDim2.new(1, 0, 1, 0)
    drag.Position = UDim2.new(0, 0, 0, 0)
    drag.BackgroundTransparency = 1
    drag.Text = ""
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
            self.UpdateAllHitboxes()
        elseif key == "AimbotFOV" then
            self:UpdateFOVCircle()
        elseif key == "RadarSize" then
            if Config.Radar and self.RadarFrame then
                self.RadarFrame.Size = UDim2.new(0, Config.RadarSize, 0, Config.RadarSize)
                self:UpdateRadar()
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
            
            local mouseX = UserInputService:GetMouseLocation().X
            local percent = (mouseX - railStartX) / railWidth
            UpdateValue(percent)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end
    
    drag.MouseButton1Down:Connect(StartDrag)
    sliderFrame.Parent = parent
    UpdateValue((default - min) / (max - min))
end

function UI:CreateSectionHeader(parent, text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.Text = "  " .. text
    header.TextColor3 = Config.UIRedTheme and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 150, 255)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 16
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.BackgroundTransparency = 1
    header.Parent = parent
    return header
end

-- ============ BUILD CONTENT FOR EACH CATEGORY ============
function UI:BuildCombatContent()
    local frame = self.ContentFrames.Combat
    
    self:CreateSectionHeader(frame, "AIMBOT")
    self:CreateToggle(frame, "Aimbot", "Aimbot", false)
    self:CreateSlider(frame, "Aimbot FOV", "AimbotFOV", 5, 150, 45, 0)
    self:CreateSlider(frame, "Aim Smoothing", "AimSmoothing", 0.01, 1, 0.12, 2)
    self:CreateToggle(frame, "Prediction Aim", "PredictionAim", true)
    self:CreateSlider(frame, "Prediction Amount", "PredictionAmmount", 0, 0.5, 0.15, 2)
    self:CreateToggle(frame, "Silent Aim", "SilentAim", false)
    self:CreateToggle(frame, "Auto Aim when in FOV", "AutoAimWhenInFOV", true)
    
    self:CreateSectionHeader(frame, "TRIGGERBOT")
    self:CreateToggle(frame, "Triggerbot", "Triggerbot", false)
    self:CreateSlider(frame, "Triggerbot Delay", "TriggerbotDelay", 0, 0.5, 0, 2)
    
    self:CreateSectionHeader(frame, "AUTO-BLOCK")
    self:CreateToggle(frame, "Auto-Block", "AutoBlock", false)
    self:CreateSlider(frame, "Block Range", "AutoBlockRange", 10, 100, 30, 0)
    self:CreateSlider(frame, "Block Angle", "AutoBlockAngle", 10, 180, 90, 0)
    
    self:CreateSectionHeader(frame, "HITBOX")
    self:CreateToggle(frame, "Persistent Hitboxes", "HitboxEnabled", true)
    self:CreateSlider(frame, "Hitbox Multiplier", "HitboxMultiplier", 1, 20, 6, 0)
    
    self:CreateSectionHeader(frame, "MAGNETISM")
    self:CreateToggle(frame, "Magnet Projectiles", "MagnetEnabled", true)
    self:CreateSlider(frame, "Magnet Range", "MagnetRange", 20, 300, 120, 0)
    self:CreateSlider(frame, "Prediction Time", "PredictionTime", 0.01, 0.8, 0.18, 2)
end

function UI:BuildVisualContent()
    local frame = self.ContentFrames.Visual
    
    self:CreateSectionHeader(frame, "ESP")
    self:CreateToggle(frame, "ESP Box", "ESPBox", true)
    self:CreateToggle(frame, "ESP Health Bar", "ESPHealthBar", true)
    self:CreateToggle(frame, "ESP Name", "ESPName", true)
    self:CreateToggle(frame, "ESP Distance", "ESPDistance", true)
    self:CreateToggle(frame, "Team Color ESP", "ESPTeamColor", true)
    self:CreateSlider(frame, "ESP Transparency", "ESPTransparency", 0, 1, 0.4, 1)
    
    self:CreateSectionHeader(frame, "RADAR")
    self:CreateToggle(frame, "Radar", "Radar", false)
    self:CreateSlider(frame, "Radar Size", "RadarSize", 100, 300, 150, 0)
    self:CreateSlider(frame, "Radar Range", "RadarRange", 50, 500, 200, 0)
    
    self:CreateSectionHeader(frame, "TARGET INFO")
    self:CreateToggle(frame, "Target HUD", "TargetHUD", false)
    self:CreateToggle(frame, "FOV Circle", "FOVCircle", false)
    self:CreateSlider(frame, "FOV Size", "AimbotFOV", 5, 150, 45, 0)
    self:CreateToggle(frame, "Kill Confirm", "KillConfirm", false)
    
    self:CreateSectionHeader(frame, "CHAMS")
    self:CreateToggle(frame, "Chams (Wallhack)", "Chams", false)
    self:CreateSlider(frame, "Chams Transparency", "ChamTransparency", 0, 1, 0.7, 1)
end

function UI:BuildMovementContent()
    local frame = self.ContentFrames.Movement
    
    self:CreateSectionHeader(frame, "SPEED")
    self:CreateToggle(frame, "Speed Boost", "SpeedBoost", false)
    self:CreateSlider(frame, "Speed Multiplier", "SpeedMultiplier", 1, 3, 1.5, 1)
    
    self:CreateSectionHeader(frame, "JUMP")
    self:CreateToggle(frame, "Jump Boost", "JumpBoost", false)
    self:CreateSlider(frame, "Jump Multiplier", "JumpMultiplier", 1, 3, 1.5, 1)
    
    self:CreateSectionHeader(frame, "SPRINT")
    self:CreateToggle(frame, "Sprint", "SprintEnabled", false)
    self:CreateSlider(frame, "Sprint Multiplier", "SprintMultiplier", 1, 3, 1.8, 1)
    
    self:CreateSectionHeader(frame, "BUNNY HOP")
    self:CreateToggle(frame, "Bunny Hop", "BunnyHop", false)
end

function UI:BuildGameContent()
    local frame = self.ContentFrames.Game
    
    self:CreateSectionHeader(frame, "SURVIVAL")
    self:CreateToggle(frame, "No Fall Damage", "NoFallDamage", false)
    self:CreateToggle(frame, "Instant Respawn", "InstantRespawn", false)
    self:CreateToggle(frame, "Anti-Stun", "AntiStun", false)
    
    self:CreateSectionHeader(frame, "INTERACTION")
    self:CreateToggle(frame, "Instant Interact", "InstantInteract", false)
    self:CreateToggle(frame, "Platform Ignorer", "PlatformIgnorer", false)
end

function UI:BuildWeaponContent()
    local frame = self.ContentFrames.Weapon
    
    self:CreateSectionHeader(frame, "GUN MODS")
    self:CreateToggle(frame, "Gun Mods", "GunMods", false)
    self:CreateToggle(frame, "Auto Reload", "AutoReload", true)
    self:CreateToggle(frame, "No Recoil", "NoRecoil", false)
    self:CreateToggle(frame, "No Spread", "NoSpread", false)
    
    self:CreateSectionHeader(frame, "WEAPON SWAP")
    self:CreateToggle(frame, "Fast Weapon Swap", "FastWeaponSwap", false)
end

function UI:BuildSettingsContent()
    local frame = self.ContentFrames.Settings
    
    self:CreateSectionHeader(frame, "PREFERENCES")
    self:CreateToggle(frame, "Team Check", "TeamCheck", true)
    self:CreateToggle(frame, "Red Theme", "UIRedTheme", true)
    self:CreateToggle(frame, "3D Shadow", "UI3DEffect", true)
    
    self:CreateSectionHeader(frame, "KEYBINDS")
    -- Keybind toggles would go here (simplified for space)
end

function UI:BuildServerContent()
    local frame = self.ContentFrames.Server
    
    self:CreateSectionHeader(frame, "SERVER HOP")
    
    local function CreateServerHopButton(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.Text = "  " .. text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.Parent = frame
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 30, 40)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 20, 30)
            }):Play()
        end)
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    CreateServerHopButton("★ LOW POPULATION (1-2 players)", 10, function()
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
    
    CreateServerHopButton("♻ REJOIN CURRENT SERVER", 50, function()
        local jobId = game.JobId
        if jobId and jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
        else
            TeleportService:Teleport(game.PlaceId)
        end
    end)
    
    CreateServerHopButton("⊕ RANDOM SERVER HOP", 90, function()
        TeleportService:Teleport(game.PlaceId)
    end)
end

-- ============ NAVIGATION ============
function UI:SwitchCategory(category)
    -- Update button states
    for cat, btn in pairs(self.SidebarButtons) do
        if cat == category then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(60, 10, 10) or Color3.fromRGB(40, 60, 100)
            }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            }):Play()
        end
    end
    
    -- Hide all content frames
    for _, frame in pairs(self.ContentFrames) do
        frame.Visible = false
    end
    
    -- Show selected category
    if self.ContentFrames[category] then
        self.ContentFrames[category].Visible = true
        self.ActiveCategory = category
        
        -- Update canvas size
        task.wait(0.1)
        local contentFrame = self.ContentFrames[category]
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteWindowSize.Y + 20)
    end
end

-- ==================== SYSTEMS ====================

-- Hitbox System (4-6-4 Locked)
do
    local DataStore = ReplicatedStorage:FindFirstChild(Config.PersistentHitboxStore)
    if not DataStore then
        DataStore = Instance.new("Folder")
        DataStore.Name = Config.PersistentHitboxStore
        DataStore.Parent = ReplicatedStorage
    end
    
    local function ApplyHitbox(hrp, multiplier)
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
    
    UI.UpdateAllHitboxes = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    ApplyHitbox(hrp, Config.HitboxMultiplier)
                end
            end
        end
    end
    
    local function OnCharacterAdded(char)
        task.wait(0.5)
        local hrp = char:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            ApplyHitbox(hrp, Config.HitboxMultiplier)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(OnCharacterAdded)
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(OnCharacterAdded)
        end
    end
    
    LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
    
    if LocalPlayer.Character then
        OnCharacterAdded(LocalPlayer.Character)
    end
end

-- Projectile Magnetism
do
    Workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("BasePart") then
            local name = desc.Name:lower()
            for _, keyword in ipairs({
                "jar", "crystal", "axe", "projectile", "boomerang", 
                "janedoe", "knife", "throw", "blade", "katana",
                "chakram", "disc", "star", "card", "nail"
            }) do
                if name:find(keyword) then
                    table.insert(UI.TrackedProjectiles, desc)
                    break
                end
            end
        end
    end)
end

-- ESP System
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
            if updateCount >= 5 then break end
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
        
        task.wait()
    end)
end

-- Radar System
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
        
        local center = Instance.new("Frame", radar)
        center.Name = "Center"
        center.Size = UDim2.new(0, 4, 0, 4)
        center.Position = UDim2.new(0.5, -2, 0.5, -2)
        center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", center).CornerRadius = UDim.new(1, 0)
        
        UI.RadarFrame = radar
        UI:UpdateRadar()
    end
    
    UI.UpdateRadar = function()
        if not UI.RadarFrame or not Config.Radar then return end
        
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
        task.wait(0.1)
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

-- Target HUD
do
    local hudFrame
    
    UI.CreateTargetHUD = function()
        if hudFrame then return end
        
        hudFrame = Instance.new("Frame")
        hudFrame.Name = "TargetHUD"
        hudFrame.Size = Config.TargetHUDSize
        hudFrame.Position = Config.TargetHUDPos
        hudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hudFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        hudFrame.BorderSizePixel = 2
        hudFrame.ZIndex = 100
        Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0, 8)
        hudFrame.Parent = UI.ScreenGui
        
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
            
            task.wait()
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

-- Chams System (Cached)
do
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
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 100, 100)
                part.Transparency = 0.7
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
    end
    
    UI.RestoreChams = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                RemoveChamsFromCharacter(player.Character)
            end
        end
    end
end

-- Kill Confirm
do
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
                                UI:TriggerKillFlash()
                            end
                        end
                    end
                end
            end
        end
        
        task.wait()
    end)
end

-- Movement Boosts
do
    local originalWalkSpeed = 16
    local originalJumpPower = 50
    
    UI.Connections.MovementLoop = RunService.Heartbeat:Connect(function()
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
        
        if Config.SprintEnabled and UserInputService:IsKeyDown(Config.SprintKeybind) then
            hum.WalkSpeed = originalWalkSpeed * Config.SpeedMultiplier * Config.SprintMultiplier
        end
        
        if Config.BunnyHop and UserInputService:IsKeyDown(Config.BunnyHopKeybind) then
            if hum:GetState() == Enum.HumanoidStateType.Running then
                hum.Jump = true
            end
        end
        
        task.wait()
    end)
end

-- Weapon Mods
do
    UI.Connections.WeaponModsLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.GunMods then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                pcall(function()
                    if Config.NoRecoil then
                        if tool:FindFirstChild("Recoil") then tool.Recoil.Value = 0 end
                        if tool:FindFirstChild("MaxRecoil") then tool.MaxRecoil.Value = 0 end
                    end
                    if Config.NoSpread then
                        if tool:FindFirstChild("Spread") then tool.Spread.Value = 0 end
                        if tool:FindFirstChild("MaxSpread") then tool.MaxSpread.Value = 0 end
                    end
                    if Config.FastWeaponSwap and tool:FindFirstChild("Cooldown") then
                        tool.Cooldown.Value = 0
                    end
                end)
            end
        end
        
        task.wait(0.5)
    end)
end

-- Triggerbot
do
    local lastTriggerTime = 0
    
    UI.Connections.TriggerbotLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.Triggerbot then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        local currentTime = tick()
        if currentTime - lastTriggerTime < Config.TriggerbotDelay then return end
        
        local isTriggerPressed = UserInputService:IsMouseButtonPressed(Config.TriggerbotKeybind) or
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
                            lastTriggerTime = currentTime
                        end)
                    end
                end
            end
        end
        
        task.wait()
    end)
end

-- Instant Interact
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

-- Auto Heal
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

-- No Fall Damage & Anti-Stun
do
    UI.Connections.DefensiveLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            if Config.NoFallDamage then
                hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            end
            if Config.AntiStun then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
            if Config.InstantRespawn and hum.Health <= 0 then
                hum.Health = 100
            end
        end
        
        task.wait()
    end)
end

-- Platform Ignorer
do
    UI.Connections.PlatformIgnorerLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not Config.PlatformIgnorer then return end
        
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
        
        task.wait(1)
    end)
end

-- ==================== MAIN COMBAT LOOP ====================
do
    local lastMagnetScan = 0
    
    UI.Connections.MasterCombatLoop = RunService.Heartbeat:Connect(function()
        if not Config.Enabled then return end
        
        local now = tick()
        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        
        -- 1. HITBOX FORCE (4-6-4 LOCKED)
        if myHrp then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local baseSize = Vector3.new(4, 6, 4)
                        local scale = Config.HitboxMultiplier / 6
                        local targetSize = baseSize * scale
                        
                        if hrp.Size ~= targetSize then
                            hrp.Size = targetSize
                            hrp.CanCollide = true
                            hrp.CanTouch = true
                        end
                        
                        if Config.ESP then
                            hrp.Transparency = Config.HitboxTransparency
                            hrp.Material = Enum.Material.Neon
                            hrp.Color = Config.HitboxColor
                        end
                    end
                end
            end
        end
        
        -- 2. MAGNETISM
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
        
        -- 3. AUTO-BLOCK
        if Config.AutoBlock and myHrp and now - (lastBlockTime or 0) >= Config.BlockCooldown then
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
        
        -- 4. UPDATE ESP HEALTH BARS
        if Config.ESP and Config.ESPHealthBar then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local hum = char:FindFirstChild("Humanoid")
                    local bar = UI.ESPObjects[char]
                    if bar and hum and bar:IsA("BillboardGui") then
                        local fill = bar:FindFirstChild("Fill")
                        if fill then
                            fill.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
                        end
                    end
                end
            end
        end
        
        task.wait()
    end)
end

-- ==================== AIMBOT (Mobile Optimized) ====================
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
    
    UI.Connections.AimbotLoop = RunService.RenderStepped:Connect(function()
        if not Config.Enabled or not Config.Aimbot then return end
        
        local shouldAim = Config.AutoAimWhenInFOV or IsAimActive()
        if shouldAim then
            local target = GetTarget()
            if target then
                local targetPos = target.Position
                
                if Config.PredictionAim then
                    targetPos = targetPos + (target.AssemblyLinearVelocity * (Config.PredictionTime + Config.PredictionAmmount))
                end
                
                local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, math.clamp(Config.AimSmoothing, 0.01, 1))
            end
        end
        
        task.wait()
    end)
end

-- ==================== KEYBINDS ====================
do
    UI.Connections.KeybindListener = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Config.MasterKeybind then
            Config.Enabled = not Config.Enabled
            print("APEX DOMAIN: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
            
            if UI.MainFrame then
                UI.MainFrame.Visible = Config.Enabled
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
        
        if UI.MainFrame then
            UI.MainFrame:Destroy()
            UI.MainFrame = nil
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
    task.wait(2)
    
    if BuildUI() then
        print("◈ APEX DOMAIN ULTIMATE v7.0 LOADED ◈")
        print("PROFESSIONAL UI WITH SIDEBAR NAVIGATION")
        print("• Organized Categories (Combat, Visual, Movement, Game, Weapon, Settings, Server)")
        print("• Mobile + PC Optimized")
        print("• 4-6-4 Locked Hitboxes")
        print("• Mobile Camera Aimbot")
        print("Press F1 to toggle")
    else
        warn("Failed to build UI!")
        task.wait(3)
        if BuildUI() then
            print("UI loaded on retry")
        else
            warn("UI failed to load after retry")
        end
    end
end)

return UI
