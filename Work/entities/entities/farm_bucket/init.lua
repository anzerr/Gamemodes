AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/MetalBucket01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles( Angle(0, 0, 0) )
	self:SetPos( self:GetPos() + Vector(0, 0, 0) )
	self:DrawShadow(false)
	
	self.NextUpdate = CurTime()+0.5
	self.Water = 0
		self:SetNWInt("WaterLevel", self.Water)
	
end

function ENT:Think()	
	if (CurTime() > self.NextUpdate) then
		self.NextUpdate = CurTime()+0.5
		self:SetNWInt("WaterLevel", self.Water)
	
		if (self.Water == 0) then
			if self:WaterLevel() >= 2 then
				local effect = EffectData()
					effect:SetOrigin( self:GetPos() + Vector(0, 0, 7) )
					effect:SetScale( 10 )
				util.Effect( "watersplash", effect )
				self.Water = 1
			end
		end
	end
end
