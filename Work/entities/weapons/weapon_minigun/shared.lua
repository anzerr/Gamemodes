if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName 			= "Minigun"
	SWEP.Slot				= 1
	SWEP.SlotPos 			= 1
	SWEP.IconLetter 		= "y"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
 
end

SWEP.ViewModel				= "models/weapons/v_minigun.mdl"
SWEP.WorldModel				= "models/weapons/w_minigun.mdl"

SWEP.Primary.ClipSize		= 200
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "item_rebar"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
	
function SWEP:Initialize()
	self:SetWeaponHoldType("shotgun")

	if (CLIENT) then
		self.texture1 = surface.GetTextureID( "hud/hudgrid" )
	end
	
	self.loopingSound = {}
	self.DrawAnimation = 1
	self.LoadedCur = CurTime()
	self.OverHeat = 0
	self.OverHeatCur = CurTime()
	self.OverHeatHolsterCur = CurTime()
end

function SWEP:ViewModelDrawn( )
	self:AddAmmoCount( 37, Vector(0, 3.2, -14.2), Angle( 43, -25, 32.5 ), 30, self:Clip1(), self.OverHeat )
end

function SWEP:PrimaryAttack()		
	if ( CurTime() > self.LoadedCur and self:Clip1() >= 1 and self.OverHeat < 100 ) then
		self.LoadedCur = CurTime()+0.1
		self.OverHeat = self.OverHeat+1
		self.OverHeatCur = CurTime()+2
		if ( self.OverHeat == 100 ) then
			self.LoadedCur = CurTime()+4
			self.OverHeatCur = CurTime()+4
			
			if ( self.loopingSound[1] == nil ) then
				self.loopingSound[1] = CreateSound( self.Owner, "npc/attack_helicopter/aheli_crash_alert2.wav" )
			end
			self.loopingSound[1]:Play()
			self.loopingSound[1]:FadeOut( 4 )
				
			if ( self.loopingSound[2] == nil ) then
				self.loopingSound[2] = CreateSound( self.Owner, "ambient/gas/steam2.wav" )
			end
			self.loopingSound[2]:Play()
			self.loopingSound[2]:FadeOut( 4 )
		end
		if (SERVER) then self.Owner:EmitSound("weapons/minigun/mini-1.wav") end
		self:SetClip1( self:Clip1()-1 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		local bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0.05, 0.05, 0.05)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 10+(self.OverHeat*0.1)
		self.Owner:FireBullets(bullet)
	end	
end

function SWEP:Reload()
	if (CurTime() > self.LoadedCur and self:Clip1() < self.Primary.ClipSize ) then
		if self.Owner:SharedHasItem( self.Primary.Ammo, 1 ) then
			self.LoadedCur = CurTime()+3.5
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			if (SERVER) then
				self.Owner:EmitSound( "weapons/ar2/ar2_reload.wav" )
				local a = self.Primary.ClipSize-self:Clip1()
				self:SetClip1( self:Clip1()+self.Owner:WeaponReload( self.Primary.Ammo, a ) )
				self.Owner:RemoveItem( self.Primary.Ammo, self.Owner:WeaponReload( self.Primary.Ammo, a ) )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	--for i=0, self:GetBoneCount() - 1 do
	--	print( i .. " " ..self:GetBoneName(i));
	--end
end

function SWEP:Deploy()
	self.DrawAnimation = 1
	self:SetIronsights( false )

	if ( self.OverHeat >= 1 ) then
		local a = math.max( self.OverHeatCur-CurTime(), 0 )
		local b = math.max( (CurTime()-a)-self.OverHeatHolsterCur, 0 )
		self.OverHeat = math.max(self.OverHeat - math.floor(b*10), 0)
		print( self.OverHeat )
	end
	
	if (CLIENT) then
		self.Owner:EmitSound( "weapons/universal/iron_out.wav")
	end
end

function SWEP:Holster()
	--self.Owner:EmitSound( "weapons/universal/iron_in.wav")
	self.OverHeatHolsterCur = CurTime()+0.1
	return true
end

function SWEP:Think()
	if ( CurTime() > self.OverHeatCur and self.OverHeat >= 1 ) then
		self.OverHeatCur = CurTime()+0.1
		self.OverHeat = self.OverHeat-1
	end

	if self.Owner:KeyPressed(IN_ATTACK2) then
		self:SetIronsights(true)
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self:SetIronsights(false)
 	end
end

function SWEP:GetViewModelPosition( pos, ang )
	if not(self.DrawAnimation <= 0) then self.DrawAnimation = math.max(self.DrawAnimation-(0.04*self.DrawAnimation), 0) end
	return self:SetIronSights( pos, ang, 0.15, Vector( 0, -5, (10*self.DrawAnimation) ), Angle( -1*(120*self.DrawAnimation), (1*self.DrawAnimation), 0 ) )
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.IronSightsPos = Vector(0, -7.5, 0) -- -7.5
SWEP.IronSightsAng = Vector(0, 0, 0)

