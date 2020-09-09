local D, C, L = unpack(select(2, ...))

local TestUI = function(msg)
	if not DuffedUI[2].unitframes.enable then return end

	if msg == '' then
		print("'|cffc41f3barena|r' or '|cffc41f3ba|r' to show arena frames")
		print("'|cffc41f3bboss|r' or '|cffc41f3bb|r' to show boss frames")
		print("'|cffc41f3bpet|r' or '|cffc41f3bp|r' to show pet frames")
		print("'|cffc41f3bmaintank|r' or '|cffc41f3bmt|r' to show maintank frames")
		print("'|cffc41f3raidframe|r' or '|cffc41f3brf|r' to show raid frames")
	elseif msg == 'arena' or msg == 'a' then
		for i = 1, 3 do
			_G['oUF_Arena'..i]:Show()
			_G['oUF_Arena'..i].Hide = function() end
			_G['oUF_Arena'..i].unit = 'player'
			_G['oUF_Arena'..i].Trinket.Icon:SetTexture('Interface\\Icons\\INV_Jewelry_Necklace_37')
		end
	elseif msg == 'boss' or msg == 'b' then
		for i = 1, 3 do
			_G['oUF_Boss'..i]:Show()
			_G['oUF_Boss'..i].Hide = function() end
			_G['oUF_Boss'..i].unit = 'player'
		end
	elseif msg == 'pet' or msg == 'p' then
		oUF_Pet:Show()
		oUF_Pet.Hide = function() end
		oUF_Pet.unit = 'player'
	elseif msg == 'maintank' or msg == 'mt' then
		oUF_MainTank:Show()
		oUF_MainTank.Hide = function() end
		oUF_MainTank.unit = 'player'
	elseif msg == 'raidframe' or msg == 'rf' then
		
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = '/testui'

hooksecurefunc('ContainerFrame_UpdateLockedItem', function(frame,slot)
	local index = frame.size + 1 - slot
	local itemButton = _G[frame:GetName()..'Item'..index]
	if not itemButton then print(frame:GetName(),slot,index) end
end)

--[[hooksecurefunc(getmetatable(GameTooltip).__index,'Show', function(self)
	print(self:GetName() or tostring(self))
end)]]

-- Shorten framestack command
SlashCmdList["FSTACK"] = function() SlashCmdList.FRAMESTACK(0) end
_G.SLASH_FSTACK1 = "/fs"

-- Enable lua error by command
function SlashCmdList.LUAERROR(msg)
	msg = string.lower(msg)
	if (msg == "on") then
		DisableAllAddOns()
		EnableAddOn("DuffedUI")
		EnableAddOn("DuffedUI_ConfigUI")
		SetCVar("scriptErrors", 1)
		ReloadUI()
	elseif (msg == "off") then
		SetCVar("scriptErrors", 0)
		print("|cffff0000Lua errors off.|r")
	else
		print("|cffff0000/luaerror on - /luaerror off|r")
	end
end
_G.SLASH_LUAERROR1 = "/luaerror"

-- ConfigFrame
SlashCmdList["DUFFEDUI_CONFIGUI"] = function()
	if (not DuffedUIConfig) then D['Print']("Oh no! DuffedUI Config not found!") return end
	if (not DuffedUIConfigFrame) then DuffedUIConfig:CreateConfigWindow() end
	if DuffedUIConfigFrame:IsVisible() then	DuffedUIConfigFrame:Hide() else	DuffedUIConfigFrame:Show() end
end
SLASH_DUFFEDUI_CONFIGUI1 = "/config"
SLASH_DUFFEDUI_CONFIGUI2 = "/configui"
SLASH_DUFFEDUI_CONFIGUI3 = "/cfg"