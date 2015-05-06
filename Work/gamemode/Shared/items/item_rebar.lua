local ITEM = {}

ITEM.Name = "Steel Rebar"
ITEM.Info = "ammo"
ITEM.Model = "models/crossbow_bolt.mdl"
ITEM.MultiModel = "models/Items/CrossbowRounds.mdl"
ITEM.Skin = "Models/Weapons/rebar/rebar"
ITEM.Vector = 5
ITEM.Weight = 0.05
ITEM.useAble = 0

function ITEM:DropItem( ply, Amount )
	local Count = Amount or 1
	ply:SpawnItem("item_rebar", Count)
	ply:RemoveItem("item_rebar", Count)
	ply:UpdateWeight()
end

function ITEM:UseItem( ply, EntID )
end

Inventory.Items:RegisterItem("item_rebar", ITEM)