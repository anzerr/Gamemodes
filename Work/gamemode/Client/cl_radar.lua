local EntityFilterList = {} --exemple 1, 15 (depth, row) or (->, down)
	EntityFilterList["farm_plant"] = "1, 1"
	EntityFilterList["farm_bucket"] = "2, 1"
	EntityFilterList["inventory_item"] = "3, 1"
	
	local Scanerbackground = surface.GetTextureID("hud/circle_full")
	local Scaneroutline = surface.GetTextureID("hud/circle_rim")
	local DisplayPlayerPos = surface.GetTextureID("hud/radar_player")
	local DisplayPlayerVueAngle = surface.GetTextureID("hud/radar_vue")
	local LocalPlayerMaxFps = math.floor(1 / FrameTime())

	local IconList = surface.GetTextureID("hud/radar_icon")
local function radar_GetEntityIcon( a, b, c, d, e )
	if d < 1 then d = 1 elseif d > 16 then d = 16 end
	if e < 1 then e = 1 elseif e > 16 then e = 16 end
	local f, g = surface.GetTextureSize( IconList )
	
	surface.SetTexture( IconList )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawPartialTexturedRect( a-(c/2), b-(c/2), c, c, 32*(d-1), 32*(e-1), 32, 32, f, g )
end

local function radar_GetEntityIconPos( a )
	if EntityFilterList[a:GetClass()] != nil then
		local c = string.Explode(", ", EntityFilterList[a:GetClass()])
		local b = {}
			b[1] = tonumber(c[1])
			b[2] = tonumber(c[2])
		return b
	end
end

local function radar_range( a, b )
	for v, k in pairs( EntityFilterList ) do
		if ValidEntity( a ) then
			if ( a:GetClass() == v or a:IsPlayer() ) then
				if ( a:GetPos():Distance(LocalPlayer():GetPos()) < b ) then
					return true
				else
					return false
				end
			end
		end
	end
	
	return false
end

local function radar_entPosPixel( a, b, d, e, f, g )
	local ply = d
	local x = ply:GetPos().x-a:GetPos().x-e
	local y = ply:GetPos().y-a:GetPos().y-f
	
	local z = math.sqrt( x*x + y*y )
	
	local phi = math.Deg2Rad( math.Rad2Deg( math.atan2( x, y ) ) - math.Rad2Deg( math.atan2( ply:GetAimVector().x, ply:GetAimVector().y ) ) - g )
		x = math.cos(phi)*z
		y = math.sin(phi)*z

	return {x/b, y/b}
end

local function radar_DrawPlayerPoint( a, b, c, d )
	local HealthPos = radar_entPosPixel( a, 2*d, a, 25, 0, LocalPlayer():EyeAngles().y )
	local Health = 510*(a:Health()/100)
	surface.SetTexture(Scanerbackground)
	surface.SetDrawColor( math.min(510-Health, 255), math.min(Health, 255), 0, 255 )
	surface.DrawTexturedRectRotated( math.floor(b-HealthPos[2]), math.floor(c-HealthPos[1]), 7, 7, 0 )
	
	surface.SetTexture(DisplayPlayerPos)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( b, c, 16, 16, a:EyeAngles().y - LocalPlayer():EyeAngles().y )
	
	if ( a:GetPos():Distance(LocalPlayer():GetPos()) < (256*d) - (48*d) ) then
		surface.SetTexture(DisplayPlayerVueAngle)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( b, c, 64, 64, a:EyeAngles().y - LocalPlayer():EyeAngles().y )
	end
end

local function radar_Draw( a, b, c, d )
	if ( a:IsPlayer( ) ) then 
		if ( a:Alive() and a != LocalPlayer() ) then
			radar_DrawPlayerPoint( a, b, c, d )
		end
	else
		local e = radar_GetEntityIconPos( a )
		radar_GetEntityIcon( b, c, 12, e[1], e[2] )
	end
end

	local DisplayBar = surface.GetTextureID("hud/circle_bar")
local function addhudbar_RoundD( a, b, c, e, f, g, h )
	local d = h*(b/100)
	if (g < g+d) then
		for i=g-(d/2), g+(d/2) do
		   surface.SetTexture(DisplayBar)
		   surface.SetDrawColor(c[1],c[2],c[3],255)
		   surface.DrawTexturedRectRotated(e,f,a,a,i)
		end
	end
 end
 
local function GetMapBottom( pos )
	local tr = {}
	tr.start = pos
	tr.endpos = tr.start + Vector( 0, 0, -250 )
	tr.filter = LocalPlayer()
	tr = util.TraceLine(tr)
	
	return tr.HitPos
end

function radar_Scan( a, b, c )
	local d = 256*a
	local e = GetMapBottom( LocalPlayer():GetPos()+Vector(0,0,100) )
		Update_RenderPosAng( "render/render_1", Angle(90,LocalPlayer():EyeAngles().yaw,0), e+Vector(0,0,d), 120 )
		surface.SetTexture( RT_texture[ "render/render_1" ] )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawPoly( surface.DrawCirclePoly( b+16, c+16, d/(a*2), 20 ) )
		
	for k, v in pairs( ents.GetAll() ) do
		if radar_range( v, d-(16*a) ) then
			local pos = radar_entPosPixel( v, 2*a, LocalPlayer(), 0, 0, 90 )
			radar_Draw( v, b-pos[1]+16, c-pos[2]+16, a )
		end
	end
		
	local Health = 510*(LocalPlayer():Health()/100)
	surface.SetTexture(Scanerbackground)
	surface.SetDrawColor( math.min(510-Health, 255), math.min(Health, 255), 0, 255 )
	surface.DrawTexturedRectRotated( b+16, c+16+4, 7, 7, 0 )
	
	surface.SetTexture(DisplayPlayerPos)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( b+16, c+16, 16, 16, 0 )
	
	surface.SetTexture(Scaneroutline)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( b+16, c+16, d/(a/2)-4, d/(a/2)-4, 0 )

	--addhudbar_RoundD( d/a, GetServerTableValue( LocalPlayer(), "stamina" ), {200, 0, 0}, b+16, c+16, 0, math.floor((360/3)*1) )
	--addhudbar_RoundD( d/a, GetServerTableValue( LocalPlayer(), "hunger" ), {0, 200, 0}, b+16, c+16, math.floor((360/3)*1), math.floor((360/3)*1) )
	--addhudbar_RoundD( d/a, LocalPlayer():Health(), {0, 0, 200}, b+16, c+16, math.floor((360/3)*2), math.floor((360/3)*1) )
end

