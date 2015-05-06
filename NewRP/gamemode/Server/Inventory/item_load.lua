Inventory.Item = {}

function RegisterItem( itemUnique, itemTable )
	Inventory.Item[itemUnique] = itemTable
	Inventory.Item[itemUnique]["name"] = itemTable["name"] or ""
	Inventory.Item[itemUnique]["count"] = itemTable["count"] or 0
	print("Client Add '" .. itemTable["name"] .. "' to Items .")
end

function GetItemTable( item )
	if (Inventory.Item[item] != nil) then
		return Inventory.Item[item]
	else
		return false
	end
end

function LoadItem( item )
	local a = GetItemTable( item )
	local new = {}
	for c, d in pairs( a ) do
		new[c] = d
	end
	
	return new
end

for k, v in pairs( file.Find( "NewRP/gamemode/Server/Inventory/Item/*", "lsv" ) ) do
	print( "(LD) Server/Inventory/Item/" .. v ) 
	include("NewRP/gamemode/Server/Inventory/Item/" .. v)
end
