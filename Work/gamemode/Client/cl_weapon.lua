
local weapon = FindMetaTable("Weapon")

function weapon:SetIronSights( a, b, c, d, e )
	a = a + d.x * b:Right()
	a = a + d.y * b:Forward()
	a = a + d.z * b:Up()
	b:RotateAroundAxis( b:Right(), e.p )
	b:RotateAroundAxis( b:Up(), e.y )
	b:RotateAroundAxis( b:Forward(), e.r )
		
	if (not self.IronSightsPos) then return a, b end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - c) then
		return a, b
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - c) then
		Mul = math.Clamp((CurTime() - fIronTime) / c, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		b = b * 1
		b:RotateAroundAxis( b:Right(), self.IronSightsAng.x * Mul )
		b:RotateAroundAxis( b:Up(), self.IronSightsAng.y * Mul )
		b:RotateAroundAxis( b:Forward(), self.IronSightsAng.z * Mul )
	end

	a = a + Offset.x * b:Right() * Mul
	a = a + Offset.y * b:Forward() * Mul
	a = a + Offset.z * b:Up() * Mul
	
	return a, b
end

function weapon:AddZoomedScope( a, b, c, d )
	local m = self.Owner:GetViewModel()
	local mt = m:GetBoneMatrix( a )

	if mt then
		local ps=mt:GetTranslation()
		local an=mt:GetAngle()
		an:RotateAroundAxis(an:Right(),90)

		ps = ps + b.x * an:Right()
		ps = ps + b.y * an:Forward()
		ps = ps + b.z * an:Up()
		
		local eyeang = self.Owner:GetAimVector():Angle()
		local right = eyeang:Right()
		local up = eyeang:Up()  
		Update_RenderPosAng( "render/render_2", self.Owner:GetAngles()-Angle(0, 0, 90), self.Owner:GetShootPos()+right*2-up*2, d )

		cam.Start3D2D( ps+an:Forward()*7, Angle(an.p-90, an.y, 0), 0.3 )
			surface.SetTexture( RT_texture[ "render/render_2" ] )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawPoly( surface.DrawCirclePoly( 0, 0, c, 20 ) )
			
			surface.SetTexture( self.swepScopeTexutre )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRectRotated( 0, 0, c*2, c*2, (360/24)*(d-1) )
			--surface.DrawPoly( surface.DrawCirclePoly( 0, 0, c, 20 ) )
		cam.End3D2D()
	end
end

function weapon:AddAmmoCount( a, b, c, d, e, f )
	local m = self.Owner:GetViewModel()
	local mt = m:GetBoneMatrix( a )

	if mt then
		local ps=mt:GetTranslation()
		local an=mt:GetAngle()
		an:RotateAroundAxis(an:Right(),90)

		ps = ps + b.x * an:Right()
		ps = ps + b.y * an:Forward()
		ps = ps + b.z * an:Up()
		
		an:RotateAroundAxis( an:Up(), c.p )
		an:RotateAroundAxis( an:Forward(), c.y )
		an:RotateAroundAxis( an:Right(), c.r )
		
		cam.Start3D2D( ps+an:Forward()*7, an, 0.1 )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, d, d )
				local h = 510*(f/100)
				surface.SetTexture( self.texture1 )
				surface.SetDrawColor( math.min(h, 255), math.min(510-h, 255), 0, 75 )
				surface.DrawTexturedRectRotated( d/2, d/2, d, d, 0 )
			
			surface.SetTextColor( 0, 0, 0, 255 )
			surface.SetFont( "Trebuchet18" )
			local Width, Height = surface.GetTextSize( e )
			surface.SetTextPos( (d-Width)/2, (d-Height)/2 )
			surface.DrawText( e )	

			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetFont( "Trebuchet18" )
			local Width, Height = surface.GetTextSize( e )
			surface.SetTextPos( (d-Width)/2-1, (d-Height)/2-1 )
			surface.DrawText( e )			
		cam.End3D2D()
	end
end

function weapon:InitPropOnWeapon( a )
	self.DrawProp = {}
	
	local mdl = self.Owner:GetViewModel()
	for k, v in pairs( a ) do
		self.DrawProp[k] = ClientsideModel( v.model, RENDERGROUP_OPAQUE)
		if ( v.skin != nil ) then self.DrawProp[k]:SetMaterial( v.skin ) end
		self.DrawProp[k]:SetModelScale( v.scale )
		self.DrawProp[k]:SetNoDraw(true)
		self.DrawProp[k]:SetOwner(mdl)
		self.DrawProp[k]:SetParent(mdl)
		self.DrawProp[k].angle = v.angle
		self.DrawProp[k].pos = v.pos
		self.DrawProp[k].Color = Color(255, 255, 255, 255)
	end
end

function weapon:SetColorOnWeapon( a, b )
	self.DrawProp[a].Color = Color(b[1], b[2], b[3], b[4])
end

function weapon:UpdateAllProp( )
	for i=0, self:GetBoneCount()-1 do
		if ( self.DrawProp[i] != nil) then
			local m = self.Owner:GetViewModel()
			local mt = m:GetBoneMatrix(i)
		
			if mt then
				local ps=mt:GetTranslation()
				local an=mt:GetAngle()
				an:RotateAroundAxis(an:Right(),90)
				local b = self.DrawProp[i].pos
					ps = ps + b.x * an:Right()
					ps = ps + b.y * an:Forward()
					ps = ps + b.z * an:Up()
					
				self.DrawProp[i]:SetPos( ps+an:Forward()*7 )
				an:RotateAroundAxis( an:Up(), self.DrawProp[i].angle.p )
					an:RotateAroundAxis( an:Forward(), self.DrawProp[i].angle.y )
					an:RotateAroundAxis( an:Right(), self.DrawProp[i].angle.r )
				self.DrawProp[i]:SetAngles( an )
				local c = self.DrawProp[i].Color
				render.SetColorModulation(c.r/255, c.g/255, c.b/255)
                render.SetBlend(c.a/255)
				self.DrawProp[i]:DrawModel()
                render.SetBlend(1)
                render.SetColorModulation(1, 1, 1)
			end
		end
	end
end

function weapon:SetBoneScale( )
	self.BuildViewModelBones = function( s )
		if LocalPlayer():GetActiveWeapon() == self and self.ViewBoneScale then
			for k, v in pairs( self.ViewBoneScale ) do
				local m = s:GetBoneMatrix(k)
				if (!m) then continue end
				m:Scale(v)
				s:SetBoneMatrix(k, m)
			end
		end
	end
end

function weapon:UpdateBoneScale( )
	local vm = self.Owner:GetViewModel()
	if !ValidEntity(vm) then return end
	
	if vm.BuildBonePositions ~= self.BuildViewModelBones then
		vm.BuildBonePositions = self.BuildViewModelBones
	end
end

function weapon:CrossBow_FullHeat( a, b, c )
	--[[local m = self.Owner:GetViewModel()
	local mt = m:GetBoneMatrix(a)
	local random = math.random( 12.5, 37.5 )
	
	if mt then
		local ps=mt:GetTranslation()
		local an=mt:GetAngle()
		an:RotateAroundAxis(an:Right(),90)
			ps = ps + b.x * an:Right()
			ps = ps + b.y * an:Forward()
			ps = ps + b.z * an:Up()
			
		if (  random >= 34 ) then
			print(1)
			local effect = EffectData()
				effect:SetOrigin( ps+an:Forward()*7 )
				effect:SetAngle( Angle(an.p-90, an.y, an.r) )
				effect:SetScale( (random/2)-16 )
			util.Effect( c, effect )
		end
	end
	]]
	self.Owner:EmitSound("weapons/physcannon/superphys_small_zap"..math.random( 1, 4 )..".wav", math.random( 12.5, 37.5 ), 100)
end