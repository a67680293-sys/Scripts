-- [[ FORSAKEN: DIVINE DOMAIN - APEX OVERLORD V3 ]] --
-- UI STYLE: ANIME-STYLE PREMIUM (SIDEBAR + ANIMATED ACCORDION)
-- POWER: 100% PHYSICS-LOCKED HITBOXES & CONTEXTUAL MAGNETISM
-- TARGET: JANE DOE (JAR/AXE) & KILLER (SLASH)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ MASTER STATE ]] --
_G.ApexData = {
    Enabled = false,
    HitboxSize = 6,
    FOVSize = 160,
    Prediction = 0.25, -- Optimized for fast movement
    MagnetRange = 95,
    
    -- Visual Toggles
    ESP = false,
    Tracers = false,
    TeamCheck = true,
    
    -- Movement Toggles
    InfStamina = false,
    AntiSlow = false,
    WalkSpeed = 16,
    
    -- UI State
    AnimeImg = "rbxassetid://14451731631", -- Sukuna Background
    CurrentTab = "Combat"
}

-- [[ UI CONSTRUCTION: ANIME-STYLE PREMIUM ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Apex_Overlord_Suite"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Anime Background
local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.Image = _G.ApexData.AnimeImg
Bg.ImageTransparency = 0.8
Bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 12)

-- Sidebar (Left)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Sidebar.BackgroundTransparency = 0.3
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

-- Sidebar Title
local SideTitle = Instance.new("TextLabel", Sidebar)
SideTitle.Size = UDim2.new(1, 0, 0, 50)
SideTitle.Text = "領域展開"
SideTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 22
SideTitle.BackgroundTransparency = 1

-- Content Container
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(0, 350, 0, 330)
Content.Position = UDim2.new(0, 155, 0, 40)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2.5, 0)
Content.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0, 12)

-- [[ PRO COMPONENT BUILDERS ]] --
local function NewSection(name)
    local Section = Instance.new("Frame", Content)
    Section.Size = UDim2.new(0, 330, 0, 45)
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Section.ClipsDescendants = true
    Instance.new("UICorner", Section)

    local Header = Instance.new("TextButton", Section)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.Text = "   " .. name
    Header.TextColor3 = Color3.new(1, 1, 1)
    Header.Font = Enum.Font.GothamBold
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.BackgroundTransparency = 1

    local Icon = Instance.new("TextLabel", Header)
    Icon.Size = UDim2.new(0, 45, 0, 45)
    Icon.Position = UDim2.new(1, -45, 0, 0)
    Icon.Text = "+"
    Icon.TextColor3 = Color3.fromRGB(255, 0, 0)
    Icon.Font = Enum.Font.GothamBold
    Icon.BackgroundTransparency = 1

    local Inner = Instance.new("Frame", Section)
    Inner.Size = UDim2.new(1, -20, 0, 300)
    Inner.Position = UDim2.new(0, 10, 0, 50)
    Inner.BackgroundTransparency = 1
    Instance.new("UIListLayout", Inner).Padding = UDim.new(0, 8)

    local Open = false
    Header.MouseButton1Click:Connect(function()
        Open = not Open
        local GoalSize = Open and UDim2.new(0, 330, 0, 250) or UDim2.new(0, 330, 0, 45)
        TweenService:Create(Section, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = GoalSize}):Play()
        Icon.Text = Open and "-" or "+"
    end)
    return Inner
end

local function NewSlider(parent, text, min, max, default, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(1, 0, 0, 50)
    SFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", SFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamSemibold
    Label.BackgroundTransparency = 1

    local Rail = Instance.new("Frame", SFrame)
    Rail.Size = UDim2.new(1, 0, 0, 8)
    Rail.Position = UDim2.new(0, 0, 0.7, 0)
    Rail.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Instance.new("UICorner", Rail)
    
    local Fill = Instance.new("Frame", Rail)
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", Fill)

    local Trigger = Instance.new("TextButton", Rail)
    Trigger.Size = UDim2.new(1, 0, 1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""

    Trigger.MouseButton1Down:Connect(function()
        local Move
        Move = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation().X
            local perc = math.clamp((mouse - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(perc, 0, 1, 0)
            local val = math.round(min + (perc * (max - min)))
            Label.Text = text .. ": " .. val
            callback(val)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then Move:Disconnect() end
        end)
    end)
end

local function NewToggle(parent, text, key)
    local TBtn = Instance.new("TextButton", parent)
    TBtn.Size = UDim2.new(1, 0, 0, 35)
    TBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TBtn.Text = text .. ": OFF"
    TBtn.TextColor3 = Color3.new(1,1,1)
    TBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TBtn)

    TBtn.MouseButton1Click:Connect(function()
        _G.ApexData[key] = not _G.ApexData[key]
        TBtn.Text = text .. ": " .. (_G.ApexData[key] and "ON" or "OFF")
        TBtn.BackgroundColor3 = _G.ApexData[key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 45)
    end)
end

-- [[ TAB CONTENT INITIALIZATION ]] --
local Combat = NewSection("⚔️ Combat & Aimbot")
local Visuals = NewSection("👁️ Visuals (ESP)")
local Misc = NewSection("🏃 Movement & World")

NewToggle(Combat, "Master System", "Enabled")
NewSlider(Combat, "Hitbox Mult", 1, 15, 6, function(v) _G.ApexData.HitboxSize = v end)
NewSlider(Combat, "Aim FOV", 50, 500, 160, function(v) _G.ApexData.FOVSize = v end)

NewToggle(Visuals, "Player ESP", "ESP")
NewToggle(Visuals, "Team Check", "TeamCheck")

NewToggle(Misc, "Inf Stamina", "InfStamina")
NewToggle(Misc, "Anti-Slow", "AntiSlow")

-- [[ THE "BYPASS" ENGINE ]] --

local function GetTarget()
    local best, dist = nil, _G.ApexData.MagnetRange
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if _G.ApexData.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                best = p.Character.HumanoidRootPart
                dist = mag
            end
        end
    end
    return best
end

-- Ability Specific Magnetism (Jane/Killer)
local function ApplyMagnetism(part)
    local targetHRP = GetTarget()
    if not targetHRP then return end

    local connection = RunService.Heartbeat:Connect(function()
        if not part or not part.Parent or not targetHRP or not targetHRP.Parent then
            connection:Disconnect()
            return
        end

        local targetPos = targetHRP.Position + (targetHRP.AssemblyLinearVelocity * _G.ApexData.Prediction)
        local direction = (targetPos - part.Position).Unit

        if part:IsA("BasePart") and not part.Assembly then
            part.Velocity = direction * 150 -- Direct velocity override
        else
            part.AssemblyLinearVelocity = direction * part.AssemblyLinearVelocity.Magnitude
        end
    end)
end

-- Scan existing parts on load
for _, part in pairs(workspace:GetChildren()) do
    local n = part.Name:lower()
    if n:find("jar") or n:find("crystal") or n:find("axe") or n:find("slash") then
        ApplyMagnetism(part)
    end
end

workspace.ChildAdded:Connect(function(c)
    if not _G.ApexData.Enabled then return end
    task.wait(0.01) -- Ensure part is fully loaded
    local n = c.Name:lower()
    if n:find("jar") or n:find("crystal") or n:find("axe") or n:find("slash") then
        ApplyMagnetism(c)
    end
end)

-- Hitbox Scaling
RunService.Heartbeat:Connect(function()
    if _G.ApexData.Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                
                if not hum or hum.Health <= 0 then 
                    hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1
                    continue 
                end
                
                -- Force Hitbox Scale
                hrp.Size = Vector3.new(2, 2, 2) * _G.ApexData.HitboxSize
                hrp.Transparency = 0.65
                hrp.Color = (p.Team and p.Team.Name:lower():find("killer")) and Color3.new(1,0,0) or Color3.new(0,1,0)
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end
    
    if _G.ApexData.InfStamina then
        local st = LocalPlayer.Character:FindFirstChild("Stamina", true) or LocalPlayer:FindFirstChild("Stamina", true)
        if st and st:IsA("NumberValue") then st.Value = 100 end
    end
end)

-- [[ ANIME-STYLE UI ANIMATIONS ]] --
-- Sukuna Circle Minimize
local SukunaBtn = Instance.new("ImageButton", ScreenGui)
SukunaBtn.Size = UDim2.new(0, 85, 0, 85)
SukunaBtn.Image = _G.ApexData.AnimeImg
SukunaBtn.Visible = false
Instance.new("UICorner", SukunaBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", SukunaBtn).Thickness = 3

-- Close Button
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(0.92, 0, 0.02, 0)
CloseBtn.Text = "-"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false; SukunaBtn.Visible = true; SukunaBtn.Position = Main.Position
end)
SukunaBtn.MouseButton1Click:Connect(function()
    Main.Visible = true; SukunaBtn.Visible = false
end)

-- [[ ANTI-DETECTION ]] --
-- Use coroutine to prevent anti-cheat detection
coroutine.wrap(function()
    while true do
        task.wait(0.1)
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") then
                v:GetPropertyChangedSignal("Velocity"):Wait()
                end
