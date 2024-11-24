Config = {
    -- 框架 (auto, esx, qb)
    Framework = 'auto',

    -- 新版 ESX (1.9.2 及以上)
    IsNewESX = lib.checkDependency('es_extended', '1.9.2'),

    -- 使用ox_lib通知
    UseOxLibNotify = false,

    -- 显示距离
    Distance = 20,

    -- 显示自己
    ShowSelf = true,

    -- https://github.com/tabarra/txAdmin/blob/8cbc767aa24e614fe2dc801810cb3ea58df282fd/shared/cleanPlayerName.ts
    ClearName = false,

    --[[
        玩家姓名模板
        支持替换的参数:
        * {name}: 玩家框架注册姓名
        * {job}: 职业名称
        * {grade}: 职位名称
        * {serverId}: 服务器ID
    ]]
    NameTemplate = '[{serverId}] {name}\n{job} - {grade}',

    -- 替换规则 (使用 string.gsub 进行替换, 参考下方示例及 https://atom-l.github.io/lua5.4-manual-zh/6.4.html#string.gsub)
    SubstituteRule = {
        { '警察', '👮警察' },
    },

    -- 按键
    Key = {
        --[[ 
            模式:
            * Disable: 禁用按键, 名称标签将默认一直显示
            * Toggle: 按下按键或使用命令切换名称标签显示/隐藏
            * OnlyShowOnPress: 仅按下按键时显示名称标签, 会占用更多资源
        ]]
        Mode = 'Toggle',

        -- 按键ID https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/
        Toggle = { Command = 'gamertag', Mapper = 'KEYBOARD', Parameter = 'O' },

        -- 键值 https://docs.fivem.net/docs/game-references/controls/#controls
        OnlyShowOnPress = 19,
    },

    Draw = {
        -- 绘制方式 (MpGamerTag, DrawText3D)
        Mode = 'DrawText3D',

        MpGamerTag = {
            --[[
                玩家在同一辆载具内名称标签处理方式
                * true: 合并, 游戏默认行为, 过长名称会造成标签重叠
                * false: 不合并, 独立显示在每个玩家的头部上方
            ]]
            UseVehicleBehavior = false,

            Components = {
                { Id = 0, Color = 0, Alpha = 255 }, -- GAMER_NAME
                { Id = 3, Color = 0, Alpha = 255 }, -- BIG_TEXT
                { Id = 4, Color = 0, Alpha = 255 }, -- AUDIO_ICON
                { Id = 16, Color = 0, Alpha = 255 }, -- MP_TYPING
            },
        },

        DrawText3D = {
            -- 字体
            Font = 1,
            -- 大小
            Size = 0.35,
            -- 随距离改变大小
            ScaleWithDistance = false,
            -- 颜色
            Color = { r = 255, g = 255, b = 255, a = 255 },
        },
    },
}
