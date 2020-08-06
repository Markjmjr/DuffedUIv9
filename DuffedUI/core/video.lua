local D, C, L = unpack(select(2, ...))

local _G = _G

local math_max = _G.math.max
local math_min = _G.math.min
local string_match = string.match

local InCombatLockdown = _G.InCombatLockdown
local UIParent = _G.UIParent
local mult = 768 / string_match(GetCVar('gxWindowedResolution'), '%d+x(%d+)') / C['general']['uiscale']

local function GetPerfectScale()
	local scale = C['general']['uiscale']
	local bestScale = math_max(0.4, math_min(1.15, 768 / D.ScreenHeight))
	local pixelScale = 768 / D.ScreenHeight

	if C['general']['autoscale'] then
		scale = bestScale
	end

	mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end

local Graphic = CreateFrame('Frame')
Graphic:RegisterEvent('PLAYER_ENTERING_WORLD')
Graphic:SetScript('OnEvent', function(self, event)
	if isScaling then
		return
	end

	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale and not InCombatLockdown() then
		UIParent:SetScale(scale)
	end

	C['general']['uiscale'] = scale

	isScaling = false

	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('DISPLAY_SIZE_CHANGED')
end)