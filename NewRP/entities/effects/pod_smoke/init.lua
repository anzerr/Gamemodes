
function EFFECT:Init( data )
	self.particle = {}
	self.Ent = data:GetEntity()
	self.Count = 180
	self.LastEffect = 0
	self.LastPos = nil
	self.KillThink = nil
	
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local size = data:GetMagnitude()
	
	for i = 1, self.Count do
		self.particle[i] = emitter:Add( "effect/Dirt", Pos )
		self.particle[i]:SetDieTime( (20+(0.1*self.Count))-(0.1*i) )
		self.particle[i]:SetStartAlpha( 255 )
		self.particle[i]:SetEndAlpha( 0 )
		self.particle[i]:SetStartSize( size )
		self.particle[i]:SetEndSize( size*4 )
		self.particle[i]:SetRoll( 5 )
		self.particle[i]:SetRollDelta( 0.5 * math.random( -2, 2 ) )
		local a = math.random( 100, 255 )
		self.particle[i]:SetColor( a, a, a )
		self.particle[i]:SetVelocity( VectorRand()*10 )
		self.particle[i]:SetPos( Vector( 0, 0, 40000 ) )
	end
	
	self.KillThink = CurTime()+(20+(0.1*self.Count))-(0.1*self.Count)
	
	emitter:Finish()
end

function EFFECT:Think( )

	if ( self.LastEffect + 0.05 < CurTime() ) then
		self.LastEffect = CurTime()
		if (self.Count >= 1 ) then
			if IsValid(self.Ent) then
				if not(self.Ent:GetMoveType( ) == MOVETYPE_NONE) then
					if ( self.LastPos == nil ) then
						self.particle[self.Count]:SetPos( self.Ent:GetPos() )
					else
						self.particle[self.Count]:SetPos( self.LastPos )
					end
					self.LastPos = self.Ent:GetPos()
					self.Count = self.Count-1
				else
					self.particle[self.Count]:SetDieTime( 0 )
				end
			end
		end
	end
	
	if ( self.KillThink != nil and self.KillThink < CurTime() ) then
		for kill = 1, self.Count do
			self.particle[kill]:SetDieTime( 0 )
		end
		Msg("Client side effect Pod_smoke has been killed after " .. self.KillThink .. "\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

	
end
