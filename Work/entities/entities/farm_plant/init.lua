AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local day = 10

function ENT:Initialize()
	self:SetModel("models/mine/dirt/dirt.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetAngles( Angle(0, math.random(0,360), 0) )
	self:SetPos( self:GetPos() + Vector(0, 0, 0) )
	self:DrawShadow(false)
	
	self.PlantWaterLevel = day
	self.CurDelay = CurTime()
	if self.PlantID == "melon" then
		self.PlantGrowTime = day*2
	end
end

function ENT:SpawnFruit( a )
	self.PlantID = nil
	for i=1, 2 do 
		local entItem = ents.Create("Inventory_item")
		entItem:SetPos(self:GetPos() + Vector( math.random( -25, 25 ), math.random( -25, 25 ), 25 ) )
		entItem.Unique = a
		entItem.Amount = 1
		entItem:Spawn()
		
		entItem:SetMoveType( MOVETYPE_NONE )
	end
end

function ENT:HasFruit()
	local ent = ents.GetByIndex( tonumber( EntID ) )
	local a = 0
	local b = 0
	for k, v in pairs( ents.FindInSphere(self:GetPos(), 100) ) do a = a+1 end
	
	for k, v in pairs( ents.FindInSphere(self:GetPos(), 100) ) do
		if v:GetClass() == "inventory_item" then
			if (v:GetMoveType() == MOVETYPE_NONE) then
				b = b+1
			end
		end
	end
	
	if (b >= 1) then
		return true
	else
		return false
	end
end

function ENT:GetWaterBucket()
	for k, v in pairs( ents.FindInSphere(self:GetPos(), 25) ) do
		if v:GetClass() == "farm_bucket" then
			if (self.PlantWaterLevel <= (day/100)*10) then
				if (v.Water == 1) then
					self.PlantWaterLevel = day
					v.Water = 0
					local effect = EffectData()
						effect:SetOrigin( v:GetPos() + Vector(0, 0, 7) )
						effect:SetScale( 10 )
					util.Effect( "watersplash", effect )
					local effect = EffectData()
						effect:SetOrigin( self:GetPos() + Vector(0, 0, 7) )
						effect:SetScale( 10 )
					util.Effect( "watersplash", effect )
				end
			end
		end
	end
end

function ENT:Think()
	self:GetWaterBucket()

	if not self:HasFruit() then
		if self.PlantWaterLevel >= 0 then
			if self.PlantID != nil then
				if (CurTime() > self.CurDelay) then
					self.CurDelay = CurTime() + 1
					self.PlantWaterLevel = self.PlantWaterLevel - 1
					if ((self:GetNWInt("Grow")+(100/self.PlantGrowTime)) >= 100) then
						self:SetNWInt( "Grow", 100 )
						self:SpawnFruit( "item_" .. self.PlantID )
					else
						self:SetNWInt("Grow",self:GetNWInt("Grow")+(100/self.PlantGrowTime) )
					end
				end
			else
				if (self:GetNWInt("Grow") != 0) then
					local effect = EffectData()
						effect:SetOrigin( self:GetPos() + Vector(0, 0, 7) )
						effect:SetScale( 10 )
					util.Effect( "plant_effect", effect )
					self:SetNWInt("Grow",0)
				end
			end
		end
	end
end
