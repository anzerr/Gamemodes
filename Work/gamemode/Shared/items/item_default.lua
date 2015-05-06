local ITEM = {}

ITEM.Name = "Default"
ITEM.Info = "Default something!"
ITEM.Model = "models/mine/bananaseeds/bananaseeds.mdl"
ITEM.Vector = 5
ITEM.Weight = 1

function ITEM:DropItem( ply, Amount )
	local Count = Amount or 1
	ply:SpawnItem("item_default", Count)
	ply:RemoveItem("item_default", Count)
	ply:UpdateWeight()
end

function ITEM:UseItem( ply, EntID )
	local ent = ents.GetByIndex( tonumber( EntID ) )
	for k, v in pairs( ents.FindInSphere(ent:GetPos(), 100) ) do
		if v:GetClass() == "farm_plant" then
			v.PlantID = "melon"
			ent:Remove()
		end
	end
end

Inventory.Items:RegisterItem("item_default", ITEM)