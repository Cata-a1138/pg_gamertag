---ox_lib通知
if Config.UseOxLibNotify then
    ---@class NotifyData
    ---@field title string
    ---@field type 'success' | 'error'

    ---@param data NotifyData
    function Notify(data)
        lib.notify(data)
    end
end
