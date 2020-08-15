local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local Num = NUM_ACTIONBAR_BUTTONS
local MainMenuBar_OnEvent = MainMenuBar_OnEvent

function ab:UpdateBar1()
	local ab1 = DuffedUIBar1
	local Button

	for i = 1, Num do
		Button = _G['ActionButton'..i]
		ab1:SetFrameRef('ActionButton'..i, Button)
	end

	ab1:Execute([[
		Button = table.new()
		for i = 1, 12 do
			table.insert(Button, self:GetFrameRef('ActionButton'..i))
		end
	]])

	ab1:SetAttribute('_onstate-page', [[
		if HasTempShapeshiftActionBar() then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end

		for i, Button in ipairs(Button) do
			Button:SetAttribute('actionpage', tonumber(newstate))
		end
	]])

	RegisterStateDriver(ab1, 'page', ab1.GetBar())
end

function ab:CreateBar1()
	local move = D['Move']
	local Size = D['buttonsize']
	local PetSize = D['petbuttonsize']
	local Spacing = D['buttonspacing']
	local ab1 = DuffedUIBar1

	ab1.Page = {
		['DRUID'] = '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;',
		['PRIEST'] = '[bonusbar:1] 7;',
		['ROGUE'] = '[bonusbar:1] 7;',
		['WARLOCK'] = '[stance:1] 10;',
		['MONK'] = '[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;',
		['DEFAULT'] = '[overridebar] 14; [possessbar] 12; [shapeshift] 13; [vehicleui:12] 12; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
	}

	function ab1:GetBar()
		local Condition = ab1.Page['DEFAULT']
		local Class = select(2, UnitClass('player'))
		local Page = ab1.Page[Class]

		if Page then Condition = Condition .. ' ' .. Page end
		Condition = Condition .. ' [form] 1; 1'
		return Condition
	end

	ab:UpdateBar1()

	ab1:RegisterEvent('PLAYER_ENTERING_WORLD')
	ab1:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR')
	ab1:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR')
	ab1:SetScript('OnEvent', function(self, event, unit, ...)
		if (event == 'PLAYER_ENTERING_WORLD') then
			for i = 1, Num do
				local Button = _G['ActionButton'..i]
				Button:SetSize(Size, Size)
				Button:ClearAllPoints()
				Button:SetParent(self)
				Button:SetAttribute('showgrid', 1)
				Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
					
				ab:SkinButton(Button)
				local Icon = _G['ActionButton'..i..'Icon']
				Icon:SetInside()

				if (i == 1) then
					Button:SetPoint('BOTTOMLEFT', Spacing, Spacing)
				else
					local Previous = _G['ActionButton'..i-1]
					Button:SetPoint('LEFT', Previous, 'RIGHT', Spacing, 0)
				end
			end
		elseif (event == 'UPDATE_VEHICLE_ACTIONBAR') or (event == 'UPDATE_OVERRIDE_ACTIONBAR') then
			for i = 1, 12 do
				local Button = _G['ActionButton'..i]
				local Action = Button.action
				local Icon = Button.icon

				if Action >= 120 then
					local Texture = GetActionTexture(Action)

					if (Texture) then
						Icon:SetTexture(Texture)
						Icon:Show()
					else
						if Icon:IsShown() then Icon:Hide() end
					end
				end
			end
		end
	end)

	for i = 1, Num do
		local Button = _G['ActionButton'..i]
		ab1['Button'..i] = Button
	end
end
