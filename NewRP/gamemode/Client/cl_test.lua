
local AugTable = {}

local BoneTable = {}

	BoneTable[1] = {}
		BoneTable[1]["L_Thigh"] = {22}
		BoneTable[1]["L_Calf"] = {19,20,21}
		BoneTable[1]["L_UpperArm"] = {60,68,265}
		BoneTable[1]["L_Forearm"] = {10,11,12,57,59,266}
		BoneTable[1]["L_Hand"] = {30,31,32,33,34,35,36,37,38,39,40}
		
		BoneTable[1]["R_Thigh"] = {18}
		BoneTable[1]["R_Calf"] = {23,24,25}
		BoneTable[1]["R_UpperArm"] = {63,71,270,14}
		BoneTable[1]["R_Forearm"] = {15,16,58,67,271}
		BoneTable[1]["R_Hand"] = {44,45,46,47,48,49,50,51,52,53,54}
		
	BoneTable[2] = {}
		BoneTable[2]["L_Thigh"] = {5}	
		BoneTable[2]["L_Calf"] = {2,3,4}	
		BoneTable[2]["L_UpperArm"] = {17}	
		BoneTable[2]["L_Forearm"] = {18}
		BoneTable[2]["L_Hand"] = {19,20,21,22,23,24,25,26,27,28,29}
		
		BoneTable[2]["R_Thigh"] = {1}
		BoneTable[2]["R_Calf"] = {6,7,8}
		BoneTable[2]["R_UpperArm"] = {31}
		BoneTable[2]["R_Forearm"] = {32}
		BoneTable[2]["R_Hand"] = {33,34,35,36,37,38,39,40,41,42,43}
		
local function CreateAug( a, b, c, d )
	if ( AugTable[a] == nil ) then
		AugTable[a] = {}
	end

	if ( AugTable[a][b] == nil ) then
		MsgN( "add client model" )
		AugTable[a][b] = ents.CreateClientProp( )
		AugTable[a][b]:SetModel( c )--ply:GetModel() )
		AugTable[a][b]:SetMaterial( d )
		AugTable[a][b]:SetParent( a )
		AugTable[a][b]:Spawn()

		timer.Simple( 0.1, function() 
			AugTable[a][b]:SetPos( a:GetPos() ) 
			AugTable[a][b]:AddEffects( EF_BONEMERGE ) 
		end )
	else
		MsgN( "can't add client model" )
	end
end

local function BoneData( a )
	local b = {"R", "L"}

	for k, v in pairs(b) do
		if table.KeyFromValue(a, tostring(v.."_Thigh"))then
			if not(table.KeyFromValue(a, tostring(v.."_Calf")))then
				table.insert( a, tostring(v.."_Calf") )
			end
		end
		
		if table.KeyFromValue(a, tostring(v.."_UpperArm"))then
			if not(table.KeyFromValue(a, tostring(v.."_Forearm")))then
				table.insert( a, tostring(v.."_Forearm") )
			end
			if not(table.KeyFromValue(a, tostring(v.."_Hand")))then
				table.insert( a, tostring(v.."_Hand") )
			end
		end
		
		if table.KeyFromValue(a, tostring(v.."_Forearm"))then
			if not(table.KeyFromValue(a, tostring(v.."_Hand")))then
				table.insert( a, tostring(v.."_Hand") )
			end
		end
	end
	
	return a
end

local function GetBone( a, b )
	local c = {}
		a = BoneData( a )
	
	for k, v in pairs(a) do
		MsgN( v )
		if BoneTable[b][v] != nil then
			table.Add(c,BoneTable[b][v])
		end
	end

	for k, v in pairs(c) do
		MsgN( v )
	end
		
	return c
end

local function SetAug( a, b )
	for count = 1, 2 do
		local bone = GetBone( b[count], count )
		local vector = {}
			vector[1] = Vector(1,1,1)
			vector[2] = Vector(0,0,0)
			if count == 2 then 
				vector[1] = Vector(0,0,0)
				vector[2] = Vector(1,1,1)
			end
		
			for i = 0, 300 do
				AugTable[a][count]:ManipulateBoneScale( i, vector[1] )
			end
			
		for k, v in pairs(bone) do
			MsgN( v )
			AugTable[a][count]:ManipulateBoneScale( v, vector[2] )
		end
	end
end

local function RemoveAug( a )	
	AugTable[a][1]:Remove()
	AugTable[a][1] = nil
	AugTable[a][2]:Remove()
	AugTable[a][2] = nil
end

local function InitAug( a )			
	CreateAug( a, 1, "models/Humans/Group01/Female_01.mdl", "" )
	CreateAug( a, 2, "models/t600/slow.mdl", "" )
end

net.Receive( "SendPlayerDeath", function(len)    
    MsgN("Test2: Contains "..len.." bits") 

    local a = net.ReadTable()
	local ply = a["Player"]

	RemoveAug( ply )
	
	timer.Simple( 0.1, function()
		local ragdoll = nil
		for k, v in pairs( ents.FindInSphere(ply:GetPos(),128) ) do
			if (v:GetClass() == "prop_ragdoll" ) then
				ragdoll = v
			end
			MsgN(k)
			MsgN(v)
		end	
		
		if ( ragdoll != nil ) then
			MsgN("good")
			local barney = ents.CreateClientProp( )
				barney:SetModel( "models/t600/slow.mdl" )
				barney:SetPos( ragdoll:GetPos() )
				barney:SetParent( ragdoll )
				barney:AddEffects( EF_BONEMERGE ) 
			barney:Spawn( )
		end
	end)
end)

net.Receive( "SendPlayerLimbandAug", function(len)    
    MsgN("Test2: Contains "..len.." bits") 

    local a = net.ReadTable()
	local ply = a["Player"]

	local table = {}
	table[1] = a[1]
	table[2] = a[2]
	
	for k, v in pairs(a) do
		MsgN(v)
	end
	
	InitAug( ply )
	SetAug( ply, table )
end)

concommand.Add("rp_stuff1", function( ply, cmd, args )

end)
