-- [[ FORSAKEN: DIVINE DOMAIN - APEX OVERLORD v5.4 ]] --
-- VERSION: 2026.5.4 (GITHUB-SPEC UNABRIDGED)
-- STYLE: XAN-STYLE 3D RENDER (IMAGE 1 & 2 INTEGRATED)
-- POWER: ORIGINAL 4-6-4 HITBOX SYSTEM & HIGHLIGHT ESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ MASTER CONFIGURATION ]] --
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
        AutoAttack = false
    },
    Movement = {
        SpeedMult = 1,
        JumpForce = 1,
        Noclip = false,
        InfStamina = false
    },
    ESP = {
        Active = false,
        ShowPlayers = true,
        ShowGenerators = false
    },
    Assets = {
        MainBG = "rbxassetid://14451731631", -- Image 1
        MinimizeIcon = "rbxassetid://14451731631" -- Image 2
    }
}

-- [[ UI CONSTRUCTION: ACE 3D RENDER ENGINE ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Apex_Domain_Master_400"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainShadow = Instance.new("Frame", ScreenGui)
MainShadow.Size = UDim2.new(0, 526, 0, 406)
MainShadow.Position = UDim2.new(0.5, -263, 0.5, -203)
MainShadow.BackgroundColor3 = Color3.new(0,0,0)
MainShadow.BackgroundTransparency = 0.5
MainShadow.BorderSizePixel = 0
Instance.new("UICorner", MainShadow).CornerRadius = UDim.new(0, 20)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 400)
Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(13, 7, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

-- Image 1: Sukuna Domain Background
local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Image = _G.ApexConfig.Assets.MainBG
BgImage.ImageTransparency = 0.75
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 20)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 0.86, 0)
Sidebar.Position = UDim2.new(0, 0, 0.14, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 12, 30)
Sidebar.BackgroundTransparency = 0.2
Sidebar.ZIndex = 1
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0, 345, 0, 335)
Scroll.Position = UDim2.new(0, 160, 0.14, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 6, 0) -- Expanded for 400+ line scale
Scroll.ScrollBarThickness = 3
Scroll.ZIndex = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 12)

-- [[ 3D COMPONENT FACTORY ]] --
local function AddToggle(text, tab, key)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundTransparency = 1
    
    local Shadow = Instance.new("Frame", Frame)
    Shadow.Size = UDim2.new(1, 0, 1, 0)
    Shadow.Position = UDim2.new(0, 2, 0, 2)
    Shadow.BackgroundColor3 = Color3.new(0,0,0)
    Shadow.ZIndex = 1
    Instance.new("UICorner", Shadow)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    Btn.Text = "  " .. text .. " - OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.ZIndex = 2
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        _G.ApexConfig[tab][key] = not _G.ApexConfig[tab][key]
        local state = _G.ApexConfig[tab][key]
        Btn.Text = "  " .. text .. " - " .. (state and "ON" or "OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(25, 15, 40)
    end)
end

local function AddSlider(text, tab, key, min, max, default)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -10, 0, 65)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.Font = Enum.Font.GothamBold
    Label.BackgroundTransparency = 1

    local Rail = Instance.new("Frame", Frame)
    Rail.Size = UDim2.new(1, 0, 0, 8)
    Rail.Position = UDim2.new(0, 0, 0.7, 0)
    Rail.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Instance.new("UICorner", Rail)

    local Fill = Instance.new("Frame", Rail)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    Instance.new("UICorner", Fill)

    local Trig = Instance.new("TextButton", Rail)
    Trig.Size = UDim2.new(1, 0, 1, 0)
    Trig.BackgroundTransparency = 1
    Trig.Text = ""

    Trig.MouseButton1Down:Connect(function()
        local Move = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation().X
            local perc = math.clamp((mouse - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(perc, 0, 1, 0)
            local val = math.round(min + (perc * (max - min)))
            Label.Text = text .. ": " .. val
            _G.ApexConfig[tab][key] = val
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end
        end)
    end)
end

-- Initialize Components
AddToggle("🔮 Master Power", "Main", "Enabled")
AddToggle("🛡️ Team Check", "Main", "TeamCheck")
AddToggle("👥 Player Highlight", "ESP", "Active")
AddToggle("🏃 Infinite Stamina", "Movement", "InfStamina")
AddSlider("🎯 Hitbox Scale", "Combat", "HitboxMult", 1, 20, 6)
AddSlider("⏳ Prediction", "Combat", "Prediction", 0.05, 0.5, 0.18)

-- [[ ORIGINAL 4-6-4 HITBOX & ESP SYSTEM ]] --
local function UpdateVisuals()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Original Hitbox Logic
                if _G.ApexConfig.Main.Enabled and _G.ApexConfig.Combat.HitboxMult > 0 then
                    local mult = _G.ApexConfig.Combat.HitboxMult
                    hrp.Size = Vector3.new(4, 6, 4) * (mult / 2)
                    hrp.Transparency = 0.5
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                    hrp.Color = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end

                -- Original Highlight ESP
                local existingHighlight = p.Character:FindFirstChild("ApexESP")
                if _G.ApexConfig.ESP.Active then
                    if not existingHighlight then
                        local highlight = Instance.new("Highlight", p.Character)
                        highlight.Name = "ApexESP"
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    end
                elseif existingHighlight then
                    existingHighlight:Destroy()
                end
            end
        end
    end
end

-- [[ PHYSICS MAGNETISM (UNABRIDGED) ]] --
workspace.ChildAdded:Connect(function(obj)
    if not _G.ApexConfig.Main.Enabled then return end
    task.wait(0.01)
    local n = obj.Name:lower()
    if n:find("jar") or n:find("crystal") or n:find("axe") or n:find("slash") then
        local heart
        heart = RunService.Heartbeat:Connect(function()
            if obj and obj.Parent then
                local best, dist = nil, _G.ApexConfig.Combat.MagnetRange
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if _G.ApexConfig.Main.TeamCheck and player.Team == LocalPlayer.Team then continue end
                        local mag = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if mag < dist then best = player.Character.HumanoidRootPart; dist = mag end
                    end
                end
                if best then
                    local p = best.Position + (best.AssemblyLinearVelocity * _G.ApexConfig.Combat.Prediction)
                    obj.AssemblyLinearVelocity = (p - obj.Position).Unit * 200
                end
            else heart:Disconnect() end
        end)
    end
end)

-- [[ MAIN RENDER LOOP ]] --
RunService.RenderStepped:Connect(function()
    UpdateVisuals()
    if _G.ApexConfig.Movement.InfStamina and LocalPlayer.Character then
        local stam = LocalPlayer.Character:FindFirstChild("Stamina", true)
        if stam and stam:IsA("NumberValue") then stam.Value = 100 end
    end
end)

-- [[ SUKUNA MINIMIZE (IMAGE 2) ]] --
local SukunaCircle = Instance.new("ImageButton", ScreenGui)
SukunaCircle.Size = UDim2.new(0, 90, 0, 90)
SukunaCircle.Position = UDim2.new(0.5, -45, 0.8, 0)
SukunaCircle.Image = _G.ApexConfig.Assets.MinimizeIcon
SukunaCircle.Visible = false
Instance.new("UICorner", SukunaCircle).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", SukunaCircle)
Stroke.Thickness = 4; Stroke.Color = Color3.new(1,0,0)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(0.92, 0, 0.02, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false; MainShadow.Visible = false; SukunaCircle.Visible = true
end)
SukunaCircle.MouseButton1Click:Connect(function()
    Main.Visible = true; MainShadow.Visible = true; SukunaCircle.Visible = false
end)

print("_domain expansion: APEX DOMINION UNABRIDGED LOADED.")
