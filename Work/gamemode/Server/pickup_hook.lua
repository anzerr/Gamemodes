
local function PlayerGetProps( entity )
	for _, v in pairs(player.GetAll()) do
		if (v.HasItemInHands[1]) then
			if (v.HasItemInHands[2] == entity) then
				return true
			end
		end
	end
end

local function PlayerWeaponToggle( ply, toggle )
	local wep = ply:GetActiveWeapon()
	local Cur = 0
		if (toggle == false) then 
			Cur = 10 
		end
		
	if (ValidEntity(wep)) then
		wep:SetNextPrimaryFire(CurTime()+Cur)
		wep:SetNextSecondaryFire(CurTime()+Cur)
		if (ply.HasItemInHands[6] != toggle) then
			ply.HasItemInHands[6] = toggle
			ply:DrawViewModel(toggle)
			ply:DrawWorldModel(toggle)
		end
	end
end

hook.Add("PlayerInitialSpawn", "Init_PickUpItems", function( ply )
	ply.HasItemInHands = {}
		ply.HasItemInHands[1] = false
		ply.HasItemInHands[2] = nil
		ply.HasItemInHands[3] = nil
		ply.HasItemInHands[4] = 0
		ply.HasItemInHands[5] = 0
		ply.HasItemInHands[6] = true
		
	PropTableAddedSize = {}
		PropTableAddedSize["models/props_junk/metalbucket01a.mdl"] = 9
end)

hook.Add( "PlayerUse", "PickUpItems", function( ply, entity )
	if (CurTime() > ply.HasItemInHands[4]) then
		ply.HasItemInHands[4] = CurTime() + 0.5
		if (!ply.HasItemInHands[1]) then
			local tr = ply:EyeTrace(150)
			if (tr.Entity:IsValid()) then
				if (tr.Entity:GetMoveType() != MOVETYPE_NONE) then
					tr.Entity:SetCollisionGroup(1)
					ply.HasItemInHands[3] = ply.HasItemInHands[2]
					ply.HasItemInHands[2] = tr.Entity:EntIndex()
					ply.HasItemInHands[1] = true

					if (PropTableAddedSize[tr.Entity:GetModel()] != nil) then
						ply.HasItemInHands[5] = PropTableAddedSize[tr.Entity:GetModel()]
					end
				end
			end
		else
			PlayerWeaponToggle( ply, true )
			
			local item = ents.GetByIndex( tonumber( ply.HasItemInHands[2] ) )
			if (item != nil and item:IsValid()) then
				ply.HasItemInHands[1] = false
				local pObject = item:GetPhysicsObject()
				if (ValidEntity( pObject )) then
					pObject:Wake()
				end
			end
		end
	end
end)

	local ThinkCooldown = 0
hook.Add( "Think", "Think_PickUpItems", function( )
	if (CurTime() > ThinkCooldown) then
		ThinkCooldown = CurTime()+0.01
			
		for _, v in pairs(player.GetAll()) do
			if (v.HasItemInHands[1]) then
				local item = ents.GetByIndex( tonumber( v.HasItemInHands[2] ) )
				if (item != nil and item:IsValid( )) then
					local tr = {}
					tr.start = v:GetShootPos()
					tr.endpos = tr.start + (v:GetCursorAimVector() * (70+v.HasItemInHands[5]))
					tr.filter = { v, item }
					tr = util.TraceLine(tr)

					item:SetAngles( Angle( 0, 0, 0 ) )				
					item:SetPos( tr.HitPos + Vector(0, 0, v.HasItemInHands[5]) )
					
					PlayerWeaponToggle( v, false )
				end
			else
				if not PlayerGetProps( v.HasItemInHands[2] ) then
					local item1 = ents.GetByIndex( tonumber( v.HasItemInHands[2] ) )	
					if (item1 != nil and item1:IsValid()) then
						if item1:GetCollisionGroup() == 1 then
							item1:SetCollisionGroup(0)
						end
					end
					
					local item2 = ents.GetByIndex( tonumber( v.HasItemInHands[3] ) )
					if (item2 != nil and item2:IsValid()) then
						if item2:GetCollisionGroup() == 1 then
							item2:SetCollisionGroup(0)
						end
					end
				end
			end
		end
	end
end)