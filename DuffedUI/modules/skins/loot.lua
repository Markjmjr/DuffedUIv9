local D, C, L = unpack(select(2, ...))

local function LoadSkin()
	-- loot history frame
	LootHistoryFrame:StripTextures()
	LootFrame.NineSlice:Kill()
	LootFrameInset.NineSlice:Kill()
	LootHistoryFrame.CloseButton:SkinCloseButton()
	LootHistoryFrame:StripTextures()
	LootHistoryFrame:SetTemplate('Transparent')
	LootHistoryFrame.ResizeButton:SkinCloseButton()
	LootHistoryFrame.ResizeButton.t:SetText('v v v v')
	LootHistoryFrame.ResizeButton:SetTemplate()
	LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
	LootHistoryFrame.ResizeButton:Height(19)
	LootHistoryFrame.ResizeButton:ClearAllPoints()
	LootHistoryFrame.ResizeButton:Point('TOP', LootHistoryFrame, 'BOTTOM', 0, -2)
	LootHistoryFrameScrollFrameScrollBar:SkinScrollBar()
	
	local function UpdateLoots(self)
		local numItems = C_LootHistory.GetNumItems()
		for i=1, numItems do
			local frame = self.itemFrames[i]
			
			if not frame.isSkinned then
				frame.NameBorderLeft:Hide()
				frame.NameBorderRight:Hide()
				frame.NameBorderMid:Hide()
				frame.IconBorder:Hide()
				frame.Divider:Hide()
				frame.ActiveHighlight:Hide()
				frame.Icon:SetTexCoord(.08,.88,.08,.88)
				frame.Icon:SetDrawLayer('ARTWORK')
				
				-- create a backdrop around the icon
				frame:CreateBackdrop('Default')
				frame.backdrop:Point('TOPLEFT', frame.Icon, -2, 2)
				frame.backdrop:Point('BOTTOMRIGHT', frame.Icon, 2, -2)
				frame.backdrop:SetBackdropColor(0,0,0,0)
				frame.isSkinned = true
			end
		end
	end
	hooksecurefunc('LootHistoryFrame_FullUpdate', UpdateLoots)
	
	-- master loot frame
	MasterLooterFrame:StripTextures()
	MasterLooterFrame:SetTemplate('Transparent')
	
	hooksecurefunc('MasterLooterFrame_Show', function()
		local b = MasterLooterFrame.Item
		if b then
			local i = b.Icon
			local icon = i:GetTexture()
			local c = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]
			
			b:StripTextures()
			i:SetTexture(icon)
			i:SetTexCoord(.1,.9,.1,.9)
			b:CreateBackdrop()
			b.backdrop:SetOutside(i)
			b.backdrop:SetBackdropBorderColor(c.r, c.g, c.b)
		end
		
		for i=1, MasterLooterFrame:GetNumChildren() do
			local child = select(i, MasterLooterFrame:GetChildren())
			if child and not child.isSkinned and not child:GetName() then
				if child:GetObjectType() == 'Button' then
					if child:GetPushedTexture() then
						child:SkinCloseButton()
					else
						child:SetTemplate()
						child:StyleButton()		
					end
					child.isSkinned = true
				end
			end
		end
	end)
	
	--[[ bonus
	BonusRollFrame:StripTextures()
	BonusRollFrame:CreateBackdrop('Transparent')
	BonusRollFrame.backdrop:SetFrameLevel(0)
	BonusRollFrame.PromptFrame.Icon:SetTexCoord(.1,.9,.1,.9)
	BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame('Frame', nil, BonusRollFrame.PromptFrame)
	BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel() - 1)
	BonusRollFrame.PromptFrame.IconBackdrop:SetOutside(BonusRollFrame.PromptFrame.Icon)
	BonusRollFrame.PromptFrame.IconBackdrop:SetTemplate()
	BonusRollFrame.PromptFrame.Timer.Bar:SetColorTexture(75/255,  175/255, 76/255)
	BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(75/255,  175/255, 76/255)
	BonusRollFrame.BlackBackgroundHoist:StripTextures()
	BonusRollFrame.PromptFrame.Timer:CreateBackdrop()
	BonusRollLootWonFrame:StripTextures()
	BonusRollLootWonFrame:SetTemplate('Transparent')
	if not BonusRollLootWonFrame.Icon.b then
		BonusRollLootWonFrame.Icon.b = CreateFrame('Frame', nil, BonusRollLootWonFrame)
		BonusRollLootWonFrame.Icon.b:SetTemplate('Default')
		BonusRollLootWonFrame.Icon.b:Point('TOPLEFT', BonusRollLootWonFrame.Icon, 'TOPLEFT', -2, 2)
		BonusRollLootWonFrame.Icon.b:Point('BOTTOMRIGHT', BonusRollLootWonFrame.Icon, 'BOTTOMRIGHT', 2, -2)
		BonusRollLootWonFrame.Icon:SetParent(BonusRollLootWonFrame.Icon.b)
	end

	BonusRollMoneyWonFrame:StripTextures()
	BonusRollMoneyWonFrame:SetTemplate('Transparent')
	if not BonusRollMoneyWonFrame.Icon.b then
		BonusRollMoneyWonFrame.Icon.b = CreateFrame('Frame', nil, BonusRollMoneyWonFrame)
		BonusRollMoneyWonFrame.Icon.b:SetTemplate('Default')
		BonusRollMoneyWonFrame.Icon.b:Point('TOPLEFT', BonusRollMoneyWonFrame.Icon, 'TOPLEFT', -2, 2)
		BonusRollMoneyWonFrame.Icon.b:Point('BOTTOMRIGHT', BonusRollMoneyWonFrame.Icon, 'BOTTOMRIGHT', 2, -2)
		BonusRollMoneyWonFrame.Icon:SetParent(BonusRollMoneyWonFrame.Icon.b)
	end]]

	-- Lootframe
	if C['loot']['lootframe'] then
		LootFrame:StripTextures()
		LootFrameInset:StripTextures()
		LootFrame:SetWidth(LootFrame:GetWidth() + 30)
		LootFrame:SetHeight(LootFrame:GetHeight() - 30)
		LootFrameCloseButton:SkinCloseButton()
		LootFrame:SetTemplate('Transparent')
		LootFramePortraitOverlay:Hide()

		for i = 1, LootFrame:GetNumRegions() do
			local region = select(i, LootFrame:GetRegions())
			if region:GetObjectType() == 'FontString' then
				if region:GetText() == ITEMS then LootFrame.Title = region end
			end
		end

		LootFrame.Title:ClearAllPoints()
		LootFrame.Title:SetPoint('TOPLEFT', LootFrame, 'TOPLEFT', 4, -4)
		LootFrame.Title:SetJustifyH('LEFT')

		for i = 1, LOOTFRAME_NUMBUTTONS do
			local button = _G['LootButton' .. i]
			local icon = _G['LootButton' .. i .. 'IconTexture']
			_G['LootButton' .. i .. 'NameFrame']:Hide()
			button:SkinButton()
			icon:SetTexCoord(.1, .9, .1, .9)
			icon:SetInside()
			_G['LootButton' .. i .. 'IconQuestTexture']:Hide()

			local point, attachTo, point2, x, y = button:GetPoint()
			button:ClearAllPoints()
			button:SetPoint(point, attachTo, point2, x, y + 30)
		end

		hooksecurefunc('LootFrame_UpdateButton', function(index)
			local numLootItems = LootFrame.numLootItems
			local numLootToShow = LOOTFRAME_NUMBUTTONS
			local self = LootFrame
			if self.AutoLootTable then numLootItems = #self.AutoLootTable end
			if numLootItems > LOOTFRAME_NUMBUTTONS then numLootToShow = numLootToShow - 1 end

			local button = _G['LootButton' .. index]
			local slot = (numLootToShow * (LootFrame.page - 1)) + index
			if (button and button:IsShown()) then
				local texture, item, quantity, quality, locked, isQuestItem, questId, isActive
				if LootFrame.AutoLootTablLootFramee then
					local entry = LootFrame.AutoLootTable[slot]
					if entry.hide then
						button:Hide()
						return
					else
						texture = entry.texture
						item = entry.item
						quantity = entry.quantity
						quality = entry.quality
						locked = entry.locked
						isQuestItem = entry.isQuestItem
						questId = entry.questId
						isActive = entry.isActive
					end
				else
					texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(slot)
				end

				if texture then
					if questId and not isActive then
						ActionButton_ShowOverlayGlow(button)
					elseif questId or isQuestItem then
						ActionButton_ShowOverlayGlow(button)
					else
						ActionButton_HideOverlayGlow(button)
					end
				end
			end
		end)

		LootFrame:HookScript('OnShow', function(self)
			if IsFishingLoot() then
				self.Title:SetText(L['loot']['fish'])
			elseif(not UnitIsFriend('player', 'target') and UnitIsDead'target') then
				self.Title:SetText(UnitName('target'))
			else
				self.Title:SetText(LOOT)
			end
		end)

		LootFrameDownButton:SkinNextPrevButton()
		LootFrameUpButton:SkinNextPrevButton()
	end
end

tinsert(D['SkinFuncs']['DuffedUI'], LoadSkin)