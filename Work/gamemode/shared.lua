DeriveGamemode( "base" )

GM.Name 	= "Work"
GM.Author 	= "Thoron174/Balv"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

Inventory.Items = {}
Inventory.Items.Stored = {}

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

local meta = FindMetaTable( "Player" )

function meta:EyeTrace( dis )
	local tr = {}
	tr.start = self:GetShootPos()
	tr.endpos = tr.start + (self:GetCursorAimVector() * dis)
	tr.filter = self
	tr = util.TraceLine(tr)
	return tr
end
