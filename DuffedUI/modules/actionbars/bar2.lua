local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar2()
	local Size = D['buttonsize']
	local Spacing = D['buttonspacing']
	local MultiBarBottomLeft = MultiBarBottomLeft
	local ab2 = DuffedUIBar2

	MultiBarBottomLeft:SetShown(true)
	MultiBarBottomLeft:SetParent(ab2)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G['MultiBarBottomLeftButton'..i]
		local PreviousButton = _G['MultiBarBottomLeftButton'..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute('showgrid', 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		
		ab:SkinButton(Button)

		if (i == 1) then
			Button:SetPoint('BOTTOMLEFT', ab2, Spacing, Spacing)
		else
			Button:SetPoint('LEFT', PreviousButton, 'RIGHT', Spacing, 0)
		end

		ab2['Button'..i] = Button
	end

	for i = 7, 12 do
		local Button = _G['MultiBarBottomLeftButton'..i]
		local Button1 = _G['MultiBarBottomLeftButton1']

		Button:SetFrameLevel(Button1:GetFrameLevel() - 2)
	end
end