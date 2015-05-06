
-- fix this so it's a table and not a net work int ( they are so shit and work shitly with client server syc )
	-- no need for a client side of this
local pmeta = FindMetaTable("Player")

function pmeta:IsKnockOut( )
	if (self.PlayerIsKnockOut == 1) then 
		return true 
	end
end

function pmeta:KnockOut( Time )

	self.Weapons = {}
	self.EffectProp = {}
		local EffectPropCount = 1
		
	for k, v in pairs( self.EffectProp ) do
		if ValidEntity( v ) then
			v:Remove()
		end
	end
		
	local ragdoll = ents.Create("prop_ragdoll")

	local velocity = self:GetVelocity()
	local model = self:GetModel()

		ragdoll:SetPos( self:GetPos() )
		ragdoll:SetAngles( self:GetAngles() )
		ragdoll:SetModel( model )
		ragdoll:Spawn( )
	
	for i = 1, ragdoll:GetPhysicsObjectCount() do
		local physicsObject = ragdoll:GetPhysicsObjectNum(i)

		if ( ValidEntity( physicsObject ) ) then
			local position, angle = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )

			physicsObject:SetPos( position )
			physicsObject:SetAngle( angle )
			physicsObject:AddVelocity( velocity )
		end
	end
		
	if ( self:Alive() ) then
		for k, v in pairs( self:GetWeapons() ) do
			local class = v:GetClass()
			table.insert( self.Weapons, {class, true} )
			
			local weaponeffectmodel = string.gsub( v:GetModel(), "v_", "w_" )
			if util.IsValidModel( weaponeffectmodel ) then
				local BoneIndexBack = self:LookupBone( "ValveBiped.Bip01_Spine4" )
				local pos, ang = self:GetBonePosition( BoneIndexBack )
				
				self.EffectProp[EffectPropCount] = ents.Create( "prop_physics" )
				self.EffectProp[EffectPropCount]:SetModel( weaponeffectmodel )
				self.EffectProp[EffectPropCount]:SetPos( pos )
				self.EffectProp[EffectPropCount]:SetAngles( Angle( 0, 0, 0 ) )
				self.EffectProp[EffectPropCount]:Spawn()
				self.EffectProp[EffectPropCount]:Activate()
				EffectPropCount = EffectPropCount+1
			end
		end
	end
	
	if (self.PlayerAccessory != "none") then
		local itemTable = Inventory.Items:GetItem( self.PlayerAccessory )
		
		if itemTable != nil then
			local BoneIndexBack = self:LookupBone( "ValveBiped.Bip01_Head1" )
			local pos, ang = self:GetBonePosition( BoneIndexBack )
			
			self.EffectProp[EffectPropCount] = ents.Create( "prop_physics" )
			self.EffectProp[EffectPropCount]:SetModel( itemTable.Model )
			self.EffectProp[EffectPropCount]:SetPos( pos )
			self.EffectProp[EffectPropCount]:SetAngles( Angle( 0, 0, 0 ) )
			self.EffectProp[EffectPropCount]:Spawn()
			self.EffectProp[EffectPropCount]:Activate()
			EffectPropCount = EffectPropCount+1
		end
	end

	self:StripWeapons( )
	self.PlayerIsKnockOut = 1
	Global_SycServerClientTable( "knockout", self.PlayerIsKnockOut, self )

	ragdoll:SetSkin( self:GetSkin() )
	ragdoll:SetColor( self:GetColor() )
	ragdoll:SetMaterial( self:GetMaterial() )

	if ( self:IsOnFire() ) then ragdoll:Ignite(8, 0) end

	self:GetTable().Stamina = self.PlayerStamina
	self:GetTable().Health = self:Health() 
	self:GetTable().Hunger = self.PlayerHunger
	
	if ( self:InVehicle() and ValidEntity( self:GetVehicle() ) ) then
		constraint.NoCollide( ragdoll, self:GetVehicle(), true, true )
	end

	self:Flashlight( false )
	self:Spectate( OBS_MODE_CHASE )
	self:SpectateEntity( ragdoll )
	self:CrosshairDisable()
	
	timer.Simple( Time, function()
		local angle = self:EyeAngles()
		
		--self:Spawn()
		self:UnSpectate()
		self:CrosshairEnable()
		self:Spawn()
		self:SetEyeAngles( Angle(angle.p, angle.y, 0) )
		self:SetPos( ragdoll:GetPos() + Vector( 0, 0, 40 ) )
		
		self.PlayerIsKnockOut = 0
		Global_SycServerClientTable( "knockout", self.PlayerIsKnockOut, self )
		
		if ( ValidEntity( ragdoll ) ) then
			ragdoll:Remove()
		end
		
		self.PlayerStamina = self:GetTable().Stamina
		self.PlayerHunger = self:GetTable().Hunger
		self:SetHealth( self:GetTable().Health )
			
		for k, v in pairs( self.EffectProp ) do
			if ValidEntity( v ) then
				v:Remove()
			end
		end
		
		for k, v in pairs( self.Weapons ) do
			self:Give( v[1] )
		end
	end )
	
end
