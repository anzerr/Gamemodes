
local pmeta = FindMetaTable("Player")

function pmeta:WeaponReload( a, b )
	if (self.PlayerInventoryTable[a] == nil) then
		return 0
	end
	
	return math.min(self.PlayerInventoryTable[a], b)
end	
