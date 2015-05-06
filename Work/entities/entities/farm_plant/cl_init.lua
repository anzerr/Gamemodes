include( "shared.lua" )

function ENT:Initialize()
	self:SetModelScale( Vector( math.random(0.8, 1), math.random(0.8, 1), 1 ) )
	
	self.Plant = ents.Create( "prop_physics" )
	self.Plant:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self.Plant:SetPos( self.Entity:GetPos() + Vector(0, 0, 0) )
	self.Plant:SetAngles( Angle( 0, 0, 0 ) )
	self.Plant:SetParent( self )
	self.Plant:Spawn()
	self.Plant:Activate()
end

function ENT:Draw()
	local Size = ( self:GetNWInt("Grow")/100 )
	self.Plant:SetModelScale( Vector( Size, Size, Size ) )
	self.Plant:SetPos( self.Entity:GetPos() + Vector(0, 0, Size*26) )
	self:DrawModel()
end

function ENT:Think()

end

function ENT:OnRemove()

end