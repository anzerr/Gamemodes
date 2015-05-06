if (CLIENT) then
local ITEM = {}

ITEM.Name = "bee hive"

function ITEM:InitEffect( emitter, ply )
	local a = {}

	local BoneIndexBack = ply:LookupBone( "ValveBiped.Bip01_Head1" )
		if ( ply.effecttable == nil ) then
			ply.effecttable = {}
		end
		
	if BoneIndexBack then
		local pos, ang = ply:GetBonePosition( BoneIndexBack )
	
		for i = 1, 100 do
			a[i] = emitter:Add( "effect/Bee", pos )
			a[i]:SetDieTime( 10 )
			a[i]:SetStartAlpha( 255 )
			a[i]:SetEndAlpha( 255 )
			a[i]:SetStartSize( 3 )
			a[i]:SetEndSize( 3 )
			a[i]:SetPos( pos + Vector( math.random(-20, 20), math.random(-20, 20), 10+math.random(-20, 20) ) )
			ply.effecttable[i] = CurTime()+0.1
		end
		
		return a
	end
end

function ITEM:InitProp( ply )
	local a = {}

	a[1] = ents.CreateClientProp( )
	a[1]:SetModel( "models/XQM/Rails/gumball_1.mdl" )
	a[1]:SetMaterial( "models/debug/debugwhite" )
	a[1]:SetRenderMode( 1 )
	a[1]:SetColor( Color( math.random(0,255), math.random(0,255), math.random(0,255), 255 ) )
	a[1]:SetModelScale( 0.5, 0 )
	a[1]:Spawn()
	
	return a
end

function ITEM:ThinkEffect( a, ply )
	local BoneIndexBack = ply:LookupBone( "ValveBiped.Bip01_Head1" )
			
	if BoneIndexBack then
		local pos, ang = ply:GetBonePosition( BoneIndexBack )
	
		for i = 1, 100 do
			if ( ply.effecttable[i] < CurTime() ) then
				ply.effecttable[i] = CurTime()+(math.random(1, 10)/10)
					a[i]:SetDieTime( a[i]:GetDieTime()+1 )
				
				local random = Vector( 10+math.random(-10, 10), math.random(-10, 10), math.random(-10, 10) )
				local newpos = ((random+pos)-a[i]:GetPos()):GetNormalized()
				local distance = pos:Distance( a[i]:GetPos() )*(math.random(10, 15)/10)
				a[i]:SetVelocity( newpos*distance )
			end
		end
	end
	
	return a
end

function ITEM:ThinkProp( a, ply )
	for _, v in pairs( a ) do
		local pos_a = Vector( 2, 0, 0 )
		local ang_a = Vector( 0, 0, 0 )
		local BoneIndexBack = ply:LookupBone( "ValveBiped.Bip01_Head1" )
			
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

RegisterAccessory("bee_hive", ITEM)
end