AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/test/droppodtest.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLY )	
	self:SetSolid( SOLID_VPHYSICS )

	local ang = self:GetAngles()
	self.Pod = ents.Create( "prop_vehicle_prisoner_pod" )
	self.Pod:SetModel("models/vehicles/prisoner_pod_inner.mdl")
	self.Pod:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	self.Pod:SetPos( self:GetPos() + ang:Forward()*40 + ang:Right()*-1 + ang:Up()*10 )
	self.Pod:SetRenderMode( 1 )
	self.Pod:SetColor( Color( 0, 255, 0, 0 ) )
	self.Pod:SetParent( self )
	self.Pod:Spawn()
	
	self.Owner = self.Owner or self

	self.NextUpdate = CurTime() + 0.1
	self.Velocity = 1
	self.Life = 100
	self.HitTarget = false
	self.PlayedSpawn = false
	self.LastWobble = self.Entity:GetForward()
	self.Owner:EnterVehicle( self.Pod )
end

function ENT:Touch( touch )
	if ( touch != self.Owner or touch:GetClass() == "Spawn_pod" or touch:IsWorld() ) then
		self:SetMoveType( MOVETYPE_NONE )
		self.HitTarget = true
	end
end

function ENT:ChangeVelocity( a, b )
	local Wobble = nil

	Wobble = (self:GetVelocity() + Vector(self.RandomRotX*b, self.RandomRotZ*b, self.RandomRotY*b) + self.LastWobble):GetNormalized()
	
	local RocketAng = self:GetForward()
	local NewAng = Wobble*(0.03*5) + RocketAng
	
	NewAng = NewAng:GetNormalized()
	
	self:SetAngles( NewAng:Angle() )

	self:SetLocalVelocity( NewAng*a )

	self.LastWobble = Wobble
end

function ENT:Think()
	if self.NextUpdate < CurTime() then
		self.NextUpdate = CurTime() + 0.1		
		if !self.HitTarget then
			if (self.Velocity >= 0) then
				self.Velocity = self.Velocity - 0.05
			end
			self:ChangeVelocity( 10000, self.Velocity )
		else
			if (self.Life >= 0) then
				self.Life = self.Life-1
			else
				--self:Remove()
			end
			
			if ( not self.PlayedSpawn ) then
				timer.Simple( 5, function() 
					self.Owner:ExitVehicle() 
					local ang = self:GetAngles()
					self.Owner:SetPos( self:GetPos() + ang:Forward()*20 + ang:Right()*1 + ang:Up()*70 )
				end)
				--self.Owner:UnSpectate()
				--self.Owner:Spawn()
				--constraint.NoCollide( self, self.Owner, true, true )
				--self.Owner:SetPos( self:GetPos()+Vector( 0, 0, 100 ) )
				--self.Owner:SetVelocity( self:GetUp() * 200 + Vector( 0, 0, 50 ) )
				--timer.Simple( 0.1, function() self.Owner:KnockOut( 2 ) end )
				self.PlayedSpawn = true
			end
		end
	end
end
