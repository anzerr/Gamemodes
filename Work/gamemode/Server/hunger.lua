
	local ThinkCooldown = 0
hook.Add( "Think", "Think_Check_Hunger", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+1
			
		for _, v in pairs(player.GetAll()) do
			v:CheckHunger()
		end
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:CheckHunger()
	if ( !self:Alive() ) then return end
	
	if self.PlayerHunger == nil then
		self.PlayerHunger = 0
	end	

	self:TakeHunger( 0.5 )
	
	self:SycServerClientTable( "hunger", self.PlayerHunger, self )
end	

function pmeta:TakeHunger( amount )
	if ( self.PlayerHunger - amount > 0 ) then
		self.PlayerHunger = self.PlayerHunger - amount
	else
		self.PlayerHunger = 0
	end
end	
