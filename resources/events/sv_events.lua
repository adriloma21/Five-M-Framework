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

MP.Functions.addCommand = function(command, callback, suggestion, args)
    MP.Commands[command] = callback
    MP.Commands[command].cmd = callback
    MP.Commands[command].args = args or -1
    MP.CommandsSuggestions[command] = {suggestion = suggestion, args = args}

    if suggestion then
        if not suggestion.params or not type(suggestion.params) == 'table' then suggestion.params = {} end
        if not suggestion.help or not type(suggestion.help) == 'string' then suggestion.help = '' end

        MP.CommandsSuggestions[command] = suggestion
    end

    RegisetrCommand(command, function(source, args)
        if((#args <= MP.Commands[command].args) and #args == MP.Commands[command].args or MP.Commands[command].args == -1) then
            callback(source, args, MP.Players[source])
        end
    end, false)
end

MP.Functions.addGroupCommand = function(group, command, callback, callbackfailed, suggestion, args)
    MP.Commands[command] = {}
    MP.Commands[command].perm = math.maxinteger
    MP.Commands[command].cmd = callback
    MP.Commands[command].group = group
    MP.Commands[command].callbackfailed = callbackfailed
    MP.Commands[command].args = args or -1
    MP.CommandsSuggestions[command] = {suggestion = suggestion, args = args}

    if suggestion then
        if not suggestion.params or not type(suggestion.params) == 'table' then suggestion.params = {} end
        if not suggestion.help or not type(suggestion.help) == 'string' then suggestion.help = '' end

        MP.CommandsSuggestions[command] = suggestion
    end

    RegisterCommand(command, function(source, args)
        if MP.APlayers[source] ~= nil then
            if MP.APlayers[source].group == group then
                if((#args <= MP.Commands[command].args) and #args == MP.Commands[command].args or MP.Commands[command].args == -1) then
                    callback(source, args, MP.APlayers[source])
                end
            else
                if callbackfailed ~= nil then
                    callbackfailed(source, args, MP.APlayers[source])
                end
            end
        end
    end, true)
end

-- Usergroups for Admins

MP.Functions.setupAdmin = function(player, group)
    local citizenid = player.Data.citizenid
    local pCid = player.Data.cid
    exports['ghmattimysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid AND cid = @cid', {['@citizenid'] = citizenid, ['@cid'] = pCid})
        Wait(1000)

    exports['ghmattimysql']:execute('INSERT INTO RANKING (citizenid, group) VALUES (@citizenid, @group)', {
        ['@citizenid'] = citizenid, 
        ['@group'] = group})
    end)
    print('[MP-Base] '..citizenid..' was added to the group '..group)
    TriggerClientEvent('MP-Admin:updateGroup', player.Data.playerID, group)
end

MP.Function.BuildCommands = function(source)
    local src = source
    for k, v in pairs(MP.CommandsSuggestions) do
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end

MP.Function.ClearCommands = function(source)
    for k, v in pairs(MP.CommandsSuggestions) do
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end