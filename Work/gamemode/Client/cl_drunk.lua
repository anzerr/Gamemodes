
	local effect = 1
usermessage.Hook("drunk_effect", function( um )
	local a = um:ReadString()
	if (tonumber(a) > 10) then a = 10 end
	
	effect = tonumber(a)/10
end)

hook.Add( "RenderScreenspaceEffects", "drunk_render_effect", function( um )
	DrawMotionBlur( effect, 1, 0.01)
end)