local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/siernlib/main/library.lua"))()

local timeModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/laderite/zenx/main/packages/timeModule.lua"))()

function Debug(Error)
    if not isfile("debug.txt") then
        writefile("debug.txt", "Created @ " .. timeModule:Time() .. " on " .. timeModule:Date() .. "\n")
    end
    appendfile("debug.txt", "\nAn error occurred!\nError: " .. Error .. "\nTraceback: " .. debug.traceback())
end

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local PlayerGui = player.PlayerGui
local MoneyMeter = PlayerGui.PlayingScene.Money.Cash.Meter
PlayerGui.Shop.Frame.Visible = false

function tweenTP(input, studspersecond, offset) -- not mine
    local char = game:GetService("Players").LocalPlayer.Character;
    local input = input or error("input is nil");
    local studspersecond = studspersecond or 1000;
    local offset = offset or CFrame.new(0,0,0);
    local vec3, cframe;
 
    if typeof(input) == "table" then
        vec3 = Vector3.new(unpack(input)); cframe = CFrame.new(unpack(input));
    elseif typeof(input) ~= "Instance" then
        return error("wrong format used");
    end;
    
    Time = (char.HumanoidRootPart.Position - (vec3 or input.Position)).magnitude/studspersecond;
    local twn = game.TweenService:Create(char.HumanoidRootPart, TweenInfo.new(Time,Enum.EasingStyle.Linear), {CFrame = (cframe or input.CFrame) * offset});
    twn:Play();
    twn.Completed:Wait();
end

local function convertToNumber(str)
    local amount = str:gsub("[%$,]", "")
    return tonumber(amount)
end

local function getCash()
    local money = convertToNumber(MoneyMeter.Text)
    return money
end

local function getGems()
    local money = convertToNumber(MoneyMeter.Text)
    return money
end

function getTycoon()
    for _,v in pairs(workspace.PlayerTycoons:GetDescendants()) do
        if v.Name == "Owner" and tostring(v.Value) == player.Name then
            return v.Parent.Parent
        end
    end
end

local Tycoon = workspace.PlayerTycoons[getTycoon().Name]
local collectButton = Tycoon.Essentials.Giver.CollectButton

local function buy()
    if getgenv().autoBuy then
        local workerButton = nil
        local Buttons = Tycoon.Buttons:GetChildren()
        for _, button in pairs(Buttons) do
            if button.Button.BrickColor == BrickColor.new("Sea green") then
                local price = button.Button.BillboardGui.Frame.Price.Text
                if string.find(string.lower(button.Name), "worker") then
                    workerButton = button
                    local price = convertToNumber(price)
                    if (price and price <= getCash()) then
                        break -- prioritize buying worker button
                    end
                else
                    local price = convertToNumber(price)
                    if (price and price <= getCash()) then
                        local startTime = os.time()
                        repeat
                            task.wait()
                            player.Character.HumanoidRootPart.CFrame = button.Button.CFrame
                            firetouchinterest(player.Character.HumanoidRootPart, button.Button, 0)
                        until not button:IsDescendantOf(Tycoon) or os.time() - startTime >= 0.5
                        player.Character.HumanoidRootPart.CFrame = collectButton.CFrame
                    end
                end
            elseif button.Button.BrickColor == BrickColor.new("Dark Curry") then
                button:Destroy()
            end
        end
        if workerButton then
            local price = convertToNumber(workerButton.Button.BillboardGui.Frame.Price.Text)
            if (price and price <= getCash()) then
                local startTime = os.time()
                repeat
                    task.wait()
                    player.Character.HumanoidRootPart.CFrame = workerButton.Button.CFrame
                    firetouchinterest(player.Character.HumanoidRootPart, workerButton.Button, 0)
                until not workerButton:IsDescendantOf(Tycoon) or os.time() - startTime >= 0.5
                player.Character.HumanoidRootPart.CFrame = collectButton.CFrame
            end
        end
    end
end

local cashCounter = Tycoon.Essentials.Giver.CollectScreen.SurfaceGui.Frame.Amount
local collectAfter = 1000
local collectingCash = false

local function collectCash()
    if not getgenv().autoCollect or collectingCash then return end

    local cashText = cashCounter.Text:gsub("%$", "")
    local cash = tonumber(cashText)

    if (cash and cash >= collectAfter) then
        collectingCash = true

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = collectButton.CFrame
        wait()

        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, collectButton, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, collectButton, 1)
        collectingCash = false
    end
end

cashCounter:GetPropertyChangedSignal('Text'):Connect(function()
    collectCash()
end)

coroutine.resume(coroutine.create(function()
    while task.wait(1) do
        buy()
    end
end))


local win = Library:Create({
    Name = "Military Tycoon // Zen X",
})
local maintab = win:Tab('Main')

local main = maintab:Section('AUTOFARM')
main:Toggle('Auto Buy',function(v)
    getgenv().autoBuy = v
end)
main:Toggle('Auto Collect',function(v)
    getgenv().autoCollect = v
end)

local autoCollectSliderElement = main:Slider("Slider", 1000,10000,1000,500,function(v)
    collectAfter = v
end)

function discordFunction()
    xpcall(function()
        local StarterGui = game:GetService("StarterGui")
        local bindable = Instance.new("BindableFunction")

        function bindable.OnInvoke(response)
            setclipboard('https://discord.gg/4xwTXuSHHC')
        end

        StarterGui:SetCore("SendNotification", {
            Title = "Discord",
            Text = "Copy discord invite?",
            Duration = 60,
            Callback = bindable,
            Button1 = "Yes",
            Button2 = "No"
        })
    end, Debug)
end
