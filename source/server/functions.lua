-- ox_lib通知
if Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error'

    ---@param source number
    ---@param data NotifyData
    function Notify(source, data)
        TriggerClientEvent('ox_lib:notify', source, data)
    end
end

---处理作弊玩家
---@param source number
---@param reason string
function HandleCheatPlayer(source, reason)
    DropPlayer(source, reason)
end

