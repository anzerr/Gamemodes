
require("glon")

local meta = FindMetaTable("Player")

function meta:HasItem( item, count )
	if (self.PlayerInventoryTable[item] == nil) then
		return false
	end
	
	return self.PlayerInventoryTable[item] >= tonumber(count)
end

function meta:SpawnItem( item, count )
	if (Inventory.Items.Stored[item] != nil) then
		local tr = self:EyeTrace(80)
		
		local entItem = ents.Create("Inventory_item")
		entItem:SetPos(tr.HitPos + Vector( 0, 0, Inventory.Items.Stored[item].Vector ))
		entItem.Unique = item
		entItem.Amount = count
		entItem:Spawn()
	end
end

function meta:GiveItem( item, amount )
	local inventory = self.PlayerInventoryTable
	
	if (!inventory[item]) then
		inventory[item] = 0
		inventory[item] = inventory[item] + amount
	else
		inventory[item] = inventory[item] + amount
	end
	
	self:UpdateWeight()
	
	umsg.Start("inventory_give_item", self)
		umsg.String(item)
		umsg.Long(amount)
	umsg.End()
end

function meta:RemoveItem( item, amount )
	local inventory = self.PlayerInventoryTable
	
	if (inventory[item] != nil and inventory[item] >= 1) then
		inventory[item] = inventory[item] - amount
		
		umsg.Start("inventory_remove_item", self)
			umsg.String(item)
			umsg.Long(inventory[item])
		umsg.End()
	end

	if (inventory[item] == 0) then
		inventory[item] = nil
	end
end

function meta:SaveInventory()
	local Data = glon.encode(self.PlayerInventoryTable)
	file.Write( "inventory/" .. self:UniqueID() .. ".txt", Data )
end

function CombineItem( a, b )
	local c = ents.GetByIndex( math.max( a:EntIndex( ), b:EntIndex( ) ) )
	local d = ents.GetByIndex( math.min( a:EntIndex( ), b:EntIndex( ) ) )
	if ( c:GetClass() == "inventory_item" and d:GetClass() == "inventory_item" and c != a  ) then
		if ( c.Unique == d.Unique ) then
			c.Amount = c.Amount + d.Amount
			d:Remove()
			c:SetNWString("Item_Amount", c.Amount)
			if ( c.Amount >= 2 and c:GetModel() != c.itemTable.MultiModel ) then
				c:SetModel( c.itemTable.MultiModel )
			end
		end
	end
end