local D, C, L = unpack(select(2, ...))

if not DuffedUIEditedDefaultConfig then return end

local settings = DuffedUIEditedDefaultConfig

for group, options in pairs(settings) do
	if not C[group] then C[group] = {} end

	for option, value in pairs(options) do
		if group ~= 'media' then C[group][option] = value end
	end
end
