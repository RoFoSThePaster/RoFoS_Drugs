shared_script '@FiveEye/FiveEye.lua'

-- Generated automaticly by RB Generator.
fx_version('cerulean')
games({ 'gta5' })
lua54 'yes'

shared_script('config.lua');

server_scripts({

    'server/*.lua'

});

client_scripts({

    'lib/pmenu.lua',
    'client/*.lua'

});