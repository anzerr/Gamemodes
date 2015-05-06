
usermessage.Hook("syc_table_sever_client", function( um )
	local a = um:ReadEntity()
	local b = string.Explode(" , ", um:ReadString())

	if a.ClientServerTable == nil then
		a.ClientServerTable = {}
	end
	
	if IsValid(a) then
		if tonumber( b[2] ) then
			a.ClientServerTable[b[1]] = tonumber( b[2] )
		else
			a.ClientServerTable[b[1]] = b[2]
		end
	else
		if tonumber( b[2] ) then
			print( " -- error on entity - number: "..b[1]..", "..tonumber( b[2] ) )
		else
			print( " -- error on entity - not number: "..b[1]..", "..b[2] )
		end
	end
end)

function GetServerTableValue( a, b )
	if IsValid(a) then
		if a.ClientServerTable == nil then
			a.ClientServerTable = {}
		end

		if a.ClientServerTable[b] != nil then
			return a.ClientServerTable[b]
		else
			return 0
		end
	end
end