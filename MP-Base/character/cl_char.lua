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

-- Verify Name

exports('verifyName', function(name)
    for k, v in ipairs(bannedNames) do
        if name == v  then
            local reason = "Trying to use inappropriate name and ruin the fun for everyone. Please think about your choices or never come back to the server! "
            TriggerServerEvent("MP-Admin:Disconnect", reason)
        end
    end

    local nameLength = string.len(name)
    if nameLength > 25 or nameLength < 2 then
        return 'Your Name Is too short or long'
    end

    local count = 0
	for i in name:gmatch("[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-]") do
		count = count + 1
	end
	if count ~= nameLength then
		return "Your player name contains special characters that are not allowed on this server."
	end

	local spacesInName = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, "%S+") do
		if string.match(word, "%u") then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 1 then
		return "Your name contains more than two spaces"
	end

	if spacesWithUpper ~= spacesInName then
		return "your name must start with a capital letter."
	end

	return ""
end)

RegisterNUICallback('deleteCharacter', function(data)
    local charData = data
    TriggerServerEvent('MP-Base:deleteChar', charData)
end)

RegisterNetEvent('MP-Base:Char:setupCharacters')
AddEventHandler('MP-Base:Char:setupCharacters', function()
    MP.Functions.TriggerServerCallback('MP-Base:getChar', function(data) -- Gets all data from character
        SendNUIMessage({type = "setupCharacters", characters = data})
    end)
end)

-- Export Change Character
exports('MP-Base:ChangeChar', function()
    TriggerEvent('MP-Base:Char:setupCharacters')
end)

