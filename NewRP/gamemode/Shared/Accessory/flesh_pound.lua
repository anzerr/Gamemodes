if (CLIENT) then
local ITEM = {}

ITEM.Name = "Flesh Pound"

function ITEM:InitEffect( emitter, ply )
	return a
end

function ITEM:InitProp( ply )
	local a = {}
	local bone = {}
		bone[1] = "ValveBiped.Bip01_Head1"
		bone[2] = "ValveBiped.Bip01_L_Hand"
		bone[3] = "ValveBiped.Bip01_R_Hand"
	local Offseta = {} -- pos
		Offseta[1] = Vector( 2, 0, 0 )
		Offseta[2] = Vector( 5, 0, 0 )
		Offseta[3] = Vector( 5, 0, 0 )
	local Offsetb = {} -- ang
		Offsetb[1] = Vector( 0, 0, 0 )
		Offsetb[2] = Vector( 0, 0, 0 )
		Offsetb[3] = Vector( 0, 0, 0 )
		
	for i = 1, 3 do
		a[i] = {}
		a[i] = ents.CreateClientProp( )
		a[i]:SetModel( "models/XQM/Rails/gumball_1.mdl" )
		a[i]:SetMaterial( "models/debug/debugwhite" )
		a[i]:SetRenderMode( 1 )
		a[i]:SetColor( Color( math.random(0,255), math.random(0,255), math.random(0,255), 255 ) )
		a[i]:SetModelScale( 0.5, 0 )
		a[i].Bone = bone[i]
		a[i].OffPos = Offseta[i]
		a[i].OffAng = Offsetb[i]
		a[i]:Spawn()
	end
	
	return a
end

function ITEM:ThinkEffect( a, ply )
	return a
end

function ITEM:ThinkProp( a, ply )
	for _, v in pairs( a ) do
		local pos_a = v.OffPos
		local ang_a = v.OffAng
		local BoneIndexBack = ply:LookupBone( v.Bone )
			
		if BoneIndexBack then
			local pos_b, ang_b = ply:GetBonePosition( BoneIndexBack )
			
			if ( pos_b and pos_b ~= v:GetPos() ) then
				v:SetPos( pos_b + ang_b:Forward()*pos_a.x + ang_b:Right()*pos_a.y + ang_b:Up()*pos_a.z )
					ang_b:RotateAroundAxis( ang_b:Up(), ang_a.x )
					ang_b:RotateAroundAxis( ang_b:Forward(), ang_a.y )
					ang_b:RotateAroundAxis( ang_b:Right(), ang_a.z )
				v:SetAngles( ang_b )
			end
		end
	end
	
	return a
end

RegisterAccessory("flesh_pound", ITEM)
end