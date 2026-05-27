fx_version("cerulean")
game("gta5")
description("Battleroyale script with an advanced, clean and optimized system. Designed for a fun experience for your players.")
authors("Alan")
version("1.0.0")

shared_scripts({
    "@ox_lib/init.lua",
})

client_scripts({
	"client/**.lua"
})

server_script({
	"server/**.lua"
})

files({
	"shared/*.lua"
})

dependency({
	"ox_lib"
})