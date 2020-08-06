local D, C, L = unpack(select(2, ...))
if not C['auras']['player'] then return end

local frame = DuffedUIAuras
local content = DuffedUIAuras.content
local move = D['move']

for _, frame in next, {
	'DuffedUIAurasPlayerBuffs',
	'DuffedUIAurasPlayerDebuffs',
} do
	local header
	local wrap
	wrap = C['auras']['wrap']

	header = CreateFrame('Frame', frame, oUFDuffedUI_PetBattleFrameHider, 'SecureAuraHeaderTemplate')
	header:SetClampedToScreen(true)
	header:SetMovable(true)
	header:SetAttribute('minHeight', 30)
	header:SetAttribute('wrapAfter', wrap)
	header:SetAttribute('wrapYOffset', -50)
	header:SetAttribute('xOffset', -35)
	header:CreateBackdrop()
	header.backdrop:SetBackdropBorderColor(1, 0, 0)
	header.backdrop:FontString('text', C['media']['font'], 11)
	header.backdrop.text:SetPoint('CENTER')
	header.backdrop.text:SetText(L['move']['buffs'])
	header.backdrop:SetAlpha(0)
	header:SetAttribute('minWidth', wrap * 35)
	header:SetAttribute('template', 'DuffedUIAurasAuraTemplate')
	header:SetAttribute('weaponTemplate', 'DuffedUIAurasAuraTemplate')
	header:SetSize(30, 30)

	RegisterAttributeDriver(header, 'unit', '[vehicleui] vehicle; player')
	table.insert(content, header)
end

local buffs = DuffedUIAurasPlayerBuffs
local debuffs = DuffedUIAurasPlayerDebuffs

local filter = 0

buffs:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -7, 2)
buffs:SetAttribute('filter', 'HELPFUL')
buffs:SetAttribute('includeWeapons', 1)
buffs:Show()
move:RegisterFrame(buffs)

debuffs:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -7, -2)
debuffs:SetAttribute('filter', 'HARMFUL')
debuffs:Show()
move:RegisterFrame(debuffs)