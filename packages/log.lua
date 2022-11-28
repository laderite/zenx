local GetName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local hook = "https://discord.com/api/webhooks/1046677898670641243/lRMWIf17xqR8pLs7qocSjb48j1Fn0pLY6Imrp_vb8yGilxQ9jOG_lv2RtvXgpUJP2vc8"
local data = {
    ["embeds"] = {
        {
            ["title"] = "**Execution**",
            ["description"] = [[
                ```
Name: ]] .. game.Players.LocalPlayer.Name .. [[

Game: ]] .. GetName.Name .. [[

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
