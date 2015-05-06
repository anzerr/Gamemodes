
concommand.Add("rp_spawnitem", function( ply, cmd, args )
	--if (table.HasValue( Inventory.allowSpawning, ply:SteamID() ) or ply:IsAdmin()) then
		local item = args[ 1 ] or ""
		local Count = args[ 2 ] or 1
		
		if (Inventory.Items.Stored[item] != nil) then
			ply:SpawnItem( item, Count )
		else
			ply:PrintMessage( 2, "Invalid item: '" .. item .. "'\nType 'rp_showitems' in console to see available items!" )
			return
		end
	--end
end)

concommand.Add("rp_giveitem", function( ply, cmd, args )
	--if (table.HasValue( Inventory.allowSpawning, ply:SteamID() ) or ply:IsAdmin()) then
		local item = args[ 1 ] or ""
		local Count = args[ 2 ] or 1
		
		if (Inventory.Items.Stored[item] != nil) then
			ply:GiveItem( item, Count )
		else
			ply:PrintMessage( 2, "Invalid item: '" .. item .. "'\nType 'rp_showitems' in console to see available items!" )
			return
		end
	--end
end)

concommand.Add("rp_showitems", function( ply, cmd, args )
	if (table.HasValue( Inventory.allowSpawning, ply:SteamID() ) or ply:IsAdmin()) then
		ply:PrintMessage(2, "====== Items ======")
		
		for item, _ in pairs( Inventory.Items.Stored ) do
			ply:PrintMessage( 2, item )
		end
	end
end)

concommand.Add("rp_item_use", function( ply, cmd, args )
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) )
	
	if (item != nil and item:IsValid( ) and item:GetClass( ) == "inventory_item") then
		if (item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
			local itemTable = Inventory.Items:GetItem( item.Unique )
			itemTable:UseItem( ply, args[ 1 ] )
		end
	end
end)

concommand.Add("rp_item_use_accessory", function( ply, cmd, args )
	local itemTable = Inventory.Items:GetItem( args[ 1 ] )
	if (itemTable.IsAccessory == 1) then
		if (ply:HasItem( args[ 1 ], 1 )) then
			itemTable:UseItem( ply, nil )
		end
	end
end)

concommand.Add("rp_item_pickup", function( ply, cmd, args )
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) )
	
	if (item != nil and item:IsValid( ) and item:GetClass( ) == "inventory_item") then
		if (item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
			local itemTable = Inventory.Items:GetItem( item.Unique )
			if ply:CanHold( itemTable.Weight*item.Amount ) then
				ply:GiveItem( item.Unique, item.Amount )
				ply:UpdateWeight()
				item:Remove()
			else
				local a = ply:CanMaxHold( itemTable.Weight )
				if a != false then
					ply:GiveItem( item.Unique, a )
					item.Amount = item.Amount-a
					item:SetNWString("Item_Amount", item.Amount)
				end
			end
		end
	end
end)

concommand.Add("rp_item_drop", function( ply, cmd, args )
	local item = args[ 1 ]
	local count = args[ 2 ] or 1
	
	if (Inventory.Items.Stored[item] != nil) then
		if (ply:HasItem( item, count )) then
			local itemTable = Inventory.Items:GetItem( item )
			
			itemTable:DropItem( ply, count )
			ply:EmitSound( "items/ammocrate_close.wav" )
		end
	end
end)