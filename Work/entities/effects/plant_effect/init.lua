
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin() - Vector( 0, 0, 0 )
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local Max = math.random( 25, 50 )
	
	for i=1, math.ceil( 40 ) do
		local particle = emitter:Add( "effect/leaf" .. math.random(1,3), Pos )
		particle:SetVelocity( Vector( math.random( -Max, Max ), math.random( -Max, Max ), math.random( 0, Max/2 ) ) )
		particle:SetGravity( Vector( math.random( -15, 15 ), math.random( -15, 15 ), math.random( 0, 15 ) ) )
		particle:SetAirResistance( 50 )
		particle:SetDieTime( math.random( 4, 6 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 10 )
		particle:SetEndSize( 0 )
		particle:SetRoll( 150 )
		particle:SetRollDelta( 0.6 * math.random( -2, 2 ) )
	end
	
	for i=1, math.ceil( 20 ) do
		local particle = emitter:Add( "particle/particle_smokegrenade", Pos )
		particle:SetVelocity( Vector( math.random( -Max, Max ), math.random( -Max, Max ), math.random( 0, Max ) ) )
		particle:SetGravity( Vector( math.random( -5*i, 5*i ), math.random( -5*i, 5*i ), 10*i ) )
		particle:SetAirResistance( 200 )
		particle:SetDieTime( math.random( 4, 6 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 0 )
		particle:SetEndSize( math.random( 50, 100 ) )
		particle:SetRoll( 150 )
		particle:SetRollDelta( 0.6 * math.random( -2, 2 ) )
		
		if math.random( 0, 1 ) == 1 then
			local Pcolor = math.random( 75, 150 )
			particle:SetColor( Pcolor, Pcolor, Pcolor/2.5 )
		else
			local Pcolor = math.random( 50, 100 )
			particle:SetColor( Pcolor, Pcolor/1.125, Pcolor/2.25 )	
		end
	end

end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end
