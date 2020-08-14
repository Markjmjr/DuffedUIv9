local D, C, L = unpack(select(2, ...))
if IsAddOnLoaded('AddOnSkins') then return end


local function LoadSkin()
	local skins = {
		'StaticPopup1',
		'StaticPopup2',
		'StaticPopup3',
		'StaticPopup4',
		'GameMenuFrame',
		'InterfaceOptionsFrame',
		'VideoOptionsFrame',
		'AudioOptionsFrame',
		'LFDDungeonReadyStatus',
		'TicketStatusFrameButton',
		'LFDSearchStatus',
		'AutoCompleteBox',
		'ConsolidatedBuffsTooltip',
		'ReadyCheckFrame',
		'StackSplitFrame',
		'CharacterFrame',
		'VoiceChatTalkers'
	}

	for i = 1, getn(skins) do
		if _G[skins[i]] then _G[skins[i]]:SetTemplate('Transparent') end
	end

	LFDRoleCheckPopup:StripTextures()
	LFDRoleCheckPopup:SetTemplate('Transparent')
	LFDRoleCheckPopupAcceptButton:SkinButton()
	LFDRoleCheckPopupDeclineButton:SkinButton()
	LFDRoleCheckPopupRoleButtonTank:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SkinCheckBox()
	LFDRoleCheckPopupRoleButtonTank:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonTank:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonDPS:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS:GetChildren():GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonHealer:GetChildren():SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer:GetChildren():GetFrameLevel() + 1)
	LFGListInviteDialog.Border:Kill()

	CinematicFrameCloseDialog:SetTemplate('Transparent')
	CinematicFrameCloseDialog:SetScale(C['general']['uiscale'])
	CinematicFrameCloseDialogConfirmButton:SkinButton()
	CinematicFrameCloseDialogResumeButton:SkinButton()
	CinematicFrameCloseDialog.Border:Kill()

	ReportCheatingDialog:StripTextures()
	ReportCheatingDialog:SetTemplate('Transparent')
	ReportCheatingDialogReportButton:SkinButton()
	ReportCheatingDialogCancelButton:SkinButton()
	ReportCheatingDialogCommentFrame:StripTextures()
	ReportCheatingDialogCommentFrameEditBox:SkinEditBox()

	for i = 1, 4 do
		for j = 1, 3 do
			_G['StaticPopup' .. i .. 'Button' .. j]:SkinButton()
			_G['StaticPopup' .. i].Border:Kill()
			_G['StaticPopup' .. i].Border.Bg:Kill()
			_G['StaticPopup' .. i .. 'EditBox']:SkinEditBox()
			_G['StaticPopup' .. i .. 'MoneyInputFrameGold']:SkinEditBox()
			_G['StaticPopup' .. i .. 'MoneyInputFrameSilver']:SkinEditBox()
			_G['StaticPopup' .. i .. 'MoneyInputFrameCopper']:SkinEditBox()
			_G['StaticPopup' .. i .. 'EditBox'].backdrop:Point('TOPLEFT', -2, -4)
			_G['StaticPopup' .. i .. 'EditBox'].backdrop:Point('BOTTOMRIGHT', 2, 4)
			_G['StaticPopup' .. i .. 'ItemFrameNameFrame']:Kill()
			_G['StaticPopup' .. i .. 'ItemFrame']:GetNormalTexture():Kill()
			_G['StaticPopup' .. i .. 'ItemFrame']:SetTemplate('Default')
			_G['StaticPopup' .. i .. 'ItemFrame']:StyleButton()
			_G['StaticPopup' .. i .. 'ItemFrameIconTexture']:SetTexCoord(.08, .92, .08, .92)
			_G['StaticPopup' .. i .. 'ItemFrameIconTexture']:ClearAllPoints()
			_G['StaticPopup' .. i .. 'ItemFrameIconTexture']:Point('TOPLEFT', 2, -2)
			_G['StaticPopup' .. i .. 'ItemFrameIconTexture']:Point('BOTTOMRIGHT', -2, 2)
		end
	end

	local BlizzardMenuButtons = {
		'Options', 
		'SoundOptions', 
		'UIOptions', 
		'Keybindings', 
		'Macros',
		'Ratings',
		'AddOns', 
		'Logout', 
		'Quit', 
		'Continue', 
		'MacOptions',
		'Store',
		'Help',
		'WhatsNew',
		'Addons'
	}

	for i = 1, getn(BlizzardMenuButtons) do
		local button = _G['GameMenuButton'..BlizzardMenuButtons[i]]
		if button then button:SkinButton() end
		GameMenuFrame.Border:Kill()
	end

	local BlizzardHeader = {
		'GameMenuFrameHeader', 
		'InterfaceOptionsFrame', 
		'AudioOptionsFrame', 
		'VideoOptionsFrame',
	}
	
	for i = 1, getn(BlizzardHeader) do
		local title = _G[BlizzardHeader[i]..'Header']
		local header = GameMenuFrame.Header
		if header then
			header:StripTextures()
		end	
		if title then
			title:StripTextures()
			title:ClearAllPoints()
			if title == _G['GameMenuFrame.Header'] then title:SetPoint('TOP', GameMenuFrame, 0, 7) else title:SetPoint('TOP', BlizzardHeader[i], 0, 0) end
		end
	end
	VideoOptionsFrame.Header:StripTextures()

	if GameMenuFrame_UpdateVisibleButtons then
		hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function()
			GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonStore:GetHeight())
			if IsAddOnLoaded('Enhanced_Config') then GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonStore:GetHeight()) end
		end)
	end
	
	local rc = {
		'ReadyCheckFrameYesButton',
		'ReadyCheckFrameNoButton',
	}

	for i = 1, getn(rc) do
		local Buttons = _G[rc[i]]
		if Buttons then Buttons:SkinButton() end
	end

	_G['ReadyCheckFrameYesButton']:SetParent(_G['ReadyCheckFrame'])
	_G['ReadyCheckFrameNoButton']:SetParent(_G['ReadyCheckFrame'])
	_G['ReadyCheckFrameYesButton']:ClearAllPoints()
	_G['ReadyCheckFrameNoButton']:ClearAllPoints()
	_G['ReadyCheckFrameYesButton']:SetPoint('RIGHT', _G['ReadyCheckFrame'], 'CENTER', -2, -20)
	_G['ReadyCheckFrameNoButton']:SetPoint('LEFT', _G['ReadyCheckFrameYesButton'], 'RIGHT', 3, 0)
	_G['ReadyCheckFrameText']:SetParent(_G['ReadyCheckFrame'])	
	_G['ReadyCheckFrameText']:ClearAllPoints()
	_G['ReadyCheckFrameText']:SetPoint('TOP', 0, -12)

	_G['ReadyCheckListenerFrame']:SetAlpha(0)
	_G['ReadyCheckFrame']:HookScript('OnShow', function(self) if UnitIsUnit('player', self.initiator) then self:Hide() end end)

	if not IsAddOnLoaded('AddOnSkins') then
		local BlizzardButtons = {
			'VideoOptionsFrameOkay', 
			'VideoOptionsFrameCancel', 
			'VideoOptionsFrameDefaults', 
			'VideoOptionsFrameApply', 
			'AudioOptionsFrameOkay', 
			'AudioOptionsFrameCancel', 
			'AudioOptionsFrameDefaults', 
			'InterfaceOptionsFrameDefaults', 
			'InterfaceOptionsFrameOkay', 
			'InterfaceOptionsFrameCancel',
			'StackSplitOkayButton',
			'StackSplitCancelButton',
			'RolePollPopupAcceptButton',
			'InterfaceOptionsHelpPanelResetTutorials',
			'CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton',
		}

		for i = 1, getn(BlizzardButtons) do
			local Buttons = _G[BlizzardButtons[i]]
			if Buttons then Buttons:SkinButton() end
		end

		_G['VideoOptionsFrameCancel']:ClearAllPoints()
		_G['VideoOptionsFrameCancel']:SetPoint('RIGHT',_G['VideoOptionsFrameApply'],'LEFT',-4,0)
		_G['VideoOptionsFrameOkay']:ClearAllPoints()
		_G['VideoOptionsFrameOkay']:SetPoint('RIGHT',_G['VideoOptionsFrameCancel'],'LEFT',-4,0)	
		_G['AudioOptionsFrameOkay']:ClearAllPoints()
		_G['AudioOptionsFrameOkay']:SetPoint('RIGHT',_G['AudioOptionsFrameCancel'],'LEFT',-4,0)
		_G['InterfaceOptionsFrameOkay']:ClearAllPoints()
		_G['InterfaceOptionsFrameOkay']:SetPoint('RIGHT',_G['InterfaceOptionsFrameCancel'],'LEFT', -4,0)
		VideoOptionsFrame.Border:SetAlpha(0)

		_G['StackSplitFrame']:GetRegions():Hide()
		_G['GeneralDockManagerOverflowButtonList']:SetTemplate()

		RolePollPopup:SetTemplate('Default')
		RolePollPopupCloseButton:SkinCloseButton()

		for i = 1, 4 do
			local button = _G['StaticPopup' .. i .. 'CloseButton']
			button:SetNormalTexture('')
			button.SetNormalTexture = D['Dummy']
			button:SetPushedTexture('')
			button.SetPushedTexture = D['Dummy']
			button:SkinCloseButton()
		end
		
		local frames = {
			'VideoOptionsFrameCategoryFrame',
			'VideoOptionsFramePanelContainer',
			'Display_',
			'Graphics_',
			'RaidGraphics_',
			'InterfaceOptionsFrameCategories',
			'InterfaceOptionsFramePanelContainer',
			'InterfaceOptionsFrameAddOns',
			'AudioOptionsSoundPanelPlayback',
			'AudioOptionsSoundPanelVolume',
			'AudioOptionsSoundPanelHardware',
			'AudioOptionsVoicePanelTalking',
			'AudioOptionsVoicePanelBinding',
			'AudioOptionsVoicePanelListening',
		}

		for i = 1, getn(frames) do
			local SkinFrames = _G[frames[i]]
			if SkinFrames then
				SkinFrames:StripTextures()
				SkinFrames:CreateBackdrop('Transparent')
				if SkinFrames ~= _G['VideoOptionsFramePanelContainer'] and SkinFrames ~= _G['InterfaceOptionsFramePanelContainer'] then
					SkinFrames.backdrop:Point('TOPLEFT',-1,0)
					SkinFrames.backdrop:Point('BOTTOMRIGHT',0,1)
				else
					SkinFrames.backdrop:Point('TOPLEFT', 0, 0)
					SkinFrames.backdrop:Point('BOTTOMRIGHT', 0, 0)
				end
			end
		end

		local interfacetab = {
			'InterfaceOptionsFrameTab1',
			'InterfaceOptionsFrameTab2',
		}

		for i = 1, getn(interfacetab) do
			local itab = _G[interfacetab[i]]
			if itab then
				itab:StripTextures()
				itab:SkinTab()
			end
		end
		InterfaceOptionsFrame.Border:Kill()
		InterfaceOptionsFrameTab1:ClearAllPoints()
		InterfaceOptionsFrameTab1:SetPoint('BOTTOMLEFT',InterfaceOptionsFrameCategories,'TOPLEFT',-11,-2)

		VideoOptionsFrameDefaults:ClearAllPoints()
		InterfaceOptionsFrameDefaults:ClearAllPoints()
		InterfaceOptionsFrameCancel:ClearAllPoints()
		VideoOptionsFrameDefaults:SetPoint('TOPLEFT',VideoOptionsFrameCategoryFrame,'BOTTOMLEFT',-1,-5)
		InterfaceOptionsFrameDefaults:SetPoint('TOPLEFT',InterfaceOptionsFrameCategories,'BOTTOMLEFT',-1,-5)
		InterfaceOptionsFrameCancel:SetPoint('TOPRIGHT',InterfaceOptionsFramePanelContainer,'BOTTOMRIGHT',0,-6)

		local interfacecheckbox = {
			-- Controls --
			'ControlsPanelStickyTargeting',
			'ControlsPanelAutoDismount',
			'ControlsPanelAutoClearAFK',
			'ControlsPanelLootAtMouse',
			'ControlsPanelAutoLootCorpse',
			'ControlsPanelInteractOnLeftClick',
			-- Combat --
			'CombatPanelTargetOfTarget',
			'CombatPanelFlashLowHealthWarning',
			'CombatPanelLossOfControl',
			'CombatPanelAutoSelfCast',
			'CombatPanelEnableFloatingCombatText',
			-- Display --
			'Display_UseUIScale',
			'DisplayPanelRotateMinimap',
			'DisplayPanelAJAlerts',
			'DisplayPanelShowTutorials',
			'DisplayPanelEnableFloatingCombatText',
			-- Social --
			'SocialPanelProfanityFilter',
			'SocialPanelSpamFilter',
			'SocialPanelGuildMemberAlert',
			'SocialPanelBlockTrades',
			'SocialPanelBlockGuildInvites',
			'SocialPanelBlockChatChannelInvites',
			'SocialPanelShowAccountAchievments',
			'SocialPanelOnlineFriends',
			'SocialPanelOfflineFriends',
			'SocialPanelBroadcasts',
			'SocialPanelAutoAcceptQuickJoinRequests',
			'SocialPanelFriendRequests',
			'SocialPanelShowToastWindow',
			'SocialPanelEnableTwitter',
			-- Action bars --
			'ActionBarsPanelLockActionBars',
			'ActionBarsPanelCountdownCooldowns',
			-- Names --
			'NamesPanelMyName',
			'NamesPanelNonCombatCreature',
			'NamesPanelFriendlyPlayerNames',
			'NamesPanelFriendlyMinions',
			'NamesPanelUnitNameplatesPersonalResource',
			'NamesPanelUnitNameplatesPersonalResourceOnEnemy',
			'NamesPanelUnitNameplatesMakeLarger',
			'NamesPanelUnitNameplatesShowAll',
			'NamesPanelUnitNameplatesAggroFlash',
			'NamesPanelEnemyPlayerNames',
			'NamesPanelEnemyMinions',
			'NamesPanelUnitNameplatesFriends',
			'NamesPanelUnitNameplatesFriendlyMinions',
			'NamesPanelUnitNameplatesEnemyMinions',
			'NamesPanelUnitNameplatesEnemyMinus',
			-- Camera --
			'CameraPanelWaterCollision',
			-- Mouse
			'MousePanelInvertMouse',
			'MousePanelClickToMove',
			'MousePanelEnableMouseSpeed',
		}

		for i = 1, getn(interfacecheckbox) do
			local icheckbox = _G['InterfaceOptions'..interfacecheckbox[i]]
			if icheckbox then icheckbox:SkinCheckBox() end
		end

		local interfacedropdown ={
			-- Controls --
			'ControlsPanelAutoLootKeyDropDown',
			-- Combat --
			'CombatPanelFocusCastKeyDropDown',
			'CombatPanelSelfCastKeyDropDown',
			-- Display --
			'DisplayPanelOutlineDropDown',
			'DisplayPanelSelfHighlightDropDown',
			'DisplayPanelDisplayDropDown',
			'DisplayPanelChatBubblesDropDown',
			'Graphics_SpellDensityDropDown',
			-- Social --
			'SocialPanelWhisperMode',
			'SocialPanelTimestamps',
			-- Action bars --
			'ActionBarsPanelPickupActionKeyDropDown',
			-- Names --
			'NamesPanelNPCNamesDropDown',
			'NamesPanelUnitNameplatesMotionDropDown',
			-- Camera --
			'CameraPanelStyleDropDown',
			-- Mouse --
			'MousePanelClickMoveStyleDropDown',
			-- Languages --
			'LanguagesPanelLocaleDropDown',
			'LanguagesPanelAudioLocaleDropDown',
		}

		for i = 1, getn(interfacedropdown) do
			local idropdown = _G['InterfaceOptions'..interfacedropdown[i]]
			if idropdown then DropDownList1:SetTemplate('Transparent') end
		end
		_G['InterfaceOptionsCameraPanelStyleDropDown']:SetWidth(200)

		local optioncheckbox = {
			-- Graphics --
			'Display_RaidSettingsEnabledCheckBox',
			-- Advanced --
			'Advanced_MaxFPSCheckBox',
			'Advanced_MaxFPSBKCheckBox',
			'Advanced_ShowHDModels',
			'Advanced_DesktopGamma',
			-- Network --
			'NetworkOptionsPanelOptimizeSpeed',
			'NetworkOptionsPanelUseIPv6',
			'NetworkOptionsPanelAdvancedCombatLogging',
			-- Audio --
			'AudioOptionsSoundPanelEnableSound',
			'AudioOptionsSoundPanelSoundEffects',
			'AudioOptionsSoundPanelPetSounds',
			'AudioOptionsSoundPanelEmoteSounds',
			'AudioOptionsSoundPanelMusic',
			'AudioOptionsSoundPanelLoopMusic',
			'AudioOptionsSoundPanelPetBattleMusic',
			'AudioOptionsSoundPanelAmbientSounds',
			'AudioOptionsSoundPanelDialogSounds',
			'AudioOptionsSoundPanelErrorSpeech',
			'AudioOptionsSoundPanelSoundInBG',
			'AudioOptionsSoundPanelReverb',
			'AudioOptionsSoundPanelHRTF',
			'AudioOptionsSoundPanelEnableDSPs',
			-- Voice --
			'AudioOptionsVoicePanelEnableVoice',
			'AudioOptionsVoicePanelEnableMicrophone',
			'AudioOptionsVoicePanelPushToTalkSound',
		}

		for i = 1, getn(optioncheckbox) do
			local ocheckbox = _G[optioncheckbox[i]]
			if ocheckbox then ocheckbox:SkinCheckBox() end
		end

		local optiondropdown = {
			-- Graphics --
			'Display_DisplayModeDropDown',
			'Display_ResolutionDropDown',
			'Display_RefreshDropDown',
			'Display_PrimaryMonitorDropDown',
			'Display_AntiAliasingDropDown',
			'Display_VerticalSyncDropDown',
			-- Base --
			'Graphics_TextureResolutionDropDown',
			'Graphics_FilteringDropDown',
			'Graphics_ProjectedTexturesDropDown',
			'Graphics_ShadowsDropDown',
			'Graphics_LiquidDetailDropDown',
			'Graphics_SunshaftsDropDown',
			'Graphics_ParticleDensityDropDown',
			'Graphics_SSAODropDown',
			'Graphics_DepthEffectsDropDown',
			'Graphics_LightingQualityDropDown',
			'Graphics_OutlineModeDropDown',
			-- Raid --
			'RaidGraphics_TextureResolutionDropDown',
			'RaidGraphics_FilteringDropDown',
			'RaidGraphics_ProjectedTexturesDropDown',
			'RaidGraphics_ShadowsDropDown',
			'RaidGraphics_LiquidDetailDropDown',
			'RaidGraphics_SunshaftsDropDown',
			'RaidGraphics_ParticleDensityDropDown',
			'RaidGraphics_SSAODropDown',
			'RaidGraphics_DepthEffectsDropDown',
			'RaidGraphics_LightingQualityDropDown',
			'RaidGraphics_OutlineModeDropDown',
			-- Advanced --
			'Advanced_BufferingDropDown',
			'Advanced_LagDropDown',
			'Advanced_HardwareCursorDropDown',
			'Advanced_MultisampleAntiAliasingDropDown',
			'Advanced_MultisampleAlphaTest',
			'Advanced_PostProcessAntiAliasingDropDown',
			'Advanced_ResampleQualityDropDown',
			'Advanced_GraphicsAPIDropDown',
			'Advanced_PhysicsInteractionDropDown',
			-- Audio --
			'AudioOptionsSoundPanelHardwareDropDown',
			'AudioOptionsSoundPanelSoundChannelsDropDown',
			'AudioOptionsSoundPanelSoundCacheSizeDropDown',
			-- Voice --
			'AudioOptionsVoicePanelInputDeviceDropDown',
			'AudioOptionsVoicePanelChatModeDropDown',
			'AudioOptionsVoicePanelOutputDeviceDropDown',
		}

		for i = 1, getn(optiondropdown) do
			local odropdown = _G[optiondropdown[i]]
			if odropdown then
				odropdown:SkinDropDownBox(165)
				DropDownList1:SetTemplate('Transparent')
			end
		end

		local buttons = {
			'InterfaceOptionsDisplayPanelResetTutorials',
			'InterfaceOptionsSocialPanelRedockChat',
			'InterfaceOptionsSocialPanelTwitterLoginButton',
		}
		for _, button in pairs(buttons) do _G[button]:SkinButton() end

		InterfaceOptionsFrameAddOnsListScrollBar:SkinScrollBar()

		-- sliders
		local slides = {
			-- InterfaceOptions --
			'InterfaceOptionsCombatPanelSpellAlertOpacitySlider',
			'InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset',
			'InterfaceOptionsBattlenetPanelToastDurationSlider',
			'InterfaceOptionsCameraPanelMaxDistanceSlider',
			'InterfaceOptionsCameraPanelFollowSpeedSlider',
			'InterfaceOptionsMousePanelMouseSensitivitySlider',
			'InterfaceOptionsMousePanelMouseLookSpeedSlider',
			-- Display --
			'Display_RenderScaleSlider',
			'Display_UIScaleSlider',
			-- Base --
			'Graphics_ViewDistanceSlider',
			'Graphics_EnvironmentalDetailSlider',
			'Graphics_GroundClutterSlider',
			-- Raid --
			'RaidGraphics_ViewDistanceSlider',
			'RaidGraphics_EnvironmentalDetailSlider',
			'RaidGraphics_GroundClutterSlider',
			-- Advanced
			'Advanced_MaxFPSSlider',
			'Advanced_MaxFPSBKSlider',
			'Advanced_RenderScaleSlider',
			'Advanced_GammaSlider',
			-- Audio -- 
			'AudioOptionsSoundPanelMasterVolume',
			'AudioOptionsSoundPanelSoundVolume',
			'AudioOptionsSoundPanelMusicVolume',
			'AudioOptionsSoundPanelAmbienceVolume',
			'AudioOptionsSoundPanelDialogVolume',
			-- Voice --
			'AudioOptionsVoicePanelMicrophoneVolume',
			'AudioOptionsVoicePanelSpeakerVolume',
			'AudioOptionsVoicePanelSoundFade',
			'AudioOptionsVoicePanelMusicFade',
			'AudioOptionsVoicePanelAmbienceFade',
		}

		for i = 1, getn(slides) do
			if _G[slides[i]] then
				if _G[slides[i]] ~= AudioOptionsSoundPanelSoundVolume then _G[slides[i]]:SkinSlideBar(8, true) else _G[slides[i]]:SkinSlideBar(8) end
			end
		end

		GraphicsButton:StripTextures()
		GraphicsButton:SkinButton()
		Graphics_Quality:SetScript('OnUpdate', function(self) Graphics_Quality:SkinSlideBar(11) end)

		RaidButton:StripTextures()
		RaidButton:SkinButton()
		RaidGraphics_Quality:SetScript('OnUpdate', function(self) RaidGraphics_Quality:SkinSlideBar(11) end)
	end
end

tinsert(D['SkinFuncs']['DuffedUI'], LoadSkin)