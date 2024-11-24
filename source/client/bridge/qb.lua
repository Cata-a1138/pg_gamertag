if Config.Framework ~= 'qb' then return end

local QB = exports['qb-core']:GetCoreObject()
if not QB then print('^1无法加载QB框架') return end

-- 通知
if not Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error'

    ---@param data NotifyData
    function Notify(data)
        QB.Functions.Notify(data.title, data.type)
    end
end
