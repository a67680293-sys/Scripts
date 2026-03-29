-- [[ FORSAKEN OMNI-SUITE: APEX PREDATOR EDITION ]] --
-- A culmination of advanced techniques for Forsaken, focusing on absolute performance, undetectability, and user control.
-- This script is not for public distribution. Use responsibly.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ APEX PREDATOR SETTINGS ]] --
local SETTINGS = {
    -- Core Aiming
    Enabled = false,
    AimKey = Enum.KeyCode.Q,
    AimMode = "Projectile", -- "Projectile" or "Hitscan" (for future weapons)
    Prediction = 0.165,      -- Base prediction time in seconds
    HitboxMultiplier = 1.0,  -- Multiplies the target's hitbox size (1.0 = normal, 1.5 = 50% larger)
    MaxRange = 350,          -- Max range to acquire a target
    
    -- Advanced Targeting
    TargetPriority = "Closest", -- "Closest", "Health", "Crosshair"
    TeamCheck = true,
    VisibilityCheck = true, -- Only aims at targets visible to the camera
    AntiAimbotEvasion = true, -- Attempts to counter other players' aimbots
    
    -- Undetectability & Performance
    Smoothness = 0.12,      -- How smooth the aim correction is (0 = instant, 1 = very slow)
    Humanization = 0.08,     -- Adds subtle, human-like micro-movements
    Randomness = 0.015,     -- Adds slight randomness to prediction to avoid robotic patterns
    UpdateRate = 0.008,     -- How often the aim is updated (lower is more responsive but more demanding)
    DynamicFOV = true,      -- Adjusts aim assistance based on target distance
    SilentAim = true,       -- Aims without moving your camera (if possible with the game's mechanics)
    
    -- UI & Visuals
    ShowFOV = true,
    FOVSize = 80,
    FOVColor = Color3.fromRGB(255, 255, 255),
    ShowTracer = true,
    TracerColor = Color3.fromRGB(255, 0, 100),
    AnimeBackground = "rbxassetid://14451731631"
}

-- [[ SCRIPT STATE ]] --
local ActiveProjectiles = {}
local CurrentTarget = nil
local IsAiming = false
local LastUpdateTime = 0
local MouseLocation = UserInputService.GetMouseLocation()

-- [[ ADVANCED UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 480)
Main.Position = UDim2.new(0.5, -160, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Anime Background
local BackgroundImage = Instance.new("ImageLabel", Main)
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Image = SETTINGS.AnimeBackground
BackgroundImage.ImageTransparency = 0.6
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.BackgroundTransparency = 1
local Gradient = Instance.new("UIGradient", BackgroundImage)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 0, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
Gradient.Rotation = 45

-- Top Bar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 0.6
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "APEX PREDATOR SUITE"
Title.TextColor3 = Color3.fromRGB(255, 60, 120)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Minimize Button
local HideBtn = Instance.new("TextButton", TopBar)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.9, 0, 0.15, 0)
HideBtn.Text = "_"
HideBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 5)

-- Sukuna Circular Icon (Minimized State)
local SukunaIcon = Instance.new("ImageButton", ScreenGui)
SukunaIcon.Size = UDim2.new(0, 70, 0, 70)
SukunaIcon.Image = SETTINGS.AnimeBackground
SukunaIcon.Visible = false
SukunaIcon.BackgroundTransparency = 1
Instance.new("UICorner", SukunaIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", SukunaIcon)
IconStroke.Thickness = 2
IconStroke.Color = Color3.fromRGB(255, 50, 120)

-- Main Toggle Button
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.9, 0, 0, 50)
Toggle.Position = UDim2.new(0.05, 0, 0.15, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Toggle.Text = "SUITE: STANDBY"
Toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = Color3.fromRGB(255, 50, 120)
ToggleStroke.Thickness = 2

-- Settings Container
local SettingsContainer = Instance.new("ScrollingFrame", Main)
SettingsContainer.Size = UDim2.new(0.9, 0, 0, 320)
SettingsContainer.Position = UDim2.new(0.05, 0, 0.28, 0)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.ScrollBarThickness = 4
SettingsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
local SettingsListLayout = Instance.new("UIListLayout", SettingsContainer)
SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsListLayout.Padding = UDim.new(0, 5)

-- Helper function to create settings
local function createSetting(layoutOrder, labelText, defaultValue, isSlider, callback)
    local SettingFrame = Instance.new("Frame", SettingsContainer)
    SettingFrame.Size = UDim2.new(1, 0, 0, 30)
    SettingFrame.BackgroundTransparency = 1
    SettingFrame.LayoutOrder = layoutOrder

    local Label = Instance.new("TextLabel", SettingFrame)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.BackgroundTransparency = 1
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Input
    if isSlider then
        Input = Instance.new("TextBox", SettingFrame)
        Input.Size = UDim2.new(0.4, 0, 1, 0)
        Input.Position = UDim2.new(0.55, 0, 0, 0)
        Input.Text = tostring(defaultValue)
        Input.BackgroundColor3 = Color3.from
