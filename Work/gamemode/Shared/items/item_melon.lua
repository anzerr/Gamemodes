local ITEM = {}

ITEM.Name = "Melon"
ITEM.Info = "Default something!"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Vector = 5
ITEM.Weight = 1

function ITEM:DropItem( ply, Amount )
	local Count = Amount or 1
	ply:SpawnItem("item_melon", Count)
	ply:RemoveItem("item_melon", Count)
	ply:UpdateWeight()
end

function ITEM:UseItem( ply, EntID )
	local ent = ents.GetByIndex( tonumber( EntID ) )
	
	if ( ply.PlayerHunger + 30 < 100 ) then
		ply.PlayerHunger = math.min( ply.PlayerHunger + 30, 100 )
		ply:SycServerClientTable( "hunger", ply.PlayerHunger, ply )
		ent:Remove()
	end
end

Inventory.Items:RegisterItem("item_melon", ITEM)