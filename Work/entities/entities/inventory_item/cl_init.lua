include( "shared.lua" )

function ENT:Initialize()
	self.Run = 0
	self.RunCur = CurTime()+0.5
end

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Think()
	if (CurTime() > self.RunCur and self.Run == 0) then
		--print("debug: " .. self:GetNWString("Item_ID"))
		local itemTable = Inventory.Items:GetItem(self:GetNWString("Item_ID"))

		if itemTable != nil then
			if (itemTable.IsAccessory != 0) then
				local effect = EffectData()
					effect:SetOrigin( self:GetPos() + Vector(0, 0, itemTable.AccessoryVector) )
					effect:SetEntity( self )
					effect:SetScale( 10 )
				util.Effect( "hat_effect", effect )
				self.Run = 1
			end
		end
	end
end
