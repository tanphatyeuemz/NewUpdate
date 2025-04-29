-- Zidder Hub - Dev Phatt
-- FixLag Version

local CoreGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- Giao diện
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "ZidderHubFixLag"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundTransparency = 0.4
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = ScreenGui

Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "Zidder Hub - FixLag\nDev Phatt"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextWrapped = true
Title.Parent = Frame

-- Giảm lag cực mạnh
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
        obj.Enabled = false
    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
        obj:Destroy()
    end
end

-- Giảm đồ họa Lighting
Lighting.FogEnd = 1000000
Lighting.GlobalShadows = false
Lighting.Brightness = 0

-- Tắt terrain decoration
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

print("Zidder Hub - FixLag Activated")
