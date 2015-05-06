
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin() - Vector( 0, 0, -10 )
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local size = data:GetMagnitude()

	local particle = emitter:Add( "effect/Dirt", Pos + Vector( math.random(-4*size, 4*size), math.random(-4*size, 4*size), math.random(5*size, 10*size) ) )
		particle:SetVelocity( Vector( math.random(-6*size, 6*size), math.random(-6*size, 6*size), math.random(0, 10*size) ) )
		particle:SetDieTime( 4 )
		particle:SetStartAlpha( 25 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 5*size )
		particle:SetEndSize( 10*size )
		particle:SetRoll( 10 )
		particle:SetRollDelta( 0.5 * math.random( -2, 2 ) )

	local particle = emitter:Add( "effect/Fire", Pos )
		particle:SetVelocity( Vector( math.random(-2*size, 2*size), math.random(-2*size, 2*size), math.random(0, 6*size) ) )
		particle:SetDieTime( 4 )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 7*size )
		particle:SetEndSize( 0 )
		particle:SetRoll( 10 )
		particle:SetRollDelta( 0.5 * math.random( -2, 2 ) )

	emitter:Finish()
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

	
end
