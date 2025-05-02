-- Cài đặt team và khởi tạo biến
getgenv().team = "Pirates" -- Pirates

-- Đợi game tải hoàn chỉnh
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- Tự động chọn team với phương pháp đáng tin cậy hơn
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        wait()
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes")
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end

-- Tiếp tục đợi GUI chính tải
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

-- >>> TẢI CUTTAY UI <
-- Tải UI trước khi khởi tạo auto bounty
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/diemquy/testhub/refs/heads/main/autobountyui.lua"))()

-- Khởi tạo cài đặt cơ bản nếu chưa tồn tại
if not getgenv().Setting then
    getgenv().Setting = {
        ["YOU"] = {
            ["Team"] = getgenv().team or "Pirates",
        },
        ["Webhook"] = {
            ["Enabled"] = true,
            ["Url"] = ""
        },
        ["Chat"] = {
            ["Enabled"] = false,
            ["List"] = {""},
        }
    }
end

-- Đảm bảo tồn tại tất cả các cài đặt cần thiết
if not getgenv().Setting.Melee then
    getgenv().Setting.Melee = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1.5
    }
end

if not getgenv().Setting.Sword then
    getgenv().Setting.Sword = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    }
end

if not getgenv().Setting.Gun then
    getgenv().Setting.Gun = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1,
        ["GunMode"] = false
    }
end

if not getgenv().Setting.Fruit then
    getgenv().Setting.Fruit = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0.1},
        ["F"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    }
end

if not getgenv().Setting.Click then
    getgenv().Setting.Click = {
        ["FastClick"] = true,
        ["AlwaysClick"] = true
    }
end

if not getgenv().Setting.Hunt then
    getgenv().Setting.Hunt = {
        ["Min"] = 0,
        ["Max"] = 30000000
    }
end

if not getgenv().Setting.Skip then
    getgenv().Setting.Skip = {
        ["V4"] = true,
        ["Fruit"] = false,
        ["FruitList"] = {"Buddha", "Leopard", "T-Rex"},
        ["SafeZone"] = true,
        ["NoHaki"] = true,
        ["NoPvP"] = true
    }
end

if not getgenv().Setting.SafeHealth then
    getgenv().Setting.SafeHealth = {
        ["Health"] = 7000,
        ["Mask"] = false,
        ["MaskType"] = "Mask",
        ["RaceV4"] = false
    }
end

if not getgenv().Setting.Another then
    getgenv().Setting.Another = {
        ["V3"] = true,
        ["V4"] = true,
        ["CustomHealth"] = true,
        ["Health"] = 7000,
        ["WhiteScreen"] = false,
        ["FPSBoots"] = false,
        ["LockCamera"] = false,
        ["AutoServerHop"] = true,
        ["HopWhenNoBounty"] = true,
        ["BountyLock"] = false,
        ["BountyLockAt"] = 30000000,
        ["ServerHopAfterTime"] = false,
        ["ServerHopTime"] = 900,
        ["CheckCombatBeforeHop"] = true,
        ["MaxPlayersInServer"] = 8
    }
end

-- Khởi tạo biến toàn cục
getgenv().weapon = nil
getgenv().targ = nil 
getgenv().lasttarrget = nil
getgenv().checked = {}
getgenv().pl = game.Players:GetPlayers()
getgenv().killed = nil
_G.Earned = 0  -- Số tiền kiếm được hiện tại
_G.TotalEarn = 0  -- Tổng số tiền kiếm được
_G.Time = 0  -- Thời gian hoạt động

-- Định nghĩa thế giới và cấu hình đảo
local World1, World2, World3 = false, false, false

if game.PlaceId == 7449423635 then
    World3 = true
else
    game.Players.LocalPlayer:Kick("Chỉ hỗ trợ BF Sea 3")
    return
end 

-- Cấu hình đảo dựa trên thế giới
local distbyp, island
if World3 then 
    distbyp = 5000
    island = {
        ["Port Town"] = CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375),
        ["Hydra Island"] = CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531),
        ["Mansion"] = CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375),
        ["Castle On The Sea"] = CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375),
        ["Haunted Island"] = CFrame.new(-9547.5703125, 141.0137481689453, 5535.16162109375),
        ["Great Tree"] = CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625),
        ["Candy Island"] = CFrame.new(-1106.076416015625, 13.016114234924316, -14231.9990234375),
        ["Cake Island"] = CFrame.new(-1903.6856689453125, 36.70722579956055, -11857.265625),
        ["Loaf Island"] = CFrame.new(-889.8325805664062, 64.72842407226562, -10895.8876953125),
        ["Peanut Island"] = CFrame.new(-1943.59716796875, 37.012996673583984, -10288.01171875),
        ["Cocoa Island"] = CFrame.new(147.35205078125, 23.642955780029297, -12030.5498046875),
        ["Tiki Outpost"] = CFrame.new(-16234,9,416)
    } 
elseif World2 then 
    distbyp = 3500
    island = { 
        a = CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938),
        b = CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094),
        c = CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375),
        d = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344),
        e = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828), 
        f = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875),
        g = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188),
        h = CFrame.new(923.40197753906, 125.05712890625, 32885.875),
        i = CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125),
    }
elseif World1 then 
    distbyp = 1500
    island = { 
        a = CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594), 
        b = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156), 
        c = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688), 
        d = CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969), 
        e = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754), 
        f = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094),
        g = CFrame.new(-4607.82275, 872.54248, -1667.55688), 
        h = CFrame.new(-7952.31006, 5545.52832, -320.704956),
        i = CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313),
        j = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969),
        k = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469),
        l = CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813),
        m = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875),
        n = CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875),
        o = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),
        p = CFrame.new(-4813.0249, 903.708557, -1912.69055),
        q = CFrame.new(-4970.21875, 717.707275, -2622.35449),
    } 
end

-- Định nghĩa biến cục bộ
local p = game.Players
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local hb = rs.Heartbeat
local rends = rs.RenderStepped
local webhook = {} 

-- === CÁC HÀM TIỆN ÍCH ===
-- Hàm vượt qua chướng ngại
function bypass(Pos)   
    if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local dist = math.huge
    local is = nil
    
    for i, v in pairs(island) do
        if (Pos.Position-v.Position).magnitude < dist then
            is = v 
            dist = (Pos.Position-v.Position).magnitude 
        end
    end 
    
    if is == nil then return end
    
    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
            if tween then
                pcall(function() tween:Destroy() end)
            end
            
            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                
                if tween then
                   pcall(function() tween:Cancel() end)
                end
                
                repeat task.wait()
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = is  
                    else
                        break
                    end
                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is   
                
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            else
                if not stopbypass then
                    if tween then
                       pcall(function() tween:Cancel() end)
                    end
                    
                    repeat task.wait()
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = is  
                        else
                            break
                        end
                    until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is  
                    
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
                        lp.Character:SetPrimaryPartCFrame(is)
                        wait(0.1)
                        if lp.Character and lp.Character:FindFirstChild("Head") then
                            lp.Character.Head:Destroy()
                        end
                        wait(0.5)
                        
                        repeat task.wait()
                            if lp.Character and lp.Character:FindFirstChild("PrimaryPart") then
                                lp.Character.PrimaryPart.CFrame = is  
                            else
                                break
                            end
                        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                        
                        task.wait(0.5)
                    end)
                end 
            end
        end
    end
end

-- Hàm di chuyển (tween)
function to(Pos)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
            local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if not game.Players.LocalPlayer.Character.PrimaryPart:FindFirstChild("Hold") then
                local Hold = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.PrimaryPart)
                Hold.Name = "Hold"
                Hold.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Hold.Velocity = Vector3.new(0, 0, 0)
            end
            
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            
            local Speed
            if Distance <= 250 then
                if tween then tween:Cancel() end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
            elseif Distance < 1000 then
                Speed = 375
            elseif Distance >= 1000 then
                Speed = 350
            end


            
            pcall(function()
                tween = game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
                tween:Play()
            end)
            
            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") and 
               game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("InCombat") and
               game.Players.LocalPlayer.PlayerGui.Main.InCombat.Visible then
                if not string.find(string.lower(game.Players.LocalPlayer.PlayerGui.Main.InCombat.Text), "risk") then
                   
                else
                    local dist = math.huge
                    local is = nil
                    
                    for i, v in pairs(island) do
                        if (Pos.Position-v.Position).magnitude < dist then
                            is = v 
                            dist = (Pos.Position-v.Position).magnitude 
                        end
                    end 
                    
                    if is == nil then return end
                    
                    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
                        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
                            if tween then
                                pcall(function() tween:Destroy() end)
                            end
                            
                            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
                               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
                               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
                               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                                
                                if tween then
                                   pcall(function() tween:Cancel() end)
                                end
                                
                                repeat task.wait()
                                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                        lp.Character.HumanoidRootPart.CFrame = is  
                                    else
                                        break
                                    end
                                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is   
                                
                                task.wait(0.1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            end
                        end
                    end
                end
            else
                
            end
            
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, 
                    Pos.Y, 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            end
        end
    end)
end

-- Hàm sử dụng Buso (Haki)
function buso()
    if lp.Character and not lp.Character:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Hàm sử dụng Ken (Observation Haki)
function Ken()
    if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and 
       game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and 
       game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
        return true
    else
        game:service("VirtualUser"):CaptureController()
        game:service("VirtualUser"):SetKeyDown("0x65")
        game:service("VirtualUser"):SetKeyUp("0x65")
        return false
    end
end

-- Hàm nhấn phím
function down(use, wait)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, use, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
            task.wait((wait or 0.1))
            game:GetService("VirtualInputManager"):SendKeyEvent(false, use, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
        end
    end)
end

-- Hàm trang bị vũ khí
function equip(tooltip)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait()
    
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltip then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                return true
            end
        end
    end
    return false
end

function EquipWeapon(Tool)
    pcall(function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild(Tool) then
            local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(Tool)
            if ToolHumanoid then
                ToolHumanoid.Parent = game.Players.LocalPlayer.Character
            end
        end
    end)
end

-- Hàm click
function Click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,1,0,1))
end

-- === CHUẨN BỊ GAME ===
-- No Clip
spawn(function()
    while game:GetService("RunService").Stepped:wait() do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Boots FPS
if getgenv().Setting.Another.FPSBoots then
    local removedecals = false
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and removedecals then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end
    
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end

-- Loại bỏ đối tượng
function ObjectRemove()
    for i, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name,"Tree") or string.find(v.Name,"House") then
            pcall(function() v:Destroy() end)
        end
    end
end

-- Đối tượng vô hình
function InvisibleObject()
    for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if (v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart")) and v.Transparency then
            v.Transparency = 1
        end
    end
    
    spawn(function()
        pcall(function()
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Death") then
                game.ReplicatedStorage.Effect.Container.Death:Destroy()
            end
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Respawn") then
                game.ReplicatedStorage.Effect.Container.Respawn:Destroy()
            end
            if game.ReplicatedStorage.Effect.Container:FindFirstChild("Hit") then
                game.ReplicatedStorage.Effect.Container.Hit:Destroy()
            end
        end)
    end)
end

ObjectRemove()
InvisibleObject()

-- White Screen
if getgenv().Setting.Another.WhiteScreen then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end	

-- === HÀM CHÍNH AUTO BOUNTY ===
-- Kiểm tra fruit
function hasValue(array, targetString)
    if not array then return false end
    for _, value in ipairs(array) do
        if value == targetString then
            return true
        end
    end
    return false
end

-- Fast Attack
if getgenv().Setting.Click.FastClick then
    local fastattack = true
    local y = nil
    
    -- Cố gắng lấy CombatFramework
    pcall(function()
        local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
        if CameraShaker then
            CameraShaker:Stop()
        end
        
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts") then
            local success, result = pcall(function()
                return require(game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework"))
            end)
            
            if success and result then
                local getCombatFramework = result
                local getCombatFrameworkR = debug.getupvalues(getCombatFramework)[2]
                y = getCombatFrameworkR
            end
        end
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if fastattack and y and typeof(y) == "table" then
                pcall(function()
                    if y.activeController then
                        y.activeController.timeToNextAttack = 0
                        y.activeController.hitboxMagnitude = 60
                        y.activeController.active = false
                        y.activeController.timeToNextBlock = 0
                        y.activeController.focusStart = 1655503339.0980349
                        y.activeController.increment = 1
                        y.activeController.blocking = false
                        y.activeController.attacking = false
                        if y.activeController.humanoid then
                            y.activeController.humanoid.AutoRotate = true
                        end
                    end
                end)
            end
        end)
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if fastattack == true and lp and lp.Character then
                if lp.Character:FindFirstChild("Stun") then
                    lp.Character.Stun.Value = 0
                end
                if lp.Character:FindFirstChild("Busy") then
                    lp.Character.Busy.Value = false 
                end
            end
        end)
    end)
else
    local y = nil
    
    -- Cố gắng lấy CombatFramework
    pcall(function()
        if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts") then
            local success, result = pcall(function()
                return require(game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework"))
            end)
            
            if success and result then
                local getCombatFramework = result
                local getCombatFrameworkR = debug.getupvalues(getCombatFramework)[2]
                y = getCombatFrameworkR
            end
        end
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if y and typeof(y) == "table" then
                pcall(function()
                    if y.activeController then
                        y.activeController.hitboxMagnitude = 60
                        y.activeController.active = false
                        y.activeController.timeToNextBlock = 0
                        y.activeController.focusStart = 1655503339.0980349
                        y.activeController.increment = 1
                        y.activeController.blocking = false
                        y.activeController.attacking = false
                        if y.activeController.humanoid then
                            y.activeController.humanoid.AutoRotate = true
                        end
                    end
                end)
            end
        end)
    end)
end

-- Circle
local radius = 25
local speedCircle = 30
local angle = 0
local yTween = 5
local function getNextPosition(center)
    angle = angle + speedCircle
    return center + Vector3.new(math.sin(math.rad(angle)) * radius, yTween, math.cos(math.rad(angle)) * radius)
end

-- Hop Server
local hopserver = false
local starthop = false
local stopbypass = false

spawn(function()
    while task.wait() do
        if hopserver then
            stopbypass = true
            starthop = true
        end
    end
end)

spawn(function()
    while task.wait() do
        if starthop then
            repeat task.wait()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    to(lp.Character.HumanoidRootPart.CFrame*CFrame.new(0, math.random(500, 10000), 0))
                end
            until (lp.PlayerGui and lp.PlayerGui:FindFirstChild("Main") and 
                  lp.PlayerGui.Main:FindFirstChild("InCombat") and
                  lp.PlayerGui.Main.InCombat.Visible and 
                  not string.find(string.lower(lp.PlayerGui.Main.InCombat.Text), "risk")) or 
                  (lp.PlayerGui and lp.PlayerGui:FindFirstChild("Main") and
                  lp.PlayerGui.Main:FindFirstChild("InCombat") and 
                  not lp.PlayerGui.Main.InCombat.Visible)
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                to(CFrame.new(0, 10000, 0))
            end
            
            HopServer()
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                to(lp.Character.HumanoidRootPart.CFrame*CFrame.new(0, math.random(500, 10000), 0))
            end
        end
    end
end)

-- Hàm chuyển server
function CheckInComBat()
    return game.Players.LocalPlayer.PlayerGui.Main.BottomHUDList.InCombat.Visible and game.Players.LocalPlayer.PlayerGui.Main.BottomHUDList.InCombat.Text and (string.find(string.lower(game.Players.LocalPlayer.PlayerGui.Main.BottomHUDList.InCombat.Text),"risk"))
end 
function HopServer(counts)
    if counts == nil then
        counts = 10
    end
    local function nigga(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible then
                if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                    v.Visible = false
                end
            end
            v:GetPropertyChangedSignal("Visible"):Connect(
                function()
                    if v.Visible then
                        if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                            v.Visible = false
                        end
                    end
                end
            )
        end
    end
    for i, v in game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren() do
        nigga(v)
    end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(nigga)
    game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = "Singapore"
    while wait() do
        if not CheckInComBat() then
            for r = 1, math.huge do
                for k, v in game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) do
                    if k ~= game.JobId and v["Count"] <= counts then
                        game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k)
                    end
                end
            end
        end
    end
end

-- Đăng ký hàm HopServer cho UI
getgenv().HopServer = HopServer

-- Skip Player
function SkipPlayer()
    UI.ShowNotification("Đã bỏ qua người chơi", "warning")
    
    getgenv().killed = getgenv().targ 
    if getgenv().targ then
        table.insert(getgenv().checked, getgenv().targ)
    end
    getgenv().targ = nil
    UI.SetTarget("None")
    target()
end

-- Đăng ký hàm SkipPlayer cho UI
getgenv().SkipPlayer = SkipPlayer

-- Target Selection
function target() 
    pcall(function()
        UI.ShowNotification("Đang tìm mục tiêu mới...", "info")
        
        local d = math.huge
        local p = nil
        getgenv().targ = nil
        
        for _, v in pairs(game.Players:GetPlayers()) do 
            if v.Team ~= nil and (tostring(lp.Team) == "Pirates" or (tostring(v.Team) == "Pirates" and tostring(lp.Team) ~= "Pirates")) then
                if v and v:FindFirstChild("Data") and ((getgenv().Setting.Skip.Fruit and hasValue(getgenv().Setting.Skip.FruitList, v.Data.DevilFruit.Value) == false) or not getgenv().Setting.Skip.Fruit) then
                    if v ~= lp and v ~= getgenv().targ and 
                       v.Character and v.Character:FindFirstChild("HumanoidRootPart") and
                       (v.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < d and 
                       not hasValue(getgenv().checked, v) and 
                       v.Character.HumanoidRootPart.CFrame.Y <= 12000 then
                        
                        if (tonumber(lp.Data.Level.Value) - 250) < v.Data.Level.Value then
                            if v.leaderstats["Bounty/Honor"] and 
                               v.leaderstats["Bounty/Honor"].Value >= getgenv().Setting.Hunt.Min and 
                               v.leaderstats["Bounty/Honor"].Value <= getgenv().Setting.Hunt.Max and 
                               not hopserver then 
                                
                                if (getgenv().Setting.Skip.V4 and not v.Character:FindFirstChild("RaceTransformed")) or not getgenv().Setting.Skip.V4 then
                                    p = v 
                                    d = (v.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude 
                                    
                                    if getgenv().Setting.Chat.Enabled and getgenv().Setting.Chat.List and #getgenv().Setting.Chat.List > 0 then
                                        local chatMsg = getgenv().Setting.Chat.List[math.random(1, #getgenv().Setting.Chat.List)]
                                        if chatMsg then
                                            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(chatMsg, "All")
                                        end
                                    end
                                end
                            end
                        end
                    end 
                end
            end
        end 
        
        if p == nil then 
            HopServer()
            UI.ShowNotification("Không tìm thấy mục tiêu, đang chuyển server...", "warning")
        else
            UI.ShowNotification("Đã tìm thấy mục tiêu: " .. p.Name, "success")
            UI.SetTarget(p.Name)
        end
        
        getgenv().targ = p
        UI.UpdateTargetsList()
    end)
end
function CheckSafeZone(nitga)
    for r, v in pairs(workspace['_WorldOrigin']['SafeZones']:GetChildren()) do
        if v and v:IsA("Part") then
            if (v.Position - nitga.Position).Magnitude <= 400 then
                return true
            end
        end
    end
    return false
end
-- Kết nối Ken khi gần với mục tiêu
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and lp.Character and
               (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                Ken()
            end
        end)
    end
end)

-- Logic xoay vòng vũ khí
local gunmethod = getgenv().Setting.Gun.GunMode
local melee, gun, sword, fruit

spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and 
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                    if not gunmethod then
                        if getgenv().Setting.Melee.Enable then
                            getgenv().weapon = "Melee"
                            wait(getgenv().Setting.Melee.Delay or 0.1)
                        end
                        if getgenv().Setting.Fruit.Enable then
                            getgenv().weapon = "Blox Fruit"
                            wait(getgenv().Setting.Fruit.Delay or 0.1)
                        end
                        if getgenv().Setting.Sword.Enable then
                            getgenv().weapon = "Sword"
                            wait(getgenv().Setting.Sword.Delay or 0.1)
                        end
                        if getgenv().Setting.Gun.Enable then
                            getgenv().weapon = "Gun"
                            wait(getgenv().Setting.Gun.Delay or 0.1)
                        end
                    else
                        pcall(function()
                            EquipWeapon("Melee")
                            EquipWeapon("Gun")
                        end)
                    end
                end
            end
        end)
    end
end)

-- PvP và khả năng đặc biệt
spawn(function()
    while task.wait() do 
        pcall(function()
            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main") and
               game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("PvpDisabled") and
               game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
            
            if getgenv().targ and getgenv().targ.Character and lp.Character and
               (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 50 then
                buso()
                
                if getgenv().Setting.Another.V3 then
                    if getgenv().Setting.Another.CustomHealth and 
                       lp.Character.Humanoid.Health <= getgenv().Setting.Another.Health then
                        l = 0.1
                        down("T")
                    end
                end
                
                if getgenv().Setting.Another.V4 then
                    l = 0.1
                    down("Y")
                end   
            end
        end)
    end
end)

-- Logic chiến đấu
spawn(function()
    while task.wait() do
        if not getgenv().targ or not getgenv().targ.Character then target() end
        if not getgenv().targ then hopserver = true end 
        
        pcall(function()
            if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and 
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                
                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                    spawn(function()
                        if not gunmethod then
                            pcall(function() EquipWeapon("Summon Sea Beast") end)
                            equip(getgenv().weapon)
                            
                            for _, v in pairs(lp.Character:GetChildren()) do 
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Melee" then
                                        if getgenv().Setting.Melee.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and 
                                               getgenv().Setting.Melee.Z.Enable then	
                                                hold = getgenv().Setting.Melee.Z.HoldTime
                                                down("Z", hold)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Melee.X.Enable then	
                                                l = getgenv().Setting.Melee.X.HoldTime
                                                down("X", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("C") and
                                                   lp.PlayerGui.Main.Skills[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Melee.C.Enable then	
                                                l = getgenv().Setting.Melee.C.HoldTime
                                                down("C", l)
                                            elseif getgenv().Setting.Melee.V.Enable and
                                                   lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("V") and
                                                   lp.PlayerGui.Main.Skills[v.Name].V.Cooldown.AbsoluteSize.X <= 0 then	
                                                l = getgenv().Setting.Melee.V.HoldTime
                                                down("V", l)
                                            else
                                                Click()
                                            end
                                        end
                                    elseif v.ToolTip == "Gun" then
                                        if getgenv().Setting.Gun.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and 
                                               getgenv().Setting.Gun.Z.Enable then	
                                                l = getgenv().Setting.Gun.Z.HoldTime
                                                down("Z", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Gun.X.Enable then	
                                                l = getgenv().Setting.Gun.X.HoldTime
                                                down("X", l)
                                            else
                                                Click()
                                            end
                                        end
                                    elseif v.ToolTip == "Sword" then
                                        if getgenv().Setting.Sword.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and 
                                               getgenv().Setting.Sword.Z.Enable then	
                                                l = getgenv().Setting.Sword.Z.HoldTime
                                                down("Z", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Sword.X.Enable then	
                                                l = getgenv().Setting.Sword.X.HoldTime
                                                down("X", l)
                                            else
                                                Click()
                                            end
                                        end
                                    elseif v.ToolTip == "Blox Fruit" then
                                        if getgenv().Setting.Fruit.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and 
                                               getgenv().Setting.Fruit.Z.Enable then	
                                                l = getgenv().Setting.Fruit.Z.HoldTime
                                                down("Z", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Fruit.X.Enable then	
                                                l = getgenv().Setting.Fruit.X.HoldTime
                                                down("X", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("C") and
                                                   lp.PlayerGui.Main.Skills[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Fruit.C.Enable then	
                                                l = getgenv().Setting.Fruit.C.HoldTime
                                                down("C", l)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("V") and
                                                   lp.PlayerGui.Main.Skills[v.Name].V.Cooldown.AbsoluteSize.X <= 0 and 
                                                   getgenv().Setting.Fruit.V.Enable then	
                                                l = getgenv().Setting.Fruit.V.HoldTime
                                                down("V", l)
                                            elseif getgenv().Setting.Fruit.F.Enable and
                                                   lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("F") and
                                                   lp.PlayerGui.Main.Skills[v.Name].F.Cooldown.AbsoluteSize.X <= 0 then	
                                                l = getgenv().Setting.Fruit.F.HoldTime
                                                down("F", l)
                                            else
                                                Click()
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if getgenv().Setting.Melee.Enable then
                                if getgenv().Setting.Melee.Z.Enable then	
                                    l = getgenv().Setting.Melee.Z.HoldTime
                                    down("Z", l)
                                elseif getgenv().Setting.Melee.X.Enable then	
                                    l = getgenv().Setting.Melee.X.HoldTime
                                    down("X", l)
                                elseif getgenv().Setting.Melee.C.Enable then	
                                    l = getgenv().Setting.Melee.C.HoldTime
                                    down("C", l)
                                elseif getgenv().Setting.Melee.V.Enable then	
                                    l = getgenv().Setting.Melee.V.HoldTime
                                    down("V", l)
                                end
                            end
                            Click()
                        end
                        if CheckSafeZone(getgenv().targ.Character.HumanoidRootPart) or game.Players.LocalPlayer.PlayerGui.Main["[OLD]SafeZone"].Visible == true or getgenv().targ.Character.Humanoid.Sit == true then
                            SkipPlayer()
                        end
                        -- Kiểm tra thông báo về cái chết của người chơi
                        for _, v in pairs(lp.PlayerGui.Notifications:GetChildren()) do 
                            if v:IsA("TextLabel") and (string.find(string.lower(v.Text), "player") or string.find(string.lower(v.Text), "người chơi")) then 
                                SkipPlayer()
                                pcall(function() v:Destroy() end)
                            end
                        end
                    end)
                end
            end
        end)
    end
end)

-- Logic di chuyển và định vị
local a, b
local Nguvc = 5
local helloae = false
local safehealth = false

spawn(function()
    while task.wait(0.05) do
        if not getgenv().targ then target() end
        if not getgenv().targ then hopserver = true end 
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.BottomHUDList.PvpDisabled.Visible then
            pcall(function()
                if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and 
                lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
                lp.Character:FindFirstChild("Humanoid") then
                    
                    if lp.Character.Humanoid.Health > getgenv().Setting.SafeHealth.Health then
                        pcall(function()    
                            if not (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and 
                                getgenv().targ:DistanceFromCharacter(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").Position) < 10000) then
                                workspace.CurrentCamera.CameraSubject = getgenv().targ.Character
                                if (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
                                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.SafeZone.Visible == true then
                                        print("Safe Zone")
                                        SkipPlayer()
                                    end
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        if getgenv().Setting.Click.AlwaysClick then
                                            Click()
                                        end
                                        
                                        if helloae then
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        else
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        end
                                    else 
                                        print("Player Died")
                                        SkipPlayer()
                                    end
                                else
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                    else
                                        print("Player Died")
                                        SkipPlayer()
                                    end
                                end
                            else
                                print("Raid")
                                SkipPlayer()
                            end
                        end)
                        
                        a = getgenv().targ.Character.HumanoidRootPart.Position
                        
                        if a ~= b then
                            yTween = 0
                            b = a
                            
                            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                                Nguvc = 14
                            else
                                Nguvc = 15
                            end
                        else
                            yTween = 5
                            
                            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                                Nguvc = 3
                            else
                                Nguvc = 5
                            end
                        end
                        
                        if getgenv().targ.Character.HumanoidRootPart.CFrame.Y >= 10 then
                            helloae = true
                        else
                            helloae = false
                        end
                    else
                        safehealth = true
                        
                        if getgenv().targ.Character:FindFirstChild("HumanoidRootPart") then
                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, math.random(5000, 100000), 0))
                        end
                    end
                end
            end)
        else
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
        end
    end
end)

-- Logic nhắm
local aim = false
local CFrameHunt

spawn(function()
    while task.wait() do 
        if getgenv().targ and getgenv().targ.Character and 
           lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
           (getgenv().targ.Character:WaitForChild("HumanoidRootPart").CFrame.Position - lp.Character:WaitForChild("HumanoidRootPart").CFrame.Position).Magnitude < 40 then 
            
            aim = true 
            
            if (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) then
                CFrameHunt = CFrame.new(
                    getgenv().targ.Character.HumanoidRootPart.Position + 
                    getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 2, 
                    getgenv().targ.Character.HumanoidRootPart.Position
                )
            else
                CFrameHunt = CFrame.new(
                    getgenv().targ.Character.HumanoidRootPart.Position + 
                    getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 5, 
                    getgenv().targ.Character.HumanoidRootPart.Position
                )
            end
        else
            aim = false
        end
    end
end)

-- Remote hook cho nhắm
spawn(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg, false)
    
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        
        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if aim and CFrameHunt then
                        args[2] = CFrameHunt.Position
                        return old(unpack(args))
                    end
                end
            end
        end
        
        return old(...)
    end)
end)

-- Nhắm chuột
local Mouse = lp:GetMouse()

Mouse.Button1Down:Connect(function()
    pcall(function()
        if getgenv().targ and aim and CFrameHunt then
            local args = {
                [1] = CFrameHunt.Position,
                [2] = getgenv().targ.Character.HumanoidRootPart
            }
            
            local tool = lp.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("RemoteFunctionShoot") then
                tool.RemoteFunctionShoot:InvokeServer(unpack(args))
            end
        end
    end)
end)

-- Khóa camera
spawn(function()
    while task.wait() do
        if getgenv().Setting.Another.LockCamera then
            local targetPlayer = getgenv().targ
            
            if targetPlayer and targetPlayer.Character then
                local targetCharacter = targetPlayer.Character
                local camera = game.Workspace.CurrentCamera
                
                if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                    local lookAtPos = targetCharacter.HumanoidRootPart.Position
                    local cameraPos = camera.CFrame.Position
                    local newLookAt = CFrame.new(cameraPos, lookAtPos)
                    camera.CFrame = newLookAt
                end
            end
        end
    end
end)

-- Tự động tham gia lại khi mất kết nối
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if not hopserver and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        print("Cuttay Auto Bounty | Đang vào lại!")
        UI.ShowNotification("Bị ngắt kết nối, đang vào lại...", "warning")
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

-- === WEBHOOK ===
local Urlsent = getgenv().Setting.Webhook.Url

function wSend(main)
    spawn(function()
        local success, error = pcall(function()
            local Data = game:GetService("HttpService"):JSONEncode(main)
            local Head = {["content-type"] = "application/json"}
            local Send = http_request or request or HttpPost or syn.request 
            
            if Send then 
                Send({Url = Urlsent, Body = Data, Method = "POST", Headers = Head})
            end
        end)
        
        if not success then
            print("Lỗi webhook: " .. tostring(error))
        end
    end)
end 

function wEarn(targ, earn, total) 
    if getgenv().Setting.Webhook.Enabled and getgenv().killed then
        local targetName = "Unknown"
        if targ and targ.Name then
            targetName = targ.Name
        end
        
        local data = {
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "**Cuttay Hub | Auto Bounty**",
                    ["color"] = 3447003, -- Màu xanh dương Discord
                    ["fields"] = {
                        {
                            ["name"] = "Tài khoản: ",
                            ["value"] = "||"..game.Players.LocalPlayer.Name.."||",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Mục tiêu: ",
                            ["value"] = "```"..targetName.."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Bounty thu được: ",
                            ["value"] = "```Earned: "..tostring(earn).."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Tổng Bounty: ",
                            ["value"] = "```Earned: "..tostring(total).."```",
                            ["inline"] = false,
                        },
                        {
                            ["name"] = "Bounty hiện tại: ",
                            ["value"] = "```"..(math.round((game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Value / 1000000)*100)/100).."M```",
                            ["inline"] = false,
                        }
                    },
                    ["thumbnail"] = {
                        ["url"] = "https://cdn.discordapp.com/attachments/1338107245983957013/1352284325386784850/Untitled524_20240705122146.png?ex=67dd746b&is=67dc22eb&hm=9271d0158ce1b078c61e2a5358ef80f1ff5e5619de9e159c2fe867a4a5ee734b&",
                    },
                    ["footer"] = {
                        ["text"] = "Cuttay Hub - .gg/baokhanh",
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }
            }
        }
        
        wSend(data)
    end
end

-- === QUẢN LÝ CÀI ĐẶT ===
local foldername = "Zidder Hub Auto Bounty"
local filename = foldername.."/Settings.json"

function saveSettings()
    local HttpService = game:GetService("HttpService")
    
    pcall(function()
        if not isfolder(foldername) then
            makefolder(foldername)
        end
        
        local json = HttpService:JSONEncode(getgenv().Setting)
        writefile(filename, json)
    end)
end

function loadSettings()
    local HttpService = game:GetService("HttpService")
    
    pcall(function()
        if isfolder(foldername) and isfile(filename) then
            local settings = HttpService:JSONDecode(readfile(filename))
            
            -- Cập nhật cài đặt từ file
            for category, values in pairs(settings) do
                if getgenv().Setting[category] then
                    for key, value in pairs(values) do
                        getgenv().Setting[category][key] = value
                    end
                end
            end
        end
    end)
end

-- Tải cài đặt
loadSettings()

-- === CẬP NHẬT THỐNG KÊ ===
local Bounty = game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value
local Earned = 0
local startTime = tick()
local OldTotalEarned = _G.TotalEarn or 0
local TotalEarned = _G.TotalEarn or 0

-- Hàm định dạng số
function FormatNumber(number)
    if number >= 1000000 then
        return string.format("%.2fM", number / 1000000)
    elseif number >= 1000 then
        return string.format("%.1fK", number / 1000)
    else
        return tostring(number)
    end
end

-- Luồng cập nhật thống kê
spawn(function()
    while task.wait() do
        pcall(function()
            Earned = game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value - Bounty
            
            -- Cập nhật thời gian
            local elapsedTime = tick() - startTime
            local hours = math.floor(elapsedTime / 3600)
            local minutes = math.floor((elapsedTime % 3600) / 60)
            local seconds = math.floor(elapsedTime % 60)
            _G.Time = elapsedTime
            
            -- Định dạng thời gian
            local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            
            -- Cập nhật UI
            UI.UpdateStats(
                FormatNumber(Earned),
                FormatNumber(TotalEarned + Earned),
                FormatNumber(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value)
            )
            
            -- Cập nhật webhook nếu cần
            if Earned ~= 0 and TotalEarned ~= OldTotalEarned + Earned then
                TotalEarned = OldTotalEarned + Earned
                _G.TotalEarn = TotalEarned 
                saveSettings()
                
                if getgenv().killed then
                    wEarn(getgenv().killed, Earned, TotalEarned)
                end
            end
        end)
    end
end)

-- Lưu cài đặt định kỳ
spawn(function()
    while task.wait(10) do
        saveSettings()
    end
end)

-- Khởi tạo danh sách người chơi
UI.UpdateTargetsList()

-- Cập nhật giao diện
UI.ShowNotification("Auto Bounty đã sẵn sàng!", "success")