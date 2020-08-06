local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

if C['actionbar']['RightSideBarDisable'] then
	MultiBarLeft:SetAlpha(0)
else
	local bar = DuffedUIBar4
	MultiBarLeft:SetParent(bar)

	for i= 1, 12 do
		local b = _G['MultiBarLeftButton' .. i]
		local b2 = _G['MultiBarLeftButton' .. i - 1]
		if C['actionbar']['RightSideBar'] then b:SetSize(D['buttonsize'], D['buttonsize']) else b:SetSize(D['SidebarButtonsize'], D['SidebarButtonsize']) end
		b:ClearAllPoints()
		b:SetFrameStrata('BACKGROUND')
		b:SetFrameLevel(15)
		b.noGrid = false
		b:SetAttribute("showgrid", 1)

		if C['actionbar']['RightSideBar'] then
			if i == 1 then b:SetPoint('BOTTOMLEFT', bar, D['buttonspacing'], D['buttonspacing']) else b:SetPoint('LEFT', b2, 'RIGHT', D['buttonspacing'], 0) end
		else
			if i == 1 then
				b:SetPoint('TOPLEFT', bar, D['buttonspacing'], -D['buttonspacing'])
			elseif i == 7 then
				b:SetPoint('TOPRIGHT', bar, -D['buttonspacing'], -D['buttonspacing'])
			else
				b:SetPoint('TOP', b2, 'BOTTOM', 0, -D['buttonspacing'])
			end
		end
	end
	RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show')

	if C['actionbar']['Rightsidebars'] then
		function RightSideBar(alpha)
			DuffedUIBar4:SetAlpha(alpha)
			MultiBarLeft:SetAlpha(alpha)
		end

		local function mouseover(f)
			f:EnableMouse(true)
			f:SetAlpha(0)
			f:HookScript('OnEnter', function() RightSideBar(1) end)
			f:HookScript('OnLeave', function() RightSideBar(0) end)
		end
		mouseover(DuffedUIBar4)

		for i = 1, 12 do
			_G['MultiBarLeftButton' .. i]:EnableMouse(true)
			_G['MultiBarLeftButton' .. i .. 'Cooldown']:SetDrawBling(false)
			_G['MultiBarLeftButton' .. i .. 'Cooldown']:SetSwipeColor(0, 0, 0, 0)
			_G['MultiBarLeftButton' .. i]:HookScript('OnEnter', function() RightSideBar(1) end)
			_G['MultiBarLeftButton' .. i]:HookScript('OnLeave', function() RightSideBar(0) end)
		end
	end
end