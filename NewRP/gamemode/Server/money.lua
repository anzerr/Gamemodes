local Table_money = {}
local Table_fakemoney = {}
	
local pmeta = FindMetaTable("Player")

function pmeta:CanAfford( a )
	local b = Table_money[self]
	if ( math.floor(a) < 0 or b - math.floor(a) < 0 ) then 
		return false
	else
		return true
	end
end

local function Init( ply )
	if ply.Table_fakemoney == nil then
		ply.Table_fakemoney = {}
	end
	
	if Table_money[ply] == nil then
		Table_money[ply] = 0
	end
end

local function spawn( ply, a, b )
	local ent = ents.Create( "Credit_chip" )
	ent:SetPos( ply:EyeTrace( 100 ).HitPos )
	ent.amount = a
	ent.table = b
	ent:Spawn()
	ent:Activate()
end

local function Sort( a )
	MsgN("*")
	print( table.concat( a, " " ) )
	--	for b, c in pairs( a ) do
	--		local add = 0
	--		while table.HasValue( a, c+add ) do
	--			add = add+1
	--		end
	--		a[b] = c+add
	--	end
		
	local e = {}
	local f = {}
	local count = 1
	for i = 1, table.Count(a) do
		for b, c in pairs( a ) do
			if (e[count] == nil or c < e[count]) then
				local add = 0
				while table.HasValue( e, c+add ) do
					add = add+1
				end
				e[count] = c+add
				f[count] = b
			end	
			if table.Count(a) <= b then
				table.remove( a, f[count] )
				count = count+1
			end
		end
	end
	
	MsgN("+")
	print( table.concat( a, " " ) )
	MsgN("-")
	print( table.concat( e, " " ) )
	return e
end

function pmeta:AddMoney( a, b )
	Init( self )
	
	Table_money[self] = Table_money[self] + a
	
	for k, v in pairs( b ) do
		b[k] = v+(Table_money[self]-a)
	end
		table.Add( self.Table_fakemoney, b )
		self.Table_fakemoney = Sort( self.Table_fakemoney )

	MsgN("fake = " .. table.Count( self.Table_fakemoney ) )
	MsgN("money = " .. Table_money[self] )
end

function pmeta:DropMoney( a )
	Init( self )
	
	if self:CanAfford( a ) then
		local b = {}
		local c = {}
		local count = 0
			Table_money[self] = Table_money[self] - a
			
		for k, v in pairs( self.Table_fakemoney ) do
			if ( v > Table_money[self] ) then
				count = count + 1
				b[count] = v-(Table_money[self])
				c[k] = v
			end
		end
	
		count = 0
		for k, v in pairs( c ) do
			MsgN( k.." remove now " .. v )
			table.remove( self.Table_fakemoney, k-count )
			count = count+1
		end
		
		self.Table_fakemoney = Sort( self.Table_fakemoney )
		spawn( self, a, b )
		MsgN("fake = " .. table.Count( self.Table_fakemoney ) )
		MsgN("money = " .. Table_money[self] )
	end
end

concommand.Add("rp_money", function( ply, cmd, args )
	for k, v in pairs( ply.Table_fakemoney ) do
		MsgN( k .." " .. v )
	end
	MsgN( "money = " .. Table_money[ply] )
end)

concommand.Add("rp_dropmoney", function( ply, cmd, args )
	local a = args[1] or 0
	ply:DropMoney( a )
end)

concommand.Add("rp_addmoney", function( ply, cmd, args )
	local a = math.random(10,100)
	local b = {}
	local count = 1
		for i = 1, a do
			if (math.random(1,10) == 1) then
				count = count+1
				b[count] = i
			end
		end

	ply:AddMoney( a, b )
end)