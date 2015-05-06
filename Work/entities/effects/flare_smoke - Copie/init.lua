
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin() - Vector( 0, 0, -10 )
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local size = data:GetMagnitude()

	for i=1, math.ceil( 2 ) do
		local particle = emitter:Add( "particle/particle_smokegrenade", Pos )
			particle:SetDieTime( 4 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 5*size )
			particle:SetEndSize( 10*size )
			particle:SetRoll( 10 )
			particle:SetRollDelta( 0.5 * math.random( -2, 2 ) )
		if i == 2 then	
			local a = math.random( 254, 255 )
			particle:SetColor( a, a/2, 0 )
		else	
			local a = math.random( 100, 200 )
			particle:SetColor( a, a, a )
		end
	end
	
	local particle = emitter:Add( "effects/yellowflare", Pos )
		particle:SetVelocity( Vector( math.random( -100, 100 ), math.random( -100, 100 ), math.random( 0, 100/2 ) ) )
		particle:SetGravity( Vector( math.random( -15, 15 ), math.random( -15, 15 ), math.random( 0, 15 ) ) )
		particle:SetAirResistance( 50 )
		particle:SetDieTime( math.random( 4, 6 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 10 )
		particle:SetEndSize( 0 )
		particle:SetRoll( 150 )
		particle:SetRollDelta( 0.6 * math.random( -2, 2 ) )
		particle:SetColor( 255, 125, 0 )
	emitter:Finish()
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

	
end
