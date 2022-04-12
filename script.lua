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
if identifyexecutor() == "Fluxus" and name == "Trade_Tower" then return loadstring(game:HttpGet('https://raw.githubusercontent.com/laderite/zenx/main/scripts/Trade%20Tower%20Fluxus.lua'))() end -- Trade tower script for fluxus users
return loadstring(game:HttpGet(url.. "/"..(name or "Universal")..".lua"))()
