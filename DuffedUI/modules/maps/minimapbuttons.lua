local D, C, L = unpack(select(2, ...))
local Module = D:NewModule("MinimapButtons", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- Sourced: NDui (Siweia)

local _G = _G
local string_match = _G.string.match
local string_find = string.find
local table_insert = table.insert
local string_upper = _G.string.upper

local C_Timer_After = _G.C_Timer.After
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local Minimap = _G.Minimap

function Module:CreateMinimapButtons()
	local r, g, b = D.r, D.g, D.b
	local buttons = {}
	local blackList = {
		["BattlefieldMinimap"] = true,
		["ButtonCollectFrame"] = true,
		["FeedbackUIButton"] = true,
		["GameTimeFrame"] = true,
		["GarrisonLandingPageMinimapButton"] = true,
		["HelpOpenTicketButton"] = true,
		["HelpOpenWebTicketButton"] = true,
		["MiniMapBattlefieldFrame"] = true,
		["MiniMapLFGFrame"] = true,
		["MiniMapMailFrame"] = true,
		["MiniMapTracking"] = true,
		["MiniMapVoiceChatFrame"] = true,
		["MinimapBackdrop"] = true,
		["MinimapZoneTextButton"] = true,
		["MinimapZoomIn"] = true,
		["MinimapZoomOut"] = true,
		["QueueStatusMinimapButton"] = true,
		["MinimapFrame"] = true,
		["MinimapToggleButton"] = true,
		["TimeManagerClockButton"] = true,
	}

	local bu = CreateFrame("Button", "MinimapToggleButton", Minimap)
	bu:SetAlpha(0.8)
	bu:SetSize(14, 14)
	bu:SetPoint("BOTTOMLEFT", -7, -7)
	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture("Interface\\COMMON\\Indicator-Gray")
	bu:SetHighlightTexture("Interface\\COMMON\\Indicator-Green")
	D['AddTooltip'](bu, "ANCHOR_LEFT", "Minimap Buttons", "white")

	local bin = CreateFrame("Frame", "Minimap Buttons", UIParent)
	bin:SetPoint("RIGHT", bu, "LEFT", -3, -6)
	bin:Hide()
	D['CreateGF'](bin, 220, 24, "Horizontal", 0, 0, 0, 0, .7)
	local topLine = CreateFrame("Frame", nil, bin)
	topLine:SetPoint("BOTTOMRIGHT", bin, "TOPRIGHT", 1, 0)
	D['CreateGF'](topLine, 220, 1, "Horizontal", r, g, b, 0, .7)
	local bottomLine = CreateFrame("Frame", nil, bin)
	bottomLine:SetPoint("TOPRIGHT", bin, "BOTTOMRIGHT", 1, 0)
	D['CreateGF'](bottomLine, 220, 1, "Horizontal", r, g, b, 0, .7)
	local rightLine = CreateFrame("Frame", nil, bin)
	rightLine:SetPoint("LEFT", bin, "RIGHT", 0, 0)
	D['CreateGF'](rightLine, 1, 24, "Vertical", r, g, b, .7, .7)
	bin:SetFrameStrata("LOW")

	local function hideBinButton() bin:Hide() end

	local function clickFunc()
		UIFrameFadeOut(bin, 0.5, 1, 0)
		C_Timer_After(0.5, hideBinButton)
	end

	local isCollecting

	local function CollectRubbish()
		if isCollecting then return end
		isCollecting = true

		for _, child in ipairs({Minimap:GetChildren()}) do
			local name = child:GetName()
			if name and not blackList[name] and not string_match(string_upper(name), "HANDYNOTES") then
				if child:GetObjectType() == "Button" or string_match(string_upper(name), "BUTTON") then
					child:SetParent(bin)
					child:SetSize(16, 16)
					for j = 1, child:GetNumRegions() do
						local region = select(j, child:GetRegions())
						if region:GetObjectType() == "Texture" then
							local texture = region:GetTexture() or ""
							if string_find(texture, "Interface\\CharacterFrame") or string_find(texture, "Interface\\Minimap") then
								region:SetTexture(nil)
							elseif texture == 136430 or texture == 136467 then
								region:SetTexture(nil)
							end
							region:ClearAllPoints()
							region:SetAllPoints()
							region:SetTexCoord(unpack(D['IconCoord']))
						end
					end

					if child:HasScript("OnDragStart") then child:SetScript("OnDragStart", nil) end

					if child:HasScript("OnDragStop") then child:SetScript("OnDragStop", nil) end

					if child:GetObjectType() == "Button" then
						child:SetHighlightTexture(C['media']['blank'])
						child:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
					elseif child:GetObjectType() == "Frame" then
						child.highlight = child:CreateTexture(nil, "HIGHLIGHT")
						child.highlight:SetAllPoints()
						child.highlight:SetColorTexture(1, 1, 1, .25)
					end

					if name == "DBMMinimapButton" then
						child:SetScript("OnMouseDown", nil)
						child:SetScript("OnMouseUp", nil)
					end

					table_insert(buttons, child)
				end
			end
		end

		isCollecting = nil
	end

	local function SortRubbish()
		if #buttons == 0 then
		bu:Hide() return end -- Hides bu if no minimap button active 

		local lastbutton
		for _, button in pairs(buttons) do
			if button:IsShown() then
				button:ClearAllPoints()
				if not lastbutton then
					button:SetPoint("RIGHT", bin, -3, 0)
				else
					button:SetPoint("RIGHT", lastbutton, "LEFT", -3, 0)
				end
				lastbutton = button
			end
		end
	end

	bu:SetScript("OnClick", function()
		SortRubbish()
		C_Timer_After(10.0, clickFunc)
		if bin:IsShown() then
			clickFunc()
		else
			UIFrameFadeIn(bin, 0.5, 0, 1)
		end
	end)

	C_Timer_After(0.3, function()
		CollectRubbish()
		SortRubbish()
	end)
end

function Module:OnEnable()
	if not C['general']['minimapbuttons'] then return end
	Module.CreateMinimapButtons()
end