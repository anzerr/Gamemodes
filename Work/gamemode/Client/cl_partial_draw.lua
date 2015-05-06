-- A function to draw a certain part of a texture
function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	--[[ 
		Arguments:
		x: Where is it drawn on the x-axis of your screen
		y: Where is it drawn on the y-axis of your screen
		w: How wide must the image be?
		h: How high must the image be?
		partx: Where on the given texture's x-axis can we find the image you want?
		party: Where on the given texture's y-axis can we find the image you want?
		partw: How wide is the partial image in the given texture?
		parth: How high is the partial image in the given texture?
		texw: How wide is the texture?
		texh: How high is the texture?
	]]--
	
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
		ErrorNoHalt("surface.DrawPartialTexturedRect: Missing argument!");
		
		return;
	end;

	local percX, percY = partx / texw, party / texh;
	local percW, percH = partw / texw, parth / texh;
	
	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
		}
	};
		
	surface.DrawPoly( vertexData );
end;

--[[local Scanerbackground = surface.GetTextureID("hud/radar_map")
	local Scanerbackgroundaa = surface.GetTextureID("hud/circle_full")
	local pos = { 512-126+8, 512-126+28, 17.5, 17.5 }
hook.Add( "HUDPaint", "Draw_hud_maizaeazeazeazn", function()	
	local playerpos = LocalPlayer():GetPos()
	surface.SetTexture(Scanerbackground)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawPartialTexturedRect( 100, 100, 256, 256, pos[1]+(playerpos[2]/pos[3]), pos[2]+(playerpos[1]/pos[4]), 256, 256, 1024, 1024 )
	
	surface.SetTexture(Scanerbackgroundaa)
	surface.SetDrawColor( 0, 255, 0, 255 )
	surface.DrawTexturedRectRotated( 100+126-6, 100+126-6, 12, 12, 0 )
end)

local RT = GetRenderTarget( "SomeRT", 512, 512, false )
local OldRT = nil
local OldScrW = nil
local OldScrH = nil
local RenderWidth = 512
local RenderHeight = 512

local MaterialFile = "some/blank/material" -- Make a texture that is about the size of your render target
local screenMat = Material( MaterialFile )
local screenTex = surface.GetTextureID( MaterialFile )
local OldTex = nil

local CamData = {}

local sin,cos,rad = math.sin,math.cos,math.rad
local function GeneratePoly(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end
 
local function DrawOverHead( a, b )
	OldRT = render.GetRenderTarget()
	
	OldScrW = ScrW()
	OldScrH = ScrH()
	
	render.SetViewPort( 0, 0, RenderWidth, RenderHeight )
		render.SetRenderTarget( RT )
			render.Clear( 0, 0, 0, 255 )

			CamData = {
				x = 0,
				y = 0,
				w = RenderWidth,
				h = RenderHeight,
				angles = Angle(90,LocalPlayer():EyeAngles().yaw,0),
				origin = LocalPlayer():GetPos()+Vector(0,0,500),
				drawhud = false,
				drawviewmodel = false,
				dopostprocess = false,
			}

			render.RenderView( CamData )
		render.SetRenderTarget( OldRT )
	render.SetViewPort( 0, 0, OldScrW, OldScrH )

	OldTex = screenMat:GetMaterialTexture( "$basetexture" )
	screenMat:SetMaterialTexture( "$basetexture", RT )

	surface.SetTexture( screenTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawPoly( GeneratePoly( a, b, 100, 20 ) )
	
	screenMat:SetMaterialTexture( "$basetexture", OldTex )
end

hook.Add( "HUDPaint", "TestScreen", function()
	DrawOverHead( 150, 150 )
end )]]
