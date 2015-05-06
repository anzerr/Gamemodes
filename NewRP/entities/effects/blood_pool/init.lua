
function EFFECT:Init( data )
	
	self.Origin = data:GetOrigin()
	
	for v, k in pairs(Blood_Scale) do
		if ( self:GetPos():Distance( v ) == 0 ) then
			self.Origin = v
		end
	end

	self.KillThink = CurTime()
	
	self.LastEffect = 0
	self.Scale = 0
	self.Rota = math.random( 0, 360 )
	self.DrawPos = Vector(self.Origin.x, self.Origin.y, BloodFloorPos)
	
end

function EFFECT:Think( )
	
	if ( self.LastEffect+0.1 < CurTime() ) then
		self.LastEffect = CurTime()
		self.Scale = Blood_Scale[self.Origin]
	end
	
	if ( Blood_Cur[self.Origin] != nil and self.KillThink+Blood_Cur[self.Origin] < CurTime() ) then
		Msg("Client side effect Blood_effect has been killed after " .. self.KillThink .. "\n" )
		Blood_Effect_List[self.Origin] = nil
		Blood[self.Origin] = nil
		Blood_Scale[self.Origin] = nil
		Blood_Cur[self.Origin] = nil
		return false
	else
		return true
	end
end

function EFFECT:Render()
	if ( LocalPlayer():GetPos():Distance( self.DrawPos ) <= MaxDrawDistance and self.Scale != nil and self.DrawPos != nil ) then
		cam.Start3D2D( self.DrawPos+Vector( 0, 0, 1 ), Angle( 0, 0, 0), self.Scale )
			surface.SetTexture( Blood_Settings["Texture"] )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRectRotated( 0, 0, 100, 100, self.Rota )
		cam.End3D2D()
	end
end
