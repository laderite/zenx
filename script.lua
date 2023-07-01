local GetName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local hooks = {"https://discord.com/api/webhooks/972921153217757235/QN6qHvXXwoZBuBGEyIz1fqWQwm0CHR6TfhS3FmDCWV-jlnS4YNw2v6SOKt0wD8MUwq54"}

local data = {
    ["embeds"] = {
        {
            ["title"] = "**Execution**",
            ["description"] = "",
            ["fields"] = {
                {
                    name = "Game",
                    value = GetName.Name,
                    inline = true,
                },
            },
            ["type"] = "rich",
            ["color"] = tonumber(0xFF0000),
        }
    }
}
local newdata = game:GetService("HttpService"):JSONEncode(data)
local headers = {["content-type"] = "application/json"}

request = http_request or request or HttpPost or syn.request
pcall(function()
    request({Url = hooks[1], Body = newdata, Method = "POST", Headers = headers})
end)

local url = "https://raw.githubusercontent.com/laderite/zenx/main/scripts"

local games = {
    [5023820864] = "Trade Tower";
    [4866692557] = "Age of Gays";
    [2990100290] = "RPG Simulator"; -- world 1
    [4628853904] = "RPG Simulator"; -- world 2
    [8328351891] = "Mega Mansion Tycoon";
    [7424863999] = "Super Hero VS God Tycoon";
    [8069117419] = "Demon Soul";
    [7180042682] = "Military Tycoon";
    [7800644383] = "Untitled Hood GUI";
    [9183932460] = "Untitled Hood New GUI";
}

for i,v in next, games do
    games[i] = table.concat(v:split(' '), '_')
end

local name = games[game.PlaceId] or games[game.GameId]
return loadstring(game:HttpGet(url.. "/"..(name or "Universal")..".lua"))()
