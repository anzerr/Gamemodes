
local function Scan( a, c )
	if file.IsDir(a) then
		for _, b in pairs( file.Find( a.."/*" ) ) do
			Scan( a.."/"..b, c )
		end
	else
		local d = string.gsub( a, c, "" )
		print( "adding file to Download: "..d )
		resource.AddSingleFile( d )
	end
end

hook.Add("Initialize", "Int_Doawnload_list", function()	
	local a = "../gamemodes/Work/content"
	for _, b in pairs( file.Find( a.."/*" ) ) do
		Scan( a.."/"..b, a.."/" )
	end
end)