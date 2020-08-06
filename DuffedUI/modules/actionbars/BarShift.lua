local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local move = D['move']
local spacing = D['buttonspacing']

local StanceBar = CreateFrame('Frame', 'DuffedUIStance', UIParent, 'SecureHandlerStateTemplate')
StanceBar:SetHeight(15)
StanceBar:SetWidth((D['petbuttonsize'] * 4) + (D['petbuttonsize'] * 3))
StanceBar:ClearAllPoints()
StanceBar:Point('TOPLEFT', 0, -200)
StanceBarFrame.ignoreFramePositionManager = true
StanceBarFrame:StripTextures()
StanceBarFrame:SetParent(StanceBar)
StanceBarFrame:ClearAllPoints()
StanceBarFrame:SetPoint('TOPLEFT', StanceBar, 'TOPLEFT', -7, 0)
StanceBarFrame:EnableMouse(true)

for i = 1, NUM_STANCE_SLOTS do
	local Button = _G['StanceButton'..i]
	Button:Show()

	if (i ~= 1) then
		local Previous = _G['StanceButton'..i -1]
		Button:ClearAllPoints()
		if C['actionbar']['verticalshapeshift'] then
			Button:Point('TOP', Previous, 'BOTTOM', 0, -spacing)
		else
			Button:Point('LEFT', Previous, 'RIGHT', spacing, 0)
		end
	end
end

if C['actionbar']['shapeshiftmouseover'] then
	local function mouseover(alpha)
		for i = 1, NUM_STANCE_SLOTS do
			local Button = _G['StanceButton' .. i]
				Button:SetAlpha(alpha)
			end
		end

	for i = 1, NUM_STANCE_SLOTS do
		_G['StanceButton' .. i]:SetAlpha(C['actionbar']['shapeshiftmouseovervalue'])
		_G['StanceButton' .. i .. 'Cooldown']:SetDrawBling(false)
		_G['StanceButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
		_G['StanceButton' .. i]:HookScript('OnEnter', function(self) mouseover(1) end)
		_G['StanceButton' .. i]:HookScript('OnLeave', function(self) mouseover(C['actionbar']['shapeshiftmouseovervalue']) end)
	end
end
RegisterStateDriver(StanceBar, 'visibility', '[vehicleui][petbattle] hide; show')

StanceBar:RegisterEvent('PLAYER_ENTERING_WORLD')
StanceBar:RegisterEvent('UPDATE_SHAPESHIFT_FORMS')
StanceBar:RegisterEvent('UPDATE_SHAPESHIFT_USABLE')
StanceBar:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN')
StanceBar:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
StanceBar:RegisterEvent('ACTIONBAR_PAGE_CHANGED')
StanceBar:RegisterEvent('PLAYER_TALENT_UPDATE')
StanceBar:RegisterEvent('SPELLS_CHANGED')
StanceBar:SetScript('OnEvent', function(self, event, ...)
	if (event == 'UPDATE_SHAPESHIFT_FORMS') then
	elseif (event == 'PLAYER_ENTERING_WORLD') then
		D['ShiftBarUpdate'](self)
		D['StyleShift'](self)
	else
		D['ShiftBarUpdate'](self)
	end
end)
move:RegisterFrame(StanceBar)
RegisterStateDriver(StanceBar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show')