local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

function ab:CreatePetBar()
	local pet = DuffedUIPetBar
	local PetSize = C['actionbar']['petbuttonsize']
	local Spacing = C['actionbar']['buttonspacing']
	local PetActionBarFrame = PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns

	PetActionBarFrame:EnableMouse(0)
	PetActionBarFrame:ClearAllPoints()
	PetActionBarFrame:SetParent(hide)

	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		Button:SetParent(pet)
		Button:ClearAllPoints()
		Button:SetSize(PetSize, PetSize)
		Button:SetNormalTexture("")
		Button:Show()

		if (i == 1) then
			Button:SetPoint("TOPLEFT", pet, "TOPLEFT", Spacing, -Spacing)

			pet:SetWidth(Button:GetWidth() + (Spacing * 2))
			pet:SetHeight((Button:GetWidth() * 10) + (Spacing * 11))
		else
			Button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -Spacing)
		end
		
		if Button:IsEventRegistered("UPDATE_BINDINGS") then Button:UnregisterEvent("UPDATE_BINDINGS") end

		pet:SetAttribute("addchild", Button)
		pet["Button"..i] = Button
	end

	hooksecurefunc("PetActionBar_Update", ab.UpdatePetBar)
	ab:SkinPetButtons()
	RegisterStateDriver(pet, "visibility", "[@pet,exists,nopossessbar]show;hide")
end