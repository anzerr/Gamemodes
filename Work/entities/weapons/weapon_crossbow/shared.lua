if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName 			= "Crossbow"
	SWEP.Slot				= 2
	SWEP.SlotPos 			= 2
	SWEP.IconLetter 		= "y"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	
end

SWEP.ViewModel				= "models/Weapons/v_crossbow.mdl"
SWEP.WorldModel				= "models/Weapons/w_crossbow.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "item_rebar"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
	
function SWEP:Initialize()
	self:SetWeaponHoldType("crossbow")
		
	if (CLIENT) then
		self.swepScopeTexutre = surface.GetTextureID( "hud/scopetexure" )
		local prop = {}
			prop[31] = { model = "models/crossbow_bolt.mdl", skin = "Models/Weapons/rebar/rebar", scale = Vector(1.04, 1.04, 1.04), angle = Angle( 0, 0, 0 ), pos = Vector(-0.01, -12.7, 0.1) }

		self:InitPropOnWeapon( prop )
		
		--self.ViewBoneScale = {}
		--	self.ViewBoneScale[31] = Vector(0.009, 0.009, 0.009)
		
		--self:SetBoneScale( )
		self.Zoom = 7
	end
	
	self.LoadedCur = CurTime()
	self.DrawAnimation = 1
	self.BoltHeatCur = CurTime()
	self.BoltHeat = 0
end

function SWEP:ViewModelDrawn( )
	self:UpdateAllProp( )
	--self:UpdateBoneScale( )
	local a = 255*(GetServerTableValue( self, "weaponboltheat" )/100)
	self:SetColorOnWeapon( 31, {255, 255, 255, 255-a} )
	self:AddZoomedScope( 24, Vector(-4.53, -12.3, 0), 2.7, self.Zoom )
end

function SWEP:PrimaryAttack()	
	if (SERVER) then 
		if ( CurTime() > self.LoadedCur and self:Clip1() >= 1 ) then
			self.Owner:EmitSound("weapons/crossbow/fire1.wav") 
			self.LoadedCur = CurTime()+0.1
			self:SetClip1( self:Clip1()-1 )
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			if (SERVER) then 
				self:Throw( 1000 )
				self.Owner:ViewPunch( Angle( math.random( -15, -5 ), 0, 0 ) )
			end	
		end	
	end
end

function SWEP:Throw( range )
	if (SERVER) then
		local eyeang = self.Owner:GetAimVector():Angle()
		local right = eyeang:Right()
		local up = eyeang:Up()  
		
		local ent = ents.Create( "farm_crossbow" )
			ent:SetOwner(self.Owner)
			ent:SetPos( self.Owner:GetShootPos()+right*2-up*2 )
			ent:SetAngles( self.Owner:GetAngles() )
			ent:SetPhysicsAttacker(self.Owner)		
			ent.Heat = self.BoltHeat
			ent.BoltOwner = self.Owner
			ent.Speed = 20000
		ent:Spawn()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()	
	if (SERVER) then
		if (self:GetIronsights() != true and CurTime() > self.LoadedCur and self:Clip1() <= 0 ) then
			if self.Owner:HasItem( self.Primary.Ammo, self.Primary.ClipSize ) then
				self.Owner:EmitSound("weapons/crossbow/reload1.wav") 
				timer.Simple( 0.75, function() self.Owner:EmitSound("weapons/crossbow/bolt_load"..math.random( 1, 2 )..".wav") end)
				self.LoadedCur = CurTime()+1.7
				self.BoltHeatCur = CurTime()+5+1.7
				self:SetClip1( self.Owner:WeaponReload( self.Primary.Ammo, self.Primary.ClipSize ) )
				self.BoltHeat = 0
				self.Owner:SycServerClientTable( "weaponboltheat", self.BoltHeat, self )
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
				self.Owner:RemoveItem( self.Primary.Ammo, self.Owner:WeaponReload( self.Primary.Ammo, self.Primary.ClipSize ) )
			end
		end
	end
end

function SWEP:Deploy()
	if (self:Clip1() <= 0) then
		self.Weapon:SendWeaponAnim( ACT_VM_FIDGET )
	end
	self.DrawAnimation = 1
	self:SetIronsights( false )
	if (CLIENT) then
		self.Owner:EmitSound( "weapons/universal/iron_out.wav")
	end
end

function SWEP:Holster()
	if (SERVER) then
		self.BoltHeat = 0
		self.Owner:SycServerClientTable( "weaponboltheat", self.BoltHeat, self )
	end
	if (self:GetIronsights() != true) then
		--self.Owner:EmitSound( "weapons/universal/iron_in.wav")
		return true
	else
		return false
	end
end

function SWEP:Think()
	if (SERVER) then
		if ( CurTime() > self.BoltHeatCur and self:Clip1() >= 1 ) then
			self.BoltHeatCur = CurTime()+0.2
			self.BoltHeat = math.min(self.BoltHeat+4, 100)
			self.Owner:SycServerClientTable( "weaponboltheat", self.BoltHeat, self )
		end
	end
	
	if (CLIENT) then
		if ( CurTime() > self.BoltHeatCur and self:Clip1() >= 1 ) then
			self.BoltHeatCur = CurTime()+0.2
			local heat = GetServerTableValue( self, "weaponboltheat" )
			if ( heat >= 100 ) then
				self:CrossBow_FullHeat( 31, Vector(-1, -1*math.random(0, 20), 0), "crossbow_sparks" )
			end
		end
	end
	
	if (CLIENT) then
		if (self:GetIronsights() == true) then
			if self.Owner:KeyDown( IN_RELOAD ) then
				self.Zoom = math.min(self.Zoom+0.1, 25)
			elseif self.Owner:KeyDown( IN_USE ) then
				self.Zoom = math.max(self.Zoom-0.1, 1)
			end
		end
	end
	
	if self.Owner:KeyPressed(IN_ATTACK2) then
		self:SetIronsights(true)
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self:SetIronsights(false)
 	end
end

function SWEP:AdjustMouseSensitivity( ) 
	if (self:GetIronsights() == true) then
		return self.Zoom/20
	else
		return 1
	end
end

function SWEP:GetViewModelPosition( pos, ang )
	if not(self.DrawAnimation <= 0) then self.DrawAnimation = math.max(self.DrawAnimation-(0.08*self.DrawAnimation), 0) end
	return self:SetIronSights( pos, ang, 0.15, Vector( 0, -5, (10*self.DrawAnimation) ), Angle( -1*(60*self.DrawAnimation), (1*self.DrawAnimation), 0 ) )
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.IronSightsPos = Vector(-7, -7.5, 3)
SWEP.IronSightsAng = Vector(0, -2, 0)
