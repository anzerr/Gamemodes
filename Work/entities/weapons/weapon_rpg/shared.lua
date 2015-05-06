if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName 			= "RPG-7"
	SWEP.Slot				= 4
	SWEP.SlotPos 			= 4
	SWEP.IconLetter 		= "y"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	
end

SWEP.ViewModel				= "models/Weapons/v_RL7.mdl"
SWEP.WorldModel				= "models/Weapons/w_RPG7/w_rpg7.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "item_rebar"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
	
function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")

	self.LoadedCur = CurTime()
	self.DrawAnimation = 1
end

function SWEP:ViewModelDrawn( )
end

function SWEP:PrimaryAttack()	
	if (SERVER) then 
		if ( CurTime() > self.LoadedCur and self:Clip1() >= 1 ) then
			self.Owner:EmitSound("weapons/rpg/rpg.wav") 
			self.LoadedCur = CurTime()+0.1
			self:SetClip1( self:Clip1()-1 )
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			if (SERVER) then 
				self:Throw( 3000 )
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
			ent.Velocity = self.Owner:GetAimVector() * range
		ent:Spawn()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()	
	if (SERVER) then
		if (self:GetIronsights() != true and CurTime() > self.LoadedCur and self:Clip1() <= 0 ) then
			if self.Owner:HasItem( self.Primary.Ammo, self.Primary.ClipSize ) then
				self.Owner:EmitSound("weapons/rpg/rpg_reload.wav")  
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
		self.Owner:GetViewModel():SetPlaybackRate( 10 )
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		--self.Owner:GetViewModel( ):SetPlaybackRate( 1 )
	end
	self.DrawAnimation = 1
	self:SetIronsights( false )
	if (CLIENT) then
		self.Owner:EmitSound( "weapons/universal/iron_out.wav")
	end
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) then
		self:SetIronsights(true)
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self:SetIronsights(false)
 	end
end

function SWEP:GetViewModelPosition( pos, ang )
	if not(self.DrawAnimation <= 0) then self.DrawAnimation = math.max(self.DrawAnimation-(0.08*self.DrawAnimation), 0) end
	return self:SetIronSights( pos, ang, 0.15, Vector( 0, -5, -1*(90*self.DrawAnimation) ), Angle( -1*(120*self.DrawAnimation), (1*self.DrawAnimation), 0 ) )
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.IronSightsPos = Vector(0, -2, 3)
SWEP.IronSightsAng = Vector(0, -2, 0)
