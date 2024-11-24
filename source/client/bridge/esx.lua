if Config.Framework ~= 'esx' then return end

local export, ESX = pcall(function()
    return exports.es_extended:getSharedObject()
end)
if not export then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    if not ESX then print('^1无法加载ESX框架') return end
end

-- 通知
if not Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error'

    ---@param data NotifyData
    function Notify(data)
        ESX.ShowNotification(data.title, data.type)
    end
end

local JOBS
if not Config.IsNewESX then
    RegisterNetEvent('pg_gamertag:sendJobs', function(data)
        JOBS = data
    end)
end

function GetPlayerJobAndGradeLabel(playerState)
    local playerJob = playerState.job
    if Config.IsNewESX then
        return playerJob.label, playerJob.grade_label
    else
        while not JOBS do Wait(0) end
        local job = JOBS[playerJob.name]
        return job.label, job.grades[playerJob.grade]
    end
end
