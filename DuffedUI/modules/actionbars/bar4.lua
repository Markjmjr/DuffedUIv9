local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar4()
	local Size = D['SidebarButtonsize']
	local Spacing = D['buttonspacing']
	local MultiBarLeft = MultiBarLeft
	local ab4 = DuffedUIBar4

	MultiBarLeft:SetShown(true)
	MultiBarLeft:SetParent(ab4)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G['MultiBarLeftButton'..i]
		local PreviousButton = _G['MultiBarLeftButton'..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute('flyoutDirection', 'UP')
		Button:SetAttribute('showgrid', 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
		
		ab:SkinButton(Button)

		if C['actionbar']['RightSideBar'] then
			if i == 1 then
				Button:SetPoint('BOTTOMLEFT', ab4, Spacing, Spacing)
			else
				Button:SetPoint('LEFT', PreviousButton, 'RIGHT', Spacing, 0)
			end
		else
			if (i == 1) then
				Button:SetPoint('TOPLEFT', ab4, Spacing, -Spacing)
			elseif (i == 7) then
				Button:SetPoint('TOPRIGHT', ab4, -Spacing, -Spacing)
			else
				Button:SetPoint('TOP', PreviousButton, 'BOTTOM', 0, -Spacing)
			end
		end

		if C['actionbar']['Rightsidebars'] then
			function RightSideBar(alpha)
				ab4:SetAlpha(alpha)
				MultiBarLeft:SetAlpha(alpha)
			end
	
			local function mouseover(f)
				f:EnableMouse(true)
				f:SetAlpha(0)
				f:HookScript('OnEnter', function() RightSideBar(1) end)
				f:HookScript('OnLeave', function() RightSideBar(0) end)
			end
			mouseover(ab4)
	
			for i = 1, 12 do
				_G['MultiBarLeftButton' .. i]:EnableMouse(true)
				_G['MultiBarLeftButton' .. i .. 'Cooldown']:SetDrawBling(false)
				_G['MultiBarLeftButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
				_G['MultiBarLeftButton' .. i]:HookScript('OnEnter', function() RightSideBar(1) end)
				_G['MultiBarLeftButton' .. i]:HookScript('OnLeave', function() RightSideBar(0) end)
			end
		end

		ab4['Button'..i] = Button
	end
end