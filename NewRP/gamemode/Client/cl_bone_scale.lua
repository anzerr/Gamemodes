
function Client_BoneManipulate( ent, bone, scale, pos, ang )
	if ( !bone ) then return false end
	
	if tonumber( bone ) then
		ent:ManipulateBoneScale( bone, scale )
		ent:ManipulateBonePosition( bone, pos )
		ent:ManipulateBoneAngles( bone, ang )
	else
		local a = {}
			a[1] = bone
		if ( string.find( bone, "_L_" ) != nil ) then
			a[2] = string.Replace( bone, "_L_", "_R_" )
		elseif ( string.find( bone, "_R_" ) != nil ) then
			a[2] = string.Replace( bone, "_R_", "_L_" )
		end
		
		for b, c in pairs(a) do
			local BoneIndexBack = ent:LookupBone( c )
			ent:ManipulateBoneScale( BoneIndexBack, scale )
			ent:ManipulateBonePosition( BoneIndexBack, pos )
			ent:ManipulateBoneAngles( BoneIndexBack, ang )
		end
	end
end

	--[[
function RandomPlayerStats( ply )
	if ( ply.PlayerStatsList == nil ) then
		ply.PlayerStatsList = {}
	end
	

	ply.PlayerStatsList["Weight"] = 45 + math.random( 2, 8 )*((ply.PlayerStatsList["Height"]-152)/2.5)

	ply.PlayerStatsList["Fat"] = math.random( 25/(ply.PlayerStatsList["Height"]/ply.PlayerStatsList["Weight"]), 60/(ply.PlayerStatsList["Height"]/ply.PlayerStatsList["Weight"]) )

	ply.PlayerStatsList["Strength"] = (ply.PlayerStatsList["Weight"]-((ply.PlayerStatsList["Weight"]/100)*ply.PlayerStatsList["Fat"]))*(ply.PlayerStatsList["Gender"]*0.75)

end]]

function Client_Modlel_ScaleFootSize( ply, c )
	local a = (c-15.51)*(100/(31.5-15.51))
	local b = (a-50)/180
	Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Toe0", Vector(1+b, 1+b, 1+b), Vector(a/40, (a/40)*-1, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Foot", Vector(1+b, 1+b, 1+b), Vector(0, 0, 0), Angle(0, 0, 0) )
end

function Client_Modlel_ScaleIQ( ply, c )
	local a = (c-50)*(100/(140-50))
	local b = (a-50)/100
	Client_BoneManipulate( ply, "ValveBiped.Bip01_Head1", Vector(1+(b*0.5), 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
end

function Client_Modlel_ScaleStrength( ply, c )
	local a = (c-32)*(100/(183-32))
	local b = math.max( 0, (a-10))/100
	if ( ply.Client_PlayerStatsList["Gender"] == 2 ) then
		Client_BoneManipulate( ply, "ValveBiped.Bip01_R_Shoulder", Vector(1+(b*1), 1+(b*1), 1+(b*1)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_UpperArm", Vector(1, 1, 1), Vector(b*3, b*2, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, 64, Vector(1, 1+(b*1), 1+(b*1)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, 63, Vector(1, 1+(b*1), 1+(b*1)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_Spine2", Vector(1, 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Clavicle", Vector(1+(b*2), 1+(b*2), 1), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Forearm", Vector(1, 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
	else
		Client_BoneManipulate( ply, "ValveBiped.Bip01_Spine2", Vector(1, 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Clavicle", Vector(1+(b*0.5), 1+(b*0.5), 1), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_R_Shoulder", Vector(1+(b*1), 1+(b*1), 1+(b*1)), Vector(0, 0, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_UpperArm", Vector(1, 1+(b*1), 1+(b*1)), Vector(b*2, b*1, 0), Angle(0, 0, 0) )
		Client_BoneManipulate( ply, "ValveBiped.Bip01_L_Forearm", Vector(1, 1+(b*0.25), 1+(b*0.25)), Vector(0, 0, 0), Angle(0, 0, 0) )
	end
end

function Client_Modlel_ScaleFat( ply, c )
	local a = (c-8)*(100/(75-8))
	local b = math.max( -5, (a-5))/100
	Client_BoneManipulate( ply, "ValveBiped.Bip01_R_Thigh", Vector(1, 1+(b*1), 1+(b*1)), Vector(0, 0, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_R_Calf", Vector(1, 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_Pelvis", Vector(1+(b*0.75), 1+(b*0.75), 1+(b*0.75)), Vector(0, 0, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_Spine1", Vector(1+(b*0.5), 1+(b*0.5), 1+(b*0.5)), Vector(0, 0, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_Spine2", Vector(1, 1, 1), Vector(0, 0, 0), Angle(0, 0, 0) )
	Client_BoneManipulate( ply, "ValveBiped.Bip01_Spine4", Vector(1, 1, 1), Vector(0, 0, 0), Angle(0, 0, 0) )
end	
	
local function Stuff( ply )
	for i = 0, 500 do
		Client_BoneManipulate( ply, i, Vector(1, 1, 1), Vector(0, 0, 0), Angle(0, 0, 0) )
	end

	Client_Modlel_ScaleFootSize( ply, ply.Client_PlayerStatsList["Foot_Size"] )
	Client_Modlel_ScaleIQ( ply, ply.Client_PlayerStatsList["IQ"] )
	Client_Modlel_ScaleStrength( ply, ply.Client_PlayerStatsList["Strength"] )
	Client_Modlel_ScaleFat( ply, ply.Client_PlayerStatsList["Fat"] )
end
	
	Client_PlayerStatsList = {}
net.Receive( "SendPlayerStats", function(len)    
    MsgN("Test2: Contains "..len.." bits") 

    local a = net.ReadTable()
	local ent = a["Player"]
	
	if ent.Client_PlayerStatsList == nil then
		ent.Client_PlayerStatsList = {}
	end

	ent.Client_PlayerStatsList = table.Copy(a)
	Stuff( ent )
end)

