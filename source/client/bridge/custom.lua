if Config.Framework ~= 'custom' then return end

-- 通知
if not Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error'

    ---@param data NotifyData
    function Notify(data)
        
    end
end
