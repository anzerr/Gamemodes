
function EFFECT:Init( data )

	self.Ent = data:GetEntity()
	self.Magnitude = data:GetMagnitude()
	self.particle = {}
	self.ModelEffect = {}
	self.ModelFloor = {}
	self.ModelOffset = {}
	
	local tr = {}
	tr.start = data:GetOrigin() + Vector( 0, 0, 20 )
	tr.endpos = tr.start + Vector( 0, 0, -500 )
	tr.filter = table.Add( ents.GetAll(), player.GetAll() )
	tr = util.TraceLine(tr)
	self.Floor = tr.HitPos.z
		
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	
	for i = 1, 10 do
		self.particle[i] = emitter:Add( "effect/Fire", Pos )
		self.particle[i]:SetDieTime( 60 )
		self.particle[i]:SetStartAlpha( 0 )
		self.particle[i]:SetEndAlpha( 0 )
		self.particle[i]:SetStartSize( 0 )
		self.particle[i]:SetEndSize( 0 )
		self.particle[i]:SetRoll( 0 )
		self.particle[i]:SetRollDelta( 0 )
		self.particle[i]:SetColor( 255, 255, 255 )
		self.particle[i]:SetCollide( true )
		self.particle[i]:SetGravity( Vector(0,0,-400) )
		local x = 100 * math.sin( (i/100)*(3.14159265*2) )
		local y = 100 * math.cos( (i/100)*(3.14159265*2) )
				
		local Scale = math.random( 100, 1000 ) /1000
		self.particle[i]:SetVelocity( Vector( x*Scale, y*Scale, math.random(0,80) ) )
		MsgN( 0.75*Scale )
		self.particle[i]:SetBounce( 0.25*Scale )
		
		self.ModelEffect[i] = ents.CreateClientProp( )
		self.ModelEffect[i]:SetModel( "models/weapons/rifleshell.mdl" )
		self.ModelEffect[i]:Spawn()
		self.ModelFloor[i] = 0
		self.ModelOffset[i] = Vector( 0, 0, 0 )
		self.ModelEffect[i]:SetAngles( Angle( math.random( 0, 360 ), math.random( 0, 360 ), math.random( 0, 360 ) ) )
	end

	self.KillThink = CurTime()+60
	
	emitter:Finish()
end

function EFFECT:Think( )

	for i = 1, 10 do
		self.ModelEffect[i]:SetPos( self.particle[i]:GetPos()+self.ModelOffset[i] )
		if (self.particle[i]:GetPos().z-self.Floor) <= 1 then
			local a = self.particle[i]:GetVelocity()
			a = math.floor(a.x+a.y+a.z)
			if ( a == 0 and self.ModelFloor[i] == 0 ) then	
				self.ModelFloor[i] = 1
			elseif ( self.ModelFloor[i] == 1 ) then	
				a = self.ModelEffect[i]:GetAngles()
				if ( a.p > 180 ) then
					self.ModelEffect[i]:SetAngles( Angle( a.p-1, a.y, a.r ) )
				elseif ( a.p < 180 ) then
					self.ModelEffect[i]:SetAngles( Angle( a.p+1, a.y, a.r ) )
				end
				
				a = self.ModelEffect[i]:GetAngles()
				if ( a.r > 180 ) then
					self.ModelEffect[i]:SetAngles( Angle( a.p, a.y, a.r-1 ) )
				elseif ( a.r < 180 ) then
					self.ModelEffect[i]:SetAngles( Angle( a.p, a.y, a.r+1 ) )
				end
				
				a = self.ModelEffect[i]:GetAngles()
				if ( a.p == 180 and a.r == 180 ) then
					self.ModelFloor[i] = -1
				end
				---MsgN( self.ModelEffect[i]:GetAngles() )
			end
		else
			local a = self.particle[i]:GetVelocity()
			a = math.floor(a.x+a.y+a.z)
			if ( a != 0 and self.ModelFloor[i] == 0 ) then
				a = self.ModelEffect[i]:GetAngles()
				if ( a.p >= 360 ) then a.p = 0 end
				if ( a.r >= 360 ) then a.r = 0 end
				if ( a.y >= 360 ) then a.y = 0 end
				
				local b  = Angle( math.random(0,1), math.random(0,1), math.random(0,1))
				self.ModelEffect[i]:SetAngles( a+b )
			end
		end
	end
	
	if ( self.KillThink != nil and self.KillThink < CurTime() ) then
		for kill = 1, 10 do
			self.particle[kill]:SetDieTime( 0 )
			self.ModelEffect[kill]:Remove()
		end
		
		Msg("Client side effect Pod_flames has been killed after " .. self.KillThink .. "\n" )
		return false
	else
		return true
	end
end

function EFFECT:Render()

	
end
