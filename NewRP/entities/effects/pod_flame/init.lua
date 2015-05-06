
function EFFECT:Init( data )
	self.particle = {}
	self.particlesize = {}
	self.SoundEffect = {}
	self.SoundEffectCur = {}
	
	self.Ent = data:GetEntity()
	self.Count = 20
	self.LastEffect = 0
	self.Magnitude = data:GetMagnitude()
	self.Gas = false
	self.SoundToggle = false
	self.LastSoundEffect = 0
	self.SoundToggle2 = 3
	self.SoundCount = 0
	self.SoundScale = 1
	self.GasTankSize = 0
	self.KillThink = nil
	
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	
	for i = 1, self.Count do
		self.particle[i] = emitter:Add( "effect/Fire", Pos )
		self.particle[i]:SetDieTime( 1 )
		self.particle[i]:SetStartAlpha( 255 )
		self.particle[i]:SetEndAlpha( 255 )
		self.particle[i]:SetStartSize( self.Magnitude )
		self.particle[i]:SetEndSize( self.Magnitude )
		self.particle[i]:SetRoll( math.random( -5, 5 ) )
		self.particle[i]:SetRollDelta( math.random( -1, 1 ) )
		self.particle[i]:SetColor( 0, 0, 255 )
		self.particle[i]:SetPos( Vector( 0, 0, 40000 ) )
		self.particlesize[i] = (self.Magnitude/self.Count)*i
	end
	 
	self.SoundEffect[1] = CreateSound(self.Ent, Sound( "vehicles/APC/apc_cruise_loop3.wav" ) )
	self.SoundEffectCur[1] = -1
	self.SoundEffect[1]:Play()
	
	self.SoundEffect[2] = CreateSound(self.Ent, Sound( "ambient/wind/wind_rooftop1.wav") )
	self.SoundEffectCur[2] = -1
	self.SoundEffect[2]:Play()
	
	self.SoundEffect[3] = CreateSound(self.Ent, Sound( "vehicles/APC/apc_slowdown_fast_loop5.wav") )
	
	self.SoundEffect[4] = CreateSound(self.Ent, Sound( "vehicles/APC/apc_shutdown.wav") )
	
	self.SoundEffect[5] = CreateSound(self.Ent, Sound( "npc/env_headcrabcanister/explosion.wav") )
	self.SoundEffectCur[5] = -2
	
	self.SoundEffect[6] = CreateSound(self.Ent, Sound( "npc/env_headcrabcanister/hiss.wav") )
	
	emitter:Finish()
end

function EFFECT:Think( )

	for i = 1, 6 do
		if ( self.SoundEffectCur[i] != nil ) then 
			if ( self.SoundEffectCur[i] == -2 and self.Gas == true ) then
				self.SoundEffectCur[i] = CurTime()+7
				self.SoundEffect[i]:Play()
			elseif ( self.SoundEffectCur[i] == -1 and self.Gas == true ) then
				self.SoundEffectCur[i] = nil
				self.SoundEffect[i]:Stop()
			elseif ( self.SoundEffectCur[i] > 0 and self.SoundEffectCur[i] < CurTime() ) then
				self.SoundEffectCur[i] = nil
				self.SoundEffect[i]:Stop()
			end
		end
	end
	
	if ( self.SoundToggle == true ) then
		if ( self.LastSoundEffect < CurTime() ) then

			if ( self.SoundToggle2 == 1 ) then
				self.LastSoundEffect = CurTime() + 1
				self.SoundEffect[4]:Stop()
				self.SoundToggle = false
			elseif ( self.SoundToggle2 == 2 ) then
				self.LastSoundEffect = CurTime() + 1
				self.SoundEffect[3]:Stop()
				self.SoundEffect[4]:Play()
				self.SoundToggle2 = 1
			else
				self.LastSoundEffect = CurTime() + self.GasTankSize
				self.SoundEffect[3]:Play()
				self.SoundToggle2 = 2
			end
		end
	end

	if ( self.LastEffect + 0.01 < CurTime() ) then
		self.LastEffect = CurTime()
		
		for i = 1, self.Count do
			local c = (self.particlesize[i]/self.Magnitude)
			self.particle[i]:SetColor( 255-255*(c/1.7), 125, 255*c )
			
			if IsValid(self.Ent) then
				local ang = self.Ent:GetAngles()
				self.particle[i]:SetPos( self.Ent:GetPos()+ ang:Forward()*-90 + ang:Right()*-2 + ang:Up()*3 - self.Ent:GetForward()*(self.Magnitude-(self.particlesize[i]*((self.particlesize[i]*(self.Count/5))/self.Magnitude))) )
				self.particle[i]:SetStartSize( self.particlesize[i] )
				self.particle[i]:SetEndSize( self.particlesize[i] )
				if ( self.particlesize[i] > 0 ) then
					self.particlesize[i] = math.max(self.particlesize[i] - 0.2, 0)
				else
					self.particlesize[i] = self.Magnitude
				end
				
				if not self.Gas then
					if not(self.Ent:GetMoveType( ) == MOVETYPE_NONE ) then
						self.particle[i]:SetDieTime( self.particle[i]:GetDieTime()+0.02 )
					else
						if ( i == self.Count ) then
							self.Gas = true
							self.KillThink = CurTime()+self.GasTankSize+10
							self.SoundToggle = true
							Msg( self.GasTankSize )
						end 
						local a = math.random(25, 100)/10
						if ( a > self.GasTankSize ) then self.GasTankSize = a end
						self.SoundToggle = true
						self.particle[i]:SetDieTime( self.particle[i]:GetDieTime()+a )
					end
				end
			else
				if not self.Gas then
					if ( i == self.Count ) then
						self.Gas = true
						self.KillThink = CurTime()+self.GasTankSize+10
						self.SoundToggle = true
						Msg( self.KillThink )
					end 
					local a = math.random(25, 100)/10
					if ( a > self.GasTankSize ) then self.GasTankSize = a end
					self.particle[i]:SetDieTime( self.particle[i]:GetDieTime()+a )
				end
			end
		end
	end
	
	if ( self.KillThink != nil and self.KillThink < CurTime() ) then
		for i = 1, 6 do
			self.SoundEffect[i]:Stop()
		end
		
		for kill = 1, self.Count do
			self.particle[kill]:SetDieTime( 0 )
		end
		
		Msg("Client side effect Pod_flames has been killed after " .. self.KillThink .. "\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

	
end
