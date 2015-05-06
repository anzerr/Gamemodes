AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/Items/AR2_Grenade.mdl" )

	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_FLY )	
	self:SetSolid( SOLID_BBOX )

	self.Owner = self.Owner or self

	self.NextUpdate = CurTime() + 0.1
	self.Velocity = 2000
	self.Life = 100
	self.HitTarget = false
	self.LastWobble = self.Entity:GetForward()
end

function ENT:Touch( touch )
	if ( touch != self.Owner or touch:GetClass() == "farm_flare" ) then
		self:SetMoveType( MOVETYPE_NONE )
		--self.HitTarget = true
		--self.NextUpdate = CurTime() + 2
	end
end

function ENT:ChangeVelocity( a, b )
	local Wobble = nil
	local c = 1
	if b == 1 then
		Wobble = (VectorRand() + self.LastWobble):GetNormalized()
	else
		Wobble = (self:GetVelocity() - Vector(0, 0, a) + self.LastWobble):GetNormalized()
		c = 5
	end
	
	local RocketAng = self:GetForward()
	local NewAng = Wobble*(0.03*c) + RocketAng

	NewAng = NewAng:GetNormalized()
	
	self:SetAngles( NewAng:Angle() )

	self:SetLocalVelocity( NewAng*a )

	self.LastWobble = Wobble
end

function ENT:Think()
	if self.NextUpdate < CurTime() then
		self.NextUpdate = CurTime() + 0.1		
		if !self.HitTarget then
			if (self.Velocity - 300 >= 0) then
				self.Velocity = self.Velocity - 300
								
				self:ChangeVelocity( self.Velocity, 1 )
			else
				local color = { self:GetColor( ) }
				if color[4] != 0 then self:SetColor( 255, 255, 255, 0 ) end
				local effect = EffectData()
					effect:SetOrigin( self.Entity:GetPos() )
					effect:SetMagnitude( 1 )
				util.Effect( "flare_effect", effect )
					self:ChangeVelocity( 300, 0 )
					
				if (self.Life >= 0) then
					self.Life = self.Life-1
				else
					self:Remove()
				end
			end
		else
			self:Remove()
		end
	end
end
