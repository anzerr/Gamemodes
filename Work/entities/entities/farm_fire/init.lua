
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/wood_pallet001a.mdl")

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetAngles( Angle(0, 0, 0) )
	self.Entity:SetPos( self:GetPos() + Vector(0, 0, 10) )
	
	self.LastDamage = CurTime()

	self:DrawShadow(false)
end

function ENT:Think( )	
	if self.LastDamage < CurTime() then
		self.LastDamage = CurTime()+0.1

		for k , v in pairs( ents.FindInSphere( self:GetPos(), 60 ) ) do
			if v:IsPlayer() and v:Alive() then
				v:Ignite(1, 0)
				v:TakeDamage(4, v, v)
			end
		end
	end
end

function ENT:Use( activator, caller )

end
