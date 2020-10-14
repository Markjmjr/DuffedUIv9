local D, C, L = unpack(select(2, ...))

local _G = _G
local WorldMap = CreateFrame('Frame', 'BackdropTemplate')
local fontflag = 'THINOUTLINE'
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local IsInInstance = IsInInstance
-- /dump C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit('player'), 'player'):GetXY()
-- /dump C_Map.GetBestMapForUnit('player')

function WorldMap:AddMoving()
	if WorldMap.MoveButton then return end
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
	WorldMapFrame:SetClampedToScreen(true)

	WorldMap.MoveButton:SetScript("OnDragStart", function(self) WorldMapFrame:StartMoving() end)
	WorldMap.MoveButton:SetScript("OnDragStop", function(self)
		WorldMapFrame:StopMovingOrSizing()

		local A1, P, A2, X, Y = WorldMapFrame:GetPoint()
		local Data = DuffedUIDataPerChar['Move']

		Data.WorldMapPosition = {A1, "UIParent", A2, X, Y}
	end)
end

function WorldMap:Coords()
	if CoordsFrame then return end
	local coords = CreateFrame('Frame', 'CoordsFrame', WorldMapFrame)
	local fontheight = 11 * 1.1
	coords:SetFrameLevel(90)
	coords:FontString('PlayerText', C['media']['font'], fontheight, fontflag)
	coords:FontString('MouseText', C['media']['font'], fontheight, fontflag)
	coords.PlayerText:SetTextColor(235 / 255, 245 / 255, 0 / 255)
	coords.PlayerText:SetText('Player: x, x')
	coords.PlayerText:SetPoint('TOPLEFT', WorldMapFrame.ScrollContainer, 'TOPLEFT', 5, -5)
	coords.MouseText:SetTextColor(235 / 255, 245 / 255, 0 / 255)
	coords.MouseText:SetText('Cursor: x, x')
	coords.MouseText:SetPoint('TOPLEFT', WorldMapFrame.ScrollContainer, 'TOPLEFT', 5, -20)
	
	local int = 0
	WorldMapFrame:HookScript('OnUpdate', function(self, elapsed)
		int = int + 1
		if int >= 5 then
			
			if IsInInstance() then
				coords.PlayerText:SetText(' ')
				coords.MouseText:SetText(' ')
				return
			end
			
			if WorldMapFrame.ScrollContainer:IsMouseOver() then
				local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
				coords.MouseText:SetFormattedText('Cursor: %.2f, %.2f', x * 100, y * 100)
			else
				coords.MouseText:SetText(' ')
			end
			
			local UnitMap = C_Map_GetBestMapForUnit('player')
			if not UnitMap then
				coords.PlayerText:SetText(PLAYER..': x, x')
				return
			end
			
			local position = C_Map_GetPlayerMapPosition(UnitMap, 'player')
			if not position then
				coords.PlayerText:SetText(PLAYER..': x, x')
				return
			end
			local x, y = position.x or 0, position.y or 0
			x = math.floor(100 * x)
			y = math.floor(100 * y)
			if x ~= 0 and y ~= 0 then coords.PlayerText:SetText(PLAYER..': '..x..', '..y) else coords.PlayerText:SetText(' ') end

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

WorldMap:RegisterEvent('PLAYER_LOGIN')
WorldMap:SetScript('OnEvent', function(self, event, ...)
	WorldMap:Enable()
end)