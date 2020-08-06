local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local bar = DuffedUIPetBar
bar:RegisterEvent('PLAYER_LOGIN')
bar:RegisterEvent('PLAYER_CONTROL_LOST')
bar:RegisterEvent('PLAYER_CONTROL_GAINED')
bar:RegisterEvent('PLAYER_ENTERING_WORLD')
bar:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED')
bar:RegisterEvent('PET_BAR_UPDATE')
bar:RegisterEvent('PET_BAR_UPDATE_USABLE')
bar:RegisterEvent('PET_BAR_UPDATE_COOLDOWN')
bar:RegisterEvent('UNIT_PET')
bar:RegisterEvent('UNIT_FLAGS')
bar:RegisterEvent('UNIT_AURA')
bar:SetScript('OnEvent', function(self, event, arg1)
	if event == 'PLAYER_LOGIN' then
		PetActionBarFrame:UnregisterEvent('PET_BAR_SHOWGRID')
		PetActionBarFrame:UnregisterEvent('PET_BAR_HIDEGRID')
		PetActionBarFrame.showgrid = 1

		local button
		for i = 1, 10 do
			button = _G['PetActionButton' .. i]
			button:ClearAllPoints()
			button:SetParent(DuffedUIPetBar)

			button:Size(D['petbuttonsize'])
			if C['actionbar']['petbarhorizontal'] then
				if i == 1 then 
					button:SetPoint('TOPLEFT', D['buttonspacing'], -D['buttonspacing']) 
				else 
					button:SetPoint('LEFT', _G['PetActionButton' .. (i - 1)], 'RIGHT', D['buttonspacing'], 0)
				end
			else
				if i == 1 then
					button:SetPoint('TOPLEFT', D['buttonspacing'], -D['buttonspacing'])
				else
					button:SetPoint('TOP', _G['PetActionButton' .. (i - 1)], 'BOTTOM', 0, -D['buttonspacing'])
				end
			end
			button:Show()
			self:SetAttribute('addchild', button)
		end
		RegisterStateDriver(self, 'visibility', '[pet,novehicleui,nobonusbar:5] show; hide')
		hooksecurefunc('PetActionBar_Update', D['PetBarUpdate'])
		D['StylePet']()
	elseif event == 'PET_BAR_UPDATE' 
		or event == 'UNIT_PET' and arg1 == 'player' 
		or event == 'PLAYER_CONTROL_LOST'
		or event == 'PLAYER_CONTROL_GAINED'
		or event == 'PLAYER_FARSIGHT_FOCUS_CHANGED'
		or event == 'UNIT_FLAGS'
		or arg1 == 'pet' and (event == 'UNIT_AURA') then
			D['PetBarUpdate']()
	elseif event == 'PET_BAR_UPDATE_COOLDOWN' then
		PetActionBar_UpdateCooldowns()
	else
		D['StylePet']()
	end
end)
RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show')