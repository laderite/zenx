-- beginning of code, if you found a speed bypass, lmk if u want to thx, 'j#0499
-- and btw this is really really bad code and a lot of it from my other projects bc i haven't made a script ln like 2-3 months lol

repeat wait(1) until game:IsLoaded()

if getgenv().Settings.LeaveTimer == nil then
    getgenv().Settings.LeaveTimer = 300
end

function log(message, type)
    if type == "WARN" then
        print('WARN:', message)
    elseif type == "DEBUG" then
        print('DEBUG:', message)
    end
end

if game.PlaceId == 7127407851 then
    --log('Joining VIP', "DEBUG")
    local args = {
        [1] = "VIP",
        [2] = "Join",
        [3] = "Code"
    }

    --game:GetService("ReplicatedStorage").Assets.Remotes:GetChildren()[2]:InvokeServer(unpack(args))
    --return
end

local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Plr = Players.LocalPlayer;
repeat wait() pcall(function() Char = Plr.Character end) until Char
local Head = Char:WaitForChild("Head", 1337);
local Root = Char:WaitForChild("HumanoidRootPart", 1337);
local Humanoid = Char:WaitForChild("Humanoid", 1337);

-- find this off v3rm and modified it cuz idk metatables

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt,false)
mt.__namecall = newcclosure(function(self, ...)
  local args = {...}
  if getnamecallmethod() == 'InvokeServer' and args[1] == "Slash" then
    args[3] = "Nape"
  end
  return old(self, unpack(args))
end)


function getClosestTitan()
    local nearestPlayer, nearestDistance
    pcall(function()
        for _, player in pairs(workspace.Titans:GetChildren()) do
            local character = player.Hitboxes.Player.Nape
            if character then
                local plr = Game:GetService("Players").LocalPlayer
                local nroot = player:FindFirstChild('Main')
                local health = player.Head:FindFirstChild('Party')
                if nroot and health then
                    local distance = plr:DistanceFromCharacter(nroot.Position)
                    if (nearestDistance and distance >= nearestDistance) then continue end
                    nearestDistance = distance
                    nearestPlayer = character
                    selectt = player
                end
            end
        end
    end)
    return nearestPlayer, selectt
end

function getClosestRefill()
    local nearestPlayer, nearestDistance
        for _, player in pairs(game:GetService("Workspace").Map.Props.Refills:GetChildren()) do
            local character = player.Hitbox
            if character then
                local plr = Game:GetService("Players").LocalPlayer
                local distance = plr:DistanceFromCharacter(character.Position)
                if (nearestDistance and distance >= nearestDistance) then continue end
                nearestDistance = distance
                nearestPlayer = character
            end
        end
    return nearestPlayer
end


local VirtualInputManager = game:GetService('VirtualInputManager')
function useSkill(key, bool)
    VirtualInputManager:SendKeyEvent(bool, key, false, game)
end

function lookAt(chr,target) -- found this func somewhere
    if chr.PrimaryPart then 
        local chrPos=chr.PrimaryPart.Position 
        local tPos=target.Position 
        local newCF=CFrame.new(chrPos,tPos) 
        chr:SetPrimaryPartCFrame(newCF)
    end
end

function bladesFull()
    local Status = 0
    pcall(function()
        for _,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart.Board.Display.Blade.Segments:GetDescendants()) do
            if v.Name == "Inner" then
                if v.ImageTransparency == 1 then
                    Status = Status + 1
                end
            end
        end
    end)

    if Status == 7 then
        return true
    end
    return false
end

function refillBlades()
    wait(1)
    local args = {
        [1] = true,
        [2] = "Effect",
        [3] = "Refill"
    }
    
    game:GetService("ReplicatedStorage").Assets.Remotes:GetChildren()[1]:FireServer(unpack(args))

    wait(1.5)
    if bladesFull() == true then
        local refill = getClosestRefill()
        local Time =
        (refill.Position -
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 400
        local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
        local Tween =
            game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            Info,
            {CFrame = CFrame.new(refill.Position) + Vector3.new(0, 4, 0)}
        )
        Tween:Play()
        Tween.Completed:Wait()
        refilling = true
        wait(1)
        useSkill('R', true)
        wait(7)
        local Time =
        (refill.Position + Vector3.new(30, 4, 30) -
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 400
        local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
        local Tween =
            game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            Info,
            {CFrame = CFrame.new(refill.Position) + Vector3.new(15, 4, 15)}
        )
        Tween:Play()
        Tween.Completed:Wait()
        refilling = false
        wait(1)
    end
end

function okTitan()
    while task.wait() do
        if not titan then return end
        pcall(function()
            lookAt(Char, titan)
        end)
    end
end
local virtualUser = game:GetService('VirtualUser')
virtualUser:CaptureController()
skilln = 0
function killClosestTitan()
    wait(0.3)
    if bladesFull() == true then
        useSkill('E', false)
        refillBlades()
        return
    end
    titan, titanparrt = getClosestTitan()
    if not titan then return end
    if Plr:DistanceFromCharacter(titan.Position) <= 50 then
        getgenv().Speed = getgenv().Settings.Speed2
    else
        getgenv().Speed = getgenv().Settings.Speed
    end

    local Time =
        (titan.CFrame.p + Vector3.new(0, 7,4) -
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / getgenv().Speed
    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween =
        game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        Info,
        {CFrame = CFrame.new(titan.CFrame.p) +Vector3.new(0, 7,4)}
    )
    Tween:Play()
    Tween.Completed:Wait()
    wait()
    local Time =
    (titan.CFrame.p + Vector3.new(0, 3, 1) -
    game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / getgenv().Speed
    local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
    local Tween =
        game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        Info,
        {CFrame = CFrame.new(titan.CFrame.p) + Vector3.new(0, 7,4)}
    )
    Tween:Play()
    repeat wait() until Tween.Completed or Plr:DistanceFromCharacter(titan.Position) <= 20
    if not titan then return end
    repeat task.wait()
        if bladesFull() == false then
            Root.CFrame = CFrame.new(titan.CFrame.p) + Vector3.new(0, 1,1)
            lookAt(Char, titan)
            mousemoveabs(600,800)
            useSkill('E', true)
            mouse1click()
        else
            break
        end

    until not titanparrt.Head:FindFirstChild('Party') or bladesFull() == true
end


function getName()
    return game:GetService("ReplicatedStorage").Assets.Remotes:GetChildren()[1].Name
end

function selectMap(map, difficulty)
    for _,v in pairs(Plr.PlayerGui.Interface.PvE.Main:GetChildren()) do
        if v:IsA('ImageButton') then
            if v.Title.Text == "???" then repeat wait() until v.Title.Text ~= "???" end
            if v.Title.Text == map then
                local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
                for i,a in pairs(Signals) do
                    firesignal(v[a])
                end
            end
        end
    end
    for _,v in pairs(Plr.PlayerGui.Interface.PvE.Difficulties:GetChildren()) do
        if v:IsA('TextButton') then
            if v.Lock.Visible == false then
                if v.Name == "???" then repeat wait() until v.Name ~= "???" end
                if v.Name == difficulty then
                    local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
                    for i,a in pairs(Signals) do
                        firesignal(v[a])
                    end
                end
            end
        end
    end
end

pcall(function()
    iflobby = game:GetService("Workspace").Map.Props.Missions.Pad.Main
end)

if iflobby ~= nil then
    wait(1)
    Root.CFrame = CFrame.new(iflobby.Position)
    repeat wait() until Plr.PlayerGui.Interface.PvE.Main['1'].Visible == true
    wait()
    selectMap(getgenv().Settings.Map, getgenv().Settings.Difficulty)
    log('Selected maps', "DEBUG")
    return
end

task.spawn(function()
    wait(getgenv().Settings.LeaveTimer)
    
    local ts = game:GetService("TeleportService")

    local p = game:GetService("Players").LocalPlayer
    
     

    ts:Teleport(7229033818, p)
    log('Teleprting to main screen', 'DEBUG')
end)

getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        game:GetService("TeleportService"):Teleport(7229033818)
    end
end)
time = 0
function killTouch()
    while task.wait() do
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.TouchInterest:Destroy()
        end)
    end
end
task.spawn(killTouch)

function killTouchh()
    while task.wait(1) do
        time = time + 1
    end
end
task.spawn(killTouchh)
log('Script loaded', "DEBUG")

pcall(function() game.StarterGui:SetCore("SendNotification", {
    Title = "IF U GET NO REWARDS";
    Text = "working on a fix, will come out soon";
    Icon = "rbxassetid://57254792";
    Duration = 1337;
}) end)

pcall(function() game.StarterGui:SetCore("SendNotification", {
    Title = "IF U DONT INSTAKILL";
    Text = "upgrade the damage on ur odm, there is no instakill";
    Icon = "rbxassetid://57254792";
    Duration = 1337;
}) end)

pcall(function() game.StarterGui:SetCore("SendNotification", {
    Title = "made by jsn#0499";
    Text = "made by jsn#0499, if u have bugs or questions dm me";
    Icon = "rbxassetid://57254792";
    Duration = 1337;
}) end)

local Time =
(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(200, 0, 200) -
game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / 100
local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
local Tweena =
    game:GetService("TweenService"):Create(
    game.Players.LocalPlayer.Character.HumanoidRootPart,
    Info,
    {CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(200, 0, 200)}
)
Tweena:Play()
Tweena.Completed:Wait()

while task.wait() and not refilling do
    killClosestTitan()
end
