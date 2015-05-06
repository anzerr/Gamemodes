
local function Scan( a )
	local list, directories = file.Find( a .. "/*", "lsv" )
		
	for _, b in pairs( directories ) do
		Scan( a .. "/" .. b )
	end

	if not(file.IsDir( a , "lsv")) then
		resource.AddSingleFile( a )
		MsgN( "add " .. a )
	else
		MsgN( "dir " .. a )
	end
end

hook.Add("Initialize", "Int_Doawnload_list", function()	
	local a = "NewRP/content/"
	local list, directories = file.Find( a .. "*", "lsv" )
	
	for _, f in pairs(directories) do
		Scan( a .. f )
	end
end)
