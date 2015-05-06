
concommand.Add("rp_effect1", function( ply, cmd, args )
	local a = EffectData()
		a:SetOrigin( ply:GetPos()+Vector(0,0,90) )
		a:SetEntity( ply )
	util.Effect( "test_effect", a )
end)
