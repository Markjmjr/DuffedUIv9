local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local bar = DuffedUIBar2
MultiBarBottomLeft:SetParent(bar)

for i = 1, 12 do
	local b = _G['MultiBarBottomLeftButton' .. i]
	local b2 = _G['MultiBarBottomLeftButton' .. i - 1]
	b:SetSize(D['buttonsize'], D['buttonsize'])
	b:ClearAllPoints()
	b:SetFrameStrata('BACKGROUND')
	b:SetFrameLevel(15)
	b.noGrid = false
	b:SetAttribute("showgrid", 1)

	if i == 1 then b:SetPoint('BOTTOMLEFT', bar, D['buttonspacing'], D['buttonspacing']) else b:SetPoint('LEFT', b2, 'RIGHT', D['buttonspacing'], 0) end
end
RegisterStateDriver(bar, 'visibility', '[vehicleui][petbattle][overridebar] hide; show')