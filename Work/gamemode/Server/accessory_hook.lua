
	local ThinkCooldown = 0
hook.Add( "Think", "Think_Check_Accessory", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+2.5
			
		for _, v in pairs(player.GetAll()) do
			v:CheckAccessory()
		end
	end
end)

hook.Add("PlayerDisconnected", "send_clint_disconnected_umsg", function( ply )
	for _, v in ipairs( player.GetAll() ) do
		umsg.Start("send_clint_disconnected_weapon", v)
			umsg.Entity(ply)
		umsg.End()
		umsg.Start("send_clint_disconnected_accessory", v)
			umsg.Entity(ply)
		umsg.End()
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:CheckAccessory()
	if self.PlayerAccessory == nil then
		self.PlayerAccessory = "none"
	end	
	
	if ( self.PlayerAccessory != "none" ) then
		if not( self:HasItem( self.PlayerAccessory, 1 ) ) then
			self.PlayerAccessory = "none"
			Global_SycServerClientTable( "accessory", self.PlayerAccessory, self )
		end
	end
end	

function pmeta:SetAccessory( a )
	if self.PlayerAccessory == nil then
		self.PlayerAccessory = "none"
	end	
	
	self.PlayerAccessory = a
	Global_SycServerClientTable( "accessory", self.PlayerAccessory, self )
end	