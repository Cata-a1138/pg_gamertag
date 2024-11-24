if Config.Framework ~= 'esx' then return end

local export, ESX = pcall(function()
    return exports.es_extended:getSharedObject()
end)
if not export then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    if not ESX then print('^1无法加载ESX框架') return end
end

---通知
if not Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error' | 'inform'

    ---@param source number
    ---@param data NotifyData
    function Notify(source, data)
        if data.type == 'inform' then data.type = 'info' end
        TriggerClientEvent('esx:showNotification', source, data.title, data.type)
    end
end

if not Config.IsNewESX then
    ---获取所有职业
    ---@return table
    local function getJobs()
        if ESX.GetJobs then
            return ESX.GetJobs()
        end
        return ESX.Jobs
    end

    -- 等待职业获取
    local jobs
    repeat
        jobs = getJobs()
        Wait(1000)
    until next(jobs)

    -- 精简职业数据
    local jobsLite = {}
    for k, v in pairs(jobs) do
        local gradesLite = {}
        for i, j in pairs(v.grades) do
            gradesLite[tonumber(i)] = j.label
        end
        jobsLite[k] = { label = v.label, grades = gradesLite }
    end

    ---设置玩家状态包
    ---@param source number 玩家ServerId
    local function setPlayerStateBag(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        local job = xPlayer.getJob()
        local playerState = Player(source).state

        playerState:set('name', xPlayer.getName(), true)
        playerState:set('job', { name = job.name, grade = job.grade }, true)
    end

    RegisterNetEvent('esx:playerLoaded', function()
        local _source = source
        setPlayerStateBag(_source)
        TriggerLatentClientEvent('pg_gamertag:sendJobs', _source, 1024000, jobsLite)
    end)

    local players = GetPlayers()
    for i = 1, #players do
        local player = tonumber(players[i])
        setPlayerStateBag(player)
        TriggerLatentClientEvent('pg_gamertag:sendJobs', player, 1024000, jobsLite)
    end
end
