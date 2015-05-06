AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.itemTable = Inventory.Items:GetItem(self.Unique)		

	local a = self.itemTable.Model
	if ( tonumber(self.Amount) >= 2 ) then a = self.itemTable.MultiModel end
	self:SetModel( a )
	if ( self.itemTable.Skin != 0 ) then self:SetMaterial( self.itemTable.Skin ) end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local pObject = self:GetPhysicsObject()
	
	if (ValidEntity( pObject )) then
		pObject:Wake()
	end
	
	self.LastUpdate = CurTime()+1
	self.LastTouchUpdate = CurTime()+0.5
		
	self:SetNWString("Item_ID", self.Unique)
	self:SetNWString("Item_Amount", self.Amount)
end

function ENT:Touch( ent )
	if ( self.LastTouchUpdate < CurTime() ) then
		self.LastTouchUpdate = CurTime()+0.5
		CombineItem( ent, self )
	end
end

function ENT:Think( )	
	if ( self.LastUpdate < CurTime() ) then
		self.LastUpdate = CurTime()+1
		self:SetNWString("Item_ID", self.Unique)
	end
end
