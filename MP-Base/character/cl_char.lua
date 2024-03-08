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

