local D, C, L = unpack(select(2, ...))

D['ShiftBarUpdate'] = function(self)
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_STANCE_SLOTS do
		buttonName = 'StanceButton'..i
		button = _G[buttonName]
		icon = _G[buttonName..'Icon']
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)

			if not icon then return end
			icon:SetTexture(texture)
			cooldown = _G[buttonName..'Cooldown']
			if texture then cooldown:SetAlpha(1) else cooldown:SetAlpha(0) end

			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_Set(cooldown, start, duration, enable)

			if isActive then
				StanceBarFrame.lastSelected = button:GetID()
				button:GetCheckedTexture():SetColorTexture(0, 1, 0, .3)
			else
				button:SetCheckedTexture(0, 0, 0, 0)
			end

			if isCastable then icon:SetVertexColor(1, 1, 1) else icon:SetVertexColor(.4, .4, .4) end
		end
	end
end

D['PetBarUpdate'] = function(...)
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local ButtonName = "PetActionButton" .. i
		local PetActionButton = _G[ButtonName]
		local PetActionIcon = _G[ButtonName.."Icon"]
		local PetActionBackdrop = PetActionButton.Backdrop
		local PetAutoCastableTexture = _G[ButtonName.."AutoCastable"]
		local PetAutoCastShine = _G[ButtonName.."Shine"]
		local Name, Texture, IsToken, IsActive, AutoCastAllowed, AutoCastEnabled = GetPetActionInfo(i)

		if (not IsToken) then
			PetActionIcon:SetTexture(Texture)
			PetActionButton.tooltipName = Name
		else
			PetActionIcon:SetTexture(_G[Texture])
			PetActionButton.tooltipName = _G[Name]
		end

		PetActionButton.IsToken = IsToken
		PetActionButton.tooltipSubtext = SubText

		if (IsActive) then
			PetActionButton:SetChecked(1)

			if PetActionBackdrop then PetActionBackdrop:SetBackdropBorderColor(0, 1, 0) end

			if IsPetAttackAction(i) then PetActionButton_StartFlash(PetActionButton) end
		else
			PetActionButton:SetChecked()

			if PetActionBackdrop then PetActionBackdrop:SetBackdropBorderColor(unpack(C["media"]['bordercolor'])) end

			if IsPetAttackAction(i) then PetActionButton_StopFlash(PetActionButton) end
		end

		if AutoCastAllowed then PetAutoCastableTexture:Show() else PetAutoCastableTexture:Hide() end

		if AutoCastEnabled then AutoCastShine_AutoCastStart(PetAutoCastShine) else AutoCastShine_AutoCastStop(PetAutoCastShine) end

		if Texture then
			if (GetPetActionSlotUsable(i)) then SetDesaturation(PetActionIcon, nil) else SetDesaturation(PetActionIcon, 1) end
			PetActionIcon:Show()
		else
			PetActionIcon:Hide()
		end

		if (not PetHasActionBar() and Texture and Name ~= "PET_ACTION_FOLLOW") then
			PetActionButton_StopFlash(PetActionButton)
			SetDesaturation(PetActionIcon, 1)
			PetActionButton:SetChecked(0)
		end
	end
end