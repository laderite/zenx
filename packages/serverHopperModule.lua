local HttpService = game:GetService('HttpService')
local TeleportService = game:GetService('TeleportService')
local PlaceID = game.PlaceId
local AllIDs = {}
local FoundAnything = ""
local ActualHour = os.date("!*t").hour
local NotSameServersFileName = "NotSameServers.json"

local function loadServerIDs()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(NotSameServersFileName))
    end)
    if success and type(data) == "table" then
        AllIDs = data
    else
        table.insert(AllIDs, ActualHour)
        writefile(NotSameServersFileName, HttpService:JSONEncode(AllIDs))
    end
end

local function saveServerID(serverID)
    table.insert(AllIDs, serverID)
    writefile(NotSameServersFileName, HttpService:JSONEncode(AllIDs))
end

local function isValidServer(server, searchOption)
    local maxPlayers = tonumber(server.maxPlayers)
    local playing = tonumber(server.playing)
    local serverID = tostring(server.id)
    
    if searchOption == "lowest" then
        local serverCount = table.getn(server)
        local minCount = math.huge
        for i=1,serverCount do
            local currentPlayerCount = server[i].playing
            if currentPlayerCount < minCount then
                minCount = currentPlayerCount
            end
        end
        return maxPlayers and playing and maxPlayers > playing and not table.find(AllIDs, serverID) and playing == minCount
        
    elseif searchOption == "highest" then
        local serverCount = table.getn(server)
        local maxCount = -math.huge
        for i=1,serverCount do
            local currentPlayerCount = server[i].playing
            if currentPlayerCount > maxCount then
                maxCount = currentPlayerCount
            end
        end
        return maxPlayers and playing and maxPlayers > playing and not table.find(AllIDs, serverID) and playing == maxCount
        
    else -- searchOption == "default"
        return maxPlayers and playing and maxPlayers > playing and not table.find(AllIDs, serverID)
    end
end

local function teleportToServer(serverID)
    saveServerID(serverID)
    TeleportService:TeleportToPlaceInstance(PlaceID, serverID, game.Players.LocalPlayer)
    wait(4)
end

local function getPublicServers(cursor)
    local url = ('https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100'):format(PlaceID)
    if cursor then
        url = url .. '&cursor=' .. cursor
    end
    return HttpService:JSONDecode(game:HttpGet(url))
end

local function searchServers(searchOption)
    while true do
        local site = getPublicServers(FoundAnything)
        if site.nextPageCursor and site.nextPageCursor ~= "null" then
            FoundAnything = site.nextPageCursor
        else
            FoundAnything = ""
        end
        for _, server in ipairs(site.data) do
            if isValidServer(server, searchOption) then
                pcall(function()
                    teleportToServer(server.id)
                end)
            end
        end
        wait()
    end
end

loadServerIDs()

return {
    searchServers = searchServers
}
