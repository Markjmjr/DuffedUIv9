local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local Replace = string.gsub
local FlyoutButtons = 0

function ab:SkinButton(button)
	local Name = button:GetName()
	local Action = button.action
	local Button = button
	local Icon = _G[Name.."Icon"]
	local Count = _G[Name.."Count"]
	local Flash	 = _G[Name.."Flash"]
	local HotKey = _G[Name.."HotKey"]
	local Border = _G[Name.."Border"]
	local Btname = _G[Name.."Name"]
	local Normal = _G[Name.."NormalTexture"]
	local BtnBG = _G[Name.."FloatingBG"]
	local Font = C['media']['font']

	if not Button.IsSkinned then
		Flash:SetTexture("")
		Button:SetNormalTexture("")

		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 0, 2)

		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 0, -3)

		Count:SetFont(Font, 11, 'THINOUTLINE')

		if (Btname) then
			if (C['actionbar']['macro']) then
				Btname:SetFont(Font, 11, 'THINOUTLINE')
				Btname:ClearAllPoints()
				Btname:SetPoint("BOTTOM", 1, 1)
			else
				Btname:SetText("")
				Btname:Kill()
			end
		end

		if (BtnBG) then BtnBG:Kill() end

		if not (C['actionbar']['hotkey']) then
			HotKey:SetText("")
			HotKey:Kill()
		end

		if (Name:match("Extra")) then Button.Pushed = true end

		Button:CreateBackdrop()

		Icon:SetTexCoord(unpack(D['IconCoord']))
		Icon:SetDrawLayer("BACKGROUND", 7)

		if (Normal) then
			Normal:ClearAllPoints()
			Normal:SetPoint("TOPLEFT")
			Normal:SetPoint("BOTTOMRIGHT")
			if (Button:GetChecked()) then Button:UpdateState(Button) end
		end
		if (Border) then Border:SetTexture("") end
		
		Button:StyleButton()
		Button.isSkinned = true
	end
	
	
	-- WORKLATER (note: Need to be moved into another hook)
	--[[
	if (Border and C.ActionBars.EquipBorder) then
		if (Border:IsShown()) then
			Button.Backdrop:SetBorderColor(.08, .70, 0)
		else
			Button.Backdrop:SetBorderColor(unpack(C['General'].BorderColor))
		end
	end


	if (Action and Btname and Normal and C.ActionBars.Macro) then
		local String = GetActionText(Action)

		if String then
			local Text

			if string.byte(String, 1) > 223 then
				Text = string.sub(String, 1, 9)
			else
				Text = string.sub(String, 1, 4)
			end

			Btname:SetText(Text)
		end
	end
	--]]
end

function ab:SkinPetAndShiftButton(Normal, Button, Icon, Name, Pet)
	if Button.isSkinned then return end

	local PetSize = C['actionbar']['petbuttonsize']
	local HotKey = _G[Button:GetName().."HotKey"]
	local Cooldown = _G[Button:GetName().."Cooldown"]
	local Flash = _G[Name.."Flash"]
	local Font = C['media']['font']
	
	Cooldown:SetAlpha(0)

	Button:SetWidth(PetSize)
	Button:SetHeight(PetSize)
	Button:CreateBackdrop()

	if (C['actionbar']['hotkey']) then
		HotKey:SetFont(Font, 11, 'THINOUTLINE')
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 0, -3)
	else
		HotKey:SetText("")
		HotKey:SetAlpha(0)
	end

	Icon:SetTexCoord(unpack(D['IconCoord']))
	Icon:SetDrawLayer('BACKGROUND', 7)

	if (Pet) then
		if (PetSize < 30) then
			local AutoCast = _G[Name.."AutoCastable"]
			AutoCast:SetAlpha(0)
		end

		local Shine = _G[Name.."Shine"]
		Shine:SetSize(PetSize, PetSize)
		Shine:ClearAllPoints()
		Shine:SetPoint("CENTER", Button, 0, 0)
	end

	Flash:SetTexture("")

	if Normal then
		Normal:ClearAllPoints()
		Normal:SetPoint("TOPLEFT")
		Normal:SetPoint("BOTTOMRIGHT")
	end

	Button:StyleButton()
	Button.isSkinned = true
end

function ab:SkinPetButtons()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Name = "PetActionButton"..i
		local Button = _G[Name]
		local Icon = _G[Name.."Icon"]
		local Normal = _G[Name.."NormalTexture2"] -- ?? 2

		ab:SkinPetAndShiftButton(Normal, Button, Icon, Name, true)
	end
end

function ab:SkinStanceButtons()
	for i=1, NUM_STANCE_SLOTS do
		local Name = "StanceButton"..i
		local Button = _G[Name]
		local Icon = _G[Name.."Icon"]
		local Normal = _G[Name.."NormalTexture"]

		ab:SkinPetAndShiftButton(Normal, Button, Icon, Name, false)
	end
end

function ab:SkinFlyoutButtons()
	for i = 1, FlyoutButtons do
		local Button = _G["SpellFlyoutButton"..i]

		if Button and not Button.IsSkinned then
			ab:SkinButton(Button)
			

			if Button:GetChecked() then
				Button:SetChecked(nil)
			end

			Button.IsSkinned = true
		end
	end
end

function ab:StyleFlyout()
	if (self.FlyoutArrow) and (not self.FlyoutArrow:IsShown()) then
		return
	end

	local HB = SpellFlyoutHorizontalBackground
	local VB = SpellFlyoutVerticalBackground
	local BE = SpellFlyoutBackgroundEnd

	if self.FlyoutBorder then
		self.FlyoutBorder:SetAlpha(0)
		self.FlyoutBorderShadow:SetAlpha(0)
	end

	HB:SetAlpha(0)
	VB:SetAlpha(0)
	BE:SetAlpha(0)

	for i = 1, GetNumFlyouts() do
		local ID = GetFlyoutID(i)
		local _, _, NumSlots, IsKnown = GetFlyoutInfo(ID)
		
		if IsKnown then
			FlyoutButtons = NumSlots
			
			break
		end
	end

	ab:SkinFlyoutButtons()
end

function ab:StopButtonHighlight()
	if self.Animation and self.Animation:IsPlaying() then
		self.Animation:Stop()
		self.NewProc:Hide()
	end
end

function ab:GetKeyText()
	local Text = self
	
	if not Text then
		return
	end
	
	Text = Replace(Text, "(s%-)", "S")
	Text = Replace(Text, "(a%-)", "A")
	Text = Replace(Text, "(c%-)", "C")
	Text = Replace(Text, KEY_MOUSEWHEELDOWN , "MDn")
	Text = Replace(Text, KEY_MOUSEWHEELUP , "MUp")
	Text = Replace(Text, KEY_BUTTON3, "M3")
	Text = Replace(Text, KEY_BUTTON4, "M4")
	Text = Replace(Text, KEY_BUTTON5, "M5")
	Text = Replace(Text, KEY_MOUSEWHEELUP, "MU")
	Text = Replace(Text, KEY_MOUSEWHEELDOWN, "MD")
	Text = Replace(Text, KEY_NUMPAD0, "N0")
	Text = Replace(Text, KEY_NUMPAD1, "N1")
	Text = Replace(Text, KEY_NUMPAD2, "N2")
	Text = Replace(Text, KEY_NUMPAD3, "N3")
	Text = Replace(Text, KEY_NUMPAD4, "N4")
	Text = Replace(Text, KEY_NUMPAD5, "N5")
	Text = Replace(Text, KEY_NUMPAD6, "N6")
	Text = Replace(Text, KEY_NUMPAD7, "N7")
	Text = Replace(Text, KEY_NUMPAD8, "N8")
	Text = Replace(Text, KEY_NUMPAD9, "N9")
	Text = Replace(Text, KEY_NUMPADDECIMAL, "N.")
	Text = Replace(Text, KEY_NUMPADDIVIDE, "N/")
	Text = Replace(Text, KEY_NUMPADMINUS, "N-")
	Text = Replace(Text, KEY_NUMPADMULTIPLY, "N*")
	Text = Replace(Text, KEY_NUMPADPLUS, "N+")
	Text = Replace(Text, KEY_PAGEUP, "PU")
	Text = Replace(Text, KEY_PAGEDOWN, "PD")
	Text = Replace(Text, KEY_SPACE, "SpB")
	Text = Replace(Text, KEY_INSERT, "Ins")
	Text = Replace(Text, KEY_HOME, "Hm")
	Text = Replace(Text, KEY_DELETE, "Del")
	Text = Replace(Text, KEY_INSERT_MAC, "Hlp") -- mac
	Text = Replace(Text, KEY_BACKSPACE, "BkS")
	
	return Text
end

function ab:UpdateHotKeys()
	local Button, HotKey, Text
	local GetKeyText = ab.GetKeyText
	local Indicator = _G["RANGE_INDICATOR"]
	
	-- Action Bars HotKeys Update
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		Button = _G["ActionButton"..i]
		HotKey = _G["ActionButton"..i.."HotKey"]

		HotKey:SetText(GetKeyText(HotKey:GetText()))

		Button = _G["MultiBarBottomLeftButton"..i]
		HotKey = _G["MultiBarBottomLeftButton"..i.."HotKey"]
		
		HotKey:SetText(GetKeyText(HotKey:GetText()))

		Button = _G["MultiBarBottomRightButton"..i]
		HotKey = _G["MultiBarBottomRightButton"..i.."HotKey"]
		
		HotKey:SetText(GetKeyText(HotKey:GetText()))

		Button = _G["MultiBarRightButton"..i]
		HotKey = _G["MultiBarRightButton"..i.."HotKey"]
		
		HotKey:SetText(GetKeyText(HotKey:GetText()))

		Button = _G["MultiBarLeftButton"..i]
		HotKey = _G["MultiBarLeftButton"..i.."HotKey"]
		
		HotKey:SetText(GetKeyText(HotKey:GetText()))
	end
	
	-- Pet Action Bar HotKeys Update
	for i = 1, NUM_PET_ACTION_SLOTS do
		Button = _G["PetActionButton"..i]
		HotKey = _G["PetActionButton"..i.."HotKey"]

		HotKey:SetText(GetKeyText(HotKey:GetText()))
	end
end