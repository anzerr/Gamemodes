
	local ThinkCooldown = 0
hook.Add( "Think", "Think_Check_Stamina", function( )
	for _, v in pairs(player.GetAll()) do
		v:CheckJump()
	end
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+0.25
			
		for _, v in pairs(player.GetAll()) do
			v:CheckStamina()
		end
	end
end)

local playerMeta = FindMetaTable( "Player" )

function playerMeta:CheckJump()

	if self.PlayerJump == nil then
		self.PlayerJump = 0
	end	

	if self.PlayerJumpKeyDown == nil then
		self.PlayerJumpKeyDown = 0
	end		
	
	local Stamina = (self.PlayerStamina / 100)
		local tr = {}
			tr.start = self:GetPos()
			tr.endpos = tr.start + Vector( 0, 0, -50*Stamina )
			tr.filter = self
		tr = util.TraceLine(tr)
		local inair = self:GetPos() + Vector( 0, 0, -50*Stamina )
	
	if ( math.floor(inair[3]) != math.floor(tr.HitPos[3]) ) then
		self.PlayerJump = 0
	else
		self.PlayerJump = 1
	end
	
	if self:KeyDown( IN_JUMP ) then
		if ( self.PlayerJumpKeyDown == 0 and self.PlayerJump == 0 ) then
			self:TakeStamina( 5*Stamina )
		end
		self.PlayerJumpKeyDown = 1
	else
		self.PlayerJumpKeyDown = 0
	end
end

function playerMeta:CheckStamina()

	if self.PlayerStamina == nil then
		self.PlayerStamina = 0
	end
	
	local Stamina = (self.PlayerStamina / 100)

	if ( self:KeyDown( IN_SPEED ) and self:GetMoveType() ~= MOVETYPE_NOCLIP and ( self:KeyDown(IN_FORWARD) or self:KeyDown(IN_BACK) or self:KeyDown(IN_MOVERIGHT) or self:KeyDown(IN_MOVELEFT) ) ) then
		if ( self:Alive() and !self:InVehicle() ) then			
			if self.PlayerStamina <= 0 then
				self:SetPlayerSpeedStamina( 150, 150, 0 )
				self:GiveStamina()
			else
				self:SetPlayerSpeedStamina( 150, 150+(200*Stamina), 300*Stamina )
				self:TakeStamina( 1 )
			end
		end
	elseif self:InVehicle() then
		self:SetPlayerSpeedStamina( 150, 150, 0 )	
		self:GiveStamina()
	else
		self:SetPlayerSpeedStamina( 150, 150, 300*Stamina )
		self:GiveStamina()
	end
	
	self:SycServerClientTable( "stamina", self.PlayerStamina, self )
end		

function playerMeta:SetPlayerSpeedStamina( a, b, c )
	self:SetWalkSpeed( a )
	self:SetRunSpeed( b )	
	self:SetJumpPower( c )
end

function playerMeta:TakeStamina( a )
	if not( self:IsKnockOut( ) ) then	
		self.PlayerStamina = math.max( self.PlayerStamina - a, 0 )
	end
end

function playerMeta:GiveStamina()
	if not( self:IsKnockOut( ) or self:KeyDown(IN_FORWARD) or self:KeyDown(IN_BACK) or self:KeyDown(IN_MOVERIGHT) or self:KeyDown(IN_MOVELEFT) ) then
		local hunger = (self.PlayerHunger / 100)
		
		self.PlayerStamina = math.min( self.PlayerStamina + (2*hunger), 100 )
	elseif ( !self:IsKnockOut( ) and self:KeyDown(IN_FORWARD) or self:KeyDown(IN_BACK) or self:KeyDown(IN_MOVERIGHT) or self:KeyDown(IN_MOVELEFT) ) then
		local hunger = (self.PlayerHunger / 100)
		
		self.PlayerStamina = math.min( self.PlayerStamina + (2*(hunger/4)), 100 )
	end
end
