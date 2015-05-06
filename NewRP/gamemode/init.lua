
print( "LOADING FILES" ) 

--CLIENT
AddCSLuaFile( "Shared.lua" ) --Download
AddCSLuaFile( "cl_init.lua" ) --Download
	for k, v in pairs( file.Find( "NewRP/gamemode/Shared/*", "LUA" ) ) do
		print( "(DL) Shared/" .. v ) 
		AddCSLuaFile( "Shared/" .. v ) --Download
	end
	for k, v in pairs( file.Find( "NewRP/gamemode/Client/*", "LUA" ) ) do
		print( "(DL) Client/" .. v ) 
		AddCSLuaFile( "Client/" .. v ) --Download
	end
	
--SERVER
include( "Shared.lua" ) --Load
	for k, v in pairs( file.Find( "NewRP/gamemode/Server/*", "LUA" ) ) do 
		print( "(LD) Server/" .. v ) 
		include( "Server/" .. v ) --Load
	end
	for k, v in pairs( file.Find( "NewRP/gamemode/Shared/*", "LUA" ) ) do
		print( "(LD) Shared/" .. v ) 
		include( "Shared/" .. v ) --Load
	end
