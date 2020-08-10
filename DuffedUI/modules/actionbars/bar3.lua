local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar3()
	local Size = C['actionbar']['SidebarButtonsize']
	local Spacing = C['actionbar']['buttonspacing']
	local MultiBarBottomRight = MultiBarBottomRight
	local ab3 = DuffedUIBar3

	MultiBarBottomRight:SetShown(true)
	MultiBarBottomRight:SetParent(ab3)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarBottomRightButton"..i]
		local PreviousButton = _G["MultiBarBottomRightButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
		
		ab:SkinButton(Button)

		if (i == 1) then
			Button:SetPoint("TOPLEFT", ab3, Spacing, -Spacing)
		elseif (i == 7) then
			Button:SetPoint("TOPRIGHT", ab3, -Spacing, -Spacing)
		else
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		ab3["Button"..i] = Button
	end
end