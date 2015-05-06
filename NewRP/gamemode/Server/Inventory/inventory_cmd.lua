
concommand.Add("rp_giveitem", function( ply, cmd, args )
	local item = args[ 1 ] or ""
	local Count = args[ 2 ] or 1
	
	if (Inventory.Item[item] != nil) then
		ply:GiveItem( item, Count )
	else
		ply:PrintMessage( 2, "Invalid item: '" .. item .. "'\nType 'rp_showitems' in console to see available items!" )
		return
	end
end)

concommand.Add("rp_showitems", function( ply, cmd, args )
	ply:PrintMessage(2, "====== Items ======")
	
	for item, _ in pairs( Inventory.Item ) do
		ply:PrintMessage( 2, item )
	end
	
	ply:PrintMessage(2, "====== Your Items ======")
	
	for item, count in pairs( ply.PlayerInventory ) do
		ply:PrintMessage( 2, item .. " [count = " .. count .. "]" )
	end
end)

concommand.Add("rp_item_use", function( ply, cmd, args )
	local itemTable = GetItemTable( args[ 1 ] )
	if (ply:HasItem( args[ 1 ], 1 )) then
		itemTable:UseItem( ply )
	end
end)

concommand.Add("rp_item_drop", function( ply, cmd, args )
	local item = args[ 1 ]
	local count = args[ 2 ] or 1
	
	if (Inventory.Item[item] != nil) then
		if (ply:HasItem( item, count )) then
			local itemTable = GetItemTable( item )
			
			itemTable:DropItem( ply, count )
			ply:EmitSound( "items/ammocrate_close.wav" )
		end
	end
end)