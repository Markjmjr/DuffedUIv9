local D, C, L = unpack(select(2, ...))

-- Modified Script from Tukui T16
-- Credits got to Tukz & Hydra
local _G = _G
local WorldMap = CreateFrame('Frame', 'BackdropTemplate')
local fontflag = 'THINOUTLINE'

WorldMap.QuestTexts = {
	QuestInfoTitleHeader,
	QuestInfoDescriptionHeader,
	QuestInfoObjectivesHeader,
	QuestInfoRewardsFrame.Header,
	QuestInfoDescriptionText,
	QuestInfoObjectivesText,
	QuestInfoGroupSize,
	QuestInfoRewardText,
	QuestInfoRewardsFrame.ItemChooseText,
	QuestInfoRewardsFrame.ItemReceiveText,
	QuestInfoRewardsFrame.SpellLearnText,
	QuestInfoRewardsFrame.PlayerTitleText,
	QuestInfoRewardsFrame.XPFrame.ReceiveText,
}

function WorldMap:ColorQuestText()
	for _, Text in pairs(WorldMap.QuestTexts) do Text:SetTextColor(1, 1, 1) end

	local Objectives = QuestInfoObjectivesFrame.Objectives

	for i = 1, #Objectives do
		local Objective = _G['QuestInfoObjective'..i]
		local Completed = select(3, GetQuestLogLeaderBoard(i))

		if Completed then Objective:SetTextColor(0, 1, 0) else Objective:SetTextColor(1, 0, 0) end
	end
end

function WorldMap:SkinReward(i)
	local Reward = _G[self:GetName()..'QuestInfoItem'..i]
	local Texture = Reward.Icon:GetTexture()

	Reward:StripTextures()
	Reward:StyleButton()
	Reward:CreateBackdrop()
	Reward.Icon:SetTexture(Texture)
	Reward.backdrop:ClearAllPoints()
	Reward.backdrop:SetOutside(Reward.Icon)
	Reward.Icon:SetTexCoord(unpack(D['IconCoord']))
end

function WorldMap:Skin()
	local Map = WorldMapFrame
	local QuestScroll = QuestScrollFrame
	local Navigation = WorldMapFrame.NavBar
	local TutorialButton = WorldMapFrame.BorderFrame.Tutorial
	local ViewAllButton = QuestScrollFrame.ViewAll
	local BackButton = QuestMapFrame.DetailsFrame.BackButton
	local AbandonButton = QuestMapFrame.DetailsFrame.AbandonButton
	local ShareButton = QuestMapFrame.DetailsFrame.ShareButton
	local TrackButton = QuestMapFrame.DetailsFrame.TrackButton
	local ScrollBar = QuestScrollFrame.ScrollBar
	local Title = WorldMapFrameTitleText
	local CloseButton = WorldMapFrameCloseButton
	local SizeButton = WorldMapFrameSizeUpButton
	local RewardsInfo = MapQuestInfoRewardsFrame
	local Money = MapQuestInfoRewardsFrame.MoneyFrame
	local XP = MapQuestInfoRewardsFrame.XPFrame
	local QuestBackground = QuestScrollFrame.Background
	local StoryTooltip = QuestScrollFrame.StoryTooltip

	Map:StripTextures()
	Map:CreateBackdrop()
	Map.backdrop:ClearAllPoints()
	Map.backdrop:Size(701, 470)
	Map.backdrop:Point('TOPLEFT', 0, -66)
	Map.BorderFrame:Kill()
	Map.Header = CreateFrame('Frame', nil, Map, 'BackdropTemplate')
	Map.Header:Size(Map.backdrop:GetWidth(), 23)
	Map.Header:SetPoint('BOTTOMLEFT', Map.backdrop, 'TOPLEFT', 0, 2)
	Map.Header:SetTemplate()
	WorldMapFrame.BorderFrame:StripTextures()
	WorldMapFrame.NavBar:StripTextures() 
	WorldMapFrame.NavBar.overlay:StripTextures()

	WorldMapFrameHomeButton:SkinButton()
	WorldMapFrameHomeButton:SetFrameLevel(1)

	QuestMapFrame.DetailsFrame:StripTextures()
	QuestMapFrame.DetailsFrame.RewardsFrame:StripTextures()
	QuestMapFrame.DetailsFrame.CompleteQuestFrame:StripTextures()
	QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:StripTextures()
	QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:SkinButton()
	QuestMapFrame:StripTextures()
	StoryTooltip:StripTextures()
	StoryTooltip:SetTemplate('Transparent')

	QuestScrollFrame:SetTemplate('Transparent')
	QuestScrollFrame:ClearAllPoints()
	QuestScrollFrame:Size(299, 486)
	QuestScrollFrame:SetPoint('LEFT', Map.backdrop, 'RIGHT', 2, 13)
	QuestScrollFrame.Contents:Size(295, 491)
	QuestScrollFrame.Contents.StoryHeader:StripTextures()
	QuestScrollFrame.Contents.StoryHeader:SetTemplate('Transparent')
	QuestScrollFrame.DetailFrame.TopDetail:Hide()
	QuestScrollFrame.DetailFrame.BottomDetail:Hide()

	QuestScrollFrame.ScrollBar:StripTextures()
	QuestScrollFrame.ScrollBar:SkinScrollBar()
	QuestMapFrame.Background:SetAlpha(0)
	QuestMapFrame.DetailsFrame:CreateBackdrop()
	QuestMapFrame.DetailsFrame.backdrop:SetAllPoints(QuestScroll.backdrop)
	QuestMapFrame.DetailsFrame.backdrop:SetTemplate('Transparent')
	QuestMapFrame.DetailsFrame.backdrop:ClearAllPoints()
	QuestMapFrame.DetailsFrame.backdrop:Size(299, 470)
	QuestMapFrame.DetailsFrame.backdrop:SetPoint('LEFT', Map.backdrop, 'RIGHT', 2, 0)
	QuestMapDetailsScrollFrame.ScrollBar:SkinScrollBar()

	BackButton:SkinButton()
	BackButton:ClearAllPoints()
	BackButton:SetPoint('LEFT', Map.Header, 'RIGHT', 2, 0)
	BackButton:Size(299, 23)
	AbandonButton:StripTextures()
	AbandonButton:SkinButton()
	AbandonButton:ClearAllPoints()
	AbandonButton:SetPoint('BOTTOMLEFT', QuestMapFrame.DetailsFrame.backdrop, 'BOTTOMLEFT', 3, 3)
	ShareButton:StripTextures()
	ShareButton:SkinButton()
	TrackButton:StripTextures()
	TrackButton:SkinButton()

	QuestModelScene:SetTemplate('Transparent')

	-- Quests Buttons
	for i = 1, 2 do
		local Button = i == 1 and WorldMapFrame.SidePanelToggle.OpenButton or WorldMapFrame.SidePanelToggle.CloseButton
		local Text = (i == 1 and ' ->') or ('<- ')

		Button:ClearAllPoints()
		Button:SetPoint('BOTTOMRIGHT', 0, 0)
		Button:Size(32, 32)
		Button:StripTextures()
		Button:SetTemplate('Transparent')
		Button:SkinButton()
		Button:FontString('Text', C['media']['font'], 11, fontflag)
		Button.Text:SetPoint('CENTER')
		Button.Text:SetText(Text)
	end

	Navigation:Hide()
	Title:ClearAllPoints()
	Title:SetPoint('CENTER', Map.Header)
	TutorialButton:Kill()

	CloseButton:StripTextures()
	CloseButton:ClearAllPoints()
	CloseButton:SetPoint('RIGHT', Map.Header, 'RIGHT', 8, -1)
	CloseButton:SkinCloseButton()
	WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:SkinMaxMinFrame()

	ScrollBar:Hide()

	Money:StripTextures()
	Money:CreateBackdrop()
	Money.Icon:SetTexture('Interface\\Icons\\inv_misc_coin_01')
	Money.Icon:SetTexCoord(unpack(D['IconCoord']))
	Money.backdrop:ClearAllPoints()
	Money.backdrop:SetOutside(Money.Icon)

	XP:StripTextures()
	XP:CreateBackdrop() 
	XP.Icon:SetTexture('Interface\\Icons\\XP_Icon')
	XP.Icon:SetTexCoord(unpack(D['IconCoord']))
	XP.backdrop:ClearAllPoints()
	XP.backdrop:SetOutside(XP.Icon)
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
			local UnitMap = C_Map.GetBestMapForUnit('player')
			local x, y = 0, 0

			if not C_Map.GetPlayerMapPosition(UnitMap, 'player') then
				coords.PlayerText:SetText(PLAYER..': x, x')
				return
			end
			
			if UnitMap then
				local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, 'player')
				if GetPlayerMapPosition then x, y = C_Map.GetPlayerMapPosition(UnitMap, 'player'):GetXY() end
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

function WorldMap:AddHooks()
	hooksecurefunc('QuestInfo_Display', self.ColorQuestText)
	hooksecurefunc('QuestInfo_GetRewardButton', self.SkinReward)
end

function WorldMap:Enable()
	if not IsAddOnLoaded('AddOnSkins') then
		local SmallerMap = GetCVarBool('miniWorldMap')

		if not SmallerMap then
			ToggleWorldMap()
			WorldMapFrameSizeUpButton:Click()
			ToggleWorldMap()
		end
		self:Skin()
		self:AddHooks()
	end
	self:Coords()
end

WorldMap:RegisterEvent('ADDON_LOADED')
WorldMap:RegisterEvent('PLAYER_ENTERING_WORLD')
WorldMap:SetScript('OnEvent', function(self, event, ...)
	WorldMap:Enable()
end)