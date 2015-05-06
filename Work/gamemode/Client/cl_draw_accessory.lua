
local AccessoryModelList = {}

AccessoryModelList["none.Model"] = "models/Effects/teleporttrail.mdl"
	AccessoryModelList["none.posX"] = 0
	AccessoryModelList["none.posY"] = 0
	AccessoryModelList["none.posZ"] = 0
	AccessoryModelList["none.angX"] = 0
	AccessoryModelList["none.angY"] = 0
	AccessoryModelList["none.angZ"] = 0
	AccessoryModelList["none.ScaleX"] = 0.1
	AccessoryModelList["none.ScaleY"] = 0.1
	AccessoryModelList["none.ScaleZ"] = 0.1
	
AccessoryModelList["item_accessory_melon.Model"] = "models/props_junk/watermelon01.mdl"
	AccessoryModelList["item_accessory_melon.posX"] = 0
	AccessoryModelList["item_accessory_melon.posY"] = 0
	AccessoryModelList["item_accessory_melon.posZ"] = 0
	AccessoryModelList["item_accessory_melon.angX"] = 0
	AccessoryModelList["item_accessory_melon.angY"] = 0
	AccessoryModelList["item_accessory_melon.angZ"] = 0
	AccessoryModelList["item_accessory_melon.ScaleX"] = 1
	AccessoryModelList["item_accessory_melon.ScaleY"] = 1
	AccessoryModelList["item_accessory_melon.ScaleZ"] = 1

AccessoryModelList["item_accessory_pot.Model"] = "models/props_junk/terracotta01.mdl"
	AccessoryModelList["item_accessory_pot.posX"] = 7.5
	AccessoryModelList["item_accessory_pot.posY"] = -6
	AccessoryModelList["item_accessory_pot.posZ"] = 0.3
	AccessoryModelList["item_accessory_pot.angX"] = 55
	AccessoryModelList["item_accessory_pot.angY"] = 0
	AccessoryModelList["item_accessory_pot.angZ"] = 90
	AccessoryModelList["item_accessory_pot.ScaleX"] = 0.5
	AccessoryModelList["item_accessory_pot.ScaleY"] = 0.5
	AccessoryModelList["item_accessory_pot.ScaleZ"] = 0.5
	
	local ThinkCooldown = 0
hook.Add( "Think", "Think_DrawAccessory", function( )		
	for _, v in pairs(player.GetAll()) do
		v:Update_AccessoryDraw()	
		v:Spawn_AccessoryDraw_Models()
		v:ColorSet_AccessoryDraw()
	end
end)

local pmeta = FindMetaTable("Player")

function pmeta:Spawn_AccessoryDraw_Models()
	if self.DrawAccessorys == nil then
		if self != LocalPlayer( ) then
			self.DrawAccessorys = ents.Create( "prop_physics" )
			self.DrawAccessorys:SetModel( "models/Effects/teleporttrail.mdl" )
			self.DrawAccessorys:SetPos( self:GetPos() + Vector(0, 0, 50) )
			self.DrawAccessorys:SetAngles( Angle( 0, 0, 0 ) )
			self.DrawAccessorys:SetParent( self )
			self.DrawAccessorys:Spawn()
		end
	end
end

usermessage.Hook("send_clint_disconnected_accessory", function( um )
	local a = um:ReadEntity()
	
	if (a.DrawAccessorys != nil) then
		a.DrawAccessorys:Remove()
	end
end)

function pmeta:ColorSet_AccessoryDraw()
	if self.DrawAccessorys != nil then
		local color = { self.DrawAccessorys:GetColor( ) }
		if (self:Alive() and GetServerTableValue( self, "knockout" ) == 0) then
			if color[4] != 255 then self.DrawAccessorys:SetColor( 255, 255, 255, 255 ) end
		else
			if color[4] != 0 then self.DrawAccessorys:SetColor( 255, 255, 255, 0 ) end
		end
	end
end

function pmeta:SetParent_AccessoryDraw( a )
	if self.DrawAccessorys != nil then
		local BoneIndexBack = self:LookupBone( "ValveBiped.Bip01_Head1" )
		
		if BoneIndexBack then
			local pos, ang = self:GetBonePosition( BoneIndexBack )
			
			if ( pos and pos ~= self:GetPos() ) then
				self.DrawAccessorys:SetPos( pos + ang:Forward()*AccessoryModelList[a..".posX"] + ang:Right()*AccessoryModelList[a..".posY"] + ang:Up()*AccessoryModelList[a..".posZ"] )
					ang:RotateAroundAxis( ang:Up(), AccessoryModelList[a..".angX"] )
					ang:RotateAroundAxis( ang:Forward(), AccessoryModelList[a..".angY"] )
					ang:RotateAroundAxis( ang:Right(), AccessoryModelList[a..".angZ"] )
				self.DrawAccessorys:SetAngles( ang )
			end
		end
	end
end

function pmeta:Update_AccessoryDraw()	
	if self.DrawAccessorys != nil then
		local a = GetServerTableValue( self, "accessory" )
			if ( a == nil ) then
				a = "none"
			end
			
		if (self.DrawAccessorys:GetModel() != AccessoryModelList[a..".Model"]) then
			if (AccessoryModelList[a..".Model"] != nil) then 
				self.DrawAccessorys:SetModel( AccessoryModelList[a..".Model"] )
				local a = GetServerTableValue( self, "accessory" )..".Scale"
				self.DrawAccessorys:SetModelScale( Vector( AccessoryModelList[a.."X"], AccessoryModelList[a.."Y"], AccessoryModelList[a.."Z"] ) )
			end
		end
		
		self:SetParent_AccessoryDraw( a )
		if self.DrawAccessorys:GetParent( ) != self then
			self.DrawAccessorys:SetParent( self )
		end
	end
end