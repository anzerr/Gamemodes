
local function addhudbar_Box( a, b, c, d, e, f )
	--if ( a < 100 ) then
		local g = ScrW()/2		
			draw.RoundedBox( 1, g-(g/2)-1, (ScrH()-c)-b, g+2, c+2, Color(0, 0, 0, 255) )	
			
		if ( a > 1 ) then
			for i=0, (c-1) do
				draw.RoundedBox( 1, g-((g*(a/100))/2), (ScrH()-i)-b, g*(a/100), 1, Color(d*((i+c/2)/c), e*((i+c/2)/c), f*((i+c/2)/c), 255) )
			end
			draw.SimpleText( math.floor(a), "fnt_label", g, (ScrH()-(c-1))-b, Color(255, 255, 255, 255), 0, 0)
		end
	--end
end

	--exemple == addhudbar_Round( 75+12, 225, 225*(GetServerTableValue( LocalPlayer(), "hunger" )/100), 50, 50, 200 )
local function addhudbar_Round( a, b, c, d, e, f )
	for i=0, (c-1) do
		local x = a * math.sin( (i/b)*(3.14159265*2) )
		local y = a * math.cos( (i/b)*(3.14159265*2) )
		draw.RoundedBox( 0, 112+x, (ScrH()-112)+y, 8, 8, Color(d, e, f, 255) )
	end
end

local function addhudbar_HalfRound( a, c, d, e, f, g )
	local b = (a*5)/4
	for i=b*c, (b*d) do
		local x = a * math.sin( (i/(a*5))*(3.14159265*2) )
		local y = a * math.cos( (i/(a*5))*(3.14159265*2) )
		draw.RoundedBox( 0, e+x, f+y, 5, 5, g )
	end
end

local function addhudbar_TextRound( a, b, c, d, f )
		local e = 0
		--local g = Color(f[1], f[2], f[3], 255)
	if (d < 50) then
		e = math.random( -10, 10 )
	end
	draw.RoundedBox( 44, b-50, c-2, 145+(string.len(a)*6), 104, Color(0, 0, 0, 255) )
	draw.RoundedBox( 0, b, c-(e/2), 5, 20+e, f )
	draw.RoundedBox( 0, b+7, c-(e/2), 5, 20+e, f )
	draw.SimpleText( a, "Trebuchet24", b+14+1, c-2+1, Color(0, 0, 0, 255), 0, 0)
	draw.SimpleText( a, "Trebuchet24", b+14, c-2, f, 0, 0)
	draw.SimpleText( math.floor(d).."%", "Trebuchet24", (b+40+(string.len(a)*6))-(string.len(math.floor(d).."%")*4)+(e/5)+1, c+38+(e/5)+1, Color(0, 0, 0, 255), 0, 0)
	draw.SimpleText( math.floor(d).."%", "Trebuchet24", (b+40+(string.len(a)*6))-(string.len(math.floor(d).."%")*4)+(e/5), c+38+(e/5), f, 0, 0)
	if (d > 0) then
		addhudbar_HalfRound( 40, 2.6, 2.6+(3.4*(d/100)), b+40+(string.len(a)*6.7), c+47, f )
	end
end

local function addhudbar_RoundD( a, b, c, e, f ) -- work on this idea has a lot to give and will make the pixelason disapear
	local d = 360*(b/100)
	local texture = surface.GetTextureID("hud/circle1d_a")
	for i=0, d do
	   surface.SetTexture(texture)
	   surface.SetDrawColor(c[1],c[2],c[3],255)
	   surface.DrawTexturedRectRotated(e,f,a,a,i)
	end
 end

--hook.Add( "HUDPaint", "Draw_hud_main", function()
	--addhudbar_RoundD( 256, GetServerTableValue( LocalPlayer(), "stamina" ), {0, 200, 0}, 10+((256+32)/2), 10+((256+32)/2) )
	--addhudbar_RoundD( 256+32, GetServerTableValue( LocalPlayer(), "hunger" ), {200, 200, 0}, 10+((256+32)/2), 10+((256+32)/2) )--228
	--addhudbar_TextRound( "Health", 10, 10, LocalPlayer():Health(), Color(200, 0, 0, 255) )
	--addhudbar_TextRound( "Hunger", 10, 120, GetServerTableValue( LocalPlayer(), "hunger" ), Color(0, 175, 255, 255) )
	--addhudbar_TextRound( "Stamina", 10, 230, GetServerTableValue( LocalPlayer(), "stamina" ), Color(200, 200, 0, 255) )
	--addhudbar_HalfRound( 400, 1, 2*(GetServerTableValue( LocalPlayer(), "hunger" )/100), 200, 200, 0 )
	--addhudbar_HalfRound( 150+15, 1, 2*(GetServerTableValue( LocalPlayer(), "stamina" )/100), 100, 100, 200 )
	--addhudbar_HalfRound( 150+30, 1, 2*(LocalPlayer():Health()/100), 200, 0, 0 )
--end)

hook.Add( "HUDShouldDraw", "Hide_hud", function( name )
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end)
