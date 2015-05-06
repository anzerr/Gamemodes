
local WeaponModelList = {}

WeaponModelList["weapon_crossbow.Bone"] = "ValveBiped.Bip01_Spine4"
	WeaponModelList["weapon_crossbow.posX"] = -17
	WeaponModelList["weapon_crossbow.posY"] = 1
	WeaponModelList["weapon_crossbow.posZ"] = -2
	WeaponModelList["weapon_crossbow.angX"] = -25
	WeaponModelList["weapon_crossbow.angY"] = 84
	WeaponModelList["weapon_crossbow.angZ"] = -20
	
WeaponModelList["weapon_crowbar.Bone"] = "ValveBiped.Bip01_R_Thigh"
	WeaponModelList["weapon_crowbar.posX"] = 17
	WeaponModelList["weapon_crowbar.posY"] = 1
	WeaponModelList["weapon_crowbar.posZ"] = -3.5
	WeaponModelList["weapon_crowbar.angX"] = 0
	WeaponModelList["weapon_crowbar.angY"] = 70
	WeaponModelList["weapon_crowbar.angZ"] = 5
	
	local ThinkCooldown = 0
hook.Add( "Think", "Think_DrawWeapon", function( )	
	for _, v in pairs(player.GetAll()) do
		v:Update_WeaponDraw()
		v:Spawn_WeaponDraw_Models()
		v:ColorSet_WeaponDraw()
	end
end)

local pmeta = FindMetaTable("Player")

	local DrawWeapon = {}
function pmeta:Spawn_WeaponDraw_Models()
	if self.DrawWeapon == nil then
		if self != LocalPlayer( ) then
			self.DrawWeapon = ents.Create( "prop_physics" )
			self.DrawWeapon:SetModel( "models/props_junk/wood_crate001a.mdl" )
			self.DrawWeapon:SetPos( self:GetPos() + Vector(0, 0, 50) )
			self.DrawWeapon:SetAngles( Angle( 0, 0, 0 ) )
			self.DrawWeapon:SetParent( self )
			self.DrawWeapon:Spawn()
		end
	end
end

usermessage.Hook("send_clint_disconnected_weapon", function( um )
	local a = um:ReadEntity()
	
	if (a.DrawWeapon != nil) then
		a.DrawWeapon:Remove()
	end
end)

function pmeta:ColorSet_WeaponDraw()
	if self.DrawWeapon != nil then
		local color = { self.DrawWeapon:GetColor( ) }
		if (self:Alive() and GetServerTableValue( self, "knockout" ) == 0) then
			if color[4] != 255 then self.DrawWeapon:SetColor( 255, 255, 255, 255 ) end
		else
			if color[4] != 0 then self.DrawWeapon:SetColor( 255, 255, 255, 0 ) end
		end
	end
end


function pmeta:SetParent_WeaponDraw( a )
	if (WeaponModelList[a..".Bone"] != nil) then 
		local BoneIndexBack = self:LookupBone( WeaponModelList[a..".Bone"] )
		
		if BoneIndexBack then
			local pos, ang = self:GetBonePosition( BoneIndexBack )
			
			if ( pos and pos ~= self:GetPos() ) then
				self.DrawWeapon:SetPos( pos + ang:Forward()*WeaponModelList[a..".posX"] + ang:Right()*WeaponModelList[a..".posY"] + ang:Up()*WeaponModelList[a..".posZ"] )
					ang:RotateAroundAxis( ang:Up(), WeaponModelList[a..".angX"] )
					ang:RotateAroundAxis( ang:Forward(), WeaponModelList[a..".angY"] )
					ang:RotateAroundAxis( ang:Right(), WeaponModelList[a..".angZ"] )
				self.DrawWeapon:SetAngles( ang )
			end
		end
	end
end

function pmeta:WeaponDraw_GetAllWeapons()
	local a = {}
	local b = 0
	for _, k in pairs(self:GetWeapons()) do
		b = b+1
		a[b] = k
	end 

	return a
end

function pmeta:Update_WeaponDraw()	
	for _, k in pairs( self:WeaponDraw_GetAllWeapons() ) do	
		if ( ValidEntity(k) and ValidEntity(self:GetActiveWeapon()) ) then
			if ( self:GetActiveWeapon():GetClass() != k:GetClass() ) then
				if self.DrawWeapon != nil then
					self.DrawWeapon:SetModel( k:GetModel() )
					self:SetParent_WeaponDraw( k:GetClass() )
					if self.DrawWeapon:GetParent( ) != self then
						self.DrawWeapon:SetParent( self )
					end
				end
			end
		end
	end
end
