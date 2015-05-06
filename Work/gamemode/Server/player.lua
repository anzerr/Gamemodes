local meta = FindMetaTable("Player")

function meta:RealisticDamage( )
	self:EmitSound( "vo/npc/male01/pain0"..math.random( 1, 9 )..".wav" )
end

function GM:CanPlayerSuicide( ply )
	ply:Kill()
	--return false	
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

		if ( ValidEntity( physicsObject ) ) then
			local position, angle = ply:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )

			physicsObject:SetPos( position )
			physicsObject:SetAngle( angle )
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
	
	if (ply.PlayerAccessory != "none") then
		local itemTable = Inventory.Items:GetItem( ply:GetNWInt( "AccessoryID" ) )
		
		if itemTable != nil then
			local BoneIndexBack = ply:LookupBone( "ValveBiped.Bip01_Head1" )
			local pos, ang = ply:GetBonePosition( BoneIndexBack )
			
			ply.EffectProp[EffectPropCount] = ents.Create( "prop_physics" )
			ply.EffectProp[EffectPropCount]:SetModel( itemTable.Model )
			ply.EffectProp[EffectPropCount]:SetPos( pos )
			ply.EffectProp[EffectPropCount]:SetAngles( Angle( 0, 0, 0 ) )
			ply.EffectProp[EffectPropCount]:Spawn()
			ply.EffectProp[EffectPropCount]:Activate()
			EffectPropCount = EffectPropCount+1
		end
	end
	
	ragdoll:SetSkin( ply:GetSkin() )
	ragdoll:SetColor( ply:GetColor() )
	ragdoll:SetMaterial( ply:GetMaterial() )

	if ( ply:IsOnFire() ) then ragdoll:Ignite(8, 0) ply:Extinguish() end

	if ( ply:InVehicle() and ValidEntity( ply:GetVehicle() ) ) then
		constraint.NoCollide( ragdoll, ply:GetVehicle(), true, true )
	end
	
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity( ragdoll )
	
	timer.Simple( 16, function()
		if ( ValidEntity( ragdoll ) ) then
			if ( ValidEntity( ply ) ) then
				if ply:Alive() then
					ply:UnSpectate()
				end
			end
			ragdoll:Remove()
		end
			
		for k, v in pairs( ply.EffectProp ) do
			if ValidEntity( v ) then
				v:Remove()
			end
		end
		hook.Remove( "Think", "ModelThinkPos" )
	end )
	
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )
	Victim.PlayerDeadTime = 0
	Victim.nextsecond = CurTime() + 1
end

	maxdeathtime = 15
function GM:PlayerDeathThink( ply )
     if ( CurTime() > ply.nextsecond ) then 
          if ( ply.PlayerDeadTime < maxdeathtime ) then
               ply.PlayerDeadTime = ply.PlayerDeadTime + 1
               ply.nextsecond = CurTime() + 1
			   ply:SycServerClientTable( "deathtime", ply.PlayerDeadTime, ply )
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

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	ply:CrosshairEnable()
	
	ply.PlayerIsKnockOut = 0
	ply.PlayerDrunk = 0
	ply.PlayerBreath = 0
	ply.PlayerStamina = 100
	ply.PlayerHunger = 100
	ply:SetColor( 255, 255, 255, 255 )
	
	if ply:IsOnFire() then
		ply:Extinguish()
	end	
end

function GM:PlayerLoadout( ply )
	if ply:IsKnockOut( ) then return end

	ply:Give("weapon_crossbow")
	ply:Give("weapon_crowbar")
	ply:Give("weapon_flare")
	ply:Give("weapon_rpg")
	ply:Give("weapon_minigun")
end

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
	
	if ValidEntity( ply ) then
		umsg.Start("night_cycle_effect", ply)
			umsg.String(0)
		umsg.End()
		ply:SetAccessory( "none" )
	else
		timer.Simple(3, function()
			ply:SetAccessory( "none" )
			umsg.Start("night_cycle_effect", ply)
				umsg.String(0)
			umsg.End()
		end)
	end
end
