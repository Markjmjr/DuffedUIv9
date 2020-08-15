local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar3()
	local Size = D['SidebarButtonsize']
	local Spacing = D['buttonspacing']
	local MultiBarBottomRight = MultiBarBottomRight
	local ab3 = DuffedUIBar3

	MultiBarBottomRight:SetShown(true)
	MultiBarBottomRight:SetParent(ab3)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G['MultiBarBottomRightButton'..i]
		local PreviousButton = _G['MultiBarBottomRightButton'..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute('showgrid', 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		
		ab:SkinButton(Button)
		local Icon = _G['MultiBarBottomRightButton'..i..'Icon']
		Icon:SetInside()

		if C['actionbar']['LeftSideBar'] then
			if i == 1 then
				Button:SetPoint('BOTTOMLEFT', ab3, Spacing, Spacing)
			else
				Button:SetPoint('LEFT', PreviousButton, 'RIGHT', Spacing, 0)
			end
		else
			if (i == 1) then
				Button:SetPoint('TOPLEFT', ab3, Spacing, -Spacing)
			elseif (i == 7) then
				Button:SetPoint('TOPRIGHT', ab3, -Spacing, -Spacing)
			else
				Button:SetPoint('TOP', PreviousButton, 'BOTTOM', 0, -Spacing)
			end
		end

		if C['actionbar']['Leftsidebars'] then
			function LeftSideBar(alpha)
				ab3:SetAlpha(alpha)
				MultiBarBottomRight:SetAlpha(alpha)
			end
	
			local function mouseover(f)
				f:EnableMouse(true)
				f:SetAlpha(0)
				f:HookScript('OnEnter', function() LeftSideBar(1) end)
				f:HookScript('OnLeave', function() LeftSideBar(0) end)
			end
			mouseover(ab3)
	
			for i = 1, 12 do
				_G['MultiBarBottomRightButton' .. i]:EnableMouse(true)
				_G['MultiBarBottomRightButton' .. i .. 'Cooldown']:SetDrawBling(false)
				_G['MultiBarBottomRightButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
				_G['MultiBarBottomRightButton' .. i]:HookScript('OnEnter', function() LeftSideBar(1) end)
				_G['MultiBarBottomRightButton' .. i]:HookScript('OnLeave', function() LeftSideBar(0) end)
			end
		end

		ab3['Button'..i] = Button
	end
end
