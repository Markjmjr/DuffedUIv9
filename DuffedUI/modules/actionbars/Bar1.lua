local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local bar = DuffedUIBar1

local Page = {
	['DRUID'] = '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;',
	['PRIEST'] = '[bonusbar:1] 7;',
	['ROGUE'] = '[bonusbar:1] 7;',
	['WARLOCK'] = '[stance:1] 10;',
	['MONK'] = '[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;',
	['DEFAULT'] = '[overridebar] 14; [possessbar] 12; [shapeshift] 13; [vehicleui:12] 12; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
}

local function GetBar()
	local condition = Page['DEFAULT']
	local class = D['Class']
	local page = Page[class]
	if page then condition = condition .. ' ' .. page end
	condition = condition .. ' [form] 1; 1'
	return condition
end

bar:RegisterEvent('PLAYER_LOGIN')
bar:RegisterEvent('PLAYER_ENTERING_WORLD')
bar:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
bar:RegisterEvent('BAG_UPDATE')
bar:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR')
bar:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR')
bar:SetScript('OnEvent', function(self, event, unit, ...)
	if event == 'PLAYER_LOGIN' or event == 'ACTIVE_TALENT_GROUP_CHANGED' then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G['ActionButton' .. i]
			self:SetFrameRef('ActionButton' .. i, button)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do table.insert(buttons, self:GetFrameRef('ActionButton' .. i)) end
		]])

		self:SetAttribute('_onstate-page', [[
			if HasTempShapeshiftActionBar() then newstate = GetTempShapeshiftBarIndex() or newstate end
			for i, button in ipairs(buttons) do button:SetAttribute('actionpage', tonumber(newstate)) end
		]])

		RegisterStateDriver(self, 'page', GetBar())
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')
	elseif event == 'PLAYER_ENTERING_WORLD' then
		local button
		for i = 1, 12 do
			button = _G['ActionButton' .. i]
			button:SetSize(D['buttonsize'], D['buttonsize'])
			button:ClearAllPoints()
			button:SetParent(bar)
			button:SetFrameStrata('BACKGROUND')
			button:SetFrameLevel(15)
			button:SetAttribute("showgrid", 1)
			if i == 1 then
				button:SetPoint('BOTTOMLEFT', D['buttonspacing'], D['buttonspacing'])
			else
				local previous = _G['ActionButton'..i-1]
				button:SetPoint('LEFT', previous, 'RIGHT', D['buttonspacing'], 0)
			end
		end
	elseif event == 'UPDATE_VEHICLE_ACTIONBAR' or event == 'UPDATE_OVERRIDE_ACTIONBAR' then
		if HasVehicleActionBar() then
			if not self.inVehicle then self.inVehicle = true end
		else
			if self.inVehicle then self.inVehicle = false end
		end
	end
end)