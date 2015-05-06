	
local DamageScale = {}
	DamageScale[HITGROUP_HEAD] = 2.5
	DamageScale[HITGROUP_CHEST] = 1.5
	DamageScale[HITGROUP_STOMACH] = 1
	DamageScale[HITGROUP_GEAR] = 0.5
	DamageScale[HITGROUP_RIGHTARM] = 0.5
	DamageScale[HITGROUP_LEFTARM] = 0.5
	DamageScale[HITGROUP_RIGHTLEG] = 0.5
	DamageScale[HITGROUP_LEFTLEG] = 0.5
	DamageScale[HITGROUP_GENERIC] = 1

function GM:ScalePlayerDamage( ply, a, b )
	ply.Player_HITGROUP = a
	return b 
end	

function GM:EntityTakeDamage( a, b, c, d, e )
	if ( a:IsPlayer() ) then
		if ( DamageScale[a.Player_HITGROUP] != nil ) then
			e:ScaleDamage( DamageScale[a.Player_HITGROUP]*0.5 )
		end
	end
end

	local ThinkCooldown = 0
hook.Add( "Think", "Think_Damage_Over_Time_Tick", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+1
			
		for _, v in pairs(player.GetAll()) do
			v:DamageOverTimeTick( )
		end
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:AddDamgeOverTime( a, b )
	self.PlayerDot = a
	self.PlayerDotTick = b
	self:SycServerClientTable( "damageovertime", self.PlayerDot*self.PlayerDotTick, self )
end	

function pmeta:DamageOverTimeTick( )
	if ( self.PlayerDot == nil ) then self.PlayerDot = 0 end	
	if ( self.PlayerDotTick == nil ) then self.PlayerDotTick = 0 end	

	if ( self.PlayerDotTick > 0 ) then
		self.PlayerDotTick = self.PlayerDotTick-1
		self:TakeDamage( self.PlayerDot, self, self )
		self:SycServerClientTable( "damageovertime", self.PlayerDot*self.PlayerDotTick, self )
	end
end	
