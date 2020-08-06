local D, C = unpack(select(2, ...))
local Module = D:NewModule('SlotDurability', 'AceEvent-3.0', 'AceHook-3.0')

local _G = _G

local GetInventorySlotInfo = _G.GetInventorySlotInfo
local GetInventoryItemDurability = _G.GetInventoryItemDurability
local f, fs, ff = C['media']['font'], 11, 'THINOUTLINE'

local SlotDurStrs = {}
local Slots = {
	'Head',
	'Shoulder',
	'Chest',
	'Waist',
	'Legs',
	'Feet',
	'Wrist',
	'Hands',
	'MainHand',
	'SecondaryHand'
}

local function GetDurStrings(name)
	if (not SlotDurStrs[name]) then
		local slot = _G['Character'..name..'Slot']
		SlotDurStrs[name] = slot:CreateFontString('OVERLAY')
		SlotDurStrs[name]:SetFont(f, fs, ff)
		SlotDurStrs[name]:SetShadowOffset(D['mult'], -D['mult'])
		SlotDurStrs[name]:SetShadowColor(0, 0, 0, 0.4)
		SlotDurStrs[name]:SetPoint('TOPRIGHT', 1, -1)
	end

	return SlotDurStrs[name]
end

local function GetThresholdColour(percent)
	if percent < 0 then
		return 1, 0, 0
	elseif percent <= 0.5 then
		return 1, percent * 2, 0
	elseif percent >= 1 then
		return 0, 1, 0
	else
		return 2 - percent * 2, 1, 0
	end
end

function Module.UpdateDurability()
	for _, item in ipairs(Slots) do
		local id, _ = GetInventorySlotInfo(item..'Slot')
		local v1, v2 = GetInventoryItemDurability(id)
		v1, v2 = tonumber(v1) or 0, tonumber(v2) or 0
		local percent = v1 / v2
		local SlotDurStr = GetDurStrings(item)

		if ((v2 ~= 0) and (percent ~= 1)) then

			SlotDurStr:SetText('')
			if (math.ceil(percent * 100) < 100)then
				SlotDurStr:SetTextColor(GetThresholdColour(percent))
				SlotDurStr:SetText(math.ceil(percent * 100)..'%')
			end
		else
			SlotDurStr:SetText('')
		end
	end
end

function Module:OnEnable()
	if not C['misc']['durabilitycharacter'] then return end

	CharacterFrame:HookScript('OnShow', Module.CharacterFrame_OnShow)
	CharacterFrame:HookScript('OnHide', Module.CharacterFrame_OnHide)
end

function Module.CharacterFrame_OnShow()
	D:RegisterEvent('PLAYER_ENTERING_WORLD', Module.UpdateDurability)
	D:RegisterEvent('UNIT_INVENTORY_CHANGED', Module.UpdateDurability)
	D:RegisterEvent('UPDATE_INVENTORY_DURABILITY', Module.UpdateDurability)
	Module.UpdateDurability()
end

function Module.CharacterFrame_OnHide()
	D:UnregisterEvent('PLAYER_ENTERING_WORLD', Module.UpdateDurability)
	D:UnregisterEvent('UNIT_INVENTORY_CHANGED', Module.UpdateDurability)
	D:UnregisterEvent('UPDATE_INVENTORY_DURABILITY', Module.UpdateDurability)
end