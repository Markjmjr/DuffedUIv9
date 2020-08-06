local D, C, L = unpack(select(2, ...))
local Module = D:NewModule('CheckCorruptionState', 'AceHook-3.0', 'AceEvent-3.0')

local function checkItems(items)
    local check = {}
    for _, v in pairs(items) do
        check[v] = true
    end
    return check
end

local itemEquipLocCheck = checkItems{'INVTYPE_WRIST', 'INVTYPE_HAND', 'INVTYPE_WAIST', 'INVTYPE_LEGS', 'INVTYPE_FEET', 'INVTYPE_FINGER', 'INVTYPE_WEAPON', 'INVTYPE_SHIELD', 'INVTYPE_2HWEAPON', 'INVTYPE_HOLDABLE', 'INVTYPE_RANGED', 'INVTYPE_RANGEDRIGHT'}

local tooltipReplacedLineTest = checkItems{ITEM_SOULBOUND or 'Soulbound', ITEM_BIND_ON_EQUIP or 'Binds when equipped', ITEM_BIND_ON_PICKUP or 'Binds when picked up'}

local corruptionBonusIDCheck = checkItems{6437, 6438, 6439, 6471, 6472, 6473, 6474, 6475, 6476, 6477, 6478, 6479, 6480, 6481, 6482, 6483, 6484, 6485, 6493, 6494, 6495, 6537, 6538, 6539, 6540, 6541, 6542, 6543, 6544, 6545, 6546, 6547, 6548, 6549, 6550, 6551, 6552, 6553, 6554, 6555, 6556, 6557, 6558, 6559, 6560, 6561, 6562, 6563, 6564, 6565, 6566, 6567, 6568, 6569, 6570, 6571, 6572, 6573}

local fieldKeys = {
    'itemID',
    'enchantID',
    'gemID1',
    'gemID2',
    'gemID3',
    'gemID4',
    'suffixID',
    'uniqueID',
    'linkLevel',
    'specializationID',
    'upgradeTypeID',
    'instanceDifficultyID',
    'numBonusIDs',
    'upgradeValue',
}

local function parseLink(link, fieldsOut)
    wipe(fieldsOut)

    if not link then return end
    
    local state = 'normal'
    local upgradeTypeID
    local bonusIdx = 1
    local unknownIdx = 1
    local idx = 1

    for value in string.gmatch(link, ':(%d*)') do
        local value = value == '' and 0 or tonumber(value)
        if state == 'bonusID' then
            if bonusIdx > fieldsOut['numBonusIDs'] then
                state = 'normal'
            else
                fieldsOut['bonusID'..bonusIdx] = value
                bonusIdx = bonusIdx + 1
            end
        end
        if state == 'normal' then
            if fieldKeys[idx] == 'upgradeValue' and fieldsOut['upgradeTypeID'] == 0 then
                idx = idx + 1
            end
            
            local key = fieldKeys[idx]
            if not key then
                key = 'unknown'..unknownIdx
                unknownIdx = unknownIdx + 1
            end
            
            fieldsOut[key] = value
            
            if key == 'numBonusIDs' then
                state = 'bonusID'
            end
            
            idx = idx + 1
        end
    end
end

local fields = {}
local function getCorruptionStateText(link)
    local eligible = false
    local hasCorruptionMarker = false
    local hasTaintMarker = false
    local hasGoodMarker = false
    local hasAnyCorruption = false
    
    parseLink(link, fields)
    if fields.numBonusIDs then
        for idx = 1, fields.numBonusIDs do
            local bonusID = fields['bonusID'..idx]
            if bonusID then
                if bonusID >= 6450 and bonusID <= 6614 then
                    eligible = true
                end
                if bonusID == 6579 then
                    hasCorruptionMarker = true
                elseif bonusID == 6578 then
                    hasTaintMarker = true
                elseif bonusID == 6516 then
                    hasGoodMarker = true
                elseif corruptionBonusIDCheck[bonusID] then
                    hasAnyCorruption = true
                end
            end
        end
    end

    if not eligible then
        return nil
    end
    if hasCorruptionMarker then
		return L['tooltip']['Corrupted']
    elseif hasAnyCorruption then
		return L['tooltip']['CorruptedCraftet']
    elseif hasTaintMarker then
		return hasGoodMarker and L['tooltip']['PurifiedNew'] or L['tooltip']['PurifiedOld']
    else
		return L['tooltip']['Pristine']
    end
end

function Callback(tooltip)
    local name, link = tooltip:GetItem()
    if not (name and link) then
        return
    end

    local itemEquipLoc = select(9, GetItemInfo(link))
    if not itemEquipLocCheck[itemEquipLoc] then
        return
    end

    local tooltipName = tooltip:GetName()
    for i = 3, tooltip:NumLines() do
        local textFrame = _G[tooltipName..'TextLeft'..i]
        if not textFrame then
            break
        end
        local text = textFrame:GetText()
        if tooltipReplacedLineTest[text] then
            local corruptionStateText = getCorruptionStateText(link)
            if corruptionStateText then
                textFrame:SetText(text..' '..corruptionStateText)
            end
            return
        end
    end
end

function Module:OnEnable()
	if C['tooltip'].Enable ~= true then	return end
	if C['tooltip'].CheckCorruption ~= true then return end

	GameTooltip:HookScript('OnTooltipSetItem', function(self) Callback(self) end)
	ItemRefTooltip:HookScript('OnTooltipSetItem', function(self) Callback(self) end)
end
