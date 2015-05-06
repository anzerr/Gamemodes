
function SpawnPlants( pos )
	local tr = {}
	tr.start = pos
	tr.endpos = tr.start + Vector( 0, 0, -250 )
	tr.filter = self
	tr = util.TraceLine(tr)
	
	local entItem = ents.Create("farm_plant")
	entItem:SetPos( tr.HitPos )
	entItem.PlantID = "melon"
	entItem:Spawn()
end

	local Row = 5
	local PlantCount = 35
	local PlantSize = 150
	local StartPos = Vector( -400, -700, 0 ) 
hook.Add("InitPostEntity", "Int_Spawn_Plants", function()	
	local entItem = ents.Create("farm_bucket")
		entItem:SetPos( StartPos+Vector( -100, -100, -100 ) )
		entItem:Spawn()
		
	for i=0, PlantCount-1 do 
		x = math.floor(i/5)
		z = (i*PlantSize)-(x*(PlantSize*Row))
		SpawnPlants( StartPos + Vector( PlantSize*x, z, 0 ) )
	end
end)
