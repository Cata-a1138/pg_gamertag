local function isResourceStartedOrStarting(resource)
    local state = GetResourceState(resource)
    return state == 'started' or state == 'starting'
end

-- 自动检测框架
if Config.Framework == 'auto' then
    if isResourceStartedOrStarting('es_extended') then
        Config.Framework = 'esx'
    elseif isResourceStartedOrStarting('qb-core') then
        Config.Framework = 'qb'
    else
        print('^1无法加载框架')
    end
end

-- 自动检测医疗插件
if Config.AmbulanceScript == 'auto' then
    if isResourceStartedOrStarting('visn_are') then
        Config.AmbulanceScript = 'visn_are'
    elseif isResourceStartedOrStarting('wasabi_ambulance') then
        Config.AmbulanceScript = 'wasabi_ambulance'
    elseif isResourceStartedOrStarting('esx_ambulancejob') then
        Config.AmbulanceScript = 'esx_ambulancejob'
    elseif isResourceStartedOrStarting('qb-ambulancejob') then
        Config.AmbulanceScript = 'qb-ambulancejob'
    else
        Config.AmbulanceScript = 'custom'
    end
end
