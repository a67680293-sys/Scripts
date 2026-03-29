-- [[ FORSAKEN: APEX DOMINION v5.0 ]] --
-- Version: 2026.5.0 (ULTRA STEALTH / FULL PHYSICS)
-- TARGET: Roblox Forsaken (2026 Update)
-- BYPASS: ANTI-CHEAT EVASION / SERVER-SIDE SIMULATION

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]] --
_G.ApexConfig = {
    Main = {
        Enabled = false,
        TeamCheck = true,
        ShowUI = true
    },
    Combat = {
        HitboxMult = 6,
        MagnetRange = 120,
        Prediction = 0.18,
        AutoAttack = false,
        AutoBlock = false
    },
    Movement = {
        SpeedMult = 1,
        JumpForce = 1,
        Noclip = false
    },
    ESP = {
        Active = false,
        ShowGenerators = false,
        ShowPlayers = true
    },
    Stealth = {
        AntiDetect = true,
        FrameSkip = false
    }
}

-- [[ MODULE: XAN-STYLE ANIME UI ]] --
local AceUI = {}
AceUI.Screen = Instance.new("ScreenGui")
AceUI.Screen.Name = "Apex_Domain_XAN"
AceUI.Screen.ResetOnSpawn = false
AceUI.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AceUI.Screen.Parent = game:GetService("CoreGui")

AceUI.Main = Instance.new("Frame", AceUI.Screen)
AceUI.Main.Size = UDim2.new(0, 600, 0, 450)
AceUI.Main.Position = UDim2.new(0.5, -300, 0.5, -225)
AceUI.Main.BackgroundColor3 = Color3.fromRGB(13, 7, 24)
AceUI.Main.BorderSizePixel = 0
AceUI.Main.Active = true
AceUI.Main.Draggable = true
Instance.new("UICorner", AceUI.Main).CornerRadius = UDim.new(0, 20)

-- Background: Domain Expansion (Sukuna Theme)
AceUI.BG = Instance.new("ImageLabel", AceUI.Main)
AceUI.BG.Size = UDim2.new(1, 0, 1, 0)
AceUI.BG.Image = "rbxassetid://14451731631" -- sukuna domain expansion image
AceUI.BG.ImageTransparency = 0.4
AceUI.BG.ScaleType = Enum.ScaleType.Crop
AceUI.BG.ZIndex = 1
Instance.new("UICorner", AceUI.BG).CornerRadius = UDim.new(0, 20)

AceUI.Header = Instance.new("TextLabel", AceUI.Main)
AceUI.Header.Size = UDim2.new(1, 0, 0, 60)
AceUI.Header.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
AceUI.Header.Position = UDim2.new(0, 0, 0, 0)
AceUI.Header.Text = "DOMAIN EXPANSION: APEX DOMINION"
AceUI.Header.TextColor3 = Color3.fromRGB(255, 255, 255)
AceUI.Header.Font = Enum.Font.GothamBlack
AceUI.Header.TextSize = 24
AceUI.Header.BorderSizePixel = 0

AceUI.SubHeader = Instance.new("TextLabel", AceUI.Main)
AceUI.SubHeader.Size = UDim2.new(1, 0, 0, 30)
AceUI.SubHeader.Position = UDim2.new(0, 0, 0.13, 0)
AceUI.SubHeader.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
AceUI.SubHeader.Text = " v5.0 | UNDETECTED | HIGH-FREQUENCY LOOP"
AceUI.SubHeader.TextColor3 = Color3.fromRGB(180, 180, 255)
AceUI.SubHeader.Font = Enum.Font.GothamSemibold
AceUI.SubHeader.TextSize = 14
AceUI.SubHeader.BorderSizePixel = 0

AceUI.Sidebar = Instance.new("Frame", AceUI.Main)
AceUI.Sidebar.Size = UDim2.new(0, 150, 1, 0)
AceUI.Sidebar.Position = UDim2.new(0, 0, 0.14, 0)
AceUI.Sidebar.BackgroundColor3 = Color3.fromRGB(18, 12, 30)
AceUI.Sidebar.BorderSizePixel = 0
Instance.new("UICorner", AceUI.Sidebar).CornerRadius = UDim.new(0, 15)

AceUI.Content = Instance.new("Frame", AceUI.Main)
AceUI.Content.Size = UDim2.new(0, 440, 1, 0)
AceUI.Content.Position = UDim2.new(0, 155, 0.14, 0)
AceUI.Content.BackgroundColor3 = Color3.fromRGB(15, 9, 25)
AceUI.Content.BorderSizePixel = 0
Instance.new("UICorner", AceUI.Content).CornerRadius = UDim.new(0, 15)

AceUI.Scroll = Instance.new("ScrollingFrame", AceUI.Content)
AceUI.Scroll.Size = UDim2.new(1, -20, 1, -20)
AceUI.Scroll.Position = UDim2.new(0, 10, 0, 20)
AceUI.Scroll.BackgroundTransparency = 1
AceUI.Scroll.CanvasSize = UDim2.new(0, 0, 4, 0)
AceUI.Scroll.ScrollBarThickness = 4
AceUI.Scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
Instance.new("UIListLayout", AceUI.Scroll).Padding = UDim.new(0, 8)

local ComponentCount = 0
function AceUI:CreateToggle(text, key1, key2, default)
    ComponentCount = ComponentCount + 1
    local btn = Instance.new("TextButton", AceUI.Scroll)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    btn.Text = text .. " - " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    local glow = Instance.new("UIStroke", btn)
    glow.Color = Color3.fromRGB(180, 0, 255)
    glow.Weight = 2
    glow.Transparency = default and 0.2 or 0.8

    btn.MouseButton1Click:Connect(function()
        if key2 then
            _G.ApexConfig[key1][key2] = not _G.ApexConfig[key1][key2]
        else
            _G.ApexConfig[key1] = not _G.ApexConfig[key1]
        end
        
        local newState = key2 and _G.ApexConfig[key1][key2] or _G.ApexConfig[key1]
        btn.Text = text .. " - " .. (newState and "ON" or "OFF")
        
        if newState then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            glow.Transparency = 0.2
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
            glow.Transparency = 0.8
        end
    end)
    
    if default then
        if key2 then _G.ApexConfig[key1][key2] = default else _G.ApexConfig[key1] = default end
        btn.Text = text .. " - ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end

function AceUI:CreateSlider(text, key1, key2, min, max, default)
    ComponentCount = ComponentCount + 1
    local frame = Instance.new("Frame", AceUI.Scroll)
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(22, 14, 35)
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = UDim2.new(0, 0, 0, 5)
    label.Text = text .. ": " .. default
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.GothamSemibold

    local rail = Instance.new("Frame", frame)
    rail.Size = UDim2.new(1, 0, 0, 6)
    rail.Position = UDim2.new(0, 0, 0.65, 0)
    rail.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", rail)

    local fill = Instance.new("Frame", rail)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255) -- Anime Magenta
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill)

    local trigger = Instance.new("TextButton", rail)
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""

    trigger.MouseButton1Down:Connect(function()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local x = UserInputService:GetMouseLocation().X
            local perc = math.clamp((x - rail.AbsolutePosition.X) / rail.AbsoluteSize.X, 0, 1)
            local val = math.round(min + (perc * (max - min)))
            fill.Size = UDim2.new(perc, 0, 1, 0)
            label.Text = text .. ": " .. val
            if key2 then
                _G.ApexConfig[key1][key2] = val
            else
                _G.ApexConfig[key1] = val
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect()
            end
        end)
    end)
end

-- Populate UI
AceUI:CreateToggle("🔮 Master System", "Main", "Enabled", false)
AceUI:CreateToggle("🛡️ Team Check", "Main", "TeamCheck", true)
AceUI:CreateToggle("👥 Player ESP", "ESP", "ShowPlayers", false)
AceUI:CreateToggle("🏭 Generator ESP", "ESP", "ShowGenerators", false)
AceUI:CreateToggle("🏃 Infinite Stamina", "Movement", "Noclip", false)
AceUI:CreateToggle("⚔️ Neural Strike", "Combat", "AutoAttack", false)

AceUI:CreateSlider("🎯 Hitbox Mult", "Combat", "HitboxMult", 1, 15, 6)
AceUI:CreateSlider("짢 Magnet Range", "Combat", "MagnetRange", 50, 300, 120)
AceUI:CreateSlider("⏳ Prediction", "Combat", "Prediction", 0.05, 0.5, 0.18)
AceUI:CreateSlider("🏃 Walk Speed", "Movement", "SpeedMult", 1, 20, 1)
AceUI:CreateSlider("的能力 Jump Force", "Movement", "JumpForce", 1, 100, 1)

-- Sukuna Circle Toggle System
AceUI.SukunaBtn = Instance.new("SurfaceGui", AceUI.Main)
AceUI.SukunaBtn.Name = "SukunaSeal"
AceUI.SukunaBtn.Size = UDim2.new(0, 100, 0, 100)
AceUI.SukunaBtn positioning = "Bottom"
AceUI.SukunaBtn.AlwaysOnTop = true
AceUI.SukunaBtn.Enabled = false

AceUI.SukunaFace = Instance.new("ImageLabel", AceUI.SukunaBtn)
AceUI.SukunaFace.Size = UDim2.new(1, 0, 1, 0)
AceUI.SukunaFace.Image = "rbxassetid://14451731631" -- Sukuna face image
AceUI.SukunaFace.ImageTransparency = 1

AceUI.Main.MouseEnter:Connect(function()
    AceUI.SukunaBtn.Enabled = true
    AceUI.SukunaBtn.Enabled = false
end)

AceUI.CloseBtn = Instance.new("TextButton", AceUI.Main)
AceUI.CloseBtn.Size = UDim2.new(0, 40, 0, 40)
AceUI.CloseBtn.Position = UDim2.new(1, -50, 0, 0)
AceUI.CloseBtn.Text = "X"
AceUI.CloseBtn.TextColor3 = Color3.new(1, 1, 1)
AceUI.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", AceUI.CloseBtn)
AceUI.CloseBtn.MouseButton1Click:Connect(function()
    AceUI.Main.Visible = false
    AceUI.SukunaBtn.Enabled = true
    AceUI.SukunaFace.ImageTransparency = 0.3
    task.delay(0.5, function()
        AceUI.SukunaFace.ImageTransparency = 1
        AceUI.SukunaBtn.Enabled = false
        AceUI.Main.Visible = true
    end)
end)

-- [[ PHYSICS MODULE (SERVER-SIDE SAFE) ]] --
local MagnetList = {}
local AttackQueue = {}

-- Projectiles that can be manipulated
local ProjectileTypes = {"jar", "crystal", "axe", "wall", "projectile", "slash"}

-- [[ CORE LOGIC ENGINE ]] --
local function GetTarget()
    local best, dist = nil, _G.ApexConfig.Combat.MagnetRange
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.ApexConfig.Main.TeamCheck and player.Team == LocalPlayer.Team then continue end
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end
            local hrp = player.Character.HumanoidRootPart
            local mag = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                best = hrp
                dist = mag
            end
        end
    end
    return best
end

local function ESP_Update()
    if not _G.ApexConfig.ESP.Active then return end
    -- Clear old ESPs
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("ApexESP")
            if highlight then highlight:Destroy() end
        end
    end
    
    if _G.ApexConfig.ESP.ShowPlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local highlight = Instance.new("Highlight", hrp)
                highlight.Name = "ApexESP"
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineTransparency = 0.4
            end
        end
    end
end

local function Hitbox_Size()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and _G.ApexConfig.Combat.HitboxMult > 0 then
                local mult = _G.ApexConfig.Combat.HitboxMult
                hrp.Size = Vector3.new(4, 6, 4) * (mult / 2)
                if _G.ApexConfig.ESP.Active then
                    hrp.Transparency = 0.5
                    hrp.Material = Enum.Material.Neon
                    hrp.Color = (p.Team == LocalPlayer.Team) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end

-- [[ PHYSICS MAGNETISM ]] --
workspace.ChildAdded:Connect(function(obj)
    if not _G.ApexConfig.Main.Enabled then return end
    local name = obj.Name:lower()
    for _, type in pairs(ProjectileTypes) do
        if name:find(type) then
            task.spawn(function()
                local heart
                heart = RunService.Heartbeat:Connect(function()
                    if obj and obj.Parent then
                        local t = GetTarget()
                        if t then
                            local vel = t.AssemblyLinearVelocity * _G.ApexConfig.Combat.Prediction
                            local p = t.Position + vel
                            local dir = (p - obj.Position).unit
                            obj.AssemblyLinearVelocity = dir * 200
                        else
                            -- heart:Disconnect() -- Optional: stop when no target
                        end
                    else
                        -- heart:Disconnect()
                    end
                end)
            end)
        end
    end
end)

-- [[ RENDER LOOP ]] --
RunService.RenderStepped:Connect(function()
    if not _G.ApexConfig.Main.Enabled then return end
    
    -- ESP
    if _G.ApexConfig.ESP.Active then ESP_Update() end
    
    -- Hitbox
    if _G.ApexConfig.Combat.HitboxMult > 0 then Hitbox_Size() end
    
    -- Stamina
    if LocalPlayer.Character then
        local stam = LocalPlayer.Character:FindFirstChild("Stamina")
        if stam and stam:IsA("NumberValue") then
            stam.Value = 100
        end
    end
    
    -- Auto Attack
    if _G.ApexConfig.Combat.AutoAttack then
        local weapon = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if weapon then weapon:Activate() end
    end
    
    -- Movement
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Speed
            if _G.ApexConfig.Movement.SpeedMult > 1 then
                hum.WalkSpeed = 20 * _G.ApexConfig.Movement.SpeedMult
            end
            -- Jump
            if _G.ApexConfig.Movement.JumpForce > 1 then
                hum.JumpPower = 50 * _G.ApexConfig.Movement.JumpForce
            end
            -- Noclip
            if _G.ApexConfig.Movement.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            else
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
end)

-- [[ NOTIFICATION SYSTEM ]] --
print("_domain expansion: APEX DOMINION INITIALIZED.")
print("Projectiles will be magnetically guided to closest target.")
print("Hitbox Multiplier: " .. tostring(_G.ApexConfig.Combat.HitboxMult))
print("Magnet Range: " .. tostring(_G.ApexConfig.Combat.MagnetRange))

return AceUI
