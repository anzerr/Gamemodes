local ITEM = {}

ITEM.Name = "Garden pot"
ITEM.Info = "Default something!"
ITEM.Model = "models/props_junk/terracotta01.mdl"
ITEM.IsAccessory = 1
ITEM.AccessoryVector = 10
ITEM.Vector = 0
ITEM.Weight = 0

function ITEM:DropItem( ply, Amount )
	local Count = Amount or 1
	ply:SpawnItem("item_accessory_pot", Count)
	ply:RemoveItem("item_accessory_pot", Count)
	ply:UpdateWeight()
end

function ITEM:UseItem( ply, EntID )
	ply:SetAccessory( "item_accessory_pot" )
end

Inventory.Items:RegisterItem("item_accessory_pot", ITEM)