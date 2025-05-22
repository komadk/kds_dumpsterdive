fx_version 'cerulean'
game 'gta5'

author 'KD-Scripts'
description 'Dumpster Dive script by KD-Scripts'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}

lua54 'yes' 
