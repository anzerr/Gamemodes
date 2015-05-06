
function EFFECT:Init( data )
	self.Fade = 100
	self.NextUpdate = CurTime() + 0.1
	self.particle = {}
	self.Time = 1
 	self.LifeTime = CurTime() + self.Time
 	self.vOffset = data:GetOrigin()
	
	WorldSound("weapons/explode" .. math.random(3, 5) .. ".wav", self.vOffset, 160, 130) 
end

function EFFECT:Think( )
	if self.NextUpdate < CurTime() then
		self.NextUpdate = CurTime() + 0.01	
		self.Fade = self.Fade-1
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local e = math.random(0, 25)
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 255-(e*2)
			dlight.g = 75-e
			dlight.b = 0
			dlight.Brightness = 0.02*self.Fade
			dlight.Size = 10.24*self.Fade
			dlight.Decay = (10.24*self.Fade)*5
			dlight.DieTime = CurTime() + 0.1
		end   
	end
	return true
end

function EFFECT:Render() 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp(Fraction, 0, 1) 
 	
	self.Entity:SetColor(255, 255, 255, 255 * Fraction)
	self.Entity:SetModelScale(Vector() * 100 * (1 - Fraction))
	
   	render.SetMaterial(Material("effects/yellowflare"))
	render.DrawQuadEasy(self.vOffset, VectorRand(), 1524 * (Fraction) , 1524 * (Fraction) , color_white)
	render.DrawQuadEasy(self.vOffset, VectorRand(), math.Rand(32, 500), math.Rand(32, 500), color_white)
	render.DrawSprite(self.vOffset, 1524 * (Fraction), 1524 * (Fraction), Color(255, 150, 150, 255))
end  
