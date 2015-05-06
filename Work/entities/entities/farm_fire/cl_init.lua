
include( "shared.lua" )

function ENT:Draw()

end

ENT.LastEffect = 0
ENT.LastSound = 0

function ENT:Think ( )	

	if ( self.LastEffect + 0.4 < CurTime() ) then
		self.LastEffect = CurTime()
		local effect = EffectData()
			effect:SetOrigin( self:GetPos() )
			effect:SetMagnitude( 10 )
		util.Effect( "fire_effect", effect )
	end
	
	if ( self.LastSound + 5 < CurTime() ) then
		self.LastLastSound = CurTime()
		CreateSound( self, Sound("ambient/fire/fire_big_loop1.wav") )
	end
end
