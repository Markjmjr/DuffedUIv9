local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

if C['actionbar']['rightbarDisable'] then
	MultiBarRight:SetAlpha(0)
else
	local bar = DuffedUIBar5
	MultiBarRight:SetParent(bar)

	for i = 1, 12 do
		local b = _G['MultiBarRightButton' .. i]
		local b2 = _G['MultiBarRightButton' .. i - 1]
		b:SetSize(D['buttonsize'], D['buttonsize'])
		b:ClearAllPoints()
		b:SetFrameStrata('BACKGROUND')
		b:SetFrameLevel(15)
		b.noGrid = false
		b:SetAttribute("showgrid", 1)

		if C['actionbar']['rightbarvertical'] then
			if i == 1 then b:SetPoint('BOTTOMLEFT', bar, D['buttonspacing'], D['buttonspacing']) else b:SetPoint('LEFT', b2, 'RIGHT', D['buttonspacing'], 0) end
		else
			if i == 1 then b:SetPoint('TOPRIGHT', bar, -D['buttonspacing'], -D['buttonspacing']) else b:SetPoint('TOP', b2, 'BOTTOM', 0, -D['buttonspacing']) end
		end
	end
	RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show')

	-- Mouseover
	if C['actionbar']['rightbarsmouseover'] then
		local rbmoh = CreateFrame('Frame', nil, DuffedUIBar3)
		rbmoh:Point('RIGHT', UIParent, 'RIGHT', 0, -14)
		rbmoh:SetSize(24, (D['buttonsize'] * 12) + (D['buttonspacing'] * 13))

		function DuffedUIRightBarsMouseover(alpha)
			DuffedUIBar5:SetAlpha(alpha)
			DuffedUIBar5Button:SetAlpha(alpha)
			MultiBarRight:SetAlpha(alpha)
			if C['actionbar']['petbaralwaysvisible'] ~= true then
				DuffedUIPetBar:SetAlpha(alpha)
				for i = 1, NUM_PET_ACTION_SLOTS do _G['PetActionButton' .. i]:SetAlpha(alpha) end
			end
		end

		local function mouseover(f)
			f:EnableMouse(true)
			f:SetAlpha(0)
			f:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
			f:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
		end
		mouseover(DuffedUIBar5)
		mouseover(rbmoh)

		for i = 1, 12 do
			_G['MultiBarRightButton' .. i]:EnableMouse(true)
			_G['MultiBarRightButton' .. i .. 'Cooldown']:SetDrawBling(false)
			_G['MultiBarRightButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
			_G['MultiBarRightButton' .. i]:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
			_G['MultiBarRightButton' .. i]:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
		end

		if C['actionbar']['petbaralwaysvisible'] ~= true then
			for i = 1, NUM_PET_ACTION_SLOTS do
				_G['PetActionButton' .. i]:EnableMouse(true)
				_G['PetActionButton' .. i .. 'Cooldown']:SetDrawBling(false)
				_G['PetActionButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
				_G['PetActionButton' .. i]:HookScript('OnEnter', function() DuffedUIRightBarsMouseover(1) end)
				_G['PetActionButton' .. i]:HookScript('OnLeave', function() DuffedUIRightBarsMouseover(0) end)
			end
			mouseover(DuffedUIPetBar)
		end
	end
end