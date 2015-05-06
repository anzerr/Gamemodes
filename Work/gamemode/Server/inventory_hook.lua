
hook.Add("PlayerInitialSpawn", "init_Inventory_Load_Data", function( ply )
	ply.PlayerInventoryTable = {}
	
	if (file.Exists( "inventory/" .. ply:UniqueID() .. ".txt" )) then
		local Data = glon.decode(file.Read( "inventory/" .. ply:UniqueID() .. ".txt" ))
		
		ply.PlayerInventoryTable = Data
		
		timer.Simple(3, function()
			for k, v in pairs( ply.PlayerInventoryTable ) do
				umsg.Start("inventory_saved_items", ply)
					umsg.String(k)
					umsg.Long(v)
				umsg.End()
			end
		end, ply )
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

hook.Add("ShowSpare2", "Inventory_Menu", function( ply )
	ply:ConCommand("rp_inventory")
end)