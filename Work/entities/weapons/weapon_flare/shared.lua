if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName 			= "Flare"
	SWEP.Slot				= 3
	SWEP.SlotPos 			= 3
	SWEP.IconLetter 		= "y"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
end

SWEP.Category				= "farm"	
SWEP.Author 				= "Thoron174"
SWEP.Instructions 			= "fucking shot shit"
SWEP.Contact 				= ""
SWEP.Purpose 				= ""

SWEP.ViewModel				= "models/weapons/v_flaregun.mdl"
SWEP.WorldModel				= "models/weapons/W_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if (!SERVER) then return end
	self:SetWeaponHoldType("pistol")			
end

function SWEP:Throw( range )
	if (!SERVER) then return end
	local flare = ents.Create ( "farm_flare" )
		flare:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
		flare:SetAngles( self.Owner:EyeAngles() ) 
		flare:SetMaterial( "models/debug/debugwhite" )
		flare:SetColor(200, 0, 0, 255)	
		flare:SetOwner( self.Owner )
		flare:Spawn()
	flare:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector():GetNormalized() * range )
end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound("weapons/flaregun/fire.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	if (SERVER) then 
		self:Throw( 5000 )
		self.Owner:ViewPunch( Angle( math.random( -15, -5 ), 0, 0 ) )
		--self.Owner:StripWeapon("weapon_rp_flare")
	end	
end

function SWEP:Reload()
	return
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetIronsights( false )
	return true
end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) then
		self:SetIronsights(true)
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self:SetIronsights(false)
	if CLIENT then return end
 	end
end

local IRONSIGHT_TIME = 0.15

function SWEP:GetViewModelPosition(pos, ang)
	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.IronSightsPos = Vector (-5.8612, -10.7335, 2.3633)
SWEP.IronSightsAng = Vector (1.909, 0.0825, 0)
