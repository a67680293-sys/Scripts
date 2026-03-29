-- [[ FORSAKEN: DIVINE DOMAIN - APEX FINAL ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ SETTINGS ]] --
_G.Settings = {
    Enabled = false,
    HitboxSize = 6,
    FOVSize = 150, -- Adjust this to make the circle bigger/smaller
    MaxRange = 60, -- Projects won't track past 60 studs
    TeamCheck = true,
    Prediction = 0.16,
    Visuals = true,
    AnimeImg = "rbxassetid://14451731631"
}

-- [[ UI & FOV CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local FOVCircle = Instance.new("Frame", ScreenGui) -- Visual FOV
FOVCircle.Size = UDim2.new(0, _G.Settings.FOVSize * 2, 0, _G.Settings.FOVSize * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundColor3 = Color3.new(1, 0, 0)
FOVCircle.BackgroundTransparency = 0.9
FOVCircle.Visible = false
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FOVCircle).Color = Color3.fromRGB(255, 0, 50)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.Image = _G.Settings.AnimeImg
Bg.ImageTransparency = 0.5
Bg.BackgroundTransparency = 1
Bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Bg)

-- Sukuna Minimize Button
local SukunaBtn = Instance.new("ImageButton", ScreenGui)
SukunaBtn.Size = UDim2.new(0, 70, 0, 70)
SukunaBtn.Image = _G.Settings.AnimeImg
SukunaBtn.Visible = false
Instance.new("UICorner", SukunaBtn).CornerRadius = UDim.new(1, 0)

-- [[ LOGIC ENGINE ]] --

local function IsInFOV(targetPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if onScreen then
        local mousePos = UserInputService:GetMouseLocation()
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        return dist <= _G.Settings.FOVSize
    end
    return false
end

local function GetBestTarget()
    local target = nil
    local lastDist = _G.Settings.MaxRange
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if _G.Settings.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local hrp = p.Character.HumanoidRootPart
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < lastDist and IsInFOV(hrp.Position) then
                target = hrp
                lastDist = dist
            end
        end
    end
    return target
end

-- Jane Doe Magnetism (Jar/Axe)
workspace.ChildAdded:Connect(function(child)
    if not _G.Settings.Enabled then return end
    task.wait(0.02)
    local n = child.Name:lower()
    if n:find("jar") or n:find("axe") or n:find("crystal") then
        local target = GetBestTarget()
        if target then
            RunService.Heartbeat:Connect(function()
                if child and child.Parent and target.Parent then
                    local pred = target.Position + (target.AssemblyLinearVelocity * _G.Settings.Prediction)
                    child.AssemblyLinearVelocity = (pred - child.Position).Unit * child.AssemblyLinearVelocity.Magnitude
                end
            end)
        end
    end
end)

-- Hitbox System
local function UpdateHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            if _G.Settings.Enabled then
                hrp.Size = Vector3.new(1, 1, 1) * _G.Settings.HitboxSize
                hrp.Transparency = 0.6
                hrp.Color = (p.Team and p.Team.Name:lower():find("killer")) and Color3.new(1,0,0) or Color3.new(0,1,0)
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end

-- [[ UI SLIDERS ]] --
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0.9, 0, 0, 40)
Toggle.Position = UDim2.new(0.05, 0, 0.2, 0)
Toggle.Text = "DOMAIN: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle)

local SizeBtn = Instance.new("TextButton", Main)
SizeBtn.Size = UDim2.new(0.9, 0, 0, 40)
SizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
SizeBtn.Text = "HITBOX SIZE: 6"
SizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SizeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SizeBtn)

local FOVBtn = Instance.new("TextButton", Main)
FOVBtn.Size = UDim2.new(0.9, 0, 0, 40)
FOVBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
FOVBtn.Text = "FOV RADIUS: 150"
FOVBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FOVBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FOVBtn)

-- [[ FINAL LOGIC ]] --
Toggle.MouseButton1Click:Connect(function()
    _G.Settings.Enabled = not _G.Settings.Enabled
    Toggle.Text = _G.Settings.Enabled and "DOMAIN: ACTIVE" or "DOMAIN: OFF"
    Toggle.BackgroundColor3 = _G.Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    FOVCircle.Visible = _G.Settings.Enabled
end)

SizeBtn.MouseButton1Click:Connect(function()
    _G.Settings.HitboxSize = _G.Settings.HitboxSize + 2
    if _G.Settings.HitboxSize > 16 then _G.Settings.HitboxSize = 2 end
    SizeBtn.Text = "HITBOX SIZE: " .. _G.Settings.HitboxSize
end)

FOVBtn.MouseButton1Click:Connect(function()
    _G.Settings.FOVSize = _G.Settings.FOVSize + 50
    if _G.Settings.FOVSize > 400 then _G.Settings.FOVSize = 50 end
    FOVBtn.Text = "FOV RADIUS: " .. _G.Settings.FOVSize
    FOVCircle.Size = UDim2.new(0, _G.Settings.FOVSize * 2, 0, _G.Settings.FOVSize * 2)
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    if _G.Settings.Enabled then pcall(UpdateHitboxes) end
end)
