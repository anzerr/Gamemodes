
local meta = FindMetaTable("Player")

function meta:HasItem( item, count )
	if (self.PlayerInventory[item] == nil) then
		return false
	end
	
	return self.PlayerInventory[item] >= tonumber(count)
end

function meta:GiveItem( item, amount )
	local inventory = self.PlayerInventory
	
	if (inventory[item] == nil) then
		inventory[item] = 0
		inventory[item] = inventory[item] + amount
	else
		inventory[item] = inventory[item] + amount
	end
end

function meta:RemoveItem( item, amount )
	local inventory = self.PlayerInventory
	
	if (inventory[item] != nil and inventory[item] >= 1) then
		inventory[item] = inventory[item] - amount
	end

	if (inventory[item] == 0) then
		inventory[item] = nil
	end
end

function meta:SaveInventory()
	local Data = util.TableToJSON( self.PlayerInventory )
	file.Write( "inventory/" .. self:UniqueID() .. ".txt", "DATA" )
end
