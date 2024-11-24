--[[ FX Information ]]--
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--
author 'Cata_a <3478600437@qq.com>'
version '0.0.2'
description '玩家标签'

--[[ Manifest ]]--
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'source/shared/functions.lua',
}

client_scripts {
    'source/client/client.lua',
    'source/client/functions.lua',
    'source/client/bridge/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'source/server/server.lua',
    'source/server/functions.lua',
    'source/server/bridge/*.lua',
}

files {
    'locales/*.json',
}
