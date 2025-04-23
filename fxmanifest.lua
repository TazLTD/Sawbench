fx_version 'cerulean'
game 'gta5'

author 'TazLTD'
description 'Sawbench script for QBCore with ox_target & ox_inventory support'
version '1.1.0'

dependencies {
    'qb-core',
    'ox_target',
    'ox_lib',
    'ox_inventory'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
