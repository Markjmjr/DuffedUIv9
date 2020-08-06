local D, C = unpack(select(2, ...))
local Module = D:NewModule('SlotItemLevel', 'AceEvent-3.0', 'AceHook-3.0')
local ModuleTooltip = D:GetModule('TooltipAzerite')

local _G = _G
local next = _G.next
local pairs = _G.pairs
local select = _G.select
local type = _G.type

local BAG_ITEM_QUALITY_COLORS = _G.BAG_ITEM_QUALITY_COLORS
local C_AzeriteEmpoweredItem_IsPowerSelected = _G.C_AzeriteEmpoweredItem.IsPowerSelected
local EquipmentManager_GetItemInfoByLocation = _G.EquipmentManager_GetItemInfoByLocation
local EquipmentManager_UnpackLocation = _G.EquipmentManager_UnpackLocation
local GetContainerItemLink = _G.GetContainerItemLink
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetItemInfo = _G.GetItemInfo
local GetSpellInfo = _G.GetSpellInfo
local hooksecurefunc = _G.hooksecurefunc
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local f, fs, ff = C['media']['font'], 11, 'THINOUTLINE'

local inspectSlots = {
	'Head',
	'Neck',
	'Shoulder',
	'Shirt',
	'Chest',
	'Waist',
	'Legs',
	'Feet',
	'Wrist',
	'Hands',
	'Finger0',
	'Finger1',
	'Trinket0',
	'Trinket1',
	'Back',
	'MainHand',
	'SecondaryHand',
}

function Module:GetSlotAnchor(index)
	if not index then return end

	if index <= 5 or index == 9 or index == 15 then
		return 'BOTTOMLEFT', 40, 20
	elseif index == 16 then
		return 'BOTTOMRIGHT', -40, 2
	elseif index == 17 then
		return 'BOTTOMLEFT', 40, 2
	else
		return 'BOTTOMRIGHT', -40, 20
	end
end

function Module:CreateItemTexture(slot, relF, x, y)
	local icon = slot:CreateTexture(nil, 'ARTWORK')
	icon:SetPoint(relF, x, y)
	icon:SetSize(14, 14)
	icon:SetTexCoord(unpack(D['IconCoord']))

	icon.bg = CreateFrame('Frame', nil, slot)
	icon.bg:SetPoint('TOPLEFT', icon, -1, 1)
	icon.bg:SetPoint('BOTTOMRIGHT', icon, 1, -1)
	icon.bg:SetFrameLevel(3)
	icon.bg:SetTemplate('Transparent')
	icon.bg:Hide()

	return icon
end

function Module:CreateItemString(frame, strType)
	if frame.fontCreated then
		return
	end

	for index, slot in pairs(inspectSlots) do
		if index ~= 4 then
			local slotFrame = _G[strType..slot..'Slot']
			slotFrame.iLvlText = slotFrame:CreateFontString(nil, 'OVERLAY')
			slotFrame.iLvlText:SetFont(f, fs, ff)
			slotFrame.iLvlText:SetShadowOffset(D['mult'], -D['mult'])
			slotFrame.iLvlText:SetShadowColor(0, 0, 0, 0.4)
			slotFrame.iLvlText:ClearAllPoints()
			slotFrame.iLvlText:SetPoint('BOTTOMLEFT', slotFrame, 1, 1)
			local relF, x, y = Module:GetSlotAnchor(index)
			slotFrame.enchantText = slotFrame:CreateFontString(nil, 'OVERLAY')
			slotFrame.enchantText:SetFont(f, fs, ff)
			slotFrame.enchantText:SetShadowOffset(D['mult'], -D['mult'])
			slotFrame.enchantText:SetShadowColor(0, 0, 0, 0.4)
			slotFrame.enchantText:ClearAllPoints()
			slotFrame.enchantText:SetPoint(relF, slotFrame, x, y)
			slotFrame.enchantText:SetTextColor(0, 1, 0)
			for i = 1, 10 do
				local offset = (i - 1) * 20 + 5
				local iconX = x > 0 and x + offset or x - offset
				local iconY = index > 15 and 20 or 2
				slotFrame['textureIcon'..i] = Module:CreateItemTexture(slotFrame, relF, iconX, iconY)
			end
		end
	end

	frame.fontCreated = true
end

local azeriteSlots = {
	[1] = true,
	[3] = true,
	[5] = true,
}

local locationCache = {}
local function GetSlotItemLocation(id)
	if not azeriteSlots[id] then
		return
	end

	local itemLocation = locationCache[id]
	if not itemLocation then
		itemLocation = ItemLocation:CreateFromEquipmentSlot(id)
		locationCache[id] = itemLocation
	end
	return itemLocation
end

function Module:ItemLevel_UpdateTraits(button, id, link)
	local empoweredItemLocation = GetSlotItemLocation(id)
	if not empoweredItemLocation then
		return
	end

	local allTierInfo = D:GetModule('TooltipAzerite'):Azerite_UpdateTier(link)
	if not allTierInfo then
		return
	end

	for i = 1, 2 do
		local powerIDs = allTierInfo[i].azeritePowerIDs
		if not powerIDs or powerIDs[1] == 13 then
			break
		end

		for _, powerID in pairs(powerIDs) do
			local selected = C_AzeriteEmpoweredItem_IsPowerSelected(empoweredItemLocation, powerID)
			if selected then
				local spellID = D:GetModule('TooltipAzerite'):Azerite_PowerToSpell(powerID)
				local name, _, icon = GetSpellInfo(spellID)
				local texture = button['textureIcon'..i]
				if name and texture then
					texture:SetTexture(icon)
					texture.bg:Show()
				end
			end
		end
	end
end

function Module:ItemLevel_SetupLevel(frame, strType, unit)
	if not UnitExists(unit) then
		return
	end

	Module:CreateItemString(frame, strType)

	for index, slot in pairs(inspectSlots) do
		if index ~= 4 then
			local slotFrame = _G[strType..slot..'Slot']
			slotFrame.iLvlText:SetText('')
			slotFrame.enchantText:SetText('')
			for i = 1, 10 do
				local texture = slotFrame['textureIcon'..i]
				texture:SetTexture(nil)
				texture.bg:Hide()
			end

			local link = GetInventoryItemLink(unit, index)
			if link then
				local quality = select(3, GetItemInfo(link))
				local info = D.GetItemLevel(link, unit, index, C['misc']['gemenchantinfo'])
				local infoType = type(info)
				local level
				if infoType == 'table' then
					level = info.iLvl
				else
					level = info
				end

				if level and level > 1 and quality then
					local color = BAG_ITEM_QUALITY_COLORS[quality]
					slotFrame.iLvlText:SetText(level)
					slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
				end

				if infoType == 'table' then
					local enchant = info.enchantText
					if enchant then
						slotFrame.enchantText:SetText(enchant)
					end

					local gemStep, essenceStep = 1, 1
					for i = 1, 10 do
						local texture = slotFrame['textureIcon'..i]
						local bg = texture.bg
						local gem = info.gems and info.gems[gemStep]
						local essence = not gem and (info.essences and info.essences[essenceStep])
						if gem then
							texture:SetTexture(gem)
							bg:SetBackdropBorderColor()
							bg:Show()

							gemStep = gemStep + 1
						elseif essence and next(essence) then
							local r = essence[4]
							local g = essence[5]
							local b = essence[6]
							if r and g and b then
								bg:SetBackdropBorderColor(r, g, b)
							else
								bg:SetBackdropBorderColor()
							end

							local selected = essence[1]
							texture:SetTexture(selected)
							bg:Show()

							essenceStep = essenceStep + 1
						end
					end
				end

				if strType == 'Character' then
					Module:ItemLevel_UpdateTraits(slotFrame, index, link)
				end
			end
		end
	end
end

function Module:ItemLevel_UpdatePlayer()
	Module:ItemLevel_SetupLevel(CharacterFrame, 'Character', 'player')
end

function Module:ItemLevel_UpdateInspect(...)
	local guid = ...
	if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
		Module:ItemLevel_SetupLevel(InspectFrame, 'Inspect', InspectFrame.unit)
	end
end

function Module:ItemLevel_FlyoutUpdate(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = self:CreateFontString(nil, 'OVERLAY')
		self.iLvl:SetFont(f, fs, ff)
		self.iLvl:SetShadowOffset(D['mult'], -D['mult'])
		self.iLvl:SetShadowColor(0, 0, 0, 0.4)
		self.iLvl:SetPoint('BOTTOMLEFT', 1, 1)
	end

	local link, level
	if bag then
		link = GetContainerItemLink(bag, slot)
		level = D.GetItemLevel(link, bag, slot)
	else
		link = GetInventoryItemLink('player', slot)
		level = D.GetItemLevel(link, 'player', slot)
	end

	local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function Module:ItemLevel_FlyoutSetup()
	local location = self.location
	if not location or location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
		if self.iLvl then self.iLvl:SetText('') end
		return
	end

	local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
	if voidStorage then return end
	local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
	if bags then
		Module.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
	else
		Module.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
	end
end

function Module:ItemLevel_ScrappingUpdate()
	if not self.iLvl then
		self.iLvl = self:CreateFontString(nil, 'OVERLAY')
		self.iLvl:SetFont(f, fs, ff)
		self.iLvl:SetShadowOffset(D['mult'], -D['mult'])
		self.iLvl:SetShadowColor(0, 0, 0, 0.4)
		self.iLvl:SetPoint('BOTTOMLEFT', 1, 1)
	end

	if not self.itemLink then
		self.iLvl:SetText('')
		return
	end

	local quality = 1
	if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end
	local level = D.GetItemLevel(self.itemLink)
	local color = BAG_ITEM_QUALITY_COLORS[quality]
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function Module.ItemLevel_ScrappingShow(event, addon)
	if addon == 'Blizzard_ScrappingMachineUI' then
		for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			hooksecurefunc(button, 'RefreshIcon', Module.ItemLevel_ScrappingUpdate)
		end

		D:UnregisterEvent(event, Module.ItemLevel_ScrappingShow)
	end
end

function Module:OnEnable()
	if not C['misc']['itemlevel'] then return end

	CharacterFrame:HookScript('OnShow', Module.ItemLevel_UpdatePlayer)
	D:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', Module.ItemLevel_UpdatePlayer)
	D:RegisterEvent('INSPECT_READY', self.ItemLevel_UpdateInspect)
	hooksecurefunc('EquipmentFlyout_DisplayButton', self.ItemLevel_FlyoutSetup)
	D:RegisterEvent('ADDON_LOADED', self.ItemLevel_ScrappingShow)
end