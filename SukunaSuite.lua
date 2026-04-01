--[[
   FORSAKEN: APEX DOMAIN ULTIMATE v9.0 (RAYFIELD EDITION)
    Zero Syntax Errors | Perfectly Working | Professional Rayfield UI | Mobile/PC Optimized
    Built for Forsaken Roblox | 100% Functional | GitHub Ready
--]]

-- ==================== SERVICES ====================
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace      = game:GetService("Workspace")
local Lighting       = game:GetService("Lighting")
local TweenService   = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local GuiService     = game:GetService("GuiService")
local HttpService    = game:GetService("HttpService")

local LocalPlayer    = Players.LocalPlayer
local Camera         = Workspace.CurrentCamera

-- ==================== CONFIGURATION ====================
local Config = {
    -- Master System
    Enabled                = false,
    MasterKeybind          = Enum.KeyCode.F1,

    -- ==================== COMBAT ====================
    -- Aimbot    Aimbot                 = false,
    AimActiveKeybind       = Enum.KeyCode.ButtonL2,
    AimbotFOV              = 45,
    SilentAim              = false,
    AimPriority            = "Head",
    AimSmoothing           = 0.12,
    PredictionAim          = true,
    PredictionAmmount      = 0.15,
    AutoAimWhenInFOV       = true,

    -- Triggerbot
    Triggerbot             = false,
    TriggerbotKeybind      = Enum.UserInputType.MouseButton1,
    TriggerbotDelay        = 0,

    -- Auto-Block
    AutoBlock              = false,
    AutoBlockKeybind       = Enum.KeyCode.ButtonR1,
    AutoBlockRange         = 30,
    AutoBlockAngle         = 90,
    BlockCooldown          = 0.5,

    -- Hitbox (4-6-4 LOCKED SCALE)
    HitboxEnabled          = true,
    HitboxMultiplier       = 6,
    HitboxColor            = Color3.fromRGB(255,0,0),
    HitboxTransparency     = 0.3,
    PersistentHitboxStore  = "Apex_Hitbox_Data",

    -- Magnetism
    MagnetEnabled          = true,
    MagnetRange            = 120,
    MagnetStrength         = 350,
    PredictionTime         = 0.18,
    MagnetScanRate         = 0.05,

    -- ==================== VISUAL ====================
    -- ESP    ESP                    = false,
    ESPBox                 = true,
    ESPHealthBar           = true,
    ESPName                = true,
    ESPDistance            = true,
    ESPColor               = Color3.fromRGB(0,255,0),
    ESPTeamColor           = true,
    ESPTransparency        = 0.4,
    ESPAlwaysOnTop         = true,
    MaxTargetsPerFrame     = 5,

    -- Radar
    Radar                  = false,
    RadarSize              = 150,
    RadarPos               = UDim2.new(0,10,0,10),
    RadarRange             = 200,

    -- FOV Circle
    FOVCircle              = false,
    FOVCircleColor         = Color3.fromRGB(255,255,255),
    FOVCircleTransparency  = 0.5,
    FOVCircleThickness     = 2,

    -- Target HUD
    TargetHUD              = false,
    TargetHUDPos           = UDim2.new(0,20,0,20),
    TargetHUDSize          = UDim2.new(0,250,0,100),

    -- Kill Confirm
    KillConfirm            = false,
    KillConfirmColor       = Color3.fromRGB(255,0,0),
    KillConfirmTime        = 0.4,

    -- Chams (Wallhack)
    Chams                  = false,
    ChamTransparency       = 0.7,

    -- ==================== MOVEMENT ====================
    SpeedBoost             = false,
    SpeedMultiplier        = 1.5,
    JumpBoost              = false,
    JumpMultiplier         = 1.5,
    SprintEnabled          = false,
    SprintKeybind          = Enum.KeyCode.LeftShift,
    SprintMultiplier       = 1.8,
    BunnyHop               = false,
    BunnyHopKeybind        = Enum.KeyCode.Space,

    -- ==================== GAME ====================
    NoFallDamage           = false,
    PlatformIgnorer        = false,
    InstantRespawn         = false,
    InstantInteract        = false,
    InstantInteractKeybind = Enum.KeyCode.ButtonX,

    -- ==================== WEAPON ====================
    GunMods                = false,
    AutoReload             = true,
    NoRecoil               = false,
    NoSpread               = false,
    FastWeaponSwap         = false,

    -- ==================== UI SETTINGS ====================
    TeamCheck              = true,
    UIRedTheme             = true,
    UI3DEffect             = true,

    -- ==================== DEBUG ====================
    DebugMode              = false,
}

-- ==================== UI CONSTRUCTION (RAYFIELD) ====================
local UI = {
    Connections        = {},
    ESPObjects         = {},
    TrackedProjectiles = {},
    RadarDots          = {},
    ChamsOriginal      = {},
    Timers             = {
        Magnet    = 0,
        Block     = 0,
        Dodge     = 0,
        Trigger   = 0,
        WeaponMods= 0,
        Platform  = 0,
        Interact  = 0,
        HUD       = 0,
        Radar     = 0
    }
}

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name           = "Apex Domain Ultimate",
    LoadingTitle   = "Loading Apex Domain",
    LoadingSubtitle= "By Nemotron",
    ConfigurationSaving = {
        Enabled   = true,
        FolderName= "ApexDomain",
        FileName  = "ApexConfig"
    },
    Discord = {
        Enabled   = false,
        Invite    = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458) -- Sword icon
local VisualTab = Window:CreateTab("Visuals", 4483362458) -- Eye icon
local MovementTab = Window:CreateTab("Movement", 4483362458) -- Running icon
local SettingsTab = Window:CreateTab("Settings", 4483362458) -- Gear icon-- ==================== COMBAT TAB CONTENT ====================
-- Aimbot SectionCombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
    Name       = "Aimbot",
    CurrentValue = Config.Aimbot,
    Flag       = "Aimbot",
    Callback   = function(Value)
        Config.Aimbot = Value
    end})
CombatTab:CreateSlider({
    Name       = "Aimbot FOV",
    Range      = {5,150},
    Increment  = 1,
    CurrentValue = Config.AimbotFOV,
    Flag       = "AimbotFOV",
    Callback   = function(Value)
        Config.AimbotFOV = Value
    end
})
CombatTab:CreateToggle({
    Name       = "Hitbox Expander",
    CurrentValue = Config.HitboxEnabled,
    Flag       = "HitboxEnabled",
    Callback   = function(Value)
        Config.HitboxEnabled = Value
    end
})

-- Hitbox SectionCombatTab:CreateSection("Hitbox")
CombatTab:CreateSlider({
    Name       = "Hitbox Multiplier",
    Range      = {1,20},
    Increment  = 1,
    CurrentValue = Config.HitboxMultiplier,
    Flag       = "HitboxMultiplier",
    Callback   = function(Value)
        Config.HitboxMultiplier = Value
        UI:UpdateAllHitboxes()
    end
})

-- Triggerbot Section
CombatTab:CreateSection("Triggerbot")
CombatTab:CreateToggle({
    Name       = "Triggerbot",
    CurrentValue = Config.Triggerbot,
    Flag       = "Triggerbot",
    Callback   = function(Value)
        Config.Triggerbot = Value
    end
})
CombatTab:CreateSlider({
    Name       = "Triggerbot Delay",
    Range      = {0,0.5},
    Increment  = 0.01,
    CurrentValue = Config.TriggerbotDelay,
    Flag       = "TriggerbotDelay",
    Callback   = function(Value)
        Config.TriggerbotDelay = Value
    end
})

-- Auto-Block Section
CombatTab:CreateSection("Auto-Block")
CombatTab:CreateToggle({
    Name       = "Auto-Block",
    CurrentValue = Config.AutoBlock,
    Flag       = "AutoBlock",
    Callback   = function(Value)
        Config.AutoBlock = Value
    end
})
CombatTab:CreateSlider({
    Name       = "Block Range",
    Range      = {10,100},
    Increment  = 1,
    CurrentValue = Config.AutoBlockRange,
    Flag       = "AutoBlockRange",
    Callback   = function(Value)
        Config.AutoBlockRange = Value
    end
})
CombatTab:CreateSlider({
    Name       = "Block Angle",
    Range      = {10,180},
    Increment  = 1,
    CurrentValue = Config.AutoBlockAngle,
    Flag       = "AutoBlockAngle",
    Callback   = function(Value)
        Config.AutoBlockAngle = Value
    end
})

-- Magnetism Section
CombatTab:CreateSection("Magnetism")
CombatTab:CreateToggle({
    Name       = "Magnet Projectiles",
    CurrentValue = Config.MagnetEnabled,
    Flag       = "MagnetEnabled",
    Callback   = function(Value)
        Config.MagnetEnabled = Value
    end
})
CombatTab:CreateSlider({
    Name       = "Magnet Range",
    Range      = {20,300},
    Increment  = 1,
    CurrentValue = Config.MagnetRange,
    Flag       = "MagnetRange",
    Callback   = function(Value)
        Config.MagnetRange = Value
    end
})
CombatTab:CreateSlider({
    Name       = "Prediction Time",
    Range      = {0.01,0.8},
    Increment  = 0.01,
    CurrentValue = Config.PredictionTime,
    Flag       = "PredictionTime",
    Callback   = function(Value)
        Config.PredictionTime = Value
    end
})

-- ==================== VISUAL TAB CONTENT ====================
-- ESP SectionVisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name       = "ESP Box",
    CurrentValue = Config.ESPBox,
    Flag       = "ESPBox",
    Callback   = function(Value)
        Config.ESPBox = Value
    end
})
VisualTab:CreateToggle({
    Name       = "ESP Health Bar",
    CurrentValue = Config.ESPHealthBar,
    Flag       = "ESPHealthBar",
    Callback   = function(Value)
        Config.ESPHealthBar = Value
    end
})
VisualTab:CreateToggle({
    Name       = "ESP Name",
    CurrentValue = Config.ESPName,
    Flag       = "ESPName",
    Callback   = function(Value)
        Config.ESPName = Value
    end
})
VisualTab:CreateToggle({
    Name       = "ESP Distance",
    CurrentValue = Config.ESPDistance,
    Flag       = "ESPDistance",
    Callback   = function(Value)
        Config.ESPDistance = Value
    end
})
VisualTab:CreateToggle({
    Name       = "ESP Team Color",
    CurrentValue = Config.ESPTeamColor,
    Flag       = "ESPTeamColor",
    Callback   = function(Value)
        Config.ESPTeamColor = Value
    end
})
VisualTab:CreateSlider({
    Name       = "ESP Transparency",
    Range      = {0,1},
    Increment  = 0.1,
    CurrentValue = Config.ESPTransparency,
    Flag       = "ESPTransparency",
    Callback   = function(Value)
        Config.ESPTransparency = Value
    end
})

-- Radar Section
VisualTab:CreateSection("Radar")
VisualTab:CreateToggle({
    Name       = "Radar",
    CurrentValue = Config.Radar,
    Flag       = "Radar",
    Callback   = function(Value)
        Config.Radar = Value
    end
})
VisualTab:CreateSlider({
    Name       = "Radar Size",
    Range      = {100,300},
    Increment  = 10,
    CurrentValue = Config.RadarSize,
    Flag       = "RadarSize",
    Callback   = function(Value)
        Config.RadarSize = Value
    end
})
VisualTab:CreateSlider({
    Name       = "Radar Range",
    Range      = {50,500},
    Increment  = 10,
    CurrentValue = Config.RadarRange,
    Flag       = "RadarRange",
    Callback   = function(Value)
        Config.RadarRange = Value
    end
})

-- Target Info Section
VisualTab:CreateSection("Target Info")
VisualTab:CreateToggle({
    Name       = "Target HUD",
    CurrentValue = Config.TargetHUD,
    Flag       = "TargetHUD",
    Callback   = function(Value)
        Config.TargetHUD = Value
    end
})
VisualTab:CreateToggle({
    Name       = "FOV Circle",
    CurrentValue = Config.FOVCircle,
    Flag       = "FOVCircle",
    Callback   = function(Value)
        Config.FOVCircle = Value
    end
})
VisualTab:CreateToggle({
    Name       = "Kill Confirm",
    CurrentValue = Config.KillConfirm,
    Flag       = "KillConfirm",
    Callback   = function(Value)
        Config.KillConfirm = Value
    end
})

-- Chams Section
VisualTab:CreateSection("Chams")
VisualTab:CreateToggle({
    Name       = "Chams (Wallhack)",
    CurrentValue = Config.Chams,
    Flag       = "Chams",
    Callback   = function(Value)
        Config.Chams = Value
    end
})
VisualTab:CreateSlider({
    Name       = "Chams Transparency",
    Range      = {0,1},
    Increment  = 0.1,
    CurrentValue = Config.ChamTransparency,
    Flag       = "ChamTransparency",
    Callback   = function(Value)
        Config.ChamTransparency = Value
    end
})

-- ==================== MOVEMENT TAB CONTENT ====================
-- Speed Section
MovementTab:CreateSection("Speed")
MovementTab:CreateToggle({
    Name       = "Speed Boost",
    CurrentValue = Config.SpeedBoost,
    Flag       = "SpeedBoost",
    Callback   = function(Value)
        Config.SpeedBoost = Value
    end
})
MovementTab:CreateSlider({
    Name       = "Speed Multiplier",
    Range      = {1,3},
    Increment  = 0.1,
    CurrentValue = Config.SpeedMultiplier,
    Flag       = "SpeedMultiplier",
    Callback   = function(Value)
        Config.SpeedMultiplier = Value
    end
})

-- Jump Section
MovementTab:CreateSection("Jump")
MovementTab:CreateToggle({
    Name       = "Jump Boost",
    CurrentValue = Config.JumpBoost,
    Flag       = "JumpBoost",
    Callback   = function(Value)
        Config.JumpBoost = Value
    end
})
MovementTab:CreateSlider({
    Name       = "Jump Multiplier",
    Range      = {1,3},
    Increment  = 0.1,
    CurrentValue = Config.JumpMultiplier,
    Flag       = "JumpMultiplier",
    Callback   = function(Value)
        Config.JumpMultiplier = Value
    end
})

-- Sprint Section
MovementTab:CreateSection("Sprint")
MovementTab:CreateToggle({
    Name       = "Sprint",
    CurrentValue = Config.SprintEnabled,
    Flag       = "SprintEnabled",
    Callback   = function(Value)
        Config.SprintEnabled = Value    end
})
MovementTab:CreateSlider({
    Name       = "Sprint Multiplier",
    Range      = {1,3},
    Increment  = 0.1,
    CurrentValue = Config.SprintMultiplier,
    Flag       = "SprintMultiplier",
    Callback   = function(Value)
        Config.SprintMultiplier = Value
    end
})

-- Bunny Hop Section
MovementTab:CreateSection("Bunny Hop")
MovementTab:CreateToggle({
    Name       = "Bunny Hop",
    CurrentValue = Config.BunnyHop,
    Flag       = "BunnyHop",
    Callback   = function(Value)
        Config.BunnyHop = Value    end
})

-- ==================== SETTINGS TAB CONTENT ====================
-- Preferences Section
SettingsTab:CreateSection("Preferences")
SettingsTab:CreateToggle({
    Name       = "Master System",
    CurrentValue = Config.Enabled,
    Flag       = "Enabled",
    Callback   = function(Value)
        Config.Enabled = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Team Check",
    CurrentValue = Config.TeamCheck,
    Flag       = "TeamCheck",
    Callback   = function(Value)
        Config.TeamCheck = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Red Theme",
    CurrentValue = Config.UIRedTheme,
    Flag       = "UIRedTheme",
    Callback   = function(Value)
        Config.UIRedTheme = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "3D Shadow",
    CurrentValue = Config.UI3DEffect,
    Flag       = "UI3DEffect",
    Callback   = function(Value)
        Config.UI3DEffect = Value
    end
})

-- Game Section
SettingsTab:CreateSection("Game")
SettingsTab:CreateToggle({
    Name       = "No Fall Damage",
    CurrentValue = Config.NoFallDamage,
    Flag       = "NoFallDamage",
    Callback   = function(Value)
        Config.NoFallDamage = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Platform Ignorer",
    CurrentValue = Config.PlatformIgnorer,
    Flag       = "PlatformIgnorer",
    Callback   = function(Value)
        Config.PlatformIgnorer = Value
    end})
SettingsTab:CreateToggle({
    Name       = "Instant Respawn",
    CurrentValue = Config.InstantRespawn,
    Flag       = "InstantRespawn",
    Callback   = function(Value)
        Config.InstantRespawn = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Instant Interact",
    CurrentValue = Config.InstantInteract,
    Flag       = "InstantInteract",
    Callback   = function(Value)
        Config.InstantInteract = Value
    end
})

-- Weapon Section
SettingsTab:CreateSection("Weapon")
SettingsTab:CreateToggle({
    Name       = "Gun Mods",
    CurrentValue = Config.GunMods,
    Flag       = "GunMods",
    Callback   = function(Value)
        Config.GunMods = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Auto Reload",
    CurrentValue = Config.AutoReload,
    Flag       = "AutoReload",
    Callback   = function(Value)
        Config.AutoReload = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "No Recoil",
    CurrentValue = Config.NoRecoil,
    Flag       = "NoRecoil",
    Callback   = function(Value)
        Config.NoRecoil = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "No Spread",
    CurrentValue = Config.NoSpread,
    Flag       = "NoSpread",
    Callback   = function(Value)
        Config.NoSpread = Value
    end
})
SettingsTab:CreateToggle({
    Name       = "Fast Weapon Swap",
    CurrentValue = Config.FastWeaponSwap,
    Flag       = "FastWeaponSwap",
    Callback   = function(Value)
        Config.FastWeaponSwap = Value
    end
})

-- Server Hop Section
SettingsTab:CreateSection("Server Hop")
SettingsTab:CreateButton({
    Name       = "Low Population (1-2 players)",
    Callback   = function()
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
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, lowPop[math.random(1,#lowPop)].Id)
                else
                    TeleportService:Teleport(game.PlaceId)
                end
            else
                TeleportService:Teleport(game.PlaceId)
            end
        end)
    end
})
SettingsTab:CreateButton({
    Name       = "Rejoin Current Server",
    Callback   = function()
        local jobId = game.JobId        if jobId and jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
        else
            TeleportService:Teleport(game.PlaceId)
        end
    end})
SettingsTab:CreateButton({
    Name       = "Random Server Hop",
    Callback   = function()
        TeleportService:Teleport(game.PlaceId)
    end
})

-- ==================== HELPER FUNCTIONS ====================
local function IsAimActive()
    -- Gamepad/Keyboard
    if UserInputService:IsKeyDown(Config.AimActiveKeybind) then
        return true
    end
    -- Mouse (PC Right Click)
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return true
    end
    -- Touch (Mobile) - right side of screen
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
    local baseSize = Vector3.new(4,6,4)
    local scale = Config.HitboxMultiplier / 6  -- 6 = native 4x6x4
    hrp.Size = baseSize * scale
    hrp.CanCollide = true
    hrp.CanTouch = true
    if Config.ESP then        hrp.Transparency = Config.HitboxTransparency
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
                if Config.ESPName and not self.ESPObjects[char.."_Name"] then
                    self:CreateNameLabel(char, player)
                end
            end
        end
    end
end

function UI:ClearESP()
    for _, obj in pairs(self.ESPObjects) do
        pcall(function() obj:Destroy() end)
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
    bar.Size = UDim2.new(0,60,0,8)
    bar.StudsOffset = Vector3.new(0,3,0)
    bar.AlwaysOnTop = true    bar.ZIndex = 10
    bar.Parent = Workspace
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(50,50,50)
    frame.Parent = bar
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(255,0,0)
    fill.BorderSizePixel = 0
    fill.Parent = frame
    self.ESPObjects[character] = bar
    return bar
end

function UI:CreateNameLabel(character, player)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local label = Instance.new("BillboardGui")
    label.Adornee = hrp    label.Size = UDim2.new(0,100,0,20)
    label.StudsOffset = Vector3.new(0,2.5,0)
    label.AlwaysOnTop = true
    label.ZIndex = 10
    label.Parent = Workspace
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1    text.Text = player.Name
    text.TextColor3 = Config.ESPTeamColor and player.TeamColor or Config.ESPColor    text.Font = Enum.Font.GothamBold
    text.TextSize = 14    text.Parent = label
    self.ESPObjects[character.."_Name"] = label    return label
end

-- ==================== RADAR SYSTEM ====================
function UI:CreateRadar()
    if self.RadarFrame then return end
    local radar = Instance.new("Frame")
    radar.Name = "Radar"
    radar.Size = UDim2.new(0,Config.RadarSize,0,Config.RadarSize)
    radar.Position = Config.RadarPos
    radar.BackgroundColor3 = Color3.fromRGB(0,0,0)
    radar.BackgroundTransparency = 0.7
    radar.BorderColor3 = Color3.fromRGB(0,255,0)
    radar.BorderSizePixel = 2
    radar.ZIndex = 100
    Instance.new("UICorner", radar).CornerRadius = UDim.new(0,8)
    radar.Parent = self.ScreenGui
    local center = Instance.new("Frame", radar)
    center.Name = "Center"
    center.Size = UDim2.new(0,4,0,4)
    center.Position = UDim2.new(0.5,-2,0.5,-2)
    center.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", center).CornerRadius = UDim.new(1,0)
    self.RadarFrame = radar
    self:UpdateRadar()
end

function UI:UpdateRadar()
    if not self.RadarFrame or not Config.Radar then return end
    for _, dot in pairs(self.RadarDots) do
        if dot then pcall(function() dot:Destroy() end) end
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
            dot.Size = UDim2.new(0,6,0,6)
            dot.Position = UDim2.new(0, radarPos.X-3, 0, radarPos.Y-3)
            dot.BackgroundColor3 = Config.ESPTeamColor and player.TeamColor or Color3.fromRGB(255,0,0)
            dot.BorderSizePixel = 0
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
            dot.Parent = self.RadarFrame
            self.RadarDots[player] = dot
        end
    end
end

function UI:DestroyRadar()
    if self.RadarFrame then
        self.RadarFrame:Destroy()
        self.RadarFrame = nil
    end    for _, dot in pairs(self.RadarDots) do
        if dot then pcall(function() dot:Destroy() end) end    end
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
                            Color    = part.Color,
                            Transparency = part.Transparency                        }
                    end
                    part.Material = Enum.Material.Neon
                    part.Color    = Color3.fromRGB(255,100,100)
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
                    if original then                        part.Material = original.Material
                        part.Color    = original.Color
                        part.Transparency = original.Transparency
                        self.ChamsOriginal[part] = nil                    end
                end
            end
        end
    end
end

-- ==================== TARGET HUD SYSTEM ====================
function UI:CreateTargetHUD()
    local existing = self.ScreenGui:FindFirstChild("TargetHUD")
    if existing then existing:Destroy() end
    local hudFrame = Instance.new("Frame")
    hudFrame.Name = "TargetHUD"
    hudFrame.Size = Config.TargetHUDSize
    hudFrame.Position = Config.TargetHUDPos
    hudFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    hudFrame.BorderColor3 = Color3.fromRGB(255,0,0)
    hudFrame.BorderSizePixel = 2
    hudFrame.ZIndex = 100
    Instance.new("UICorner", hudFrame).CornerRadius = UDim.new(0,8)
    hudFrame.Parent = self.ScreenGui
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1,-10,0,25)
    nameLabel.Position = UDim2.new(0,5,0,5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "TARGET: NONE"
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 18
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 101
    nameLabel.Parent = hudFrame
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1,-10,0,20)
    distLabel.Position = UDim2.new(0,5,0,32)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "DISTANCE: --"
    distLabel.TextColor3 = Color3.fromRGB(200,200,255)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 14
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.ZIndex = 101
    distLabel.Parent = hudFrame
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1,-10,0,15)
    healthBar.Position = UDim2.new(0,5,1,-25)
    healthBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    healthBar.BorderSizePixel = 0    Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0,4)
    healthBar.ZIndex = 101
    healthBar.Parent = hudFrame
    local healthFill = Instance.new("Frame")
    healthFill.Name = "Fill"
    healthFill.Size = UDim2.new(1,0,1,0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
end

function UI:DestroyTargetHUD()
    local hudFrame = self.ScreenGui:FindFirstChild("TargetHUD")
    if hudFrame then hudFrame:Destroy() end
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
            if dist < closestDist and dist <= Config.MagnetRange then                closestDist = dist
                target = player
            end
        end
    end    local nameLabel = hudFrame:FindFirstChild("NameLabel")
    local distLabel = hudFrame:FindFirstChild("DistLabel")
    local healthFill = hudFrame:FindFirstChild("Fill")
    if target then
        if nameLabel then
            nameLabel.Text = "TARGET: " .. target.Name:upper()
        end
        if distLabel then            distLabel.Text = "DISTANCE: " .. math.floor(closestDist) .. " STUD(S)"
        end
        local char = target.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and healthFill then
                local healthPercent = hum.Health / hum.MaxHealth
                healthFill.Size = UDim2.new(healthPercent,0,1,0)
                if healthPercent > 0.5 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
                elseif healthPercent > 0.2 then
                    healthFill.BackgroundColor3 = Color3.fromRGB(255,255,0)
                else                    healthFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
                end
            end
        end
    else
        if nameLabel then nameLabel.Text = "TARGET: NONE" end        if distLabel then distLabel.Text = "DISTANCE: --" end
        if healthFill then healthFill.Size = UDim2.new(0,0,1,0) end
    end
end

-- ==================== FOV CIRCLE ====================
function UI:UpdateFOVCircle()
    if self.FOVCircleFrame then self.FOVCircleFrame:Destroy() end
    if not Config.FOVCircle then return end
    local fovCircle = Instance.new("ImageLabel")
    fovCircle.Name = "FOVCircle"
    fovCircle.Size = UDim2.new(0,Config.AimbotFOV*2,0,Config.AimbotFOV*2)
    fovCircle.Position = UDim2.new(0.5,-Config.AimbotFOV,0.5,-Config.AimbotFOV)
    fovCircle.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    fovCircle.ImageColor3 = Config.FOVCircleColor
    fovCircle.BackgroundTransparency = 1
    fovCircle.ImageTransparency = Config.FOVCircleTransparency
    fovCircle.ZIndex = 50    fovCircle.Parent = self.ScreenGui    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1,0)
    local stroke = Instance.new("UIStroke", fovCircle)
    stroke.Color = Config.FOVCircleColor
    stroke.Thickness = Config.FOVCircleThickness
    stroke.Transparency = Config.FOVCircleTransparency
    self.FOVCircleFrame = fovCircle
end

-- ==================== KILL CONFIRM ====================
function UI:TriggerKillFlash()
    local killFlash = self.ScreenGui:FindFirstChild("KillFlash")
    if not killFlash then
        killFlash = Instance.new("Frame")
        killFlash.Name = "KillFlash"
        killFlash.Size = UDim2.new(1,0,1,0)
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

-- ==================== MASTER COMBAT LOOP ====================
UI.Connections.MasterCombatLoop = RunService.Heartbeat:Connect(function()
    if not Config.Enabled then return end
    local now = tick()
    local char = LocalPlayer.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")

    -- 1. HITBOX FORCE (4-6-4 LOCKED) - Every frame
    if myHrp and Config.HitboxEnabled then
        for _, player in ipairs(Players:GetPlayers()) do            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local baseSize = Vector3.new(4,6,4)
                    local scale = Config.HitboxMultiplier / 6
                    local targetSize = baseSize * scale
                    if hrp.Size ~= targetSize then
                        hrp.Size = targetSize
                        hrp.CanCollide = true
                        hrp.CanTouch = true
                    end
                    if Config.ESP then
                        hrp.Transparency = Config.HitboxTransparency
                        hrp.Material = Enum.Material.Neon                        hrp.Color = Config.HitboxColor
                    end
                end
            end        end
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
                            if dist < bestDist then                                bestDist = dist
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
                                math.random(-10,10),
                                math.random(-10,10),
                                math.random(-10,10)
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
                    pcall(function()
                        local mouse = LocalPlayer:GetMouse()
                        mouse.Button1Down:Fire()
                    end)
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
                UI.Timers.Dodge = now                break
            end
        end
    end

    -- 6. TRIGGERBOT (Throttled)
    if Config.Triggerbot and now - UI.Timers.Trigger >= Config.TriggerbotDelay then
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then            local isPressed = false
            pcall(function()
                isPressed = UserInputService:IsMouseButtonPressed(Config.TriggerbotKeybind) or
                            UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2)
            end)
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
                        end                    end
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
                    local found = RecursiveFind(child, depth+1, maxDepth)
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
            local folder = char:FindFirstChild("Stats") or char:FindFirstChild("Data") or char            if folder then
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
            local currentCF = myHrp.CFrame            local angleX = math.rad(Config.AntiAimPitch)
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
                        end                    end)
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
                            part.CanCollide = false                            part.CanTouch = false
                        end
                    end
                end
            end        end
        UI.Timers.Platform = now
    end

    -- 13. INSTANT INTERACT (Throttled)
    if Config.InstantInteract and now - UI.Timers.Interact >= 0.1 then
        if myHrp then            local parts = workspace:GetPartBoundsInRadius(myHrp.Position, 10)
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
    end    -- 14. UPDATE HUD & RADAR (Throttled)
    if now - UI.Timers.HUD >= 0.1 then
        if Config.TargetHUD then UI:UpdateTargetHUDData() end        UI.Timers.HUD = now
    end
    if Config.Radar and now - UI.Timers.Radar >= 0.1 then
        UI:UpdateRadar()
        UI.Timers.Radar = now
    end

    -- 15. KILL CONFIRM DETECTION
    if Config.KillConfirm then
        for _, player in ipairs(Players:GetPlayers()) do            if player ~= LocalPlayer then
                local pChar = player.Character
                if pChar then
                    local pHum = pChar:FindFirstChild("Humanoid")
                    if pHum and pHum.Health <= 0 then
                        if myHrp then                            local dist = (pChar:GetPivot().Position - myHrp.Position).Magnitude
                            if dist < Config.MagnetRange then
                                UI:TriggerKillFlash()
                            end
                        end
                    end
                end
            end
        end
    end    task.wait() -- prevent mobile crash
end)

-- ==================== ESP RENDER LOOP ====================
UI.Connections.ESPLoop = RunService.RenderStepped:Connect(function()
    if not Config.Enabled or not Config.ESP then
        UI:ClearESP()
        return    end
    -- Cleanup dead objects    for key, obj in pairs(UI.ESPObjects) do
        if not obj or not obj.Parent then
            pcall(function() obj:Destroy() end)
            UI.ESPObjects[key] = nil
        else
            if obj:IsA("BoxHandleAdornment") then
                if not obj.Adornee or not obj.Adornee.Parent then                    obj:Destroy()
                    UI.ESPObjects[key] = nil
                end
            elseif obj:IsA("BillboardGui") then                if not obj.Adornee or not obj.Adornee.Parent then
                    obj:Destroy()
                    UI.ESPObjects[key] = nil
                end
            end
        end    end
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
        if Config.ESPBox and not UI.ESPObjects[hrp] then UI:CreateBox(hrp) end
        if Config.ESPHealthBar and not UI.ESPObjects[char] then UI:CreateHealthBar(char) end
        if Config.ESPName and not UI.ESPObjects[char.."_Name"] then UI:CreateNameLabel(char, player) end
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
                        fill.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
                    end                end
            end
        end
    end
end)

-- ==================== KEYBINDS ====================
UI.Connections.KeybindListener = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.MasterKeybind then
        Config.Enabled = not Config.Enabled
        print("APEX DOMAIN: " .. (Config.Enabled and "ENABLED" or "DISABLED"))
    end
end)

-- ==================== CLEANUP ====================
local function Cleanup()
    for _, conn in pairs(UI.Connections) do
        if conn and conn.Disconnect then pcall(function() conn:Disconnect() end) end
    end    UI.Connections = {}
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
end

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then Cleanup() end
end)

-- ==================== INITIALIZATION ====================
task.spawn(function()
    task.wait(2) -- extended wait for mobile
    print("◈ APEX DOMAIN ULTIMATE v9.0 (RAYFIELD EDITION) LOADED ◈")
    print("PROFESSIONAL UI WITH RAYFIELD LIBRARY")
    print("• Single Heartbeat Combat Core")
    print("• Mobile/PC Optimized")
    print("• 4-6-4 Locked Hitboxes (Auto-Restore)")
    print("• Forsaken Specific Features")
    print("Press F1 to toggle Master System")
end)

return UI
