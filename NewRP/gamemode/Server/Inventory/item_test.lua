
local new = LoadItem( "item" )
	new["name"] = "cat"
	new.UseItem = function( ply ) MsgN("change function :D") end
RegisterItem("cat", new)

local new = LoadItem( "item" )
	new["name"] = "dog"
	new.UseItem = function( ply ) MsgN("this is a dog lets hope cat does not become dog") end
RegisterItem("dog", new)