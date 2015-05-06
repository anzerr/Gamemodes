Accessory_List = {}

local function AddAccessory( ent, id )
	if ( Accessory_List[ent] == nil ) then
		Accessory_List[ent] = {}
	end
	
	if ( id != "" ) then
		if ( Accessory_List[ent].Effect == nil ) then
			Accessory_List[ent].Effect = EffectData()
				Accessory_List[ent].Effect:SetOrigin( ent:GetPos() )
				Accessory_List[ent].Effect:SetEntity( ent )
				Accessory_List[ent].Kill = 1
				Accessory_List[ent].accessoryID = id
			util.Effect( "accessory_effect", Accessory_List[ent].Effect )
		end
	else
		if ( Accessory_List[v] != nil ) then
			Accessory_List[v].Kill = 0
		end
	end
end

concommand.Add("rp_add", function( ply, cmd, args )
	AddAccessory( ply, "flesh_pound" )
end)

concommand.Add("rp_remove", function( ply, cmd, args )
	for _, v in pairs(player.GetAll()) do
		if ( Accessory_List[v] != nil ) then
			Accessory_List[v].Kill = 0
		end
	end
end)
