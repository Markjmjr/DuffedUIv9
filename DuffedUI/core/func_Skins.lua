local D, C, L = unpack(select(2, ...))

D['SkinFuncs'] = {}
D['SkinFuncs']['DuffedUI'] = {}

local LoadBlizzardSkin = CreateFrame('Frame')
LoadBlizzardSkin:RegisterEvent('ADDON_LOADED')
LoadBlizzardSkin:SetScript('OnEvent', function(self, event, addon)
	if IsAddOnLoaded('Skinner') or IsAddOnLoaded('Aurora') or not C['general']['blizzardreskin'] then
		self:UnregisterEvent('ADDON_LOADED')
		return
	end

	for _addon, skinfunc in pairs(D['SkinFuncs']) do
		if type(skinfunc) == 'function' then
			if _addon == addon then
				if skinfunc then skinfunc() end
			end
		elseif type(skinfunc) == 'table' then
			if _addon == addon then
				for _, skinfunc in pairs(D['SkinFuncs'][_addon]) do
					if skinfunc then skinfunc() end
				end
			end
		end
	end
end)
