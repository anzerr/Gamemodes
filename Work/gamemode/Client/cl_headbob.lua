
HeadBobAng = 0

function GM:CalcView( ply, origin, angles, fov )
	
	ply = ply or LocalPlayer()
	if( ply == nil ) then return end

	if ( IsValid( LocalPlayer() ) ) then
		if ( !ply:Alive() ) then return end
		
		if ( GetServerTableValue( ply, "drunk" ) > 0 ) then
			
			local view = { }
			view.origin = origin
			view.angles = angles
			
			HeadBobAng = HeadBobAng + 10 * FrameTime()
			
			view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng ) * ( GetServerTableValue( ply, "drunk" ) / 5 )
			view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng ) * ( GetServerTableValue( ply, "drunk" ) / 10 )
			
			return self.BaseClass:CalcView( ply, view.origin, view.angles, fov )
			
		end
			
		HeadBobAng = HeadBobAng % 360
		
		local scale = ply:GetVelocity():Length() / 300
		if ply:GetMoveType() == MOVETYPE_NOCLIP then scale = 0 end

			if ( ply:IsOnGround() and ( ply:KeyDown( IN_FORWARD ) or ply:KeyDown( IN_BACK ) or ply:KeyDown( IN_MOVERIGHT ) or ply:KeyDown( IN_MOVELEFT ) ) ) then
			
			local view = { }
			view.origin = origin
			view.angles = angles
				
			HeadBobAng = HeadBobAng + 5 * FrameTime()
			if ply:KeyDown( IN_SPEED ) then
				HeadBobAng = HeadBobAng + 6 * FrameTime()
			end
			
			view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng ) * scale -- * 0.5
			view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng ) * scale * 0.2
			view.origin.z = view.origin.z + math.sin( HeadBobAng + 90 ) * scale
					
			return self.BaseClass:CalcView( ply, view.origin, view.angles, fov )
				
			end
			
		local view = { }
		view.origin = origin
		view.angles = angles
		
		HeadBobAng = HeadBobAng + 3 * FrameTime()
		
		view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng ) * scale
		view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng ) * scale * 0.2
			view.origin.z = view.origin.z + math.sin( HeadBobAng + 90 ) * scale

		return self.BaseClass:CalcView( ply, view.origin, view.angles, fov )

	end
		
end
