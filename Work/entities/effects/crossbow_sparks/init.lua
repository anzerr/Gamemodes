
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin() - Vector( 0, 0, 0 )
	local Ang = data:GetAngle()
	local emitter = ParticleEmitter( data:GetOrigin() - 12*data:GetNormal() )
	local size = data:GetScale()
	
	for i=1, math.ceil( 5*size ) do
		local a = (10*size) * math.cos( (i/(5*size))*(3.14159265*2) )
		local b = (10*size) * math.sin( (i/(5*size))*(3.14159265*2) )
		local particle = emitter:Add( "effects/spark", Pos )
		particle:SetVelocity( Vector( a+math.random( -20, 20 ), b+math.random( -20, 20 ), 75 ) )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetAirResistance( 50 )
		particle:SetDieTime( 4 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 1*size )
		particle:SetEndSize( 0 )
		particle:SetRoll( 150 )
		particle:SetRollDelta( 0.6 * math.random( -2, 2 ) )
		particle:SetBounce( 1 )
		particle:SetCollide( true )
	end

end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end
