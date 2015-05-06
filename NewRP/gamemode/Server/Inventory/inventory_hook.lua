
hook.Add("PlayerInitialSpawn", "init_Inventory_Load_Data", function( ply )
	ply.PlayerInventory = {}

	if (file.Exists( "inventory/" .. ply:UniqueID() .. ".txt" , "DATA" )) then
		local Data = util.JSONToTable( file.Read( "inventory/" .. ply:UniqueID() .. ".txt", "DATA" ) )
		
		ply.PlayerInventory = Data
	else
		ply:SaveInventory()
	end
end)

hook.Add("PlayerDisconnected", "Inventory_Save_Data", function( ply )
	ply:SaveInventory()
end)

hook.Add("ShutDown", "Inventory_Save_Data_Shutdown", function()
	for _, ply in ipairs( player.GetAll() ) do
		ply:SaveInventory()
	end
end)
