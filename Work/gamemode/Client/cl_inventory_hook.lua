
local Client_Inventory = {}

usermessage.Hook("inventory_give_item", function( um )
	local item = um:ReadString()
	local amount = um:ReadLong()
	
	if (Client_Inventory[item]) then
		Client_Inventory[item] = Client_Inventory[item] + amount
	else
		Client_Inventory[item] = 0
		Client_Inventory[item] = Client_Inventory[item] + amount
	end
end)

usermessage.Hook("inventory_remove_item", function( um )
	local item = um:ReadString()
	local amount = um:ReadLong()
	
	if (amount == 0) then
		Client_Inventory[item] = nil
		return
	end
	
	Client_Inventory[item] = amount
end)

usermessage.Hook("inventory_saved_items", function( um )
	local item = um:ReadString()
	local amount = um:ReadLong()
	
	Client_Inventory[item] = 0
	Client_Inventory[item] = Client_Inventory[item] + amount
end)

function Set_Client_Inventory_Table()
	return Client_Inventory
end

function ClientHasItem( item, count )
	if (Client_Inventory[item] == nil) then
		return false
	end
	
	return Client_Inventory[item] >= tonumber(count)
end

--[[
hook.Add("Initialize", "inventory_createFont", function()
	surface.CreateFont("coolvetica", 24, 500, true, false, "inventory_itemFont")
end)

hook.Add("HUDPaint", "inventory_itemName", function()
	local tr = LocalPlayer():EyeTrace(100)

	if (tr.Entity:IsValid() and tr.Entity:GetClass() == "inventory_item") then
		local itemTable = Inventory.Items:GetItem(tr.Entity:GetNetworkedString("Item_ID"))
		if itemTable != nil then
			local entName = itemTable.Name
			local entAmount = tr.Entity:GetNetworkedString("Item_Amount")
			local entPos =  tr.Entity:GetPos():ToScreen()
			
			draw.DrawText(entName .. " x " .. entAmount, "inventory_itemFont", entPos.x + 2, entPos.y + 22, color_black, 1)
			draw.DrawText(entName .. " x " .. entAmount, "inventory_itemFont", entPos.x, entPos.y + 20, color_white, 1)
		end
	end
end)	

local color_black = Color(0, 0, 0, 255)
local InventoryOpen = false
local InventoryFrame = nil

local function ToggleMenu()
	InventoryOpen = !InventoryOpen
	gui.EnableScreenClicker(InventoryOpen)
	InventoryFrame:SetVisible(InventoryOpen)
end

function InventoryUseOptions()
	HiddenButton = vgui.Create("DButton")
	HiddenButton:SetSize(ScrW(), ScrH())
	HiddenButton:SetText("")
	HiddenButton:SetDrawBackground(false)
	HiddenButton:SetDrawBorder(false)
	
	HiddenButton.DoRightClick = function()
	
	local tr = LocalPlayer():EyeTrace(100)	
		if (tr.HitNonWorld) then
			local ContextMenu = DermaMenu()
				if (tr.Entity:GetClass() == "inventory_item") then
					local itemTable = Inventory.Items:GetItem(tr.Entity:GetNetworkedString("Item_ID"))
					if itemTable != nil then
						ContextMenu:AddOption("Pick Up", function() LocalPlayer():ConCommand("rp_item_pickup " .. tr.Entity:EntIndex()) end)
						if itemTable.IsAccessory != 1 then
							ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_item_use " .. tr.Entity:EntIndex()) end)
						end
					end
				end
			ContextMenu:Open()
		end
	end
end

local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 400)
	self:Center()
	self:SetTitle("Inventory ( F4 toggle )")
	self:ShowCloseButton(false)
	
	self.panelList = vgui.Create("DPanelList", self)
	self.panelList:SetPos(3, 25)
	self.panelList:SetSize(self:GetWide() - 6, self:GetTall() - 28)
	self.panelList:SetSpacing(2)
	self.panelList:SetPadding(4)
	self.panelList:EnableVerticalScrollbar(true)
	self.panelList:EnableHorizontal(true)
end

function PANEL:Update()
	if (self.panelList:GetItems() != nil) then
		self.panelList:Clear()
	end
	
	for k, v in pairs(Client_Inventory) do
		local itemTable = Inventory.Items:GetItem(k)

		local entFilthyHack = ents.Create("prop_physics")
		entFilthyHack:SetAngles(Angle( 0, 0, 0 ))
		entFilthyHack:SetPos(Vector( 0, 0, 0 ))
		entFilthyHack:SetModel(itemTable.Model)
		entFilthyHack:Spawn()
		
		local bgCol = Color(10, 10, 10, 255)
		local backgroundPanel = vgui.Create("DPanel")
		backgroundPanel:SetSize(55, 55)
		backgroundPanel.Paint = function()
			draw.RoundedBox(6, 0, 0, backgroundPanel:GetWide(), backgroundPanel:GetTall(), bgCol)
			draw.RoundedBox(6, 1, 1, backgroundPanel:GetWide() - 2, backgroundPanel:GetTall() - 2, Color(100, 100, 100, 200))
		end
	
		local Icon = vgui.Create("DModelPanel", backgroundPanel)
		Icon:SetSize(55, 55)
		Icon:SetModel(itemTable.Model)
		Icon:SetToolTip("Name: " .. itemTable.Name .. "\nInfo: " .. itemTable.Info .. "\nCount: " .. v)
		
		local entCenter = entFilthyHack:OBBCenter()
		local entDist = entFilthyHack:BoundingRadius() * 1.2
		
		Icon:SetLookAt(entCenter)
		Icon:SetCamPos(entCenter + Vector(entDist, entDist, entDist))
		
		Icon.DoRightClick = function()
			local Menu = DermaMenu()
				if (itemTable.dropAble == 1) then
					if (itemTable.IsAccessory == 1) then
						Menu:AddOption("Activate", function() LocalPlayer():ConCommand("rp_item_use_accessory " .. k) ToggleMenu() end)
					end
					Menu:AddOption("Drop", function() LocalPlayer():ConCommand("rp_item_drop " .. k) ToggleMenu() end)
				end
			Menu:Open()
		end
		
		Icon.OnCursorEntered = function()
			bgCol = Color(80, 80, 80, 255)
		end
		
		Icon.OnCursorExited = function()
			bgCol = Color(10, 10, 10, 255)
		end
		
		entFilthyHack:Remove()
		
		self.panelList:AddItem(backgroundPanel)
	end
end
vgui.Register("derma_inventory", PANEL, "DFrame")

InventoryUseOptions()
]]

concommand.Add("rp_inventory", function( um )
	InventoryMenu_draw( Client_Inventory )
end)

--[[
function GM:ScoreboardShow()
	gui.EnableScreenClicker(true)
end

function GM:ScoreboardHide()
	gui.EnableScreenClicker(false)
end
]]