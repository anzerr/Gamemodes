local matLight2 = Material("effects/yellowflare")

function EFFECT:Init(data) 
 	self.Time = 1
 	self.LifeTime = CurTime() + self.Time

 	self.vOffset = data:GetOrigin()
end

function EFFECT:Think() 
   
	return (self.LifeTime > CurTime())  
end 

function EFFECT:Render() 
 	 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp(Fraction, 0, 1) 
 	
	self.Entity:SetColor(255, 255, 255, 255 * Fraction)
	self.Entity:SetModelScale(Vector() * 100 * (1 - Fraction))
	
   	render.SetMaterial(matLight2)
	render.DrawQuadEasy(self.vOffset, VectorRand(), 250 * (Fraction) , 250 * (Fraction) , color_white)
	render.DrawQuadEasy(self.vOffset, VectorRand(), math.Rand(32, 500), math.Rand(32, 500), color_white)
	render.DrawSprite(self.vOffset, 250 * (Fraction), 250 * (Fraction), Color(255, 150, 150, 255))
end  