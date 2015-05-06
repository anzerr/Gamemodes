AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/crossbow_bolt.mdl" )
	if ( self.Heat <= 25 ) then self:SetMaterial( "Models/Weapons/rebar/rebar" ) end
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_FLY )	
	self:SetSolid( SOLID_BBOX )
	self:SetColor( Color( 0, 0, 0, 0 ) )

	local an = self:GetAngles()
	local tr = {}
		tr.start = self:GetPos()
		tr.endpos = tr.start + ( an:Forward()*(self.Speed*4) )
		tr.filter = {self, self.BoltOwner}
		tr = util.TraceLine(tr)
	local ps = tr.HitPos
	
	--self.NextUpdate = CurTime() + self:GetPos():Distance( ps )/self.Speed
	self.NextUpdate = 0
	self.Shot = true
end

function ENT:ShotBolt( )
	self:SetColor( Color( 255, 255, 255, 255 ) )
	self.Shot = false
	
	local an = self:GetAngles()
	local tr = {}
		tr.start = self:GetPos()
		tr.endpos = tr.start + ( an:Forward()*12000 )
		tr.filter = {self, self.BoltOwner}
		tr = util.TraceLine(tr)
	local ps = tr.HitPos

	
	if tr.Entity:IsPlayer( ) then
		if ( self.Heat == 100 ) then
			b:Ignite(5, 0)
		end
		
		self:EmitSound("weapons/crossbow/hitbod" .. math.random(1, 2) .. ".wav")
		self:Remove()
		
		local an = self:GetAngles()
		local bullet = {}
		bullet.Num    	= 1
		bullet.Src		= ps - ( an:Forward()*500 )
		bullet.Dir  	= an:Forward()
		bullet.Spread 	= Vector(0, 0, 0)
		bullet.Tracer 	= 0
		bullet.Force  	= 1
		bullet.Damage	= math.min(50+(self.Heat/2), 99)
		self:FireBullets(bullet)
	else
		self:SetMoveType( MOVETYPE_NONE )
		local an = self:GetAngles()
		local tr = {}
			tr.start = ps - ( an:Forward()*100 )
			tr.endpos = tr.start + ( an:Forward()*200 )
			tr.filter = {self, self.BoltOwner}
			tr = util.TraceLine(tr)
		local ps = tr.HitPos
		local b = Vector(0,-10,0)
		ps = ps + b.x * an:Right()
		ps = ps + b.y * an:Forward()
		ps = ps + b.z * an:Up()
		
		self:SetPos( ps )
		if ValidEntity( tr.Entity ) then
			self:SetParent( tr.Entity )
		end
		
		self:EmitSound("weapons/crossbow/hit1.wav")
		timer.Simple( 5, function() self:Remove() end)
	end
end

function ENT:Think()
	if (self.Shot) then
		if self.NextUpdate < CurTime() then
			self:ShotBolt(  )
		end
	end
end

--[[
	self:ChangeVelocity( )
	self.NextUpdate = CurTime() + 1
	self.HitTarget = false
end

function ENT:Touch( touch )
	if ( touch != self.Owner or touch:GetClass() == "farm_crossbow" ) then
		if touch:IsPlayer( ) then
			if ( self.Heat == 100 ) then
				touch:Ignite(5, 0)
			end
			
			self:EmitSound("weapons/crossbow/hitbod" .. math.random(1, 2) .. ".wav")
			self:Remove()

			local an = self:GetAngles()
			local bullet = {}
			bullet.Num    	= 1
			bullet.Src		= self:GetPos() - ( an:Forward()*25 )
			bullet.Dir  	= an:Forward()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer 	= 0
			bullet.Force  	= 1
			bullet.Damage	= math.min(50+(self.Heat/2), 99)
			self:FireBullets(bullet)
		else
			self:SetMoveType( MOVETYPE_NONE )
			local an = self:GetAngles()
			local tr = {}
				tr.start = self:GetPos() - ( an:Forward()*100 )
				tr.endpos = tr.start + ( an:Forward()*200 )
				tr.filter = {self, self.BoltOwner}
				tr = util.TraceLine(tr)
			local ps = tr.HitPos
			local b = Vector(0,-10,0)
			ps = ps + b.x * an:Right()
			ps = ps + b.y * an:Forward()
			ps = ps + b.z * an:Up()
			
			self:SetPos( ps )
			if ValidEntity(touch) then
				self:SetParent(touch)
			end
			self:EmitSound("weapons/crossbow/hit1.wav")
			self.HitTarget = true
			self.NextUpdate = CurTime() + 5
		end
	end
end

function ENT:ChangeVelocity()
	self:SetVelocity( self.Velocity )
end

function ENT:Think()
	if self.NextUpdate < CurTime() then
		self.NextUpdate = CurTime() + 1	
		if (self.HitTarget) then
			self:Remove()
		end
	end
end
]]