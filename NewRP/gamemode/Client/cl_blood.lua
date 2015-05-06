Blood = {}
Blood_Scale = {}
Blood_Cur = {}
Blood_Drop_Cur = {}
Bleed = {}
Blood_Effect_List = {}
	--Blood[Vector(100, 100, 100)] = LocalPlayer()
	--Blood_Scale[Vector(100, 100, 100)] = 1
	--Bleed[LocalPlayer()] = 10
	--Blood_Cur[Vector(100, 100, 100)] = 60*5

Step = {}
Last_Step = {}
Step_Effect_List = {}
Step_Side = {}

MaxDrawDistance = 1500
BloodFloorPos = nil

Blood_Settings = {}
Blood_Settings["DrawRange"] = 1500
Blood_Settings["MaxFps"] = 60
Blood_Settings["EffectLife"] = 60*5
Blood_Settings["Texture"] = surface.GetTextureID("effect/Blood")
Blood_Settings["L"] = surface.GetTextureID("effect/Blood_printR")
Blood_Settings["R"] = surface.GetTextureID("effect/Blood_printL")

local ThinkCur = 0
local DrawDistanceCur = 0

local function GetSpeed( a )
	if a:KeyDown( IN_DUCK ) then
		if a:KeyDown( IN_WALK ) then
			return a:GetWalkSpeed()*a:GetCrouchedWalkSpeed()
		else
			return a:GetWalkSpeed()
		end
	elseif a:KeyDown( IN_WALK ) then
		return a:GetWalkSpeed()
	elseif a:KeyDown( IN_SPEED ) then
		return a:GetRunSpeed()
	else
		return (a:GetRunSpeed()+a:GetWalkSpeed())/2
	end
end

function Blood_GetFloor( a )
	if ( BloodFloorPos == nil ) then
		local tr = {}
		tr.start = a + Vector( 0, 0, 20 )
		tr.endpos = tr.start + Vector( 0, 0, -500 )
		tr.filter = table.Add( ents.GetAll(), player.GetAll() )
		tr = util.TraceLine(tr)
		if tr.HitWorld then
			BloodFloorPos = tr.HitPos.z
		end
	end
end

function AddBlood( c, d )
	local pos = Vector(0, 0, 0)
	local ticked = false
	local scale = math.min(1, Bleed[c]/100)
	
	for e, f in pairs(Blood) do
		local num = Blood_Scale[e] or 0
		if ( e:Distance( c:GetPos() ) < 50*math.max( 0.1, num ) ) then 
			pos = e
			ticked = true
		end
	end
		
	if ( ticked == false ) then 
		pos = c:GetPos() 
	end
	
	if ( Blood_Scale[pos] == nil ) then
		Blood_Scale[pos] = (math.random( 1, 3 )/10)*scale
	end
	Blood_Scale[pos] = math.min(Blood_Scale[pos]+(0.0125*scale), 1.5)
	
	if ( Blood_Effect_List[pos] == nil ) then
		Blood_Effect_List[pos] = EffectData()
			Blood_Effect_List[pos]:SetOrigin( pos )
			Blood_Effect_List[pos]:SetEntity( c )
			Blood[pos] = c
			Blood_Cur[pos] = Blood_Settings["EffectLife"]*scale
		util.Effect( "blood_pool", Blood_Effect_List[pos] )
	end
	
	Bleed[c] = Bleed[c]-1
end

function AddStep( a, b )
	if a:OnGround() then
		if ( Step[a] == nil ) then
			Step[a] = 0
		end
		
		if ( Last_Step[a] == nil ) then
			Last_Step[a] = a:GetPos()
		end
		
		local speed = GetSpeed( a )/5
		local pos = a:GetPos()
		local num = Blood_Scale[b] or 0
		if ( b:Distance( pos ) < 50*math.max( 0.1, num ) ) then 
			if Step[a] < (num*30) then
				Step[a] = math.min( 100, Step[a]+(num*30) )
			end
		end

		if ( Last_Step[a]:Distance( pos ) > speed and Step[a] > 0 ) then 
			Blood_Effect_List[pos] = EffectData()
				Blood_Effect_List[pos]:SetOrigin( pos )
				Blood_Effect_List[pos]:SetEntity( a )
				Last_Step[a] = pos
				Blood_Cur[pos] = Blood_Settings["EffectLife"]*math.max( 0.2, math.min( 1, Step[a]/100))
				if ( Step_Side[a] == "R" ) then Step_Side[a] = "L" else Step_Side[a] = "R" end
			util.Effect( "blood_print", Blood_Effect_List[pos] )
			
			Step[a] = Step[a]-1
		end
	end
end

hook.Add( "Think", "Think_Check_Breath", function( )
	if ( ThinkCur+0.1 < CurTime() ) then
		ThinkCur = CurTime()
		local pos = Vector(0, 0, 0)
		
		for pos, ply in pairs(Blood) do
			if ( Blood_Scale[pos] != nil ) then
				for _, ent in pairs( player.GetAll() ) do
					if ( ent:Alive() ) then
						AddStep( ent, pos )
					end
				end
			end
		end
		
		for a, b in pairs(Bleed) do -- a = ply b = size
			if ( b > 0 ) then
				if ( Blood_Drop_Cur[a] == nil ) then
					Blood_Drop_Cur[a] = 0
				end
			
				if ( Blood_Drop_Cur[a]+math.max(0.1, 0.1/(Bleed[a]/100)) < CurTime() ) then
					Blood_Drop_Cur[a] = CurTime()
					AddBlood( a, b )
				end
			end
		end
	end
	
	if ( DrawDistanceCur+0.5 < CurTime() ) then
		DrawDistanceCur = CurTime()
		Blood_GetFloor( LocalPlayer():GetPos() )
		local a = (Blood_Settings["DrawRange"]/Blood_Settings["MaxFps"])*math.min( Blood_Settings["MaxFps"], math.floor(1 / FrameTime()))
		if ( a < MaxDrawDistance ) then
			MaxDrawDistance = math.max( 100, MaxDrawDistance-10)
		else
			MaxDrawDistance = math.min( 1500, MaxDrawDistance+10)
		end
	end
end)

net.Receive( "SendBlood", function(len)    
    MsgN("Test2: Contains "..len.." bits") 

    local a = net.ReadTable()
 
    for k, v in pairs(a) do
		Bleed[k] = v
	end
end)

concommand.Add("rp_table", function( ply, cmd, args )
	MsgN(GetSpeed( ply ))
end)

concommand.Add("rp_table_rest", function( ply, cmd, args )
	for e, f in pairs(Blood) do
		Blood_Cur[e] = 0
	end
end)
