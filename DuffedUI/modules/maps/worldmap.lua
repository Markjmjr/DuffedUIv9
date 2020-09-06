local D, C, L = unpack(select(2, ...))

local _G = _G
local WorldMap = CreateFrame('Frame', 'BackdropTemplate')
local fontflag = 'THINOUTLINE'
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
-- /dump C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit('player'), 'player'):GetXY()
-- /dump C_Map.GetBestMapForUnit('player')

function WorldMap:AddMoving()
	WorldMap.MoveButton = CreateFrame("Frame", nil, WorldMapFrame)
	WorldMap.MoveButton:SetSize(16, 16)
	WorldMap.MoveButton:SetPoint("TOPRIGHT", WorldMapFrameCloseButton, -55, -10)
	WorldMap.MoveButton:SetFrameLevel(WorldMapFrameCloseButton:GetFrameLevel())
	WorldMap.MoveButton:EnableMouse(true)
	WorldMap.MoveButton:RegisterForDrag("LeftButton")
	
	WorldMap.MoveButton.Texture = WorldMap.MoveButton:CreateTexture(nil, 'OVERLAY')
	WorldMap.MoveButton.Texture:SetSize(16, 16)
	WorldMap.MoveButton.Texture:SetPoint("CENTER")
	WorldMap.MoveButton.Texture:SetTexture([[Interface\CURSOR\UI-Cursor-Move]])

	WorldMapFrame:SetMovable(true)
	WorldMapFrame:SetUserPlaced(true)

	WorldMap.MoveButton:SetScript("OnDragStart", function(self) WorldMapFrame:StartMoving() end)
	WorldMap.MoveButton:SetScript("OnDragStop", function(self)
		WorldMapFrame:StopMovingOrSizing()

		local A1, P, A2, X, Y = WorldMapFrame:GetPoint()
		local Data = DuffedUIDataPerChar['Move']

		Data.WorldMapPosition = {A1, "UIParent", A2, X, Y}
	end)
end

function WorldMap:Coords()
	local coords = CreateFrame('Frame', 'CoordsFrame', WorldMapFrame)
	local fontheight = 11 * 1.1
	coords:SetFrameLevel(90)
	coords:FontString('PlayerText', C['media']['font'], fontheight, fontflag)
	coords:FontString('MouseText', C['media']['font'], fontheight, fontflag)
	coords.PlayerText:SetTextColor(235 / 255, 245 / 255, 0 / 255)
	coords.PlayerText:SetText('Player: x, x')
	coords.PlayerText:SetPoint('TOPLEFT', WorldMapFrame.ScrollContainer, 'TOPLEFT', 5, -25)
	coords.MouseText:SetTextColor(235 / 255, 245 / 255, 0 / 255)
	coords.MouseText:SetText('Cursor: x, x')
	coords.MouseText:SetPoint('TOPLEFT', WorldMapFrame.ScrollContainer, 'TOPLEFT', 5, -40)
	
	local int = 0
	WorldMapFrame:HookScript('OnUpdate', function(self, elapsed)
		int = int + 1
		if int >= 3 then
			local UnitMap = C_Map_GetBestMapForUnit('player')
			--local position = C_Map_GetPlayerMapPosition(UnitMap, 'player')
			local x, y = 0, 0

			if not C_Map_GetPlayerMapPosition(UnitMap, 'player') then
			--if not position then
				coords.PlayerText:SetText(PLAYER..': x, x')
				return
			end
			
			if UnitMap then
				local GetPlayerMapPosition = C_Map_GetPlayerMapPosition(UnitMap, 'player')
				if GetPlayerMapPosition then x, y = C_Map_GetPlayerMapPosition(UnitMap, 'player'):GetXY() end
			end		
			x = math.floor(100 * x)
			y = math.floor(100 * y)
			if x ~= 0 and y ~= 0 then coords.PlayerText:SetText(PLAYER..': '..x..', '..y) else coords.PlayerText:SetText(' ') end

			local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
			if x and y and x >= 0 and y >= 0 then
				coords.MouseText:SetFormattedText('Cursor: %.2f, %.2f', x * 100, y * 100)
			else
				coords.MouseText:SetText(' ')
			end
			int = 0
		end
	end)
end

function WorldMap:Enable()
	local SmallerMap = GetCVarBool('miniWorldMap')

	if not SmallerMap then
		ToggleWorldMap()
		SetCVar("miniWorldMap", 1)
		ToggleWorldMap()
	end
	self:AddMoving()
	self:Coords()
end

WorldMap:RegisterEvent('ADDON_LOADED')
WorldMap:RegisterEvent('PLAYER_ENTERING_WORLD')
WorldMap:SetScript('OnEvent', function(self, event, ...)
	WorldMap:Enable()
end)