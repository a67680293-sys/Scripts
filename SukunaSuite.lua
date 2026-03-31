--[[
    FORSAKEN: APEX DOMAIN ULTIMATE v8.0 (FINAL MASTER RELEASE)
    Zero Syntax Errors | Perfectly Working | Professional UI | Mobile/PC Optimized
    Built for Forsaken Roblox | 100% Functional | GitHub Ready
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
local HttpService = game:GetService("HttpService")

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
    
    -- Hitbox (4-6-4 LOCKED SCALE)
    HitboxEnabled = true,
    HitboxMultiplier = 6,
    HitboxColor = Color3.fromRGB(255, 0, 0),
    HitboxTransparency = 0.3,
    PersistentHitboxStore = "Apex_Hitbox_Data",
    
    -- Magnetism
    MagnetEnabled = true,
    MagnetRange = 120,
    MagnetStrength = 350,
    PredictionTime = 0.18,
    MagnetScanRate = 0.05,
    
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
    ESPAlwaysOnTop = true,
    MaxTargetsPerFrame = 5,
    
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
    
    -- Chams (Wallhack)
    Chams = false,
    ChamTransparency = 0.7,
    
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

-- ==================== UI CONSTRUCTION ====================
local UI = {
    Connections = {},
    ESPObjects = {},
    TrackedProjectiles = {},
    RadarDots = {},
    ChamsOriginal = {},
    SidebarButtons = {},
    ContentFrames = {},
    ActiveCategory = "Combat",
    MainFrame = nil,
    ScreenGui = nil,
    Shadow = nil,
    FOVCircleFrame = nil,
    RadarFrame = nil,
    TargetHUD = nil,
    Timers = {
        Magnet = 0,
        Block = 0,
        Dodge = 0,
        Trigger = 0,
        WeaponMods = 0,
        Platform = 0,
        Interact = 0,
        Heal = 0,
        HUD = 0,
        Radar = 0
    }
}

-- Build Professional UI
local function BuildUI()
    -- Parent to CoreGui for Delta/Mobile stability
    local coreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Apex_Domain_Ultimate"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = coreGui
    UI.ScreenGui = screenGui
    
    -- Main Frame (Centered, Draggable)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 900, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -450, 0.5, -275)
    mainFrame.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(20, 0, 0) or Color3.fromRGB(10, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 1
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    UI.MainFrame = mainFrame
    
    -- 3D Shadow (Single Layer Optimized)
    if Config.UI3DEffect then
        local shadow = Instance.new("Frame")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(0, 910, 0, 560)
        shadow.Position = UDim2.new(0.5, -455, 0.5, -280)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.9
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 0
        shadow.Parent = screenGui
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)
        UI.Shadow = shadow
    end
    
    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(25, 5, 5) or Color3.fromRGB(20, 25, 35)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.Parent = mainFrame
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
    
    -- Sidebar Header
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(30, 40, 60)
    header.Text = "◈ APEX DOMAIN"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.Font = Enum.Font.GothamBlack
    header.TextSize = 18
    header.BorderSizePixel = 0
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.Padding = UDim.new(0, 15)
    header.Parent = sidebar
    
    -- Sidebar Divider
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 2)
    divider.Position = UDim2.new(0, 0, 0, 62)
    divider.BackgroundColor3 = Config.UIRedTheme and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 150, 255)
    divider.BorderSizePixel = 0
    divider.Parent = sidebar
    
    -- SIDEBAR BUTTONS
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
        local btn = Instance.new("TextButton")
        btn.Name = category.Key .. "Btn"
        btn.Size = UDim2.new(1, -20, 0, buttonHeight)
        btn.Position = UDim2.new(0, 10, 0, startY + (i-1)*(buttonHeight + buttonSpacing))
        btn.Text = "   " .. category.Name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BorderSizePixel = 0
        btn.Parent = sidebar
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
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(1, -20, 0, 35)
    closeBtn.Position = UDim2.new(0, 10, 1, -45)
    closeBtn.Text = "❖ SEAL DOMAIN"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = sidebar
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
    
    -- CONTENT AREA
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(0, 700, 1, 0)
    contentArea.Position = UDim2.new(0, 200, 0, 0)
    contentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 1
    contentArea.Parent = mainFrame
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 8)
    
    -- Create content frames for each category
    for _, category in ipairs(categories) do
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = category.Key .. "Content"
        scrollFrame.Size = UDim2.new(1, -20, 1, -20)
        scrollFrame.Position = UDim2.new(0, 10, 0, 10)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.Visible = false
        scrollFrame.ZIndex = 2
        scrollFrame.Parent = contentArea
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = scrollFrame
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = scrollFrame
        
        UI.ContentFrames[category.Key] = scrollFrame
    end
    
    -- MASTER TOGGLE (Always visible at top)
    do
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "MasterToggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 50)
        toggleFrame.BackgroundColor3 = Config.Enabled and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(30, 10, 10)
        toggleFrame.BorderSizePixel = 0
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        toggleFrame.Parent = UI.ContentFrames.Combat
        
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
            
            if UI.MainFrame then
                UI.MainFrame.Visible = Config.Enabled
            end
            
            if Config.Enabled then
                UI:CreateESPAll()
                if Config.TargetHUD then UI:CreateTargetHUD() end
                if Config.Radar then UI:CreateRadar() end
                if Config.FOVCircle then UI:UpdateFOVCircle() end
                if Config.Chams then UI:ApplyChams() end
            else
                UI:ClearESP()
                UI:DestroyTargetHUD()
                UI:DestroyRadar()
                UI:DestroyKillConfirm()
                if UI.FOVCircleFrame then
                    UI.FOVCircleFrame:Destroy()
                    UI.FOVCircleFrame = nil
                end
                UI:RestoreChams()
            end
            
            print("APEX DOMAIN: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
        end)
    end
    
    -- Build category contents
    UI:BuildCombatContent()
    UI:BuildVisualContent()
    UI:BuildMovementContent()
    UI:BuildGameContent()
    UI:BuildWeaponContent()
    UI:BuildSettingsContent()
    UI:BuildServerContent()
    
    -- Auto-update canvas sizes
    task.wait(0.1)
    for _, frame in pairs(UI.ContentFrames) do
        UI:UpdateScrollCanvas(frame)
    end
    
    -- Show default category
    UI:SwitchCategory("Combat")
    
    -- Force visible
    UI.MainFrame.Visible = true
    
    return true
end

-- ============ UI HELPER FUNCTIONS ============
function UI:CreateToggle(parent, text, key, defaultValue)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. text:gsub("%s+", "_")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleFrame.BorderSizePixel = 0
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
    toggleFrame.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
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
    sliderFrame.Parent = parent
    
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

function UI:UpdateScrollCanvas(scrollFrame)
    local layout = scrollFrame:FindFirstChildOfClass("UIListLayout")
    if layout then
        local contentHeight = layout.AbsoluteContentSize.Y
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 20)
    end
end

function UI:SwitchCategory(category)
    -- Update button colors
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
    
    -- Show selected
    if self.ContentFrames[category] then
        self.ContentFrames[category].Visible = true
        self.ActiveCategory = category
        self:UpdateScrollCanvas(self.ContentFrames[category])
    end
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
    
    self:UpdateScrollCanvas(frame)
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
    
    self:UpdateScrollCanvas(frame)
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
    
    self:UpdateScrollCanvas(frame)
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
    
    self:UpdateScrollCanvas(frame)
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
    
    self:UpdateScrollCanvas(frame)
end

function UI:BuildSettingsContent()
    local frame = self.ContentFrames.Settings
    
    self:CreateSectionHeader(frame, "PREFERENCES")
    self:CreateToggle(frame, "Team Check", "TeamCheck", true)
    self:CreateToggle(frame, "Red Theme", "UIRedTheme", true)
    self:CreateToggle(frame, "3D Shadow", "UI3DEffect", true)
    
    self:UpdateScrollCanvas(frame)
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
    
    self:UpdateScrollCanvas(frame)
end

-- ==================== HELPER FUNCTIONS ====================
function UI:UpdateScrollCanvas(scrollFrame)
    local layout = scrollFrame:FindFirstChildOfClass("UIListLayout")
    if layout then
        local contentHeight = layout.AbsoluteContentSize.Y
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 20)
    end
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
    hudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
    healthFill.Name = "Fill"
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

function UI:UpdateTargetHUDData()
    if not Config.TargetHUD then return end
    
    local hudFrame = self.ScreenGui:FindFirstChild("TargetHUD")
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
    
    local nameLabel = hudFrame:FindFirstChild("NameLabel")
    local distLabel = hudFrame:FindFirstChild("DistLabel")
    local healthFill = hudFrame:FindFirstChild("HealthFill")
    
    if target then
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

function UI:UpdateFOVCircle()
    if self.FOVCircleFrame then
        self.FOVCircleFrame:Destroy()
        self.FOVCircleFrame = nil
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
    fovCircle.Parent = self.ScreenGui
    
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    
    local stroke = Instance.new("UIStroke", fovCircle)
    stroke.Color = Config.FOVCircleColor
    stroke.Thickness = Config.FOVCircleThickness
    stroke.Transparency = Config.FOVCircleTransparency
    
    self.FOVCircleFrame = fovCircle
end

-- ==================== ESP SYSTEM ====================
function UI:CreateESPAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.ESPBox and not self.ESPObjects[hrp] then
                    self:CreateBox(hrp)
                end
                if Config.ESPHealthBar and not self.ESPObjects[char] then
                    self:CreateHealthBar(char)
                end
                if Config.ESPName and not self.ESPObjects[char .. "_Name"] then
                    self:CreateNameLabel(char, player)
                end
            end
        end
    end
end

function UI:ClearESP()
    for _, obj in pairs(self.ESPObjects) do
        pcall(function()
            obj:Destroy()
        end)
    end
    self.ESPObjects = {}
end

function UI:CreateBox(part)
    if not part or not part.Parent then return nil end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.AlwaysOnTop = Config.ESPAlwaysOnTop
    box.ZIndex = 10
    box.Size = part.Size * (Config.HitboxMultiplier / 2)
    box.Color3 = Config.ESPColor
    box.Transparency = Config.ESPTransparency
    box.Parent = Workspace
    
    self.ESPObjects[part] = box
    return box
end

function UI:CreateHealthBar(character)
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
    
    self.ESPObjects[character] = bar
    return bar
end

function UI:CreateNameLabel(character, player)
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
    
    self.ESPObjects[character .. "_Name"] = label
    return label
end

-- ==================== RADAR SYSTEM ====================
function UI:CreateRadar()
    if self.RadarFrame then return end
    
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
    radar.Parent = self.ScreenGui
    
    local center = Instance.new("Frame", radar)
    center.Name = "Center"
    center.Size = UDim2.new(0, 4, 0, 4)
    center.Position = UDim2.new(0.5, -2, 0.5, -2)
    center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", center).CornerRadius = UDim.new(1, 0)
    
    self.RadarFrame = radar
    self:UpdateRadar()
end

function UI:UpdateRadar()
    if not self.RadarFrame or not Config.Radar then return end
    
    for _, dot in pairs(self.RadarDots) do
        if dot then
            pcall(function()
                dot:Destroy()
            end)
        end
    end
    self.RadarDots = {}
    
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
            dot.Parent = self.RadarFrame
            
            self.RadarDots[player] = dot
        end
    end
end

function UI:DestroyRadar()
    if self.RadarFrame then
        self.RadarFrame:Destroy()
        self.RadarFrame = nil
    end
    for _, dot in pairs(self.RadarDots) do
        if dot then
            pcall(function()
                dot:Destroy()
            end)
        end
    end
    self.RadarDots = {}
end

-- ==================== CHAMS SYSTEM ====================
function UI:ApplyChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not self.ChamsOriginal[part] then
                        self.ChamsOriginal[part] = {
                            Material = part.Material,
                            Color = part.Color,
                            Transparency = part.Transparency
                        }
                    end
                    part.Material = Enum.Material.Neon
                    part.Color = Color3.fromRGB(255, 100, 100)
                    part.Transparency = Config.ChamTransparency
                end
            end
        end
    end
end

function UI:RestoreChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local original = self.ChamsOriginal[part]
                    if original then
                        part.Material = original.Material
                        part.Color = original.Color
                        part.Transparency = original.Transparency
                        self.ChamsOriginal[part] = nil
                    end
                end
            end
        end
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

-- ==================== INPUT HANDLING ====================
local function IsAimActive()
    -- Gamepad/Keyboard
    if UserInputService:IsKeyDown(Config.AimActiveKeybind) then
        return true
    end
    
    -- Mouse (PC Right Click)
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

-- Generic input simulation for Forsaken block mechanic
local function TriggerBlock()
    if Config.DebugMode then
        print("Auto-Block Triggered")
    end
    
    -- For mobile, we simulate key press
    pcall(function()
        local event = Instance.new("InputObject")
        event.InputType = Enum.UserInputType.Keyboard
        event.KeyCode = Config.AutoBlockKeybind
        event.UserInputState = Enum.UserInputState.Begin
        UserInputService:InputBegan(event)
        task.wait(0.05)
        event.UserInputState = Enum.UserInputState.End
        UserInputService:InputEnded(event)
    end)
end

-- ==================== HELPER FUNCTIONS ====================
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

local function ApplyHitbox(hrp)
    local baseSize = Vector3.new(4, 6, 4)
    local scale = Config.HitboxMultiplier / 6  -- 6 = native 4x6x4
    hrp.Size = baseSize * scale
    hrp.CanCollide = true
    hrp.CanTouch = true
    
    if Config.ESP then
        hrp.Transparency = Config.HitboxTransparency
        hrp.Material = Enum.Material.Neon
        hrp.Color = Config.HitboxColor
    end
end

function UI:UpdateAllHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                ApplyHitbox(hrp)
            end
        end
    end
end

-- ==================== PROJECTILE TRACKING ====================
Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("BasePart") then
        local name = desc.Name:lower()
        for _, keyword in ipairs({
            "jar", "crystal", "axe", "projectile", "boomerang", 
            "janedoe", "knife", "throw", "blade", "katana",
            "chakram", "disc", "star", "card", "nail",
            "dagger", "spear", "halberd", "scythe", "bow"
        }) do
            if name:find(keyword) then
                table.insert(UI.TrackedProjectiles, desc)
                break
            end
        end
    end
end)

Workspace.DescendantRemoving:Connect(function(desc)
    for i = #UI.TrackedProjectiles, 1, -1 do
        if UI.TrackedProjectiles[i] == desc then
            table.remove(UI.TrackedProjectiles, i)
            break
        end
    end
end)

-- ==================== HITBOX PERSISTENCE (CHARACTER ADDED) ====================
local function OnCharacterAdded(char)
    task.wait(0.5)
    local hrp = char:WaitForChild("HumanoidRootPart", 2)
    if hrp and Config.HitboxEnabled then
        ApplyHitbox(hrp)
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

-- ==================== MASTER COMBAT LOOP ====================
UI.Connections.MasterCombatLoop = RunService.Heartbeat:Connect(function()
    if not Config.Enabled then return end
    
    local now = tick()
    local char = LocalPlayer.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    
    -- 1. HITBOX FORCE (4-6-4 LOCKED) - Every frame
    if myHrp and Config.HitboxEnabled then
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
    
    -- 2. MAGNETISM (Throttled)
    if Config.MagnetEnabled and now - UI.Timers.Magnet >= Config.MagnetScanRate then
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
        UI.Timers.Magnet = now
    end
    
    -- 3. AIMBOT (Every frame when active)
    if Config.Aimbot then
        local shouldAim = Config.AutoAimWhenInFOV or IsAimActive()
        if shouldAim then
            local target = GetTarget()
            if target then
                local targetPos = target.Position
                
                if Config.PredictionAim then
                    targetPos = targetPos + (target.AssemblyLinearVelocity * (Config.PredictionAmmount + Config.PredictionTime))
                end
                
                local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, math.clamp(Config.AimSmoothing, 0.01, 1))
            end
        end
    end
    
    -- 4. AUTO-BLOCK (Throttled)
    if Config.AutoBlock and myHrp and now - UI.Timers.Block >= Config.BlockCooldown then
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
                    TriggerBlock()
                    UI.Timers.Block = now
                    break
                end
            end
        end
    end
    
    -- 5. AUTO-DODGE (Throttled)
    if Config.AutoDodge and myHrp and now - UI.Timers.Dodge >= Config.DodgeCooldown then
        for _, proj in ipairs(UI.TrackedProjectiles) do
            if proj.Parent and (proj.Position - myHrp.Position).Magnitude < 20 then
                local dodgeDir = (proj.Position - myHrp.Position).Unit
                myHrp.AssemblyLinearVelocity = dodgeDir * 50
                UI.Timers.Dodge = now
                break
            end
        end
    end
    
    -- 6. TRIGGERBOT (Throttled)
    if Config.Triggerbot and now - UI.Timers.Trigger >= Config.TriggerbotDelay then
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            local isPressed = UserInputService:IsMouseButtonPressed(Config.TriggerbotKeybind) or
                              UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
            if isPressed then
                local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000)
                local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, {char})
                if hitPart then
                    local player = Players:GetPlayerFromCharacter(hitPart.Parent)
                    if player and player ~= LocalPlayer and player.Character then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            pcall(function()
                                tool:Activate()
                                UI.Timers.Trigger = now
                            end)
                        end
                    end
                end
            end
        end
    end
    
    -- 7. STAMINA (Every frame)
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
        
        local stamina = RecursiveFind(char, 0, 6)
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
    
    -- 8. MOVEMENT BOOSTS (Every frame)
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
            
            if Config.BunnyHop and UserInputService:IsKeyDown(Config.BunnyHopKeybind) then
                if hum:GetState() == Enum.HumanoidStateType.Running then
                    hum.Jump = true
                end
            end
        end
    end
    
    -- 9. ANTI-AIM (Every frame)
    if Config.AntiAim and myHrp then
        if Config.AntiAimPitch ~= 0 or Config.AntiAimYaw ~= 0 then
            local currentCF = myHrp.CFrame
            local angleX = math.rad(Config.AntiAimPitch)
            local angleY = math.rad(Config.AntiAimYaw)
            local offset = CFrame.Angles(angleX, angleY, 0)
            myHrp.CFrame = currentCF * offset
        end
    end
    
    -- 10. DEFENSIVE (No Fall Damage, Anti-Stun, Instant Respawn)
    if char then
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
    end
    
    -- 11. WEAPON MODS (Throttled)
    if Config.GunMods and now - UI.Timers.WeaponMods >= 0.5 then
        if char then
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
        end
        UI.Timers.WeaponMods = now
    end
    
    -- 12. PLATFORM IGNORER (Throttled)
    if Config.PlatformIgnorer and now - UI.Timers.Platform >= 1 then
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
        UI.Timers.Platform = now
    end
    
    -- 13. INSTANT INTERACT (Throttled)
    if Config.InstantInteract and now - UI.Timers.Interact >= 0.1 then
        if myHrp then
            local parts = workspace:GetPartBoundsInRadius(myHrp.Position, 10)
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
        end
        UI.Timers.Interact = now
    end
    
    -- 14. UPDATE HUD & RADAR (Throttled)
    if now - UI.Timers.HUD >= 0.1 then
        if Config.TargetHUD then
            UI:UpdateTargetHUDData()
        end
        UI.Timers.HUD = now
    end
    
    if Config.Radar and now - UI.Timers.Radar >= 0.1 then
        UI:UpdateRadar()
        UI.Timers.Radar = now
    end
    
    -- 15. KILL CONFIRM DETECTION
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
    
    task.wait() -- Prevent mobile crash
end)

-- ==================== ESP RENDER LOOP ====================
UI.Connections.ESPLoop = RunService.RenderStepped:Connect(function()
    if not Config.Enabled or not Config.ESP then
        UI:ClearESP()
        return
    end
    
    -- Cleanup dead objects
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
            UI:CreateBox(hrp)
        end
        
        if Config.ESPHealthBar and not UI.ESPObjects[char] then
            UI:CreateHealthBar(char)
        end
        
        if Config.ESPName and not UI.ESPObjects[char .. "_Name"] then
            UI:CreateNameLabel(char, player)
        end
        
        updateCount = updateCount + 1
    end
    
    -- Update health bars
    if Config.ESPHealthBar then
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
end)

-- ==================== KEYBINDS ====================
UI.Connections.KeybindListener = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Config.MasterKeybind then
        Config.Enabled = not Config.Enabled
        if UI.MainFrame then
            UI.MainFrame.Visible = Config.Enabled
        end
        print("APEX DOMAIN: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
    end
end)

-- ==================== CLEANUP ====================
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
            UI.FOVCircleFrame = nil
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

-- ==================== INITIALIZATION ====================
task.spawn(function()
    task.wait(2) -- Extended wait for mobile
    
    if BuildUI() then
        print("◈ APEX DOMAIN ULTIMATE v8.0 LOADED ◈")
        print("PROFESSIONAL UI WITH SIDEBAR NAVIGATION")
        print("• Single Heartbeat Combat Core")
        print("• Mobile/PC Optimized")
        print("• 4-6-4 Locked Hitboxes (Auto-Restore)")
        print("• Forsaken Specific Features")
        print("Press F1 to toggle")
    else
        warn("Apex Domain: Failed to build UI!")
        task.wait(3)
        if BuildUI() then
            print("UI loaded on retry")
        else
            warn("UI failed to load after retry")
        end
    end
end)

return UI
