local ITEM = {}

ITEM["name"] = "hat"
ITEM["count"] = 20

function ITEM:UseItem( ply )
	MsgN("called use hat")
end

function ITEM:DropItem( ply, count )
	MsgN(count)
end

RegisterItem("hat", ITEM)