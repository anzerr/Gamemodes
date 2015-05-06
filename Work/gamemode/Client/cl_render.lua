
local RenderTableCount = 1
local RT = {}
local RT_name = {}
local RT_cooldown = {}
local RT_data = {}
local RT_material = {}
RT_texture = {}

local OldRT = nil
local OldScrW = nil
local OldScrH = nil
local CamData = {}

local function RenderView( a, b ) 
	if ( RT[a] != nil and RT_data[a.."1"] != nil ) then
		OldRT = render.GetRenderTarget()
		OldScrW = ScrW()
		OldScrH = ScrH()

		render.SetViewPort( 0, 0, RT_data[a.."1"], RT_data[a.."1"] )
			render.SetRenderTarget( RT[a] )
				render.Clear( 0, 0, 0, 255 )

				CamData = {
					x = 0,
					y = 0,
					w = RT_data[a.."1"],
					h = RT_data[a.."1"],
					angles = RT_data[a.."2"],
					origin = RT_data[a.."3"],
					drawhud = false,
					drawviewmodel = false,
					dopostprocess = false,
					fov = 75*(RT_data[a.."4"]/100)
				}

				render.RenderView( CamData )
			render.SetRenderTarget( OldRT )
		render.SetViewPort( 0, 0, OldScrW, OldScrH )

		RT_material[a]:SetMaterialTexture( "$basetexture", RT[a] )
	end
end

local function Update_RenderTables( ) 
	for i=1, RenderTableCount do
		if ( RT_name[i] != nil and RT_cooldown[i] != nil ) then
			if (CurTime() > RT_cooldown[i] ) then
				RT_cooldown[i] = CurTime()+0.01
				RenderView( RT_name[i], i ) 
			end
		end
	end
end

function Add_RenderPoint( a, b, c, d, e )
	if ( RT[a] == nil ) then
		RT_name[RenderTableCount] = a
		RT_cooldown[RenderTableCount] = CurTime()
		RT_material[a] = Material( a )
		RT_texture[a] = surface.GetTextureID( a )
		RT[a] = GetRenderTarget( a, b, b, false )
		RT_data[a.."1"] = b
		RT_data[a.."2"] = c
		RT_data[a.."3"] = d
		RT_data[a.."4"] = e
		RenderTableCount = RenderTableCount+1
	end
end

function Update_RenderPosAng( a, b, c, d ) 
	RT_data[a.."2"] = b
	RT_data[a.."3"] = c
	RT_data[a.."4"] = d
end

Add_RenderPoint( "render/render_1", 512, Angle(0, 0, 0), Vector(0, 0, 100), 120 )
Add_RenderPoint( "render/render_2", 512, Angle(0, 0, 0), Vector(0, 0, -100), 10 )

hook.Add( "HUDPaint", "Update_all_render_textures", function()	
	Update_RenderTables( )
	radar_Scan( 3, 125, 145 )
end)
