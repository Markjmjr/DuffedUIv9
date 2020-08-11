local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar5()
	local Size = D['buttonsize']
	local Spacing = D['buttonspacing']
	local MultiBarRight = MultiBarRight
	local ab5 = DuffedUIBar5

	MultiBarRight:SetShown(true)
	MultiBarRight:SetParent(ab5)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G['MultiBarRightButton'..i]
		local PreviousButton = _G['MultiBarRightButton'..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute('showgrid', 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
		
		ab:SkinButton(Button)

		if C['actionbar']['rightbarvertical'] then
			if i == 1 then
				Button:SetPoint('BOTTOMLEFT', ab5, Spacing, Spacing)
			else 
				Button:SetPoint('LEFT', PreviousButton, 'RIGHT', Spacing, 0)
			end
		else
			if (i == 1) then
				Button:SetPoint('TOPRIGHT', ab5, -Spacing, -Spacing)
			else
				Button:SetPoint('TOP', PreviousButton, 'BOTTOM', 0, -Spacing)
			end
		end

		if C['actionbar']['rightbarsmouseover'] then
			local rbmoh = CreateFrame('Frame', nil, DuffedUIBar3)
			rbmoh:Point('RIGHT', UIParent, 'RIGHT', 0, -14)
			rbmoh:SetSize(24, (D['buttonsize'] * 12) + (D['buttonspacing'] * 13))
	
			function DuffedUIRightBarsMouseover(alpha)
				DuffedUIBar5:SetAlpha(alpha)
				DuffedUIBar5Button:SetAlpha(alpha)
				MultiBarRight:SetAlpha(alpha)
				if C['actionbar']['petbaralwaysvisible'] ~= true then
					DuffedUIPetBar:SetAlpha(alpha)
					for i = 1, NUM_PET_ACTION_SLOTS do _G['PetActionButton' .. i]:SetAlpha(alpha) end
				end
			end
	
			local function mouseover(f)
				f:EnableMouse(true)
				f:SetAlpha(0)
				f:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
				f:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
			end
			mouseover(DuffedUIBar5)
			mouseover(rbmoh)
	
			for i = 1, 12 do
				_G['MultiBarRightButton' .. i]:EnableMouse(true)
				_G['MultiBarRightButton' .. i .. 'Cooldown']:SetDrawBling(false)
				_G['MultiBarRightButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
				_G['MultiBarRightButton' .. i]:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
				_G['MultiBarRightButton' .. i]:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
			end
	
			if C['actionbar']['petbaralwaysvisible'] ~= true then
				for i = 1, NUM_PET_ACTION_SLOTS do
					_G['PetActionButton' .. i]:EnableMouse(true)
					_G['PetActionButton' .. i .. 'Cooldown']:SetDrawBling(false)
					_G['PetActionButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
					_G['PetActionButton' .. i]:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
					_G['PetActionButton' .. i]:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
				end
				mouseover(DuffedUIPetBar)
			end
		end

		ab5['Button'..i] = Button
	end
end