local D, C, L = unpack(select(2, ...))

D['CreatePopup']['DUFFEDUI_FIX_AB'] = {
	question = L['ui']['fix_ab'],
	answer1 = ACCEPT,
	answer2 = CANCEL,
	function1 = ReloadUI,
}

local DuffedUIOnLogon = CreateFrame('Frame')
DuffedUIOnLogon:RegisterEvent('PLAYER_ENTERING_WORLD')
DuffedUIOnLogon:SetScript('OnEvent', function(self, event)	
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')

	local installed = DuffedUIDataPerChar.install
	if installed then
		local b1, b2, b3, b4 = GetActionBarToggles()
		if (not b1 or not b2 or not b3 or not b4) then
			SetActionBarToggles(1, 1, 1, 1)
			D['ShowPopup']('DUFFEDUI_FIX_AB')
		end
	end

	local reason = ACTION_BUTTON_SHOW_GRID_REASON_EVENT
	for i = 1, 12 do
		local button = _G[format('ActionButton%d', i)]
		button:SetAttribute('showgrid', 1)
		button:SetAttribute('statehidden', true)
		button:Show()
		--ActionButton_ShowGrid(button, reason)

		button = _G[format('MultiBarRightButton%d', i)]
		button:SetAttribute('showgrid', 1)
		button:SetAttribute('statehidden', true)
		button:Show()
		--ActionButton_ShowGrid(button, reason)

		button = _G[format('MultiBarBottomRightButton%d', i)]
		button:SetAttribute('showgrid', 1)
		button:SetAttribute('statehidden', true)
		button:Show()
		--ActionButton_ShowGrid(button, reason)

		button = _G[format('MultiBarLeftButton%d', i)]
		button:SetAttribute('showgrid', 1)
		button:SetAttribute('statehidden', true)
		button:Show()
		--ActionButton_ShowGrid(button, reason)

		button = _G[format('MultiBarBottomLeftButton%d', i)]
		button:SetAttribute('showgrid', 1)
		button:SetAttribute('statehidden', true)
		button:Show()
		--ActionButton_ShowGrid(button, reason)
	end
end)