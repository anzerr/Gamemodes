
local meta = FindMetaTable("Player")

function meta:IsOutside( )
	local tr = {}
	tr.start = self:GetPos() + Vector( 0, 0, 90 )
	tr.endpos = tr.start + Vector( 0, 0, 250 )
	tr.filter = self
	tr = util.TraceLine(tr)
	
	if tr.HitWorld then
		return true
	else	
		return false
	end
end

local function NightEffect(a)
	for _, v in pairs(player.GetAll()) do
		umsg.Start("night_cycle_effect", self)
			umsg.String(a)
		umsg.End()
	end
end

local function Night()
	for _, v in pairs(player.GetAll()) do
		if not v:IsOutside() then
			if v:Alive() then
				v:Kill()
			end
		end
	end
end

	local Day = 300
	local ThinkCooldown = CurTime()+Day-10
hook.Add( "Think", "Think_Night_Cycle", function( )
	if (CurTime() > ThinkCooldown) then
		if (CurTime() >= ThinkCooldown and CurTime() < ThinkCooldown+11) then
			NightEffect(math.floor(CurTime()-ThinkCooldown))
		elseif (CurTime() > ThinkCooldown+11 and CurTime() < ThinkCooldown+21) then
			Night()
		elseif (CurTime() > ThinkCooldown+22) then
			NightEffect( math.floor(10-((CurTime()-ThinkCooldown)-22)) )
			if (CurTime() >= ThinkCooldown+32) then
				NightEffect(0)
				ThinkCooldown = CurTime()+Day-10
			end
		end
	end
end)
