-- Call MP

MP.Functions = MP.Functions or {}
MP.RequestID = MP.RequestID or {}
MP.ServerCallback = MP.ServerCallback or {}
MP.ServerCallbacks = MP.ServerCallbacks or {}
MP.CurrentRequestId = MP.CurrentRequestId or {}

MP.Functions.GetKey = function(key)
    local Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["0"] = 160,
        ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303,
        ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74,
        ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82,
        ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 96, ["N5"] = 97, ["N6"] = 98, ["N+"] = 99, ["N-"] = 100,
        ["N7"] = 101, ["N8"] = 102, ["N9"] = 103
    }
    return Keys[key]
end

MP.Functions.GetPlayerData = function(source) -- Get All Data From Database for the player
    return MP.GetPlayerData
end

-- Type Admin [Basic]

MP.Functions.DeleteVehicle = function(vehicle)
    SetEntityAsMissionEntity(vehicle, false, true)
    DeleteVehicle(vehicle)
end

MP.Functions.GetVehicleDirection = function()
    local civ = PlayerPedId()
    local civCoords = GetEntityCoords(civ)
    local inDirection = GetOffsetFromEntityInWorldCoords(civ, 0.0, 10.0, 0.0)
    local rayHandle = StartShapeTestRay(civCoords.x, civCoords.y, civCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, civ, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    else

    return nil
end

-- Callbacks

MP.Functions.triggerServerCallback = function(name, cb, ...)
    MP.ServerCallbacks[MP.CurrentRequestId] = cb

    TriggerServerEvent('MP-Base:server:triggerServerCallback', name, MP.CurrentRequestId, ...)

    if MP.CurrentRequestId < 65535 then
        MP.CurrentRequestId = MP.CurrentRequestId + 1
    else
        MP.CurrentRequestId = 0
    end
end

MP.Functions.GetPlayers = function()
    local MaxPlayers = 120
    local players = {}
    for i = 0, MaxPlayers, 1 do
        local civ = GetPlayerPed(i)
        if DoesEntityExist(civ) then 
            table.insert(players, i)
        end
    end

    return players
end

RegisterNetEvent('MP-Base:client:serverCallback')
AddEventHandler('MP-Base:client:serverCallback', function(requestId, ...)
    MP.ServerCallbacks[requestId](...)
    MP.ServerCallbacks[requestId] = nil
end)