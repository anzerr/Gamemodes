
function EFFECT:Init( data )
	self.particle = {}
	self.ModelEffect = {}
	self.Ent = data:GetEntity()
	self.KillThink = nil
	self.LastEffect = CurTime()+1
	self.Scale = 2
	self.Armed = false
	self.ArmedCur = nil
	
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	
	self.ModelEffect[1] = ents.CreateClientProp( )
	self.ModelEffect[1]:SetModel( "models/XQM/Rails/gumball_1.mdl" )
	self.ModelEffect[1]:SetRenderMode( 1 )
	self.ModelEffect[1]:SetColor( Color( 0, 255, 0, 255 ) )
	self.ModelEffect[1]:SetMaterial( "models/debug/debugwhite" )
	self.ModelEffect[1]:Spawn()
	
	
	self.ModelEffect[2] = ents.CreateClientProp( )
	self.ModelEffect[2]:SetModel( "models/hunter/tubes/tube2x2x025c.mdl" )
	self.ModelEffect[2]:SetRenderMode( 1 )
	self.ModelEffect[2]:SetColor( Color( 0, 0, 255, 255 ) )
	self.ModelEffect[2]:SetMaterial( "models/debug/debugwhite" )
	self.ModelEffect[2]:Spawn()
	
	self.ModelEffect[3] = ents.CreateClientProp( )
	self.ModelEffect[3]:SetModel( "models/hunter/tubes/tube2x2x025c.mdl" )
	self.ModelEffect[3]:SetRenderMode( 1 )
	self.ModelEffect[3]:SetColor( Color( 255, 0, 0, 255 ) )
	self.ModelEffect[3]:SetMaterial( "models/debug/debugwhite" )
	self.ModelEffect[3]:Spawn()
	
	self.ModelEffect[1]:SetModelScale( self.Scale, 0 )
	self.ModelEffect[2]:SetModelScale( 0.9, 0 )
	self.ModelEffect[3]:SetModelScale( 0.9, 0 )
	
	self.ModelEffect[3]:SetAngles( Angle(0, 0, 90) )
	
	self.ModelEffect[1]:SetPos( self.Ent:GetPos()+Vector(0, 400, 50) )
	self.ModelEffect[2]:SetPos( self.Ent:GetPos()+Vector(0, 400, 50) )
	self.ModelEffect[3]:SetPos( self.Ent:GetPos()+Vector(0, 400, 50) )
	self.KillThink = CurTime()+20
	
	emitter:Finish()
end

function EFFECT:Think( )

	if ( self.LastEffect + 0.01 < CurTime() ) then
		self.LastEffect = CurTime()
		if ( IsValid(self.ModelEffect[2]) and IsValid(self.ModelEffect[3]) ) then
			self.ModelEffect[3]:SetAngles( self.ModelEffect[3]:GetAngles()+Angle(2, 0, 0) )
			self.ModelEffect[2]:SetAngles( self.ModelEffect[2]:GetAngles()+Angle(0, 2, 0) )
		end
		
		if ( self.Scale >= 0.1 and self.Armed == false ) then
			self.Scale = self.Scale-(math.random( 1, 30 )/5000)
			self.ModelEffect[1]:SetModelScale( self.Scale+(math.random(-5, 5)/100), 0 )
		else
			if ( self.Armed == false ) then
				self.Armed = true
				self.ArmedCur = CurTime()+1
			end
			
			if ( self.ArmedCur < CurTime() ) then
				self.Scale = self.Scale+0.6
				self.ModelEffect[1]:SetModelScale( self.Scale, 0 )
				self.ModelEffect[1]:SetColor( Color( 0, 255, 0, math.max(255-(self.Scale*1), 0) ) )
				if ( self.Scale > 2 ) then
					if IsValid(self.ModelEffect[2]) then self.ModelEffect[2]:Remove() end
					if IsValid(self.ModelEffect[3]) then self.ModelEffect[3]:Remove() end
				end
			end
		end
	end
	
	if ( self.KillThink != nil and self.KillThink < CurTime() ) then
		for kill = 1, 3 do
			if IsValid(self.ModelEffect[kill]) then
				self.ModelEffect[kill]:Remove()
			end
		end
		Msg("Client side effect Test_effect has been killed after " .. self.KillThink .. "\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

	
end
