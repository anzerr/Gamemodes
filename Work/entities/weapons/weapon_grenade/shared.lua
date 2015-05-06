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

SWEP.ViewModel            	= "models/Weapons/v_Grenade.mdl"
SWEP.WorldModel            	= "models/Weapons/w_Grenade.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
	
function SWEP:Initialize()
	self:SetWeaponHoldType("crossbow")
		
	if(CLIENT)then
		local prop = {}
			prop[43] = { model = "models/props_junk/garbage_coffeemug001a.mdl", skin = nil, scale = Vector(0.8, 0.8, 0.8), angle = Angle( 0, 0, 90 ), pos = Vector(-0.8, -8.5, 0) }

		self:InitPropOnWeapon( prop )
	
		self.ViewBoneScale = {}
			self.ViewBoneScale[43] = Vector(0.009, 0.009, 0.009)
		
		self:SetBoneScale( )
    end
end

function SWEP:ViewModelDrawn( )
	self:UpdateAllProp( )
	self:UpdateBoneScale( )
end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )

	if (SERVER) then 
		self.Owner:ViewPunch( Angle( math.random( -15, -5 ), 0, 0 ) )
	end	
end

function SWEP:SecondaryAttack()
	for i=0, self.Owner:GetViewModel():GetBoneCount() - 1 do
		print( i .. " " .. self.Owner:GetViewModel():GetBoneName(i))
	end
end

function SWEP:Reload()
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:Think()
end
