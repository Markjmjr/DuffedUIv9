local D, C, L = unpack(select(2, ...))

-- Thx Wetxius and Shestak

local function LoadSkin()
	-- Garrison Building frame
	Mixin(GarrisonBuildingFrame, BackdropTemplateMixin)
	GarrisonBuildingFrame:StripTextures()
	GarrisonBuildingFrame:SetTemplate('Transparent')
	GarrisonBuildingFrame.CloseButton:SkinCloseButton()

	for _, button in pairs({GarrisonBuildingFrame.TownHallBox.UpgradeButton, GarrisonBuildingFrame.InfoBox.UpgradeButton}) do
		button:StripTextures(true)
		button:SkinButton()
	end

	-- Confirmation popup
	local Confirmation = GarrisonBuildingFrame.Confirmation
	Mixin(Confirmation, BackdropTemplateMixin)
	Confirmation:StripTextures()
	Confirmation:SetTemplate('Transparent')

	Confirmation.CancelButton:SkinButton()
	Confirmation.BuildButton:SkinButton()
	Confirmation.UpgradeButton:SkinButton()
	Confirmation.UpgradeGarrisonButton:SkinButton()
	Confirmation.ReplaceButton:SkinButton()
	Confirmation.SwitchButton:SkinButton()

	-- Mission UI
	Mixin(GarrisonMissionFrame, BackdropTemplateMixin)
	GarrisonMissionFrame:StripTextures()
	GarrisonMissionFrame.GarrCorners:StripTextures()
	GarrisonMissionFrame.TitleText:Show()
	GarrisonMissionFrame:SetTemplate('Transparent')
	GarrisonMissionFrame.CloseButton:SkinCloseButton()
	GarrisonMissionFrameTab1:SetPoint('BOTTOMLEFT', GarrisonMissionFrame, 'BOTTOMLEFT', 11, -40)
	GarrisonMissionFrameTab1:SkinTab()
	GarrisonMissionFrameTab2:SkinTab()

	-- Mission list
	local MissionTab = GarrisonMissionFrame.MissionTab
	local MissionList = MissionTab.MissionList
	local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
	MissionList:DisableDrawLayer('BORDER')
	MissionList.listScroll.scrollBar:SkinScrollBar()
	MissionPage.CloseButton:SkinCloseButton()
	MissionPage.CloseButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
	MissionList.CompleteDialog.BorderFrame.ViewButton:SkinButton()
	GarrisonMissionFrame.MissionComplete.NextMissionButton:SkinButton()

	GarrisonMissionFrameHelpBoxButton:SkinButton()
	Mixin(GarrisonMissionFrameHelpBox, BackdropTemplateMixin)
	GarrisonMissionFrameHelpBox:StripTextures()
	GarrisonMissionFrameHelpBox:SetTemplate('Transparent')

	for i = 1, 2 do
		_G['GarrisonMissionFrameMissionsTab'..i]:StripTextures()
		_G['GarrisonMissionFrameMissionsTab'..i]:StyleButton()
		_G['GarrisonMissionFrameMissionsTab'..i]:SetHeight(_G['GarrisonMissionFrameMissionsTab'..i]:GetHeight() - 10)
	end

	GarrisonMissionFrameMissionsTab1:SetPoint('BOTTOMLEFT', GarrisonMissionFrameMissions, 'TOPLEFT', 18, 0)

	hooksecurefunc('GarrisonMissonListTab_SetSelected', function(tab, isSelected)
		if not tab.backdrop then
			tab:CreateBackdrop('Overlay')
			tab.backdrop:SetAllPoints()
		end
		if isSelected then
			tab.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)
		else
			tab.backdrop:SetBackdropBorderColor(unpack(C['general']['bordercolor']))
		end
	end)

	for i = 1, #GarrisonMissionFrame.MissionTab.MissionList.listScroll.buttons do
		local button = GarrisonMissionFrame.MissionTab.MissionList.listScroll.buttons[i]
		if not button.backdrop then
			button:StripTextures()
			button:CreateBackdrop('Overlay')
			button.backdrop:SetPoint('TOPLEFT', 0, 0)
			button.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
			button:StyleButton(nil, 2)
		end
	end

	GarrisonMissionFrameFollowers:StripTextures()
	GarrisonMissionFrameFollowers:SetTemplate('Transparent')
	GarrisonMissionFrameFollowers.SearchBox:SkinEditBox()
	GarrisonMissionFrameFollowers.SearchBox:SetPoint('TOPLEFT', 2, 25)
	GarrisonMissionFrameFollowers.SearchBox:SetSize(301, 20)
	GarrisonMissionFrameFollowersListScrollFrameScrollBar:SkinScrollBar()
	GarrisonMissionFrameFollowers.MaterialFrame:GetRegions():Hide()
	GarrisonMissionFrameMissions.MaterialFrame:GetRegions():Hide()

	GarrisonMissionFrame.FollowerTab:StripTextures()
	GarrisonMissionFrame.FollowerTab:SetTemplate('Overlay')

	for _, item in pairs({GarrisonMissionFrame.FollowerTab.ItemWeapon, GarrisonMissionFrame.FollowerTab.ItemArmor}) do
		item.Border:Hide()
		item.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
		item:CreateBackdrop('Default')
		item.backdrop:SetPoint('TOPLEFT', item.Icon, 'TOPLEFT', -2, 2)
		item.backdrop:SetPoint('BOTTOMRIGHT', item.Icon, 'BOTTOMRIGHT', 2, -2)
		item.backdrop:SetFrameLevel(item:GetFrameLevel())
	end

	MissionPage.StartMissionButton:SkinButton()

	local function HandleGarrisonPortrait(portrait)
		if not portrait.Portrait then return end

		local size = portrait.Portrait:GetSize() + 2
		portrait:SetSize(size, size)

		portrait.Portrait:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		portrait.Portrait:ClearAllPoints()
		portrait.Portrait:SetPoint('TOPLEFT', 1, -1)

		portrait.PortraitRing:Hide()
		portrait.PortraitRingQuality:SetTexture('')
		portrait.PortraitRingCover:SetTexture('')
		portrait.LevelBorder:SetAlpha(0)

		portrait.Level:ClearAllPoints()
		portrait.Level:SetPoint('BOTTOM', 0, 1)
		portrait.Level:SetFontObject('SystemFont_Outline_Small')

		if not portrait.backdrop then
			portrait:CreateBackdrop('Default')
			portrait.backdrop:SetPoint('TOPLEFT', portrait, 'TOPLEFT', -1, 1)
			portrait.backdrop:SetPoint('BOTTOMRIGHT', portrait, 'BOTTOMRIGHT', 1, -1)
			portrait.backdrop:SetFrameLevel(portrait:GetFrameLevel())
		end
	end

	local function UpdateData(dataFrame)
		local offset = _G.HybridScrollFrame_GetOffset(dataFrame.listScroll)
		local Buttons = dataFrame.listScroll.buttons
		local followersList = dataFrame.followersList
		for i = 1, #Buttons do
			local button = Buttons[i]
			local index = offset + i

			if button then
				if (index <= #followersList) and not button.template then
					if button.Follower and not button.Follower.backdrop then
						button.Follower:CreateBackdrop('Overlay')
						button.Follower.backdrop:SetPoint('TOPLEFT', 0, 0)
						button.Follower.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
						button.Follower:StyleButton()

						button.Follower.BG:Hide()
						button.Follower.Selection:SetTexture('')
						button.Follower.AbilitiesBG:SetTexture('')
						button.Follower.BusyFrame:SetAllPoints()

						if button.Follower.PortraitFrame then
							HandleGarrisonPortrait(button.Follower.PortraitFrame)
							button.Follower.PortraitFrame:ClearAllPoints()
							button.Follower.PortraitFrame:SetPoint('TOPLEFT', 6, -5)
						end
					end
				end

				if button.Follower.Counters then
					for y = 1, #button.Follower.Counters do
						local counter = button.Follower.Counters[y]
						if counter and not counter.template then
							counter:SetTemplate('Default')
							if counter.Border then
								counter.Border:SetTexture('')
							end
							if counter.Icon then
								counter.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
								counter.Icon:SetInside()
							end
						end
					end
				end

				if button.Follower then
					if button.Follower.Selection and button.Follower.backdrop then
						if button.Follower.Selection:IsShown() then
							button.Follower.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)
							button.Follower.PortraitFrame.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)
						else
							button.Follower.backdrop:SetBackdropBorderColor(unpack(C['general']['bordercolor']))
							button.Follower.PortraitFrame.backdrop:SetBackdropBorderColor(unpack(C['general']['bordercolor']))
						end
					end

					local color = ITEM_QUALITY_COLORS[button.Follower.PortraitFrame.quality]
					if color then
						button.Follower.Name:SetTextColor(color.r, color.g, color.b)
					else
						button.Follower.Name:SetTextColor(1, 1, 1)
					end
				end
			end
		end
	end

	hooksecurefunc('GarrisonFollowerButton_AddAbility', function(self, index)
		local ability = self.Abilities[index]
		if not ability.skinned then
			ability.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
			ability.skinned = true
		end
	end)

	-- Set border color according to rarity of item
	hooksecurefunc('GarrisonMissionButton_SetRewards', function(self)
		local firstRegion, r, g, b
		local index = 0
		for _, reward in pairs(self.Rewards) do
			firstRegion = reward.GetRegions and reward:GetRegions()
			if firstRegion then firstRegion:Hide() end

			reward:ClearAllPoints()
			if IsAddOnLoaded('GarrisonMissionManager') then
				reward:SetPoint('TOPRIGHT', -D.mult * 65 + (index * -65), -D.mult)
			else
				reward:SetPoint('TOPRIGHT', -D.mult + (index * -65), -D.mult)
			end

			if reward.IconBorder then
				reward.IconBorder:SetTexture(nil)
			end

			if reward.IconBorder and reward.IconBorder:IsShown() then
				r, g, b = reward.IconBorder:GetVertexColor()
			else
				r, g, b = unpack(C['general']['bordercolor'])
			end

			if not reward.backdrop then
				reward:CreateBackdrop()
				reward.backdrop:ClearAllPoints()
				reward.backdrop:SetOutside(reward.Icon)
				reward.Icon:SetTexCoord(unpack(D['IconCoord']))
				reward.backdrop:SetFrameLevel(reward:GetFrameLevel())
			end
			reward.backdrop:SetBackdropBorderColor(r, g, b)
			index = index + 1
		end
	end)

	hooksecurefunc('GarrisonMissionPage_SetReward', function(frame)
		frame.BG:Hide()
		frame.IconBorder:SetTexture('')
		if not frame.backdrop then
			frame:CreateBackdrop()
			frame.backdrop:ClearAllPoints()
			frame.backdrop:SetOutside(frame.Icon)
			frame.Icon:SetTexCoord(unpack(D['IconCoord']))
			frame.backdrop:SetFrameLevel(frame:GetFrameLevel())
		end
		frame.Icon:SetDrawLayer('BORDER', 0)

		local r, g, b
		if frame.IconBorder and frame.IconBorder:IsShown() then
			r, g, b = frame.IconBorder:GetVertexColor()
		else
			r, g, b = unpack(C['general']['bordercolor'])
		end
		frame.backdrop:SetBackdropBorderColor(r, g, b)
	end)

	-- Landing page
	GarrisonLandingPage:StripTextures()
	GarrisonLandingPage:CreateBackdrop('Transparent')
	GarrisonLandingPage.CloseButton:SkinCloseButton()
	GarrisonLandingPageTab1:SetPoint('TOPLEFT', GarrisonLandingPage, 'BOTTOMLEFT', 70, -2)

	for i = 1, 3 do
		_G['GarrisonLandingPageTab'..i]:SkinTab()
		_G['GarrisonLandingPageTab'..i]:SetHeight(32)
		_G['GarrisonLandingPageTab'..i].Text:ClearAllPoints()
		_G['GarrisonLandingPageTab'..i].Text:SetPoint('CENTER')
	end

	GarrisonLandingPageReportListListScrollFrameScrollBar:SkinScrollBar()

	GarrisonLandingPage.FollowerList:StripTextures()
	GarrisonLandingPage.FollowerList.SearchBox:SetPoint('TOPLEFT', -1, 33)
	GarrisonLandingPage.FollowerList.SearchBox:SkinEditBox()
	GarrisonLandingPageFollowerListListScrollFrameScrollBar:SkinScrollBar()

	GarrisonLandingPage.FollowerTab:CreateBackdrop('Overlay')
	GarrisonLandingPage.FollowerTab.backdrop:SetPoint('TOPLEFT', 13, 0)
	GarrisonLandingPage.FollowerTab.backdrop:SetPoint('BOTTOMRIGHT', 2, 3)

	HandleGarrisonPortrait(GarrisonLandingPage.FollowerTab.PortraitFrame)

	GarrisonLandingPageShipFollowerList:StripTextures()
	GarrisonLandingPageShipFollowerList:SetTemplate('Transparent')

	GarrisonLandingPageShipFollowerList.SearchBox:SetPoint('TOPLEFT', 2, 25)
	GarrisonLandingPageShipFollowerList.SearchBox:SkinEditBox()
	GarrisonLandingPageShipFollowerListListScrollFrameScrollBar:SkinScrollBar()

	GarrisonLandingPage.Report.InProgress:ClearAllPoints()
	GarrisonLandingPage.Report.InProgress:SetPoint('BOTTOMLEFT', GarrisonLandingPageReportList, 'TOPLEFT', 5, 2)
	GarrisonLandingPage.Report.Available:ClearAllPoints()
	GarrisonLandingPage.Report.Available:SetPoint('LEFT', GarrisonLandingPage.Report.InProgress, 'RIGHT', 4, 0)

	for _, tab in pairs({GarrisonLandingPage.Report.InProgress, GarrisonLandingPage.Report.Available}) do
		tab:CreateBackdrop('Overlay')
		tab.backdrop:SetAllPoints()
		tab:StyleButton()

		tab.Text:ClearAllPoints()
		tab.Text:SetPoint('CENTER')
		tab.Text:SetFont(C['media']['font'], 15)
	end

	hooksecurefunc('GarrisonLandingPageReport_SetTab', function(self)
		local unselectedTab = GarrisonLandingPage.Report.unselectedTab
		unselectedTab:SetHeight(36)

		self:SetWidth(198)
		unselectedTab:SetWidth(198)

		unselectedTab:SetNormalTexture('')
		unselectedTab.backdrop:SetBackdropBorderColor(unpack(C['general']['bordercolor']))

		self:SetNormalTexture('')
		self.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)
	end)

	for i = 1, #GarrisonLandingPage.Report.List.listScroll.buttons do
		local button = GarrisonLandingPage.Report.List.listScroll.buttons[i]
		for _, reward in pairs(button.Rewards) do
			reward.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
			if not reward.backdrop then
				reward:CreateBackdrop('Default')
				reward.backdrop:SetPoint('TOPLEFT', reward.Icon, 'TOPLEFT', -2, 2)
				reward.backdrop:SetPoint('BOTTOMRIGHT', reward.Icon, 'BOTTOMRIGHT', 2, -2)
				reward.backdrop:SetFrameLevel(reward:GetFrameLevel())

				reward.Quantity:SetParent(reward.backdrop)
				reward.IconBorder:SetAlpha(0)
				hooksecurefunc(reward.IconBorder, 'SetVertexColor', function(self, r, g, b)
					self:GetParent().backdrop:SetBackdropBorderColor(r, g, b)
				end)
			end
		end
	end

	local xpBar = {
		GarrisonLandingPage.FollowerTab.XPBar,
		GarrisonLandingPage.ShipFollowerTab.XPBar,
		GarrisonMissionFrame.FollowerTab.XPBar,
		OrderHallMissionFrame.FollowerTab.XPBar,
		BFAMissionFrame.FollowerTab.XPBar
	}

	for i = 1, #xpBar do
		local xpBar = xpBar[i]
		xpBar:StripTextures()
		xpBar:CreateBackdrop('Default')
		xpBar.backdrop:SetFrameLevel(xpBar.backdrop:GetFrameLevel() + 1)
		xpBar:SetStatusBarTexture(C['media']['normTex'])

		if xpBar:GetParent().PortraitFrame then
			xpBar:ClearAllPoints()
			xpBar:SetPoint('BOTTOMLEFT', xpBar:GetParent().PortraitFrame, 'BOTTOMRIGHT', 8, -15)
		end
	end

	local function onShowFollower(frame)
		local ft = frame:GetParent().FollowerTab

		-- Ability buttons
		local btn
		for i = 1, #ft.AbilitiesFrame.Abilities do
			btn = ft.AbilitiesFrame.Abilities[i]
			if not btn.IconButton.backdrop then
				btn.IconButton.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn.IconButton.Icon:SetDrawLayer('BACKGROUND', 1)
				btn.IconButton:CreateBackdrop('Default')
				btn.IconButton.Border:SetTexture(nil)
			end
		end

		-- CombatAllySpell buttons
		for i = 1, #ft.AbilitiesFrame.CombatAllySpell do
			btn = ft.AbilitiesFrame.CombatAllySpell[i]
			if not btn.backdrop then
				btn.iconTexture:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn:CreateBackdrop('Default')
			end
		end

		-- Equipment
		if ft.AbilitiesFrame.Equipment then
			for i = 1, #ft.AbilitiesFrame.Equipment do
				btn = ft.AbilitiesFrame.Equipment[i]
				btn.Border:SetTexture(nil)
				btn.BG:SetTexture(nil)
				btn.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn:SetScale(1)
				if not btn.backdrop then
					btn:CreateBackdrop('Default')
					btn.backdrop:SetPoint('TOPLEFT', btn.Icon, 'TOPLEFT', -2, 2)
					btn.backdrop:SetPoint('BOTTOMRIGHT', btn.Icon, 'BOTTOMRIGHT', 2, -2)
				end
			end
		end
		ft, btn = nil
	end

	hooksecurefunc(GarrisonMissionFrame.FollowerList, 'ShowFollower', onShowFollower)
	hooksecurefunc(GarrisonLandingPageFollowerList, 'ShowFollower', onShowFollower)
	hooksecurefunc(GarrisonLandingPageFollowerList, 'UpdateData', UpdateData)

	-- ShipYard
	GarrisonShipyardFrame:StripTextures(true)
	GarrisonShipyardFrame:SetTemplate('Transparent')
	GarrisonShipyardFrame.BorderFrame.GarrCorners:StripTextures()
	GarrisonShipyardFrame.BorderFrame:StripTextures(true)
	GarrisonShipyardFrame.BorderFrame.TitleText:SetPoint('TOP', -6, -1)
	GarrisonShipyardFrame.BorderFrame.CloseButton2:SkinCloseButton()
	GarrisonShipyardFrameTab1:SkinTab()
	GarrisonShipyardFrameTab2:SkinTab()

	-- ShipYard: Naval Map
	local MissionTab = GarrisonShipyardFrame.MissionTab
	local MissionList = MissionTab.MissionList

	-- ShipYard: Mission
	local MissionPage = MissionTab.MissionPage
	MissionPage.CloseButton:SkinCloseButton()
	MissionPage.CloseButton:SetFrameLevel(MissionPage.CloseButton:GetFrameLevel() + 2)
	MissionList.CompleteDialog.BorderFrame:StripTextures()
	MissionList.CompleteDialog.BorderFrame:SetTemplate('Transparent')
	MissionList.CompleteDialog.BorderFrame.ViewButton:SkinButton()
	MissionList.CompleteDialog:SetAllPoints(MissionList.MapTexture)
	GarrisonShipyardFrame.MissionComplete.NextMissionButton:SkinButton()
	GarrisonShipyardFrame.MissionCompleteBackground:SetAllPoints(MissionList.MapTexture)
	MissionPage.StartMissionButton:SkinButton()

	GarrisonShipyardFrameFollowers.SearchBox:SkinEditBox()
	GarrisonShipyardFrameFollowers.SearchBox:SetPoint('TOPLEFT', 2, 25)
	GarrisonShipyardFrameFollowers.SearchBox:SetSize(301, 20)
	GarrisonShipyardFrameFollowers:StripTextures()
	GarrisonShipyardFrameFollowers:SetTemplate('Transparent')
	GarrisonShipyardFrameFollowers.MaterialFrame:GetRegions():Hide()
	GarrisonShipyardFrame.FollowerTab:StripTextures()
	GarrisonShipyardFrame.FollowerTab:SetTemplate('Overlay')
	GarrisonShipyardFrameFollowersListScrollFrameScrollBar:SkinScrollBar()

	local function skinFollowerTraitsAndEquipment(obj)
		local btn
		for i = 1, #obj.Traits do
			btn = obj.Traits[i]
			if not btn.backdrop then
				btn.Border:SetTexture(nil)
				btn.Portrait:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn:CreateBackdrop('Default')
				btn.backdrop:SetPoint('TOPLEFT', btn.Portrait, 'TOPLEFT', -2, 2)
				btn.backdrop:SetPoint('BOTTOMRIGHT', btn.Portrait, 'BOTTOMRIGHT', 2, -2)
				btn.backdrop:SetFrameLevel(2)
			end
		end
		for i = 1, #obj.EquipmentFrame.Equipment do
			btn = obj.EquipmentFrame.Equipment[i]
			if not btn.backdrop then
				btn:DisableDrawLayer('BACKGROUND')
				btn.Border:SetTexture(nil)
				btn.Counter.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn:CreateBackdrop('Default')
				btn.backdrop:SetPoint('TOPLEFT', btn.Icon, 'TOPLEFT', -2, 2)
				btn.backdrop:SetPoint('BOTTOMRIGHT', btn.Icon, 'BOTTOMRIGHT', 2, -2)

				btn.Counter.Border:SetAlpha(0)
				btn.Counter.Icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				btn.Counter:CreateBackdrop('Default')
				btn.Counter.backdrop:SetPoint('TOPLEFT', btn.Counter.Icon, 'TOPLEFT', -2, 2)
				btn.Counter.backdrop:SetPoint('BOTTOMRIGHT', btn.Counter.Icon, 'BOTTOMRIGHT', 2, -2)
			end
		end
		btn = nil
	end
	skinFollowerTraitsAndEquipment(GarrisonLandingPage.ShipFollowerTab)
	skinFollowerTraitsAndEquipment(GarrisonShipyardFrame.FollowerTab)

	-- Recruiter frame
	GarrisonRecruiterFrame:StripTextures(true)
	GarrisonRecruiterFrame:SetTemplate('Transparent')
	GarrisonRecruiterFrame.CloseButton:SkinCloseButton()
	GarrisonRecruiterFrame.UnavailableFrame:GetChildren():SkinButton()
	GarrisonRecruiterFrame.Pick.ChooseRecruits:SkinButton()
	GarrisonRecruiterFrame.Pick.ThreatDropDown:SkinDropDownBox()
	GarrisonRecruiterFrame.Pick.Radio1:SkinCheckBox()
	GarrisonRecruiterFrame.Pick.Radio2:SkinCheckBox()

	-- Recruiter select frame
	GarrisonRecruitSelectFrame:StripTextures()
	GarrisonRecruitSelectFrame:SetTemplate('Transparent')
	GarrisonRecruitSelectFrame.GarrCorners:StripTextures()
	GarrisonRecruitSelectFrame.CloseButton:SkinCloseButton()

	GarrisonRecruitSelectFrame.FollowerList:StripTextures()
	GarrisonRecruitSelectFrame.FollowerList:SetTemplate('Transparent')
	GarrisonRecruitSelectFrameListScrollFrameScrollBar:SkinScrollBar()
	GarrisonRecruitSelectFrame.FollowerList.SearchBox:SkinEditBox()
	GarrisonRecruitSelectFrame.FollowerList.SearchBox:SetPoint('TOPLEFT', 2, 25)
	GarrisonRecruitSelectFrame.FollowerList.SearchBox:SetSize(301, 20)
	GarrisonRecruitSelectFrame.FollowerSelection:StripTextures()
	GarrisonRecruitSelectFrame.FollowerSelection:SetTemplate('Overlay')

	for i = 1, 3 do
		local recruit = GarrisonRecruitSelectFrame.FollowerSelection['Recruit'..i]
		recruit.HireRecruits:SkinButton()
	end

	--	MasterPlan AddOn skin
	do
		local function skinMasterPlan()
			GarrisonLandingPageTab4:SkinTab()
			GarrisonMissionFrameTab3:SkinTab()
			GarrisonMissionFrameTab4:SkinTab()
			GarrisonShipyardFrameTab3:SkinTab()
			local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
			MissionPage.MinimizeButton:SkinCloseButton()
			MissionPage.MinimizeButton:SetPoint('TOPRIGHT', GarrisonMissionFrame.MissionTab.MissionPage.CloseButton, 'TOPLEFT', -3, 0)
			MissionPage.MinimizeButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
			GarrisonMissionFrame.MissionTab.MissionPage.CloseButton:SetSize(18, 18)
			GarrisonMissionFrame.MissionTab.MissionPage.CloseButton:SetPoint('TOPRIGHT', -4, -4)

			local MissionPage = GarrisonShipyardFrame.MissionTab.MissionPage
			MissionPage.MinimizeButton:SkinCloseButton()
			MissionPage.MinimizeButton:SetPoint('TOPRIGHT', GarrisonShipyardFrame.MissionTab.MissionPage.CloseButton, 'TOPLEFT', -3, 0)
			MissionPage.MinimizeButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
			GarrisonShipyardFrame.MissionTab.MissionPage.CloseButton:SetSize(18, 18)
			GarrisonShipyardFrame.MissionTab.MissionPage.CloseButton:SetPoint('TOPRIGHT', -4, -4)

			MPCompleteAll:SkinButton()
			MPPokeTentativeParties:SkinButton()
			GarrisonMissionFrameFollowers.SearchBox:SetSize(270, 20)
		end

		if IsAddOnLoaded('MasterPlan') then
			skinMasterPlan()
		else
			local f = CreateFrame('Frame')
			f:RegisterEvent('ADDON_LOADED')
			f:SetScript('OnEvent', function(self, _, addon)
				if addon == 'MasterPlan' then
					skinMasterPlan()
					self:UnregisterEvent('ADDON_LOADED')
				end
			end)
		end
	end

	-- Order Hall skin
	OrderHallMissionFrame:StripTextures()
	OrderHallMissionFrame:CreateBackdrop('Transparent')
	OrderHallMissionFrame.backdrop:SetPoint('TOPLEFT', 0, 0)
	OrderHallMissionFrame.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
	OrderHallMissionFrame.GarrCorners:StripTextures()
	OrderHallMissionFrame.ClassHallIcon:Kill()
	OrderHallMissionFrame.CloseButton:SkinCloseButton()

	OrderHallMissionTutorialFrame.GlowBox.ArrowGlowUp:Hide()
	OrderHallMissionTutorialFrame.GlowBox:StripTextures()
	OrderHallMissionTutorialFrame.GlowBox:SetTemplate('Transparent')
	OrderHallMissionTutorialFrame.GlowBox.CloseButton:SkinCloseButton()

	for i = 1, 3 do
		_G['OrderHallMissionFrameTab'..i]:SkinTab()
	end

	OrderHallMissionFrameMissions.CompleteDialog.BorderFrame:StripTextures()
	OrderHallMissionFrameMissions.CompleteDialog.BorderFrame:SetTemplate('Overlay')
	OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.Stage:StripTextures()

	OrderHallMissionFrame.MissionComplete:StripTextures()
	OrderHallMissionFrame.MissionComplete:CreateBackdrop('Overlay')
	OrderHallMissionFrame.MissionComplete.backdrop:SetPoint('TOPLEFT', 3, 2)
	OrderHallMissionFrame.MissionComplete.backdrop:SetPoint('BOTTOMRIGHT', -3, -12)

	OrderHallMissionFrame.MissionComplete.Stage.MissionInfo:StripTextures()
	OrderHallMissionFrame.MissionComplete.Stage.MissionInfo:CreateOverlay()
	OrderHallMissionFrame.MissionComplete.Stage.MissionInfo.overlay:SetPoint('TOPLEFT', 5, 0)
	OrderHallMissionFrame.MissionComplete.Stage.MissionInfo.overlay:SetPoint('BOTTOMRIGHT', -5, 210)
	OrderHallMissionFrame.MissionComplete.Stage.MissionInfo.overlay:SetVertexColor(0, 0, 0, 0.7)

	OrderHallMissionFrameMissions:StripTextures()
	OrderHallMissionFrameMissionsListScrollFrame:StripTextures()
	OrderHallMissionFrameMissionsListScrollFrameScrollBar:SkinScrollBar()
	OrderHallMissionFrameMissions.CombatAllyUI:StripTextures()
	OrderHallMissionFrameMissions.CombatAllyUI:CreateBackdrop('Overlay')
	OrderHallMissionFrameMissions.CombatAllyUI.backdrop:SetPoint('TOPLEFT', 18, -2)
	OrderHallMissionFrameMissions.CombatAllyUI.backdrop:SetPoint('BOTTOMRIGHT', -4, 2)
	OrderHallMissionFrameMissions.CombatAllyUI.InProgress.Unassign:SkinButton()
	OrderHallMissionFrameMissions.CombatAllyUI.InProgress.CombatAllySpell.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OrderHallMissionFrameMissions.CombatAllyUI.InProgress.CombatAllySpell:CreateBackdrop('Default')
	OrderHallMissionFrameMissions.MaterialFrame:StripTextures()
	OrderHallMissionFrame.MissionTab:StripTextures()
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage:StripTextures()
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage:SetTemplate('Overlay')
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllySpell:SetPoint('TOP', OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllyDescriptionLabel, 'BOTTOM', 0, -5)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllySpell.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllySpell:CreateBackdrop('Default')
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CloseButton:SkinCloseButton()
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.StartMissionButton:SkinButton()

	for i = 1, 2 do
		_G['OrderHallMissionFrameMissionsTab'..i]:StripTextures()
		_G['OrderHallMissionFrameMissionsTab'..i]:CreateBackdrop('Overlay')
		_G['OrderHallMissionFrameMissionsTab'..i].backdrop:SetAllPoints()
		_G['OrderHallMissionFrameMissionsTab'..i]:SetHeight(_G['OrderHallMissionFrameMissionsTab'..i]:GetHeight() - 10)
	end

	OrderHallMissionFrameMissionsTab1:SetPoint('BOTTOMLEFT', OrderHallMissionFrameMissions, 'TOPLEFT', 18, 0)
	OrderHallMissionFrameMissionsTab1.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)

	for i = 1, #OrderHallMissionFrame.MissionTab.MissionList.listScroll.buttons do
		local button = OrderHallMissionFrame.MissionTab.MissionList.listScroll.buttons[i]
		if not button.backdrop then
			button:StripTextures()
			button:CreateBackdrop('Overlay')
			button.backdrop:SetPoint('TOPLEFT', 0, 0)
			button.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
			button:StyleButton(nil, 2)
		end
	end

	-- Followers
	local Follower = OrderHallMissionFrameFollowers
	Follower:StripTextures()
	Follower.SearchBox:SkinEditBox()
	Follower.SearchBox:SetPoint('TOPLEFT', 2, 25)
	Follower.SearchBox:SetSize(301, 20)
	OrderHallMissionFrameFollowersListScrollFrameScrollBar:SkinScrollBar()
	Follower.MaterialFrame:StripTextures()
	OrderHallMissionFrame.MissionTab.MissionPage.CloseButton:SkinCloseButton()
	OrderHallMissionFrame.MissionTab.MissionPage.StartMissionButton:SkinButton()

	local FollowerTab = OrderHallMissionFrame.FollowerTab
	FollowerTab:StripTextures()
	FollowerTab:CreateBackdrop('Overlay')
	FollowerTab.backdrop:SetPoint('TOPLEFT', -2, 0)
	FollowerTab.backdrop:SetPoint('BOTTOMRIGHT', 2, -2)
	FollowerTab.ModelCluster:StripTextures()
	FollowerTab.Class:SetSize(50, 43)

	HandleGarrisonPortrait(FollowerTab.PortraitFrame)

	hooksecurefunc(OrderHallMissionFrameFollowers, 'UpdateData', UpdateData)
	hooksecurefunc(OrderHallMissionFrame.FollowerList, 'ShowFollower', onShowFollower)

	-- Missions
	OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SkinButton()
	OrderHallMissionFrame.MissionComplete.NextMissionButton:SkinButton()

	-- BFA Mission skin
	BFAMissionFrame:StripTextures()
	BFAMissionFrame:CreateBackdrop('Transparent')
	BFAMissionFrame.backdrop:SetPoint('TOPLEFT', 0, 0)
	BFAMissionFrame.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
	BFAMissionFrame.OverlayElements:Hide()
	BFAMissionFrame.TitleScroll:Hide()

	BFAMissionFrameMissions.CompleteDialog.BorderFrame:StripTextures()
	BFAMissionFrameMissions.CompleteDialog.BorderFrame:SetTemplate('Transparent')
	BFAMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SkinButton()

	BFAMissionFrameMissions.CompleteDialog.BorderFrame.Stage:StripTextures()

	BFAMissionFrame.MissionComplete.NextMissionButton:SkinButton()

	for i = 1, 3 do
		_G['BFAMissionFrameTab'..i]:SkinTab()
	end

	BFAMissionFrame.CloseButton:SkinCloseButton()
	BFAMissionFrame.CloseButton:StripTextures()

	for i = 1, 2 do
		_G['BFAMissionFrameMissionsTab'..i]:StripTextures()
		_G['BFAMissionFrameMissionsTab'..i]:CreateBackdrop('Overlay')
		_G['BFAMissionFrameMissionsTab'..i].backdrop:SetAllPoints()
		_G['BFAMissionFrameMissionsTab'..i]:SetHeight(_G['BFAMissionFrameMissionsTab'..i]:GetHeight() - 10)
	end

	BFAMissionFrameMissionsTab1.backdrop:SetBackdropBorderColor(1, 0.82, 0, 1)
	BFAMissionFrameMissionsTab1:SetPoint('BOTTOMLEFT', BFAMissionFrameMissions, 'TOPLEFT', 18, 0)

	BFAMissionFrameMissions:StripTextures()
	BFAMissionFrameMissionsListScrollFrame:StripTextures()
	BFAMissionFrameMissionsListScrollFrameScrollBar:SkinScrollBar()

	BFAMissionFrameMissions.MaterialFrame:GetRegions():Hide()
	BFAMissionFrameMissions.MaterialFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	for i = 1, #BFAMissionFrame.MissionTab.MissionList.listScroll.buttons do
		local button = BFAMissionFrame.MissionTab.MissionList.listScroll.buttons[i]
		if not button.backdrop then
			button:StripTextures()
			button:CreateBackdrop('Overlay')
			button.backdrop:SetPoint('TOPLEFT', 0, 0)
			button.backdrop:SetPoint('BOTTOMRIGHT', 0, 0)
			button:StyleButton(nil, 2)
			button.LocBG:SetHeight(75)
			button.LocBG:SetPoint('RIGHT', 0, -1)
		end
	end

	-- Followers
	local Follower = BFAMissionFrameFollowers
	Follower:StripTextures()
	Follower.SearchBox:SkinEditBox()
	Follower.SearchBox:SetPoint('TOPLEFT', 2, 25)
	Follower.SearchBox:SetSize(301, 20)
	BFAMissionFrameFollowersListScrollFrameScrollBar:SkinScrollBar()
	Follower.MaterialFrame:StripTextures()
	BFAMissionFrame.MissionTab.MissionPage.CloseButton:SkinCloseButton()
	BFAMissionFrame.MissionTab.MissionPage.StartMissionButton:SkinButton()

	local FollowerTab = BFAMissionFrame.FollowerTab
	FollowerTab:StripTextures()
	FollowerTab.ModelCluster:StripTextures()
	FollowerTab:CreateBackdrop('Overlay')
	FollowerTab.backdrop:SetPoint('TOPLEFT', -2, 0)
	FollowerTab.backdrop:SetPoint('BOTTOMRIGHT', 2, -2)
	FollowerTab.Class:SetSize(50, 43)

	HandleGarrisonPortrait(FollowerTab.PortraitFrame)

	hooksecurefunc(BFAMissionFrameFollowers, 'UpdateData', UpdateData)
	hooksecurefunc(BFAMissionFrame.FollowerList, 'ShowFollower', onShowFollower)

	-- Map
	BFAMissionFrame.MapTab.ScrollContainer:ClearAllPoints()
	BFAMissionFrame.MapTab.ScrollContainer:SetPoint('TOPLEFT')
	BFAMissionFrame.MapTab.ScrollContainer:SetPoint('BOTTOMRIGHT')
end

D['SkinFuncs']['Blizzard_GarrisonUI'] = LoadSkin