
-- fix this so it's a table and not a net work int ( they are so shit and work shitly with client server syc )
	-- no need for a client side part of this
	local ThinkCooldown = 0
hook.Add( "Think", "Think_Check_Breath", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+1
			
		for _, v in pairs(player.GetAll()) do
			v:CheckBreath()
		end
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:CheckBreath()
	if ( !self:Alive() ) then return false end

	if ( self.PlayerBreath == nil ) then
		self.PlayerBreath = 0
	end
	
	if ( self:WaterLevel() == 3 ) then
		if self:IsOnFire() then
			self:Extinguish()
		end	
	end
	
	if ( self:WaterLevel() >= 3 ) then
		self:TakeBreath( 1 )
	else
		self:GiveBreath( 1 )
	end			
end	

function pmeta:TakeBreath( amount )
	if ( self.PlayerBreath + amount < 20 ) then
		self.PlayerBreath = self.PlayerBreath + amount
	else
		if ( self:InVehicle() ) then self:ExitVehicle() end
		self.PlayerBreath = 20
		if( self:Health() > 15 ) then
			self:TakeDamage( math.random( 3, 15 ), self, self )
		else
			self:Kill()
		end
	end	
end	

function pmeta:GiveBreath( amount )
	if ( self.PlayerBreath - amount >= 0 ) then
		self.PlayerBreath = self.PlayerBreath - amount
	else
		self.PlayerBreath = 0
	end	
end
	