lib.locale()

local _g = {
    showGamerTag = true,
    mpGamerTag = {},
}

local function clearName(name)
    if not Config.ClearName then return name end
end

local function formatName(player)
    local serverId = GetPlayerServerId(player)
    local playerState = Player(serverId).state
    local jobLabel, gradeLabel = GetPlayerJobAndGradeLabel(playerState)
    local args = {
        name = clearName(playerState.name),
        job = jobLabel,
        grade = gradeLabel,
        serverId = serverId,
    }
    local name = Config.NameTemplate:gsub('{(.-)}', args)
    for _, v in pairs(Config.SubstituteRule) do
        name = string.gsub(name, table.unpack(v))
    end
    return name
end

local function createMpGamerTag(player)
    RemoveMpGamerTag(player)
    repeat Wait(0) until IsMpGamerTagFree(player)

    CreateMpGamerTagWithCrewColor(player, formatName(player), false, false, '', 0, 255, 255, 255)
end

local function updateMpGamerTag(toggle)
    if not _g.mpGamerTag.hasTalking and not _g.mpGamerTag.hasTyping then return end

    if toggle then
        if _g.mpGamerTag.updateTask then return end

        _g.mpGamerTag.updateTask = SetInterval(function()
            local players = GetActivePlayers()
            for i = 1, #players do
                local player = players[i]
                if _g.mpGamerTag.hasTalking then
                    SetMpGamerTagVisibility(player, 4, NetworkIsPlayerTalking(player))
                end
                if _g.mpGamerTag.hasTyping then
                    local serverId = GetPlayerServerId(player)
                    local playerState = Player(serverId).state
                    SetMpGamerTagVisibility(player, 16, playerState.typing)
                end
            end
        end)
    else
        if not _g.mpGamerTag.updateTask then return end

        ClearInterval(_g.mpGamerTag.updateTask)
    end
end

local function displayMpGamerTag(player, toggle)
    if player == -1 then
        local players = GetActivePlayers()
        for i = 1, #players do
            local _player = players[i]
            displayMpGamerTag(_player, toggle)
        end
        return
    end

    if toggle then
        for _, v in pairs(Config.Draw.MpGamerTag.Components) do
            if v.Id == 4 then
                SetMpGamerTagVisibility(player, v.Id, NetworkIsPlayerTalking(player))
            else
                SetMpGamerTagVisibility(player, v.Id, true)
            end
            SetMpGamerTagColour(player, v.Id, v.Color)
            SetMpGamerTagAlpha(player, v.Id, v.Alpha)
        end
    else
        SetMpGamerTagVisibilityAll(player, false)
    end
    updateMpGamerTag(toggle)
end

local function drawText3D(coords, text)
    local onScreen = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    local camCoord = GetGameplayCamCoord()
    local dist = #(camCoord - coords)

    local scale
    if Config.Draw.DrawText3D.ScaleWithDistance then
        scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100
    else
        scale = 1
    end

    if onScreen then
        local format = Config.Draw.DrawText3D
        local color = format.Color
        SetTextFont(format.Font)
        SetTextScale(0.0 * scale, format.Size * scale)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextOutline()
        SetTextCentre(true)

        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

if Config.Key.Mode == 'Toggle' then
    RegisterCommand(Config.Key.Toggle.Command, function()
        _g.showGamerTag = not _g.showGamerTag
        if Config.Draw.Mode == 'MpGamerTag' then
            displayMpGamerTag(-1, _g.showGamerTag)
        end
    end, false)
    RegisterKeyMapping(Config.Key.Toggle.Command, locale('key_description'), Config.Key.Toggle.Mapper, Config.Key.Toggle.Parameter)
elseif Config.Key.Mode == 'OnlyShowOnPress' then
    SetInterval(function()
        if IsControlPressed(0, Config.Key.OnlyShowOnPress) then
            _g.showGamerTag = true
        else
            _g.showGamerTag = false
        end
        if Config.Draw.Mode == 'MpGamerTag' then
            displayMpGamerTag(-1, _g.showGamerTag)
        end
    end)
end

if Config.Draw.Mode == 'MpGamerTag' then
    for _, v in pairs(Config.Draw.MpGamerTag.Components) do
        if v.Id == 4 then
            _g.mpGamerTag.hasTalking = true
        elseif v.Id == 16 then
            _g.mpGamerTag.hasTyping = true
        end
    end

    SetMpGamerTagsVisibleDistance(Config.Distance)
    SetMpGamerTagsUseVehicleBehavior(Config.Draw.MpGamerTag.UseVehicleBehavior)

    AddStateBagChangeHandler('job', nil, function(bagName, key, value)
        local player = GetPlayerFromStateBagName(bagName)
        if player == 0 then return end
        createMpGamerTag(player)
        if _g.showGamerTag then
            displayMpGamerTag(player, true)
        end
    end)

    local players = GetActivePlayers()
    for i = 1, #players do
        local player = players[i]
        if not Config.ShowSelf and player == cache.playerId then return end
        createMpGamerTag(player)
        displayMpGamerTag(player, true)
    end

    AddEventHandler('onResourceStop', function(resourceName)
        if cache.resource == resourceName then
            local players = GetActivePlayers()
            for i = 1, #players do
                local player = players[i]
                RemoveMpGamerTag(player)
            end
        end
    end)
elseif Config.Draw.Mode == 'DrawText3D' then
    SetInterval(function()
        if _g.showGamerTag then
            local playerPos = GetEntityCoords(cache.ped)
            local players = GetActivePlayers()
            for i = 1, #players do
                local player = players[i]
                if not Config.ShowSelf and player == cache.playerId then return end

                local ped = GetPlayerPed(player)
                if #(playerPos - GetEntityCoords(ped)) < Config.Distance then
                    drawText3D(GetPedBoneCoords(ped, 0x322C, 0, 0, 0), formatName(player))
                end
            end
        end
    end)
end

-------------
-- 垃圾回收
-------------
SetInterval(function()
    collectgarbage('collect')
end, 60000)
