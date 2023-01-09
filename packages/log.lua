pcall(function()
local GetName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local hook = "https://zennx.000webhostapp.com/"
local data = {
    ["embeds"] = {
        {
            ["title"] = "**Execution**",
            ["description"] = [[
                ```
Name: ]] .. game.Players.LocalPlayer.Name .. [[

Game: ]] .. GetName.Name .. [[

Exploit: ]] .. identifyexecutor() .. [[

```]],
            ["type"] = "rich",
            ["color"] = tonumber(0xCFD9DE),
        }
    }
}
local newdata = game:GetService("HttpService"):JSONEncode(data)
local headers = {["content-type"] = "application/json"}
request = http_request or request or HttpPost or syn.request
pcall(function()
    loadstring(game:HttpGet('https://api.countapi.xyz/hit/zenxdontmesswiththisplease.com/visits'))()
end)
pcall(function()
    request({Url = hook, Body = newdata, Method = "POST", Headers = headers})
end)
end)
