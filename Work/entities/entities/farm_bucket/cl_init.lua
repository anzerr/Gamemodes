include( "shared.lua" )

function ENT:Initialize()
	self.Plant = ents.Create( "prop_physics" )
	self.Plant:SetModel( "models/props_c17/oildrum001.mdl" )
	self.Plant:SetPos( self:GetPos() + Vector(0, 0, 1) )
	self.Plant:SetAngles( Angle( 0, 0, 0 ) )
	self.Plant:Spawn()
	self.Plant:Activate()
	
	local color = self:GetNWInt("WaterLevel")*255
	self.Plant:SetColor( color, color, color, color )
	
	self.Plant:SetMaterial( "models/shadertest/predator" )
	self.Plant:SetModelScale( Vector( 0.53, 0.53, 0.1 ) )
	self.ClientCur = CurTime()+0.5
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	if self.ClientCur == nil then
		self.ClientCur = 0
	end	

	if (CurTime() > self.ClientCur) then
		self.ClientCur = CurTime()+0.1
		local color = self:GetNWInt("WaterLevel")*255
		self.Plant:SetColor( color, color, color, color )
		self.Plant:SetPos( self:GetPos() + Vector(0, 0, 1) )
		
		if self.Plant:GetParent() != self then
			self.Plant:SetParent( self )
		end
	end
end

function ENT:OnRemove()

end