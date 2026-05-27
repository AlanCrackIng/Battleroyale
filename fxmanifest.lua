fx_version("cerulean")
game("gta5")
description("Battleroyale script with an advanced, clean and optimized system. Designed for a fun experience for your players.")
authors("Alan")
version("1.0.0")
client_scripts({
	"server/**.lua"
})

server_script({
	"server/**.lua"
})

files({
	"shared/config.lua"
})

dependency({
	"ox_lib"
})