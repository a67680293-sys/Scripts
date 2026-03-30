-- [[ FORSAKEN: APEX DOMAIN - STEALTH PHASE v3.0 ]] --
-- VERSION: 2026.5.5 (FULL UNABRIDGED MASTER)
-- STYLE: XAN 3D RENDER + SUKUNA DOMAIN
-- POWER: ORIGINAL 4-6-4 HITBOXES & PREDICTIVE MAGNETISM

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ MASTER CONFIGURATION ]] --
local Config = {
    Enabled = false,
    HitboxMultiplier = 6,
    MagnetRange = 120,
    PredictionTime = 0.18,
    TeamCheck = true,
    InfStamina = false,
    ESP = false,
    Aimbot = false,
    AimbotSmoothness = 0.5,
    AimbotFOV = 90,
    Assets = {
        MainBG = "rbxassetid://14451731631", -- Image 1
        MinimizeIcon = "rbxassetid://14451731631" -- Image 2
    }
}

-- [[ UI SYSTEM: 3D SHADOW RENDER ENGINE ]] --
local UI = {}
UI.ScreenGui = Instance.new("ScreenGui")
UI.ScreenGui.Name = "Apex_Domain_v3_Final"
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 3D Shadow Layer (Depth)
UI.Shadow = Instance.new("Frame", UI.ScreenGui)
UI.Shadow.Size = UDim2.new(0, 526, 0, 426)
UI.Shadow.Position = UDim2.new(0.5, -263, 0.5, -213)
UI.Shadow.BackgroundColor3 = Color3.new(0,0,0)
UI.Shadow.BackgroundTransparency = 0.5
UI.Shadow.BorderSizePixel = 0
Instance.new("UICorner", UI.Shadow).CornerRadius = UDim.new(0, 15)

-- Main Frame
UI.Main = Instance.new("Frame", UI.ScreenGui)
UI.Main.Size = UDim2.new(0, 520, 0, 420)
UI.Main.Position = UDim2.new(0.5, -260, 0.5, -210)
UI.Main.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
UI.Main.BorderSizePixel = 0
UI.Main.Active = true
UI.Main.Draggable = true
Instance.new("UICorner", UI.Main).CornerRadius = UDim.new(0, 15)

-- Background Image (Sukuna Domain)
UI.BG = Instance.new("ImageLabel", UI.Main)
UI.BG.Size = UDim2.new(1, 0, 1, 0)
UI.BG.Image = Config.Assets.MainBG
UI.BG.ImageTransparency = 0.7
UI.BG.ScaleType = Enum.ScaleType.Crop
UI.BG.ZIndex = 0
Instance.new("UICorner", UI.BG).CornerRadius = UDim.new(0, 15)

-- Sidebar
UI.Sidebar = Instance.new("Frame", UI.Main)
UI.Sidebar.Size = UDim2.new(0, 130, 1, 0)
UI.Sidebar.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
UI.Sidebar.BackgroundTransparency = 0.2
UI.Sidebar.ZIndex = 1
Instance.new("UICorner", UI.Sidebar).CornerRadius = UDim.new(0, 15)

-- Close Button (To Minimize)
UI.CloseBtn = Instance.new("TextButton", UI.Sidebar)
UI.CloseBtn.Size = UDim2.new(1, -20, 0, 45)
UI.CloseBtn.Position = UDim2.new(0, 10, 0.88, 0)
UI.CloseBtn.Text = "Seal Domain"
UI.CloseBtn.TextColor3 = Color3.new(1, 1, 1)
UI.CloseBtn.Font = Enum.Font.GothamBold
UI.CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
UI.CloseBtn.ZIndex = 2
Instance.new("UICorner", UI.CloseBtn)

-- Content Scroll Frame
UI.Scroll = Instance.new("ScrollingFrame", UI.Main)
UI.Scroll.Size = UDim2.new(0, 360, 0, 350)
UI.Scroll.Position = UDim2.new(0, 140, 0, 55)
UI.Scroll.BackgroundTransparency = 1
UI.Scroll.CanvasSize = UDim2.new(0, 0, 5, 0) -- High Canvas for Unabridged spec
UI.Scroll.ScrollBarThickness = 2
UI.Scroll.ZIndex = 2
Instance.new("UIListLayout", UI.Scroll).Padding = UDim.new(0, 12)

-- [[ COMPONENT BUILDERS ]] --
function UI:CreateToggle(text, key)
    local btn = Instance.new("TextButton", UI.Scroll)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    btn.Text = "  " .. text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        btn.Text = "  " .. text .. ": " .. (Config[key] and "ON" or "OFF")
        btn.BackgroundColor3 = Config[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 25, 50)
    end)
end

function UI:CreateSlider(text, key, min, max, default)
    local frame = Instance.new("Frame", UI.Scroll)
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(0.8, 0.8, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold

    local rail = Instance.new("Frame", frame)
    rail.Size = UDim2.new(1, 0, 0, 8)
    rail.Position = UDim2.new(0, 0, 0.7, 0)
    rail.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", rail)

    local fill = Instance.new("Frame", rail)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    Instance.new("UICorner", fill)

    local trigger = Instance.new("TextButton", rail)
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""

    trigger.MouseButton1Down:Connect(function()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation().X
            local perc = math.clamp((mouse - rail.AbsolutePosition.X) / rail.AbsoluteSize.X, 0, 1)
            local val = math.round(min + (perc * (max - min)))
            fill.Size = UDim2.new(perc, 0, 1, 0)
            label.Text = text .. ": " .. val
            Config[key] = val
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
        end)
    end)
end

-- Populate
UI:CreateToggle("Master Combat", "Enabled")
UI:CreateToggle("Aimbot Assist", "Aimbot")
UI:CreateToggle("Visual Highlights", "ESP")
UI:CreateToggle("Infinite Stamina", "InfStamina")
UI:CreateSlider("Hitbox Scale", "HitboxMultiplier", 1, 20, 6)
UI:CreateSlider("Aim FOV", "AimbotFOV", 30, 360, 90)

-- [[ MINIMIZE SYSTEM (Image 2) ]] --
UI.SukunaIcon = Instance.new("ImageButton", UI.ScreenGui)
UI.SukunaIcon.Size = UDim2.new(0, 100, 0, 100)
UI.SukunaIcon.Image = Config.Assets.MinimizeIcon
UI.SukunaIcon.Position = UDim2.new(0.5, -50, 0.8, 0)
UI.SukunaIcon.Visible = false
Instance.new("UICorner", UI.SukunaIcon).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", UI.SukunaIcon)
Stroke.Thickness = 4
Stroke.Color = Color3.new(1,0,0)

UI.CloseBtn.MouseButton1Click:Connect(function()
    UI.Main.Visible = false; UI.Shadow.Visible = false; UI.SukunaIcon.Visible = true
end)
UI.SukunaIcon.MouseButton1Click:Connect(function()
    UI.Main.Visible = true; UI.Shadow.Visible = true; UI.SukunaIcon.Visible = false
end)

-- [[ CORE POWER ENGINE ]] --
local function getTarget()
    local best, dist = nil, Config.MagnetRange
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if Config.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then best = p.Character.HumanoidRootPart; dist = mag end
        end
    end
    return best
end

-- Predictive Projectile Magnetism
workspace.ChildAdded:Connect(function(obj)
    if not Config.Enabled then return end
    task.wait(0.01)
    local n = obj.Name:lower()
    if n:find("jar") or n:find("crystal") or n:find("axe") or n:find("slash") then
        local t = getTarget()
        if t then
            local heart
            heart = RunService.Heartbeat:Connect(function()
                if obj and obj.Parent and t.Parent then
                    local p = t.Position + (t.AssemblyLinearVelocity * Config.PredictionTime)
                    obj.AssemblyLinearVelocity = (p - obj.Position).Unit * 200
                else heart:Disconnect() end
            end)
        end
    end
end)

-- Main Physics Loop (Hitboxes + ESP + Stamina)
RunService.RenderStepped:Connect(function()
    if Config.Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.Health > 0 then
                    -- THE 4-6-4 HITBOX SYSTEM
                    hrp.Size = Vector3.new(4, 6, 4) * (Config.HitboxMultiplier / 2)
                    hrp.CanCollide = false
                    
                    if Config.ESP then
                        hrp.Transparency = 0.5
                        hrp.Material = Enum.Material.Neon
                        hrp.Color = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                    else
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
    
    if Config.InfStamina and LocalPlayer.Character then
        local s = LocalPlayer.Character:FindFirstChild("Stamina", true)
        if s and s:IsA("NumberValue") then s.Value = 100 end
    end
end)

-- Aimbot Assist
task.spawn(function()
    while task.wait() do
        if Config.Enabled and Config.Aimbot then
            local t = getTarget()
            if t then
                local screenPoint = Camera:WorldToScreenPoint(t.Position)
                local mousePos = UserInputService:GetMouseLocation()
                local delta = Vector2.new(screenPoint.X - mousePos.X, screenPoint.Y - mousePos.Y)
                if typeof(mousemoverel) == "function" then
                    mousemoverel(delta.X / Config.AimbotSmoothness, delta.Y / Config.AimbotSmoothness)
                end
            end
        end
    end
end)

print("領域展開: APEX UNABRIDGED v3.0 LOADED.")
