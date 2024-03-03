RegisterNetEvent('MP-Base:ServerStart')
AddEventHandler('MP-Base:ServerStart', function()
    print('Server Started')
    local civ = source
    Citizen.CreateThread(function()
        local Identifier = GetPlayerIdentifiers(civ)[1] -- This gets Steam:192913831
        if not Identifier then
            DropPlayer(civ, 'Identifier not found')
        end
        return
    end)
end)

RegisterNetEvent('MP-Base:client:getObject')
AddEventHandler('MP-Base:client:getObject', function(callback)
    callback(MP)
end)

-- Commands
AddEventHandler('MP-Base:addCommand', function(command, callback, suggestion, args)
    MP.Functions.addCommand(command, callback, suggestion, args)
end)

AddEventHandler('MP-Base:addGroupCommand', function(group, command, callback, callbackfailed, suggestion, args)
    MP.Functions.addGroupCommand(group, command, callback, callbackfailed, suggestion, args)
end)

-- Callback Server
RegisterServerEvent('MP-Base:server:triggerServerCallback')
AddEventHandler('MP-Base:server:triggerServerCallback', function(name, requestId, ...)
    local civ = source

        MP.Functions.triggerServerCallback(name, requestId, civ, function(...)
            TriggerClientEvent('MP-Base:client:serverCallback', civ, requestId, ...)
    end, ...)
end)