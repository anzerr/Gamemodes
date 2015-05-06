
Inventory = {}

for k, v in pairs( file.Find( "NewRP/gamemode/Server/Inventory/*", "lsv" ) ) do
	print( "(LD) Server/Inventory/" .. v ) 
	include("NewRP/gamemode/Server/Inventory/" .. v)
end
