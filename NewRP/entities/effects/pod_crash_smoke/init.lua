
function EFFECT:Init( data )
	self.particle = {}
	self.Ent = data:GetEntity()
	self.Count = 90
	self.LastEffect = -1
	self.KillThink = nil
	
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local size = data:GetMagnitude()
		self.SmokeSize = size*6
	
	for i = 1, self.Count do
		self.particle[i] = emitter:Add( "effect/Dirt", Pos )
		self.particle[i]:SetDieTime( 10+math.random(-50, 50)/10 )
		self.particle[i]:SetStartAlpha( 255 )
		self.particle[i]:SetEndAlpha( 0 )
		self.particle[i]:SetStartSize( self.SmokeSize )
		self.particle[i]:SetEndSize( self.SmokeSize*2 )
		self.particle[i]:SetRoll( 5 )
		self.particle[i]:SetRollDelta( 0.5 * math.random( -2, 2 ) )
		local a = math.random( 100, 255 )
		self.particle[i]:SetColor( a, a, a )
		local x = self.Count * math.sin( (i/self.Count)*(3.14159265*2) )
		local y = self.Count * math.cos( (i/self.Count)*(3.14159265*2) )
				
		self.particle[i]:SetVelocity( Vector( x*math.random(2,3), y*math.random(2,3), math.random(0,80) ) )
		self.particle[i]:SetPos( self.Ent:GetPos() )
		
		if (i == self.Count) then
			self.LastEffect = CurTime()+0.5
		end
	end
	
	self.KillThink = CurTime()+10+(0.2*self.Count)
	
	emitter:Finish()
end

function EFFECT:Think( )

	if ( self.LastEffect < CurTime() and self.LastEffect != -1 ) then
		self.LastEffect = -1
		for i = 1, self.Count do
			local x = self.Count * math.sin( (i/self.Count)*(3.14159265*2) )
			local y = self.Count * math.cos( (i/self.Count)*(3.14159265*2) )
					
			self.particle[i]:SetVelocity( (self.particle[i]:GetVelocity()/10) + Vector( 0, 0, math.random(0,20) ) )
		end
	end

	if ( self.KillThink != nil and self.KillThink < CurTime() ) then
		for kill = 1, self.Count do
			self.particle[kill]:SetDieTime( 0 )
		end
		Msg("Client side effect Pod_crash_smoke has been killed after " .. self.KillThink .. "\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

	
end
