fx_version "cerulean"
description "Shitty fuel script"
author "esegovic#1337"
version '1.0.0'

lua54 'yes'

game "gta5"

shared_scripts {
  'config.lua',
  '@ox_lib/init.lua',
  '@es_extended/imports.lua'
}

client_scripts {
  'data/stations.lua',
  'client/utils.lua',
  'client/client.lua'
}

server_script 'server/*.lua'


ui_page 'web/build/index.html'


files {
  'locales/*.json',
  'web/build/index.html',
  'web/build/**/*'
}

dependencies {
  'ox_lib'
}