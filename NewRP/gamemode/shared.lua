DeriveGamemode( "base" )

GM.Name 	= "NewRP"
GM.Author 	= "Thoron174"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local meta = FindMetaTable( "Player" )

function meta:EyeTrace( dis )
	local tr = {}
	tr.start = self:GetShootPos()
	tr.endpos = tr.start + (self:GetAimVector() * dis)
	tr.filter = self
	tr = util.TraceLine(tr)
	return tr
end
