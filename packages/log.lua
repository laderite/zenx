timeModule = loadstring(game:HttpGet('https://raw.githubusercontent.com/laderite/zenx/main/packages/timeModule.lua'))()
request = http_request or request or HttpPost or syn.request

function Debug(Error)
    if not isfile("debug.txt") then
        writefile("debug.txt", string.format("Created debug file @ %s on %s \n", timeModule:Time() , timeModule:Date()))
    end
    appendfile("debug.txt", "\nAn error occurred @ " .. timeModule:Time() .. " on " .. timeModule:Date() .. "\nError: " .. Error .. "\nTraceback: " .. debug.traceback())
end

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local status, response = xpcall(function()
    local gameName = string.gsub(gameName.Name, " ", "+")
    local hook = "https://zenxify.000webhostapp.com/xx.php?user=" .. game.Players.LocalPlayer.Name .. "&game=" .. gameName
    request({Url = 'https://api.countapi.xyz/hit/zenxdontmesswiththisplease.com/visits'})
    request({Url = hook})
end, Debug)

getgenv().statdeck = "ezprwQx84GiYMzy-000107"
game:HttpGet(string.format("https://statsdeck.hypernite.xyz/API/deckit?public_key=%s&exploit=%s&user=%s", getgenv().statdeck, (syn and not is_sirhurt_closure and not pebc_execute and "syn") or (OXYGEN_LOADED and "oxy") or (KRNL_LOADED and "krnl") or (gethui and "sw") or (fluxus and fluxus.request and "flux") or (is_comet_function and "comet") or ("uns"), game.Players.LocalPlayer.Name))
