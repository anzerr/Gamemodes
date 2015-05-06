
Inventory = {}

--Client Side Loading files
include( "Shared.lua" )
	for k, v in pairs( file.Find( "Work/gamemode/Shared/*", "LUA" ) ) do
		print( "(LD) Client/" .. v ) 
		include( "Shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "Work/gamemode/Client/*", "LUA" ) ) do
		print( "(LD) Client/" .. v ) 
		include( "Client/" .. v )
	end