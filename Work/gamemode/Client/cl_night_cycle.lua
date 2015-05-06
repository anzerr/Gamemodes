
	local effect
usermessage.Hook("night_cycle_effect", function( um )
	local a = um:ReadString()

	effect = (10-tonumber(a))/10
end)

hook.Add( "RenderScreenspaceEffects", "night_cycle_render_effect", function( um )
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = effect
	tab[ "$pp_colour_colour" ] = effect
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0 
 
	DrawColorModify( tab )
end)