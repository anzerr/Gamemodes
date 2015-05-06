
function EFFECT:Init( data )
	self.Ent = data:GetEntity()
	self.ID = GetAccessory( Accessory_List[self.Ent].accessoryID )
	
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )

	self.prop = self.ID:InitProp( self.Ent )
	self.effect = self.ID:InitEffect( emitter, self.Ent )

	emitter:Finish()
end

function EFFECT:Think( )

	if IsValid(self.Ent) then
		self.effect = self.ID:ThinkEffect( self.effect, self.Ent )
		self.prop = self.ID:ThinkProp( self.prop, self.Ent )
	else
		return false
	end

	if ( Accessory_List[self.Ent].Kill != 1 or Accessory_List[self.Ent].Kill == nil ) then
		table.Empty( Accessory_List[self.Ent] )
		
		if ( self.prop != nil ) then
			for _, v in pairs( self.prop ) do
				v:Remove()
			end
		end
		
		if ( self.effect != nil ) then
			for k, v in pairs( self.effect ) do
				v:SetDieTime( 0 )
			end
		end
		
		Msg("Client side effect accesory_effect has been killed after called\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

end
