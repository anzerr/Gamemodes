include( "shared.lua" )

function ENT:Initialize()	
	local effect = EffectData()
		effect:SetOrigin( self:GetPos() )
		effect:SetEntity( self )
		effect:SetMagnitude( 80 )
	util.Effect( "pod_smoke", effect )
	
	local effect = EffectData()
		effect:SetOrigin( self:GetPos() )
		effect:SetEntity( self )
		effect:SetMagnitude( 15 )
	util.Effect( "pod_flame", effect )

end

ENT.EffectCount = false
ENT.EffectCur = 0

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think ( )	

	if (self:GetMoveType( ) == MOVETYPE_NONE and self.EffectCount == false ) then	
		if (self.EffectCur == 0) then self.EffectCur = CurTime()+0.1 end
		
		if ( self.EffectCur < CurTime() ) then
			self.EffectCount = true
			local effect = EffectData()
				effect:SetOrigin( self:GetPos() )
				effect:SetEntity( self )
				effect:SetMagnitude( 15 )
			util.Effect( "pod_crash_smoke", effect )
		end
	end
end

function ENT:OnRemove()

end
