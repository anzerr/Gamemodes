local ITEM = {}

ITEM["name"] = "item"
ITEM["count"] = 10

function ITEM:UseItem( ply )
	MsgN("called use")
end

function ITEM:DropItem( ply, count )
	MsgN(count*2)
end

RegisterItem("item", ITEM)