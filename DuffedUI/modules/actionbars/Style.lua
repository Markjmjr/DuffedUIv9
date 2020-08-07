local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

local _G = _G
local sub, replace = string.sub, string.gsub
local f, fs, ff = C['media']['font'], 11, 'THINOUTLINE'

D['StyleActionBarButton'] = function(self)
	local name = self:GetName()
	local action = self.action
	local Button = self
	local Icon = _G[name..'Icon']
	local Count = _G[name..'Count']
	local Flash	 = _G[name..'Flash']
	local HotKey = _G[name..'HotKey']
	local Border  = _G[name..'Border']
	local Btname = _G[name..'Name']
	local normal  = _G[name..'NormalTexture']
	local BtnBG = _G[name..'FloatingBG']
 
	Flash:SetTexture('')
	Button:SetNormalTexture('')
 
	Count:ClearAllPoints()
	Count:Point('BOTTOMRIGHT', 0, 2)

	HotKey:ClearAllPoints()
	HotKey:Point('TOPRIGHT', 1, -3)

	if Border and Border:IsShown() then
		Border:Hide()
		Border = D['Dummy']
	end

	if Btname and normal and C['actionbar']['macro'] then
		local query = GetActionText(action)
		if query then
			local text = string.sub(query, 1, 5)
			Btname:SetText(text)
		end
	end

	if Button.isSkinned then return end

	Count:SetFont(f, fs, ff)

	if Btname then
		if C['actionbar']['macro'] then
			Btname:SetFont(f, fs, ff)
			Btname:ClearAllPoints()
			Btname:SetPoint('BOTTOM', 1, 1)
		else
			Btname:SetText('')
			Btname:Kill()
		end
	end

	if BtnBG then BtnBG:Kill() end
 
	if C['actionbar']['hotkey'] then
		HotKey:SetFont(f, fs, ff)
		HotKey:SetShadowOffset(0, 0)
		HotKey.ClearAllPoints = D['Dummy']
		HotKey.SetPoint = D['Dummy']
	else
		HotKey:SetText('')
		HotKey:Kill()
	end

	if name:match('Extra') then
		Button:SetTemplate()
		Button.pushed = true
		Icon:SetDrawLayer('ARTWORK')
	else
		Button:CreateBackdrop()
		Button.backdrop:SetOutside(Button, 0, 0)
		Button:UnregisterEvent('ACTIONBAR_SHOWGRID')
		Button:UnregisterEvent('ACTIONBAR_HIDEGRID')
	end

	Icon:SetTexCoord(.08, .92, .08, .92)
	Icon:SetInside()

	if normal and Button:GetChecked() then ActionButton_UpdateState(Button) end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint('TOPLEFT')
		normal:SetPoint('BOTTOMRIGHT')
	end

	Button:StyleButton()
	Button.isSkinned = true
end

D['StyleActionBarPetAndShiftButton'] = function(normal, button, icon, name, pet)
	if button.isSkinned then return end

	local HotKey = _G[button:GetName()..'HotKey']

	button:Size(D['petbuttonsize'])
	button:CreateBackdrop()
	button.backdrop:SetInside(button, 0, 0)
	
	if C['actionbar']['hotkey'] then
		HotKey:SetFont(f, fs, ff)
		HotKey:SetShadowOffset(0, 0)
		HotKey:ClearAllPoints()
		HotKey:Point('TOPRIGHT', -1, -1)
	else
		HotKey:SetText('')
		HotKey:Kill()
	end

	icon:SetTexCoord(.08, .92, .08, .92)
	icon:ClearAllPoints()
	icon:SetInside()
	
	if pet then
		if D['petbuttonsize'] < 30 then
			local autocast = _G[name..'AutoCastable']
			autocast:SetAlpha(0)
		end
		local shine = _G[name..'Shine']
		shine:Size(D['petbuttonsize'])
		shine:ClearAllPoints()
		shine:SetPoint('CENTER', button, 0, 0)
	end

	button:SetNormalTexture('')
	button.SetNormalTexture = D['Dummy']

	local Flash = _G[name..'Flash']
	Flash:SetTexture('')

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint('TOPLEFT')
		normal:SetPoint('BOTTOMRIGHT')
	end

	button:StyleButton()
	button.isSkinned = true
end

D['StyleShift'] = function()
	for i = 1, NUM_STANCE_SLOTS do
		local name = 'StanceButton'..i
		local button  = _G[name]
		local icon  = _G[name..'Icon']
		local normal  = _G[name..'NormalTexture']
		D['StyleActionBarPetAndShiftButton'](normal, button, icon, name, false)
	end
end

D['StylePet'] = function()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = 'PetActionButton'..i
		local button  = _G[name]
		local icon  = _G[name..'Icon']
		local normal  = _G[name..'NormalTexture2']
		D['StyleActionBarPetAndShiftButton'](normal, button, icon, name, true)
	end
end

D['UpdateKeybind'] = function(self, actionButtonType)
	local HotKey = _G[self:GetName()..'HotKey']
	local Text = HotKey:GetText()

	if Text then
		Text = replace(Text, '(s%-)', 'S')
		Text = replace(Text, '(a%-)', 'A')
		Text = replace(Text, '(c%-)', 'C')
		Text = replace(Text, '(Mouse Button )', 'M')
		Text = replace(Text, '(Num Pad )', 'N')
		Text = replace(Text, KEY_BUTTON3, 'M3')
		Text = replace(Text, KEY_PAGEUP, 'PU')
		Text = replace(Text, KEY_PAGEDOWN, 'PD')
		Text = replace(Text, KEY_SPACE, 'SpB')
		Text = replace(Text, KEY_INSERT, 'Ins')
		Text = replace(Text, KEY_HOME, 'Hm')
		Text = replace(Text, KEY_DELETE, 'Del')
		Text = replace(Text, KEY_NUMPADDECIMAL, 'Nu.')
		Text = replace(Text, KEY_NUMPADDIVIDE, 'Nu/')
		Text = replace(Text, KEY_NUMPADMINUS, 'Nu-')
		Text = replace(Text, KEY_NUMPADMULTIPLY, 'Nu*')
		Text = replace(Text, KEY_NUMPADPLUS, 'Nu+')
		Text = replace(Text, KEY_NUMLOCK, 'NuL')
		Text = replace(Text, KEY_MOUSEWHEELDOWN, 'MWD')
		Text = replace(Text, KEY_MOUSEWHEELUP, 'MWU')
	end

	if HotKey:GetText() == _G['RANGE_INDICATOR'] then HotKey:SetText('') else HotKey:SetText(Text) end
end
--hooksecurefunc('ActionButton_OnEvent', function(self, event, ...) if event == 'PLAYER_ENTERING_WORLD' then ActionButton_UpdateHotkeys(self, self.buttonType) end end)
hooksecurefunc('PetActionButton_OnEvent', function(self, event, ...) if event == 'PLAYER_ENTERING_WORLD' then PetActionButton_SetHotkeys(self, self.buttonType) end end)

local buttons = 0
local function SetupFlyoutButton()
	for i = 1, buttons do
		if _G['SpellFlyoutButton'..i] then
			D['StyleActionBarButton'](_G['SpellFlyoutButton'..i])
			if _G['SpellFlyoutButton'..i]:GetChecked() then _G['SpellFlyoutButton'..i]:SetChecked(nil) end
		end
	end
end
SpellFlyout:HookScript('OnShow', SetupFlyoutButton)
 
-- written by Elv
D['StyleActionBarFlyout'] = function(button)
	if(not button.FlyoutArrow or not button.FlyoutArrow:IsShown()) then return end

	if not button.FlyoutBorder then return end
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)

	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end

	-- Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout:IsShown() and SpellFlyout:GetParent() == button) or GetMouseFocus() == button) then arrowDistance = 5 else arrowDistance = 2 end
	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == 'SpellBookSpellIconsFrame' then return end
	if button:GetParent() then
		local point, _, _, _, _ = button:GetParent():GetParent():GetPoint()
		if point == 'UNKNOWN' then return end

		if strfind == 'TOP' then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint('TOP', button, 'TOP', 0, arrowDistance)
			SetClampedTextureRotation(button.FlyoutArrow, 0)
		elseif point == 'RIGHT' then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint('LEFT', button, 'LEFT', -arrowDistance, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 270)
		end
	end
end

local ProcBackdrop = {
	edgeFile = C['media']['blank'], edgeSize = D['mult'],
	insets = {left = D['mult'], right = D['mult'], top = D['mult'], bottom = D['mult']},
}

local ShowOverlayGlow = function(self)
	if self.overlay then
		if (self.overlay.animOut:IsPlaying()) then
			self.overlay.animOut:Stop()
			self.overlay.animIn:Play()
		end
	else
		self.overlay = ActionButton_GetOverlayGlow()
		local frameWidth, frameHeight = self:GetSize()
		self.overlay:SetParent(self)
		self.overlay:ClearAllPoints()
		self.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
		self.overlay:SetPoint('TOPLEFT', self, 'TOPLEFT', -frameWidth * 0.2, frameHeight * 0.2)
		self.overlay:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', frameWidth * 0.2, -frameHeight * 0.2)
		self.overlay.animIn:Play()
	end
end

local HideOverlayGlow = function(self)
	if self.overlay then
		if self.overlay.animIn:IsPlaying() then self.overlay.animIn:Stop() end
		if self:IsVisible() then self.overlay.animOut:Play() else ActionButton_OverlayGlowAnimOutFinished(self.overlay.animOut) end
	end
end

D.ShowHighlightActionButton = function(self)
	if C['actionbar']['borderhighlight'] then
		if self.overlay then
			self.overlay:Hide()
			ActionButton_HideOverlayGlow(self)
		end

		if not self.Animation then
			local NewProc = CreateFrame('Frame', nil, self)
			NewProc:SetBackdrop(ProcBackdrop)
			NewProc:SetBackdropBorderColor(1, 1, 0)
			NewProc:SetAllPoints(self)
			self.NewProc = NewProc

			local Animation = self.NewProc:CreateAnimationGroup()
			Animation:SetLooping('BOUNCE')

			local FadeOut = Animation:CreateAnimation('Alpha')
			FadeOut:SetFromAlpha(1)
			FadeOut:SetToAlpha(0)
			FadeOut:SetDuration(.40)
			FadeOut:SetSmoothing('IN_OUT')

			self.Animation = Animation
		end
		if not self.Animation:IsPlaying() then self.Animation:Play() self.NewProc:Show() end
	else
		if self.overlay then
			if self.NewProc then self.NewProc:Hide() end
			self.overlay:Show()
			ShowOverlayGlow(self)
		else
			HideOverlayGlow(self)
		end
	end
end

D['HideHighlightActionButton'] = function(self)
	if C['actionbar']['borderhighlight'] then
		if self.Animation and self.Animation:IsPlaying() then self.Animation:Stop() self.NewProc:Hide() end
	else
		if self.Animation and self.Animation:IsPlaying() then
			self.Animation:Stop()
			self.NewProc:Hide()
		end
	end
end

hooksecurefunc('ActionButton_ShowOverlayGlow', D['ShowHighlightActionButton'])
hooksecurefunc('ActionButton_HideOverlayGlow', D['HideHighlightActionButton'])
--hooksecurefunc('ActionButton_Update', D['StyleActionBarButton'])
--hooksecurefunc('ActionButton_UpdateHotkeys', D['UpdateKeybind'])
--hooksecurefunc('PetActionButton_SetHotkeys', D['UpdateKeybind'])
hooksecurefunc('ActionButton_UpdateFlyout', D['StyleActionBarFlyout'])