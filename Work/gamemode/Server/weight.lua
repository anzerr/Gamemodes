
-- fix this so it's a table and not a net work int ( they are so shit and work shitly with client server syc )
	-- need a client side so you can display it on the hud
local pmeta = FindMetaTable("Player")

function pmeta:UpdateWeight()
	local Weight = 0
	
	if self.PlayerStamina == nil then
		self.PlayerStamina = 0
	end	
	
	for k, v in pairs( self.PlayerInventoryTable ) do
		local itemTable = Inventory.Items:GetItem( k )
		if itemTable != nil then
			if itemTable.Weight > 0 then
				Weight = Weight + (itemTable.Weight * v)
			end
		end
	end
	
	self.PlayerWeight = Weight
	self:SycServerClientTable( "weight", self.PlayerWeight, self )
end	

function pmeta:CanHold( amount )
	self:UpdateWeight()
		
	if ( self.PlayerWeight + amount > self:SetMaxWeight() ) then
		return false
	else
		return true
	end
end	

function pmeta:CanMaxHold( weight )
	self:UpdateWeight()

	if ( self:SetMaxWeight()-self.PlayerWeight > 0 ) then
		return (self:SetMaxWeight()-self.PlayerWeight)/weight
	else
		return false
	end
end	

function pmeta:SetMaxWeight()
	return 5
end	