local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/zenx/main/packages/library.lua"))()

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

local player = Players.LocalPlayer

local Module = require(ReplicatedStorage.Modules.SharedLocal)
local punchEvent = ReplicatedStorage.Events.Punch
local upgradeEvent = ReplicatedStorage.Events.UpgradeAbility

for _, v in next, getconnections(player.Idled) do
    v:Disable()
end

if not player.Character then
    repeat wait();
        getsenv(player:WaitForChild('PlayerScripts'):WaitForChild('IntroScript')).Play()
    until player.Character and Module.IsValidActor(player.Character)
end

spawn(function()
    while task.wait() do
        getsenv(player.PlayerScripts.GameClient)._G.energy = math.huge
    end
end)

function lightPunch()
    task.spawn(function() punchEvent:FireServer(0,0.1,1) end)
end

function heavyPunch()
    task.spawn(function() punchEvent:FireServer(0.4,0.1,1) end)
end

function goInvisible()
    invisibleStatus = true
    local ogPosition = player.Character.HumanoidRootPart.CFrame
    
    player.Character.HumanoidRootPart.CFrame = CFrame.new(-2463.92822, 256.457916, -2009.25574)
    wait(0.5)
    local Clone = player.Character.LowerTorso.Root:Clone()
    player.Character.LowerTorso.Root:Destroy()
    Clone.Parent = player.Character.LowerTorso
    wait(0.5)
    player.Character.HumanoidRootPart.CFrame = ogPosition
end
player.Character.Humanoid.Died:Connect(function()
    invisibleStatus = false
end)

function upgradeStatistic(stat, types, amount)
    if stat == nil then return end
    if types == nil then return end
    if amount == nil then return end

    if types == "default" then
        upgradeEvent:InvokeServer(stat)
    elseif types == "fast" then
        for i = 1, amount do
            task.spawn(function()
                upgradeEvent:InvokeServer(stat)
            end)
        end
    end 
end

function killPlayer(target)
    target = Players:FindFirstChild(target)
    local pos = player.Character.HumanoidRootPart.CFrame
    if target ~= nil and Module.IsValidActor(target.Character) and Module.NotProtected(target.Character) and Module.IsValidActor(player.Character) then
        if target.Character:FindFirstChild('ForceField') then
            repeat task.wait();
            until not target.Character:FindFirstChild('ForceField')
        end

        Connection = target.Character.DescendantAdded:connect(function(na)
            if na.Name == "ForceField" then
                abortStatus = true
            end
        end)

        repeat
            task.wait()
            if target.Character:FindFirstChild('HumanoidRootPart') and player.Character:FindFirstChild('HumanoidRootPart') then
                player.Character.HumanoidRootPart.CFrame = (target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.7))
                for i = 1, 20 do
                    heavyPunch()
                end
            end
        until not killPlayerStatus or not Module.IsValidActor(target.Character) or not Module.NotProtected(target.Character) or not Module.IsValidActor(player.Character)
        Connection:Disconnect()
        player.Character.HumanoidRootPart.CFrame = pos
    end
end

local function findPlayer(name)
    for _, Player in ipairs(Players:GetPlayers()) do
        if (string.lower(name) == string.sub(string.lower(Player.Name), 1, #name)) then
            return Player;
        end
    end
end

function spec()
    local plrtoview = selectedPlayer
    if not plrtoview then return end
    
    local ptv = findPlayer(plrtoview)
    if not ptv or not game.Workspace:FindFirstChild(ptv.Name) then return end
    
    spectate = true
    local Camera = game.Workspace.CurrentCamera
    Camera.CameraSubject = game.Workspace[ptv.Name].Humanoid
    Camera.CameraType = Enum.CameraType.Follow
    
    while spectate and game.Workspace:FindFirstChild(ptv.Name) do
        task.wait()
    end
    
    Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    Camera.CameraType = Enum.CameraType.Custom
end

-- Title Destroyer (the thing above ur head)
task.spawn(function()
    while task.wait() do
        if hidePlayerTitle or invisibleStatus then
            pcall(function()
                player.Character.HumanoidRootPart.titleGui.Frame:Destroy()
            end)
        end
    end
end)

--// Orb Farm
task.spawn(function()
    while task.wait() do
        if orbFarm then
            pcall(function()
                for i,v in pairs(workspace.ExperienceOrbs:GetChildren()) do
                    firetouchinterest(player.Character.HumanoidRootPart, v, 0)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if autoStats then
            upgradeStatistic(selectedStat, statMethod, statAmount)
        end
    end
end)

--// Hero Farm (farms thugs)
task.spawn(function()
    while task.wait() do
        if heroFarm then
            local target = workspace:FindFirstChild('Thug')
            if target then
                repeat wait(.1)
                    pcall(function()
                        player.Character.HumanoidRootPart.CFrame = (target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.7))
                        heavyPunch()
                    end)
                until not Module.IsValidActor(target) or not Module.IsValidActor(player.Character) or target.Humanoid.Health <= 0
                target:Destroy()
            end
        end
    end
end)

--// Villian Farm (farms civilians and police)
task.spawn(function()
    while task.wait() do
        if villianFarm then
            local target = workspace:FindFirstChild('Civilian') or workspace:FindFirstChild('Police')
            if target then
                repeat wait(.1)
                    pcall(function()
                        player.Character.HumanoidRootPart.CFrame = (target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.7))
                        heavyPunch()
                    end)
                until not Module.IsValidActor(target) or not Module.IsValidActor(player.Character) or target.Humanoid.Health <= 0
                target:Destroy()
            end
        end
    end
end)

--// Farm All (farms civilians and police and thugs)
task.spawn(function()
    while task.wait() do
        if villianFarm then
            local target = workspace:FindFirstChild('Civilian') or workspace:FindFirstChild('Police') or workspace:FindFirstChild('Thug')
            if target then
                repeat wait(.1)
                    pcall(function()
                        player.Character.HumanoidRootPart.CFrame = (target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.7))
                        heavyPunch()
                    end)
                until not Module.IsValidActor(target) or not Module.IsValidActor(player.Character) or target.Humanoid.Health <= 0
                target:Destroy()
            end
        end
    end
end)

-- Creating the library

local Menu = library:CreateMenu({
    Name = "Zen X » Age of Heroes (Rewritten)",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = ""
    },
})

-- Tabs
local MainTab = Menu:CreateTab('Main')

-- Sections
local auto_farm = MainTab:CreateSection({Name = "Auto Farm", Side = "Left"})
local auto_stats = MainTab:CreateSection({Name = "Auto Stats", Side = "Left"})
local target_section = MainTab:CreateSection({Name = "Target", Side = "Right"})
local misc_section = MainTab:CreateSection({Name = "Misc", Side = "Right"})

-- Section auto_farm
auto_farm:CreateToggle({Name = "Auto collect orbs", Callback = function(v)
    orbFarm = v
end})

auto_farm:CreateToggle({Name = "Hero Farm", Callback = function(v)
    heroFarm = v
end})

auto_farm:CreateToggle({Name = "Villian Farm", Callback = function(v)
    villianFarm = v
end})

auto_farm:CreateToggle({Name = "Farm All", Callback = function(v)
    farmAll = v
end})

-- Section auto_stats
auto_stats:CreateToggle({Name = "Auto Stats", Callback = function(v)
    autoStats = v
end})

auto_stats:CreateTextbox({Name = "Method (default, fast)", RemoveTextAfterFocusLost = false, Callback = function(v)
    statMethod = v
    statAmount = 10
end})

auto_stats:CreateTextbox({Name = "Statistic", RemoveTextAfterFocusLost = false, Callback = function(v)
    selectedStat = v
end})

-- Section target_section
local targetBox = target_section:CreateTextbox({Name = "Target", RemoveTextAfterFocusLost = false, Callback = function(va)
    setTarget(va, "Target")
end})
function setTarget(va, title)
    for i,v in pairs(game.Players:GetChildren()) do
        if (string.sub(string.lower(v.DisplayName),1,string.len(va))) == string.lower(va) then
            selectedPlayer = v.Name
            targetBox:Set('Selected ' .. v.DisplayName .. ' as the target!')
            task.wait(1.5)
            targetBox:Set(title)
            break
        end
    end
end

target_section:CreateToggle({Name = "Kill Player", Callback = function(v)
    killPlayerStatus = v 
    if v then killPlayer(selectedPlayer) end
end})

target_section:CreateToggle({Name = "Spectate Player", Callback = function(v)
    if v then
        pcall(function() spec() end)
    else
        local Camera = workspace:FindFirstChildWhichIsA('Camera')
        Camera.CameraSubject = player.Character:FindFirstChildWhichIsA('Humanoid')
        spectate = false
    end
end})

flinging = false
local flingtbl = {}
target_section:CreateToggle({Name = "Fling Player", Callback = function(v)
    if v then

        local rootpart = player.Character:FindFirstChild('HumanoidRootPart')
        if not rootpart then return end
        flingtbl.OldVelocity = rootpart.Velocity
        local bv = Instance.new("BodyAngularVelocity")
        flingtbl.bv = bv
        bv.MaxTorque = Vector3.new(1, 1, 1) * math.huge
        bv.P = math.huge
        bv.AngularVelocity = Vector3.new(0, 9e5, 0)
        bv.Parent = rootpart
        local Char = player.Character:GetChildren()
        for i, v in next, Char do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Massless = true
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
        flingtbl.Noclipping2 = game:GetService("RunService").Stepped:Connect(function()
            for i, v in next, Char do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
        flinging = true
    else
        if not v then
            local rootpart = player.Character:FindFirstChild('HumanoidRootPart')
            if not rootpart then return end
            flingtbl.OldPos = rootpart.CFrame
            local Char = player.Character:GetChildren()
            if flingtbl.bv ~= nil then
                flingtbl.bv:Destroy()
                flingtbl.bv = nil
            end
            if flingtbl.Noclipping2 ~= nil then
                flingtbl.Noclipping2:Disconnect()
                flingtbl.Noclipping2 = nil
            end
            for i, v in next, Char do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                    v.Massless = false
                end
            end
            flingtbl.isRunning = game:GetService("RunService").Stepped:Connect(function()
                if flingtbl.OldPos ~= nil then
                    rootpart.CFrame = flingtbl.OldPos
                end
                if flingtbl.OldVelocity ~= nil then
                    rootpart.Velocity = flingtbl.OldVelocity
                end
            end)
            wait(2)
            rootpart.Anchored = true
            if flingtbl.isRunning ~= nil then
                flingtbl.isRunning:Disconnect()
                flingtbl.isRunning = nil
            end
            rootpart.Anchored = false
            if flingtbl.OldVelocity ~= nil then
                rootpart.Velocity = flingtbl.OldVelocity
            end
            if flingtbl.OldPos ~= nil then
                rootpart.CFrame = flingtbl.OldPos
            end
            wait()
            flingtbl.OldVelocity = nil
            flingtbl.OldPos = nil
            flinging = false
        end
    end
end})

target_section:CreateButton({Name = "Teleport to Player", Callback = function(v)
    if Module.IsValidActor(player.Character) and Module.IsValidActor(game.Players[selectedPlayer].Character) then
        player.Character.HumanoidRootPart.CFrame = game.Players[selectedPlayer].Character.HumanoidRootPart.CFrame
    end
end})

-- Section misc_section
misc_section:CreateToggle({Name = "Hide Username", Callback = function(v)
    hidePlayerTitle = v
end})

misc_section:CreateToggle({Name = "Noclip", Callback = function(v)
    spectatePlayer = v
end})

misc_section:CreateButton({Name = "Invisible (+ hide username)", Callback = function()
    goInvisible()
    hidePlayerTitle = true
end})

misc_section:CreateButton({Name = "Rejoin", Callback = function(v)
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end})

misc_section:CreateButton({Name = "Serverhop", Callback = function(v)
    local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
Teleport()
end})

Menu:Load()
