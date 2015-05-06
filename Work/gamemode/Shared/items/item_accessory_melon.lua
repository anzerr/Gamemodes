local ITEM = {}

ITEM.Name = "Hollowed out melon"
ITEM.Info = "Default something!"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.IsAccessory = 1
ITEM.AccessoryVector = 5
ITEM.Vector = 5
ITEM.Weight = 0

function ITEM:DropItem( ply, Amount )
	local Count = Amount or 1
	ply:SpawnItem("item_accessory_melon", Count)
	ply:RemoveItem("item_accessory_melon", Count)
	ply:UpdateWeight()
end

function ITEM:UseItem( ply, EntID )
	ply:SetAccessory( "item_accessory_melon" )
end

Inventory.Items:RegisterItem("item_accessory_melon", ITEM)