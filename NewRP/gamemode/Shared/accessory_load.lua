Accessory = {}

function RegisterAccessory( itemUnique, itemTable )
	Accessory[itemUnique] = itemTable
	Accessory[itemUnique].Name = itemTable.Name or ""

	Accessory[itemUnique].InitEffect = itemTable.InitEffect or function( ply ) end

	print("Client Add '" .. itemTable.Name .. "' to Accessory .")
end

function GetAccessory( item )
	if (Accessory[item] != nil) then
		return Accessory[item]
	end
end

for k, v in pairs( file.Find( "NewRP/gamemode/Shared/Accessory/*", "lsv" ) ) do
	if (SERVER) then
		print( "(DL) Shared/Accessory/" .. v ) 
		AddCSLuaFile("NewRP/gamemode/Shared/Accessory/" .. v)
	end
	
	print( "(LD) Shared/Accessory/" .. v ) 
	include("NewRP/gamemode/Shared/Accessory/" .. v)
end
