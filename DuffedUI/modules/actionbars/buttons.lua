local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

local cp = '|cff319f1b' -- +
local cm = '|cff9a1212' -- -
local move = D['move']

local function ShowOrHideBar(bar, button)
	local db = DuffedUIDataPerChar

	if bar:IsShown() then
		if not C['actionbar']['LeftSideBarDisable'] then
			if bar == DuffedUIBar3 then
				if button == DuffedUIBar3Button then
					UnregisterStateDriver(bar, 'visibility')
					bar:Hide()
					db.bar3 = true
				end
			end
		end

		if not C['actionbar']['RightSideBarDisable'] then
			if bar == DuffedUIBar4 then
				if button == DuffedUIBar4Button then
					UnregisterStateDriver(bar, 'visibility')
					bar:Hide()
					db.bar4 = true
				end
			end
		end

		if not C['actionbar']['rightbarDisable'] then
			if bar == DuffedUIBar5 then
				if button == DuffedUIBar5Button then
					UnregisterStateDriver(bar, 'visibility')
					bar:Hide()
					db.bar5 = true
				end
			end
		end
	else
		if not C['actionbar']['LeftSideBarDisable'] then
			if bar == DuffedUIBar3 then
				db.bar3 = false
				RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle] show; show')
			end
		end

		if not C['actionbar']['RightSideBarDisable'] then
			if bar == DuffedUIBar4 then
				db.bar4 = false
				RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle] show; show')
			end
		end

		if not C['actionbar']['rightbarDisable'] then
			if bar == DuffedUIBar5 then
				db.bar5 = false
				RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle] show; show')
			end
		end
	end
end

local function MoveButtonBar(button, bar)
	local db = DuffedUIDataPerChar

	if button == DuffedUIBar3Button then
		if bar:IsShown() then 
			button.text:SetText(cm..'-|r')
		else
			button.text:SetText(cp..'+|r')
		end
	end

	if button == DuffedUIBar4Button then
		if bar:IsShown() then
			button.text:SetText(cm..'-|r')
		else
			button.text:SetText(cp..'+|r')
		end
	end

	if button == DuffedUIBar5Button then
		if bar:IsShown() then
			button.text:SetText(cm..'>|r')
			if not C['actionbar']['petbarhorizontal'] then
				DuffedUIPetBarMover:Point('RIGHT', DuffedUIBar5, 'LEFT', -6, 0)
			else
				if C['chat']['rbackground'] then
					DuffedUIPetBarMover:SetPoint('BOTTOMRIGHT', DuffedUIChatBackgroundRight, 'TOPRIGHT', 0, 3)
				else
					DuffedUIPetBarMover:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -5, 176)
				end
			end
		else
			button.text:SetText(cp..'<|r')
			if not C['actionbar']['petbarhorizontal'] then
				DuffedUIPetBarMover:Point('RIGHT', UIParent, 'RIGHT', -14, -14)
			else
				if C['chat']['rbackground'] then
					DuffedUIPetBarMover:SetPoint('BOTTOMRIGHT', DuffedUIChatBackgroundRight, 'TOPRIGHT', 0, 3)
				else
					DuffedUIPetBarMover:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -5, 176)
				end
			end
		end
	end
end

local function UpdateBar(self, bar)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	local button = self

	ShowOrHideBar(bar, button)
	MoveButtonBar(button, bar)
end

local DuffedUIBar3Button = CreateFrame('Button', 'DuffedUIBar3Button', UIParent)
DuffedUIBar3Button:SetTemplate('Default')
DuffedUIBar3Button:RegisterForClicks('AnyUp')
DuffedUIBar3Button.text = D['SetFontString'](DuffedUIBar3Button, C['media']['font'], 11, 'THINOUTLINE')
DuffedUIBar3Button:SetScript('OnClick', function(self, btn)
	if btn == 'RightButton' then
		if DuffedUIInfoLeftBattleGround and UnitInBattleground('player') then ToggleFrame(DuffedUIInfoLeftBattleGround) end
	else
		if C['actionbar']['LeftSideBarDisable'] then return UIErrorsFrame:AddMessage(L['errortext']['LeftSideBar'], 1, 0, 0, 53, 5) end  
		if not C['actionbar']['Leftsidebars'] then UpdateBar(self, DuffedUIBar3) end
	end
end)
DuffedUIBar3Button:Size(DuffedUIInfoLeft:GetHeight())
DuffedUIBar3Button:Point('LEFT', DuffedUIInfoLeft, 'RIGHT', 2, 0)
DuffedUIBar3Button.text:Point('CENTER', 2, -1)
DuffedUIBar3Button:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(C['media']['datatextcolor1'])) end)
DuffedUIBar3Button:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(C['media']['bordercolor'])) end)
DuffedUIBar3Button.text:SetText(cm .. '-|r')

local DuffedUIBar4Button = CreateFrame('Button', 'DuffedUIBar4Button', UIParent)
DuffedUIBar4Button:SetTemplate('Default')
DuffedUIBar4Button:RegisterForClicks('AnyUp')
DuffedUIBar4Button.text = D['SetFontString'](DuffedUIBar4Button, C['media']['font'], 11, 'THINOUTLINE') 
DuffedUIBar4Button:SetScript('OnClick', function(self, btn) 
	if C['actionbar']['RightSideBarDisable'] then return UIErrorsFrame:AddMessage(L['errortext']['RightSideBar'], 1, 0, 0, 53, 5) end
	if not C['actionbar']['Rightsidebars'] then UpdateBar(self, DuffedUIBar4) end
end)
DuffedUIBar4Button:Size(DuffedUIInfoLeft:GetHeight())
DuffedUIBar4Button:Point('RIGHT', DuffedUIInfoRight, 'LEFT', -2, 0)
DuffedUIBar4Button.text:Point('CENTER', 2, -1)
DuffedUIBar4Button:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(C['media']['datatextcolor1'])) end)
DuffedUIBar4Button:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(C['media']['bordercolor'])) end)
DuffedUIBar4Button.text:SetText(cm .. '-|r')

local DuffedUIBar5Button = CreateFrame('Button', 'DuffedUIBar5Button', UIParent)
DuffedUIBar5Button:Width(12)
DuffedUIBar5Button:Height(130)
DuffedUIBar5Button:Point('RIGHT', UIParent, 'RIGHT', 1, -14)
DuffedUIBar5Button:SetTemplate('Default')
DuffedUIBar5Button:RegisterForClicks('AnyUp')
DuffedUIBar5Button:SetAlpha(0)
if not C['actionbar']['rightbarDisable'] then
	if not C['actionbar']['rightbarvertical'] then DuffedUIBar5Button:SetScript('OnClick', function(self, btn) UpdateBar(self, DuffedUIBar5) end) end
	if C['actionbar']['rightbarsmouseover'] then
		DuffedUIBar5Button:SetScript('OnEnter', function(self) DuffedUIRightBarsMouseover(1) end)
		DuffedUIBar5Button:SetScript('OnLeave', function(self) DuffedUIRightBarsMouseover(0) end)
	else
		DuffedUIBar5Button:SetScript('OnEnter', function(self) self:SetAlpha(1) end)
		DuffedUIBar5Button:SetScript('OnLeave', function(self) self:SetAlpha(0) end)
	end
end
DuffedUIBar5Button.text = D['SetFontString'](DuffedUIBar5Button, C['media']['font'], 13)
DuffedUIBar5Button.text:Point('CENTER', 0, 0)
DuffedUIBar5Button.text:SetText(cm .. '>|r')

local function Vehicle_OnEvent(self, event)
	if CanExitVehicle() then
		if (UnitOnTaxi('player')) then self.text:SetText('|cff4BAF4C' .. TAXI_CANCEL_DESCRIPTION .. '|r') else self.text:SetText('|cff4BAF4C' .. LEAVE_VEHICLE .. '|r') end
		self:Show()
		self:EnableMouse(true)
	else
		self:Hide()
	end
end

local function Vehicle_OnClick(self)
	if UnitOnTaxi('player') then TaxiRequestEarlyLanding() else VehicleExit() end
end

local vehicleleft = CreateFrame('Button', 'DuffedUIExitVehicleButtonLeft', UIParent)
vehicleleft:SetPoint('TOP', UIParent, 'TOP', 0, -5)
vehicleleft:SetSize(225, 20)
vehicleleft:SetFrameStrata('LOW')
vehicleleft:SetFrameLevel(10)
vehicleleft:SetTemplate('Default')
vehicleleft:SetBackdropBorderColor(75/255,  175/255, 76/255)
vehicleleft:RegisterForClicks('AnyUp')
vehicleleft:SetScript('OnClick', function() Vehicle_OnClick() end)
vehicleleft:SetScript('OnEnter', MainMenuBarVehicleLeaveButton_OnEnter)
vehicleleft:SetScript('OnLeave', GameTooltip_Hide)
vehicleleft:RegisterEvent('PLAYER_ENTERING_WORLD')
vehicleleft:RegisterEvent('UPDATE_BONUS_ACTIONBAR')
vehicleleft:RegisterEvent('UPDATE_MULTI_CAST_ACTIONBAR')
vehicleleft:RegisterEvent('UNIT_ENTERED_VEHICLE')
vehicleleft:RegisterEvent('UNIT_EXITED_VEHICLE')
vehicleleft:RegisterEvent('VEHICLE_UPDATE')
vehicleleft:SetScript('OnEvent', Vehicle_OnEvent)
move:RegisterFrame(vehicleleft)

vehicleleft:FontString('text', C['media']['font'], 11)
vehicleleft.text:Point('CENTER', 0, 0)
vehicleleft.text:SetShadowOffset(1.25, -1.25)

local init = CreateFrame('Frame')
init:RegisterEvent('VARIABLES_LOADED')
init:SetScript('OnEvent', function(self, event)
	if not DuffedUIDataPerChar then D.SetPerCharVariable('DuffedUIDataPerChar', {}) end
	local db = DuffedUIDataPerChar

	if db.bar3 then UpdateBar(DuffedUIBar3Button, DuffedUIBar3) end
	if db.bar4 then UpdateBar(DuffedUIBar4Button, DuffedUIBar4) end
	if db.bar5 then UpdateBar(DuffedUIBar5Button, DuffedUIBar5) end
end)