
function Inventory.Items:RegisterItem( itemUnique, itemTable )
	self.Stored[itemUnique] = itemTable
	self.Stored[itemUnique].Name = itemTable.Name or ""
	self.Stored[itemUnique].Info = itemTable.Info or ""
	self.Stored[itemUnique].Model = itemTable.Model or ""
	self.Stored[itemUnique].MultiModel = itemTable.MultiModel or self.Stored[itemUnique].Model
	self.Stored[itemUnique].Skin = itemTable.Skin or 0
	self.Stored[itemUnique].Vector = itemTable.Vector or 0
	self.Stored[itemUnique].Weight = itemTable.Weight or 0
	self.Stored[itemUnique].AccessoryVector = itemTable.AccessoryVector or 0
	self.Stored[itemUnique].IsAccessory = itemTable.IsAccessory or 0
	self.Stored[itemUnique].useAble = itemTable.useAble or 1
	self.Stored[itemUnique].dropAble = itemTable.dropAble or 1
	
	if (SERVER) then
		self.Stored[itemUnique].UseItem = itemTable.UseItem or function( ply ) end
		self.Stored[itemUnique].DropItem = itemTable.DropItem or function( ply ) end
	end
	
	print("Registered item '" .. itemTable.Name .. "'.")
end

function Inventory.Items:GetItem( item )
	if (self.Stored[item] != nil) then
		return self.Stored[item]
	end
end

local meta = FindMetaTable("Player")

function meta:SharedHasItem( item, count )
	if (CLIENT) then
		return ClientHasItem( item, count )
	else
		return self:HasItem( item, count )
	end
end

for k, v in pairs( file.FindInLua("work/gamemode/Shared/Items/*.lua") ) do
	print( "(LD) Shared/Items/" .. v ) 
	include("work/gamemode/Shared/Items/" .. v)
	
	if (SERVER) then
		print( "(DL) Shared/Items/" .. v ) 
		AddCSLuaFile("work/gamemode/Shared/Items/" .. v)
	end
end