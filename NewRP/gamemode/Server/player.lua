local meta = FindMetaTable("Player")

function meta:RealisticDamage( )
	self:EmitSound( "vo/npc/male01/pain0"..math.random( 1, 9 )..".wav" )
end

function GM:CanPlayerSuicide( ply )
	if ( ply:Alive( ) and not ply:InVehicle() and not ply:IsKnockOut( ) ) then
		ply:Kill()
	end
end

function GM:PlayerHurt( ply )
	self.BaseClass:PlayerHurt( ply )
	ply:RealisticDamage()
end

function GM:DoPlayerDeath( ply )

	ply.EffectProp = {}
		local EffectPropCount = 1

	local ragdoll = ents.Create("prop_ragdoll")
	
	local velocity = ply:GetVelocity()
	local model = ply:GetModel()

		ragdoll:SetPos( ply:GetPos() )
		ragdoll:SetAngles( ply:GetAngles() )
		ragdoll:SetModel( model )
		ragdoll:Spawn( )

	for i = 1, ragdoll:GetPhysicsObjectCount() do
		local physicsObject = ragdoll:GetPhysicsObjectNum(i)

		if ( IsValid( physicsObject ) ) then
			local position, angle = ply:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )

			physicsObject:SetPos( position )
			physicsObject:SetAngles( angle )
			physicsObject:AddVelocity( velocity )
		end
	end
	

	for k, v in pairs( ply:GetWeapons() ) do
		local class = v:GetClass()
		local weaponeffectmodel = string.gsub( v:GetModel(), "v_", "w_" )
		if util.IsValidModel( weaponeffectmodel ) then
			local BoneIndexBack = ply:LookupBone( "ValveBiped.Bip01_Spine4" )
			local pos, ang = ply:GetBonePosition( BoneIndexBack )
			
			ply.EffectProp[EffectPropCount] = ents.Create( "prop_physics" )
			ply.EffectProp[EffectPropCount]:SetModel( weaponeffectmodel )
			ply.EffectProp[EffectPropCount]:SetPos( pos )
			ply.EffectProp[EffectPropCount]:SetAngles( Angle( 0, 0, 0 ) )
			ply.EffectProp[EffectPropCount]:Spawn()
			ply.EffectProp[EffectPropCount]:Activate()
			EffectPropCount = EffectPropCount+1
		end
	end
	
	ragdoll:SetSkin( ply:GetSkin() )
	ragdoll:SetColor( Color( 255, 255, 255, 255 ) )
	ragdoll:SetMaterial( "" )

	if ( ply:IsOnFire() ) then ragdoll:Ignite(8, 0) ply:Extinguish() end

	if ( ply:InVehicle() and IsValid( ply:GetVehicle() ) ) then
		constraint.NoCollide( ragdoll, ply:GetVehicle(), true, true )
	end
	
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity( ragdoll )
	
	timer.Simple( 16, function()
		if ( IsValid( ragdoll ) ) then
			if ( IsValid( ply ) ) then
				if ply:Alive() then
					ply:UnSpectate()
				end
			end
			ragdoll:Remove()
		end
			
		if IsValid(ply.EffectProp) then
			for k, v in pairs( ply.EffectProp ) do
				if IsValid( v ) then
					v:Remove()
				end
			end
		end
		hook.Remove( "Think", "ModelThinkPos" )
	end )
	RemovePlayerAug( ply )
end

function GM:CanExitVehicle( vehicle, ply )
	return false
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )
	Victim.PlayerDeadTime = 0
	Victim.nextsecond = CurTime() + 1
	Victim.DeadSpawn = true
end

	maxdeathtime = 10
function GM:PlayerDeathThink( ply )
     if ( CurTime() > ply.nextsecond ) then 
          if ( ply.PlayerDeadTime < maxdeathtime ) then
               ply.PlayerDeadTime = ply.PlayerDeadTime + 1
               ply.nextsecond = CurTime() + 1
          else          
               ply.PlayerDeadTime = nil
               ply.nextsecond = nil
               ply:Spawn()       
          end
    end
end

function GM:GetFallDamage( ply, fspeed )
	if ( ply:Health() - ( fspeed / 15 ) <= 0 ) then 
		ply:Kill()
	else
		ply:SetHealth( ply:Health() - ( fspeed / 15 ) ) 
		ply:KnockOut( 4 )
	end
end

local function SpawnPod( pos, ply )
	ply.SpawnPod = {}
	
	local tr = {}
	tr.start = pos + Vector( 0, 0, 200 )
	tr.endpos = tr.start + Vector( 0, 0, 100000 )
	tr.filter = self, ply
	tr = util.TraceLine(tr)
	
	local entItem = ents.Create("Spawn_pod")
	entItem:SetPos( tr.HitPos+Vector( 0, 0, -200 ) )
	entItem:SetAngles( Angle( 90, 0, 0) )
	entItem.Owner = ply
	entItem.RandomRotX = math.random( -1000, 1000 )
	entItem.RandomRotZ = math.random( -1000, 1000 )
	entItem.RandomRotY = math.random( -1000, 1000 )
	entItem:Spawn()
	
	ply.SpawnPod = entItem
end

	PlayerStatsList = {}
	util.AddNetworkString( "SendPlayerStats" )
function RandomPlayerStats( ply )
	if ( ply.PlayerStatsList == nil ) then
		ply.PlayerStatsList = {}
	end
	
	ply.PlayerStatsList["Player"] = ply
	
	ply.PlayerStatsList["Gender"] = math.random( 1, 2 )
		
	Player_RandomPlayerModel( ply, ply.PlayerStatsList["Gender"] )
	
	ply.PlayerStatsList["Height"] = math.random( 152, 210 )*math.min( ply.PlayerStatsList["Gender"]*0.93, 1 )
		ply:SetModelScale( ply.PlayerStatsList["Height"]/182, 0 )
	
	ply.PlayerStatsList["Foot_Size"] = math.random( 11, 15 )*(ply.PlayerStatsList["Height"]/100)
	
	ply.PlayerStatsList["Weight"] = 45 + math.random( 2, 8 )*((ply.PlayerStatsList["Height"]-141.36)/2.5)

	ply.PlayerStatsList["Fat"] = math.random( 25/(ply.PlayerStatsList["Height"]/ply.PlayerStatsList["Weight"]), 60/(ply.PlayerStatsList["Height"]/ply.PlayerStatsList["Weight"]) )

	ply.PlayerStatsList["Strength"] = (ply.PlayerStatsList["Weight"]-((ply.PlayerStatsList["Weight"]/100)*ply.PlayerStatsList["Fat"]))*math.min( 1, ply.PlayerStatsList["Gender"]*0.75 )

	if ( math.random( 1, 1000 ) == 1 ) then
		ply.PlayerStatsList["IQ"] = -5
	else
		ply.PlayerStatsList["IQ"] = math.random( 50, 140 )
	end
		
	local a = 1/255
    ply:SetPlayerColor( Vector( math.random(0,255)*a, math.random(0,255)*a, math.random(0,255)*a ) )
	
	net.Start( "SendPlayerStats" )
		net.WriteTable( ply.PlayerStatsList )
	net.Send( player.GetAll() )
end

	util.AddNetworkString( "SendPlayerLimbandAug" )
function SetPlayerAug( ply, a )
	local b = {}

	b["Player"] = ply
	b[1] = a[1]
	b[2] = a[1]
	net.Start( "SendPlayerLimbandAug" )
		net.WriteTable( b )
	net.Send( player.GetAll() )
end
	util.AddNetworkString( "SendPlayerDeath" )
function RemovePlayerAug( ply )
	local b = {}

	b["Player"] = ply
	
	net.Start( "SendPlayerDeath" )
		net.WriteTable( b )
	net.Send( player.GetAll() )
end

	util.AddNetworkString( "SendBlood" )
concommand.Add("rp_bone", function( ply, cmd, args )
	local a = {}
		a[ply] = 50
	net.Start( "SendBlood" )
		net.WriteTable( a )
	net.Send( player.GetAll() )
end)

concommand.Add("rp_force", function( ply, cmd, args )
	for _, v in pairs(player.GetAll()) do
		RandomPlayerStats( v )
	end
end)

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	ply:CrosshairEnable()
	ply:SetRenderMode( 1 )
	ply:SetColor( Color( 0, 0, 0, 0 ) )
	ply:SetMaterial("effect/Alpha")
	ply:SetModel( "models/Player/Group01/Female_02.mdl" )

	if ( ply.DeadSpawn ) then
		--timer.Simple(3, function() RandomPlayerStats( ply ) end)
		local random = math.random(1,4)
		local c = {}
			if random == 1 then
				c[1] = { "L_Hand", "R_Hand", "L_Calf", "R_Calf" }
			elseif random == 2 then
				c[1] = { "L_Thigh", "R_Thigh", "L_UpperArm" }
			elseif random == 3 then
				c[1] = { "L_UpperArm", "R_UpperArm" }
			elseif random == 4 then
				c[1] = { "L_Calf", "R_Calf", "L_Forearm", "R_Forearm" }
			end
		timer.Simple(3, function() SetPlayerAug( ply, c ) end)
		SpawnPod( Vector( -260, -177, -12223 ), ply )
		ply.DeadSpawn = false
	end
	
	if ply:IsOnFire() then
		ply:Extinguish()
	end	
end

function GM:PlayerLoadout( ply )
	if ply:IsKnockOut( ) then return end
end

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
	ply.DeadSpawn = true
end
