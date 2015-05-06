
	local Icon_table = {}
	local Open = false
	local List = nil
local function clear_TableIcon( a )
	for k, v in pairs( a ) do
		if (Icon_table[k] != nil) then
			Icon_table[k]:Remove()
		end
	end
end

local function len( a, b )
	surface.SetFont( a )
	local Width, Height = surface.GetTextSize( b )
	return Width
end
	
local function init_list( a, b, c, d )
	if (List == nil) then
		List = vgui.Create( "DPanelList" )
		List:SetPos( a, b )
		List:SetSize( c, d )
		List:SetSpacing( 7 )
		List:SetPadding( 7 )
		List:EnableVerticalScrollbar( true ) 
		List:EnableHorizontal( false )
		List.Paint = function()
			--surface.SetDrawColor( 0, 0, 0, 255 )
			--surface.DrawRect( 0, 0, List:GetWide(), List:GetTall() )
		end
	end
end
	
local function draw_TableIcon( a, b, c, d, e, f )
	init_list( b, c, e, f )
	
	for k, v in pairs( a ) do
		local itemTable = Inventory.Items:GetItem(k)

		Icon_table[k] = vgui.Create( "DButton" )
		List:AddItem( Icon_table[k] )
		Icon_table[k]:SetSize( len( "Trebuchet24", itemTable.Name )+len( "Trebuchet18", "x"..v )+4, d )
		Icon_table[k]:SetText( "" )
		Icon_table[k].Paint = function()
			for i=0, 1 do
				surface.SetTextColor( 255*i, 255*i, 255*i, 255 )
				surface.SetFont( "Trebuchet24" )
				surface.SetTextPos( -2*(i-1), -2*(i-1) )
				surface.DrawText( itemTable.Name )
			end
			local Width, Height = surface.GetTextSize( itemTable.Name )
				
			for i=0, 1 do
				surface.SetTextColor( 255*i, 0*i, 0*i, 255 )
				surface.SetFont( "Trebuchet18" )
				surface.SetTextPos( Width+(-1*(i-1))+3, -1*(i-1)+(Height/2) )
				surface.DrawText( "x"..v )
			end
		end
		Icon_table[k].DoClick = function()
			LocalPlayer():ConCommand( "rp_item_drop " .. k .. " 1" )
			if ( v == 1 ) then Icon_table[k]:Remove() end
			local ping = LocalPlayer():Ping()/1000
			timer.Simple( 0.05+(ping*2), function()
				clear_TableIcon( a )
				draw_TableIcon( Set_Client_Inventory_Table(), b, c, d, e )
			end)
		end
	end
end

function InventoryMenu_draw( a )
	Open = !Open
	gui.EnableScreenClicker(Open)
	clear_TableIcon( a )
	if ( List != nil ) then List:SetVisible(Open) end
	if (Open == true) then
		draw_TableIcon( a, 250, 250, 26, 250, 500 )
	end
end