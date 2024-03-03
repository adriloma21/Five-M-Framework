-- Call MP

MP.Functions = MP.Functions or {}
MP.Commands = {}
MP.CommandsSuggestions = {}
MP.ServerCallbacks = MP.ServerCallbacks or {}
MP.ServerCallback = {}

MP.Functions.RegisterServerCallback = function(name, cb)
    MP.ServerCallback[name] = cb
end

MP.Functions.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if MP.ServerCallback[name] ~= nil then
        MP.ServerCallback[name](source, cb, ...)
    else
        print(('MP-Base: %s does not exist'):format(name))
    end
end

MP.Functions.getPlayer = function(source)
    if MP.Player[source] ~= nil then
        return MP.Players[source]
    end
end

MP.Functions.AdminPlayers = function(source) -- Admin
    if MP.APlayer[source] ~= nil then
        return MP.APlayers[source]
    end
end

RegisterNetEvent('MP-Base:client:server:UpdatePlayer')
AddEventHandler('MP-Base:client:server:UpdatePlayer', function(Player)
    local civ = soruce
    local player = MP.Functions.getPlayer(civ)
    if player ~= nil then
        Player.Functions.Save()
    end
end)
