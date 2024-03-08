local selectedChar = false;
local cam = nil
local cam2 = nil

local bannedName = {}

Citizen.CreateThread(function()
    while true do 
        Citizen.wait(0)

        if NetworkIsSessionStarted() then
            TriggerServerEvent('MP-Base:Char:Joined')
            TriggerEvent('MP-Base:Char:StartCamera')
            TriggerEvent('MP-ui:client:CloaseCharUI')
            TrigegrEvent('MP-Base:PlayerLogin')
            selectedChar(true)
            return
        end
    end
end)

RegisterNetEvent('MP-Base:Char:Selecting')
AddEventHandler('MP-Base:Char:StartCamera', function()
    selectedChar = true
end)

GetID = function(source, cb)
    local src = source
    TriggerServerEvent('MP-Base:Char:GetID', src)
end 

RegisterNUICallback('createCharacter', function(data)
    local charData = data.CharData
    for theData, value in pairs(charData) do
        if theData == 'firstname' or theData == 'lastname' then
            reason = verifyName(value)
            print(reason)

            if reason ~= '' then
                break
            end
        end
    end

    if reason ~= '' then
        TriggerServerEvent('MP-Base:Char:createCharacter', charData)
    end
end)