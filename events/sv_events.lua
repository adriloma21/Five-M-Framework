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

-- Character SQL Functions

MP.Functions.CreatePlayer = function(source, data)
    exports['ghmattimysql']:execute('INSERT INTO players (`citizenid`, `firstname`, `lastname`, `dateofbirth`, `cash`, `bank`, `license`, `job`) VALUES (@citizenid, @firstname, @lastname, @dateofbirth, @cash, @bank, @license, @job)', {
        ['@citizenid'] = data.citizenid,
        ['@firstname'] = data.firstname,
        ['@lastname'] = data.lastname,
        ['@dateofbirth'] = data.dateofbirth,
        ['@cash'] = data.cash,
        ['@bank'] = data.bank,
        ['@license'] = data.license,
        ['@job'] = data.job
    })
        print('[MP-Base] '..Data.citizenid..' was created succesfully')

        MP.Functions.LoadPlayer(source, data)
end

MP.Functions.LoadPlayer = function(source, pData, citizenid)
    local src = source
    local citizenid = pData.citizenid

    Citizen.Wait(7)
    exports['ghmattimysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid AND cid = @cid', {['@citizenid'] = citizenid, ['@cid'] = cid}, function(result)

        -- Server Callback
        exports['ghmattimysql']:execute('UPDATE players SET name = @name WHERE citizenid = @citizenid AND cid = @cid', {['@citizenid'] = citizenid = ['@name'] = pData.name, ['@cid'] = cid}, function(result)
    
        MP.Player.LoadData(source, citizenid, cid)
        Citizen.Wait(7)
        local player = MP.Functions.getPlayer(source)
        TriggerClientEvent('MP-SetCharData', source {
            citizenid = result[1].citizenid,
            firstname = result[1].firstname,
            lastname = result[1].lastname,
            dateofbirth = result[1].dateofbirth,
            cash = result[1].cash,
            bank = result[1].bank,
            license = result[1].license,
            job = result[1].job
        })
        
        TriggerClientEvent('MP-Base:PlayerLoaded', source)
        -- TriggerClientEvent() // Do when UI completed
        -- Trigger for Admin
    end)
end
