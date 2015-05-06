
	local ThinkCooldown = 0
hook.Add( "Think", "Think_Check_Drunk", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+0.25
			
		for _, v in pairs(player.GetAll()) do
			v:CheckDrunk()
		end
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:CheckDrunk()
	if ( !self:Alive() ) then return false end

	if ( self.PlayerDrunk == nil ) then
		self.PlayerDrunk = 0
	end
		
	if ( self.PlayerDrunk <= 0 ) then 
		self.PlayerDrunk = 0
		umsg.Start("drunk_effect", self)
			umsg.String(10)
		umsg.End()
	else
		self.PlayerDrunk = self.PlayerDrunk - 0.05
		
		if ((10-(self.PlayerDrunk /10)) < 0.1) then 
			umsg.Start("drunk_effect", self)
				umsg.String(0.1)
			umsg.End()
		else 
			umsg.Start("drunk_effect", self)
				umsg.String(10-(self.PlayerDrunk /10) ) 
			umsg.End()
		end
	end
	
	self:SycServerClientTable( "drunk", self.PlayerDrunk, self )
end	
