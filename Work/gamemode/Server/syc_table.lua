
function Global_SycServerClientTable( a, b, c )
	for _, v in pairs(player.GetAll()) do
		v:SycServerClientTable( a, b, c )
	end
end	

local playerMeta = FindMetaTable( "Player" )

function playerMeta:SycServerClientTable( a, b, c )
	if IsValid(c) then
		umsg.Start("syc_table_sever_client", self)	
			umsg.Entity( c )
			umsg.String( a.." , "..b )
		umsg.End()
	end
end	
