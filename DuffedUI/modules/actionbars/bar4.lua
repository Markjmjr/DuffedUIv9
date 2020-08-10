local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ab:CreateBar4()
	local Size = C['actionbar']['SidebarButtonsize']
	local Spacing = C['actionbar']['buttonspacing']
	local MultiBarLeft = MultiBarLeft
	local ab4 = DuffedUIBar4

	MultiBarLeft:SetShown(true)
	MultiBarLeft:SetParent(ab4)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarLeftButton"..i]
		local PreviousButton = _G["MultiBarLeftButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("flyoutDirection", "UP")
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
		
		ab:SkinButton(Button)

		if (i == 1) then
			Button:SetPoint("TOPLEFT", ab4, Spacing, -Spacing)
		elseif (i == 7) then
			Button:SetPoint("TOPRIGHT", ab4, -Spacing, -Spacing)
		else
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		ab4["Button"..i] = Button
	end
end
