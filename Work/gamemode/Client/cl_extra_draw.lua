
	local sin,cos,rad = math.sin,math.cos,math.rad
function surface.DrawCirclePoly(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end

function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
		return false
	end

	local percX, percY = partx / texw, party / texh;
	local percW, percH = partw / texw, parth / texh;

	local vertexData = {
		{ x = x, y = y, u = percX, v = percY },
		{ x = x + w, y = y, u = percX + percW, v = percY },
		{ x = x + w, y = y + h, u = percX + percW, v = percY + percH },
		{ x = x, y = y + h, u = percX, v = percY + percH }
	}
		
	surface.DrawPoly( vertexData )
end