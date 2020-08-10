local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar5()
	local Size = C['actionbar']['buttonsize']
	local Spacing = C['actionbar']['buttonspacing']
	local MultiBarRight = MultiBarRight
	local ab5 = DuffedUIBar5

	MultiBarRight:SetShown(true)
	MultiBarRight:SetParent(ab5)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarRightButton"..i]
		local PreviousButton = _G["MultiBarRightButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
		
		ab:SkinButton(Button)

		if (i == 1) then
			Button:SetPoint("TOPRIGHT", ab5, -Spacing, -Spacing)
		else
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		ab5["Button"..i] = Button
	end
end