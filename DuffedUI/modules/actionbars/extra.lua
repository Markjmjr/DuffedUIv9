local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

local move = D['move']
local holder = CreateFrame('Frame', 'ExtrabuttonMover', UIParent)
holder:Size(80, 80)
holder:SetPoint('BOTTOM', 0, 250)
move:RegisterFrame(holder)

ExtraActionBarFrame:SetParent(UIParent)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint('CENTER', holder, 'CENTER', 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetPoint('CENTER', holder, 'CENTER', 0, 0)
ZoneAbilityFrame.ignoreFramePositionManager = true

local button = ExtraActionButton1
local icon = button.icon
local texture = button.style
local disableTexture = function(style, texture)
	if string.sub(texture, 1, 9) == 'Interface' or string.sub(texture, 1, 9) == 'INTERFACE' then style:SetTexture('') end
end
button.style:SetTexture('')
if not IsAddOnLoaded('AddOnSkins') then hooksecurefunc(texture, 'SetTexture', disableTexture) end