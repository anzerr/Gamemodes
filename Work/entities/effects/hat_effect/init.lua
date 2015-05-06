
function EFFECT:Init( data )	
	self.particle = {}
	self.Count = {}
	self.ModX = {}
	self.ModY = {}
	self.Ent = data:GetEntity()
	self.ThinkCooldown = 0
	self.SizePos =  self.Ent:GetPos() - data:GetOrigin()
	
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local a = 0
	local r = math.random(0.7, 10)/10
	local g = math.random(0.7, 10)/10
	local b = math.random(0.7, 10)/10

	for i = 1, math.ceil( 23 ) do
		a = a + 1
		
		if( a <= 3 ) then
			self.particle[i] = emitter:Add( "effect/hat0"..a, Pos )
			self.particle[i]:SetDieTime( CurTime()+10 )
			self.particle[i]:SetStartAlpha( 255 )
			self.particle[i]:SetEndAlpha( 255 )
			self.particle[i]:SetRoll( 0 )
			self.particle[i]:SetRollDelta( 0 )
			self.particle[i]:SetColor( (i*11)*r, (i*11)*g, (i*11)*b )
			self.particle[i]:SetEndSize( 2.5 )
			self.particle[i]:SetStartSize( 2.5 )
			self.particle[i].x = nil
			self.particle[i].y = nil
			self.Count[i] = i/50
		else
			a = 0
		end
	end
end

function EFFECT:Think( )
	if ( ValidEntity( self.Ent ) ) then
		if (CurTime() > self.ThinkCooldown) then
			self.ThinkCooldown = CurTime()+0.01
			for a=1, math.ceil( 23 ) do
				if self.Count[a] != nil then
					self.Count[a] = self.Count[a]+0.002
				end
			end
		end

			for i=1, math.ceil( 23 ) do	
				if self.particle[i] != nil then
					self.particle[i]:SetDieTime( CurTime()+10 )
					self.particle[i].x = 25 * math.cos( self.Count[i]*(3.14159265*2) )
					self.particle[i].y = 25 * math.sin( self.Count[i]*(3.14159265*2) )
					self.particle[i]:SetPos( self.Ent:GetPos() + Vector(self.particle[i].x, self.particle[i].y, (math.sin(self.Count[i]*10) * 2.5)) - self.SizePos )
				end
			end
	else
		for i=1, math.ceil( 23 ) do	
			if self.particle[i] != nil then
				self.particle[i]:SetVelocity( Vector( math.random( -100, 100 ), math.random( -100, 100 ), math.random( 0, 100/2 ) ) )
				self.particle[i]:SetDieTime( CurTime()+15 )
			end
		end
		return false
	end
		
	return true
end

function EFFECT:Render()

end
