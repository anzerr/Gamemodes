
local ModelTable1 = { "models/player/Group01/Female_01.mdl",
                          "models/player/Group01/Female_02.mdl",
                          "models/player/Group01/Female_03.mdl",
                          "models/player/Group01/Female_04.mdl",
                          "models/player/Group01/Female_05.mdl",
                          "models/player/Group01/female_06.mdl" }
						  
local ModelTable2 = { "models/player/Group01/male_01.mdl",
                          "models/player/Group01/male_02.mdl",
                          "models/player/Group01/male_03.mdl",
                          "models/player/Group01/male_04.mdl",
                          "models/player/Group01/male_05.mdl",
                          "models/player/Group01/male_06.mdl",
                          "models/player/Group01/male_07.mdl",
                          "models/player/Group01/male_08.mdl",
                          "models/player/Group01/male_09.mdl" }
						  
function Player_RandomPlayerModel( ply, a )
	if ( a == 1 ) then
		ply:SetModel( table.Random( ModelTable1 ) )
	else
		ply:SetModel( table.Random( ModelTable2 ) )
	end
end
