local D, C, L = unpack(select(2, ...))

local DataText = D['DataTexts']
local NameColor = DataText.NameColor
local ValueColor = DataText.ValueColor

D['SetPerCharVariable']('ImprovedCurrency', {})

local Profit = 0
local Spent = 0
local OldMoney = 0
local myPlayerRealm = D['MyRealm']

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	if gold ~= 0 then
		return format(ValueColor..'%s|r' .. '|cffffd700g|r' .. ValueColor..' %s|r' .. '|cffc7c7cfs|r' .. ValueColor..' %s|r' .. '|cffeda55fc|r', gold, silver, copper)
	elseif silver ~= 0 then
		return format(ValueColor..'%s|r' .. '|cffc7c7cfs|r' .. ValueColor..' %s|r' .. '|cffeda55fc|r', silver, copper)
	else
		return format(ValueColor..'%s|r' .. '|cffeda55fc|r', copper)
	end
end

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ''

	cash = format('%.2d' .. '|cffffd700g|r' .. ' %.2d' .. '|cffc7c7cfs|r' .. ' %.2d' .. '|cffeda55fc|r', gold, silver, copper)
	return cash
end	

local Update = function(self, event)
	if event == 'PLAYER_LOGIN' then OldMoney = GetMoney() end

	local NewMoney	= GetMoney()
	local Change = NewMoney - OldMoney

	if OldMoney == NewMoney then
		Profit = 0
		Spent = 0
		Change = 0
	elseif OldMoney > NewMoney then
		Spent = Spent - Change
	else 
		Profit = Profit + Change
	end
	self.Text:SetText(formatMoney(NewMoney))

	local myPlayerName  = UnitName('player')
	if DuffedUIData == nil then DuffedUIData = {} end
	if DuffedUIData['gold'] == nil then DuffedUIData['gold'] = {} end
	if DuffedUIData['gold'][myPlayerRealm] == nil then DuffedUIData['gold'][myPlayerRealm] = {} end
	if DuffedUIData['Class'] == nil then DuffedUIData['Class'] = {} end
	if DuffedUIData['Class'][myPlayerRealm] == nil then DuffedUIData['Class'][myPlayerRealm] = {} end
	if DuffedUIData['FavouriteItems'] == nil then DuffedUIData['FavouriteItems'] = {} end
	DuffedUIData['Class'][myPlayerRealm][myPlayerName] = D['Class']
	DuffedUIData['gold'][myPlayerRealm][myPlayerName] = GetMoney()
	OldMoney = NewMoney
end

local OnEnter = function(self)
	if not C['datatext']['ShowInCombat'] then
		if InCombatLockdown() then return end
	end

	if ImprovedCurrency['Archaeology'] == nil then ImprovedCurrency['Archaeology'] = true end
	if ImprovedCurrency['Cooking'] == nil then ImprovedCurrency['Cooking'] = true end
	if ImprovedCurrency['Professions'] == nil then ImprovedCurrency['Professions'] = true end
	if ImprovedCurrency['Garrison'] == nil then ImprovedCurrency['Garrison'] = true end
	if ImprovedCurrency['Miscellaneous'] == nil then ImprovedCurrency['Miscellaneous'] = true end
	if ImprovedCurrency['PvP'] == nil then ImprovedCurrency['PvP'] = true end
	if ImprovedCurrency['Raid'] == nil then ImprovedCurrency['Raid'] = true end

	local prof1, prof2, archaeology, _, cooking = GetProfessions()

	GameTooltip:SetOwner(self:GetTooltipAnchor())
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L['dt']['session'])
	GameTooltip:AddDoubleLine(L['dt']['earned'], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L['dt']['spent'], formatMoney(Spent), 1, 1, 1, 1, 1, 1)

	if Profit < Spent then
		GameTooltip:AddDoubleLine(L['dt']['deficit'], formatMoney(Profit - Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent) > 0 then
		GameTooltip:AddDoubleLine(L['dt']['profit'], formatMoney(Profit - Spent), 0, 1, 0, 1, 1, 1)
	end

	GameTooltip:AddLine(' ')

	local totalGold = 0
	local myGold = {}
	GameTooltip:AddLine(L['dt']['character'])

	local thisRealmList = DuffedUIData.gold[myPlayerRealm]
	for k,_ in pairs(thisRealmList) do
		if thisRealmList[k] then
			local class = DuffedUIData['Class'][myPlayerRealm][k] or 'PRIEST'
			local color = class and (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class] or _G.RAID_CLASS_COLORS[class])
			tinsert (myGold,
				{
					name = k,
					amount = thisRealmList[k],
					amountText = FormatTooltipMoney(thisRealmList[k]),
					r = color.r, g = color.g, b = color.b,
				}
			)
		end
		totalGold = totalGold + thisRealmList[k]
		end

		for i = 1, #myGold do
			local g = myGold[i]
			GameTooltip:AddDoubleLine(g.name == D['MyName'] and g.name..' |TInterface\\COMMON\\Indicator-Green:14|t' or g.name, g.amountText, g.r, g.g, g.b, 1, 1, 1)
		end

	GameTooltip:AddLine(' ')
	GameTooltip:AddLine(L['dt']['server'])
	GameTooltip:AddDoubleLine(FROM_TOTAL .. ' ', FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

	if archaeology and ImprovedCurrency['Archaeology'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(PROFESSIONS_ARCHAEOLOGY .. ': ')
		D['Currency'](384) -- Dwarf
		D['Currency'](385) -- Troll
		D['Currency'](393) -- Fossil
		D['Currency'](394) -- Night Elf
		D['Currency'](397) -- Orc
		D['Currency'](398) -- Draenei
		D['Currency'](399) -- Vyrkul
		D['Currency'](400) -- Nerubian
		D['Currency'](401) -- Tol'vir
		D['Currency'](676) -- Pandaren
		D['Currency'](677) -- Mogu
		D['Currency'](754) -- Mantid
		D['Currency'](821) -- Draenor Clans
		D['Currency'](828) -- Ogre
		D['Currency'](829) -- Arakkoa
		D['Currency'](1172) -- Highborne
		D['Currency'](1173) -- Highmountain
		D['Currency'](1174) -- Demonic
	end

	if cooking and ImprovedCurrency['Cooking'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(PROFESSIONS_COOKING .. ': ')
		D['Currency'](81)
		D['Currency'](402)
	end

	if ImprovedCurrency['Professions'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine('Profession Token')
		D['Currency'](61)
		D['Currency'](361)
		D['Currency'](910)
		D['Currency'](980)
		D['Currency'](999)
		D['Currency'](1008)
		D['Currency'](1017)
		D['Currency'](1020)
	end

	if ImprovedCurrency['Garrison'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine('Garrison')
		D['Currency'](824)
		D['Currency'](1101)
		D['Currency'](1220)
		D['Currency'](1342, false, true)
		D['Currency'](1560)
	end

	if ImprovedCurrency['Raid'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(L['dt']['dr'])
		D['Currency'](1560) -- BfA
		D['Currency'](1565)
		D['Currency'](1580, false, true)
		D['Currency'](1587)
		D['Currency'](1716) -- Patch 8.1
		D['Currency'](1710)				
		D['Currency'](1717)
		D['Currency'](1718)
		D['Currency'](1721) -- Patch 8.2
		D['Currency'](1755) -- Patch 8.3
		D['Currency'](1719)
		D['Currency'](1803)
	end

	if ImprovedCurrency['PvP'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(PVP_FLAG)
		D['Currency'](390, true)
		D['Currency'](391)
		D['Currency'](392, false, true)
		D['Currency'](944)
		D['Currency'](1268)
		D['Currency'](1356)
	end

	if ImprovedCurrency['Miscellaneous'] then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(MISCELLANEOUS)
		D['Currency'](241)
		D['Currency'](416)
		D['Currency'](515)
		D['Currency'](777)
		D['Currency'](1149, false, true)
		D['Currency'](1154, false, true)
		D['Currency'](1275)
		D['Currency'](1820, false, true)
	end

	GameTooltip:AddLine(' ')
	GameTooltip:AddDoubleLine(KEY_BUTTON1..':', L['dt']['goldbagsopen'], 1, 1, 1)
	GameTooltip:AddDoubleLine(KEY_BUTTON2..':', L['dt']['goldcurrency'], 1, 1, 1)
	GameTooltip:AddDoubleLine(L['dt']['goldreset'], L['dt']['goldreset2'], 1, 1, 1)

	GameTooltip:Show()
	GameTooltip:SetTemplate('Transparent')
end

local OnLeave = function()
	GameTooltip:Hide()
end

local RightClickMenu = {
	{ text = 'DuffedUI Improved Currency Options', isTitle = true , notCheckable = true },
	{ text = 'Show Archaeology Fragments', checked = function() return ImprovedCurrency['Archaeology'] end, func = function()
		if ImprovedCurrency['Archaeology'] then ImprovedCurrency['Archaeology'] = false else ImprovedCurrency['Archaeology'] = true end
	end	},
	{ text = 'Show Profession Tokens', checked = function() return ImprovedCurrency['Professions'] end, func = function()
		if ImprovedCurrency['Professions'] then ImprovedCurrency['Professions'] = false else ImprovedCurrency['Professions'] = true end
	end	},
	{ text = 'Show Garrison Tokens', checked = function() return ImprovedCurrency['Garrison'] end, func = function()
		if ImprovedCurrency['Garrison'] then ImprovedCurrency['Garrison'] = false else ImprovedCurrency['Garrison'] = true end
	end	},
	{ text = 'Show Player vs Player Currency', checked = function() return ImprovedCurrency['PvP'] end, func = function()
		if ImprovedCurrency['PvP'] then ImprovedCurrency['PvP'] = false else ImprovedCurrency['PvP'] = true end
	end	},
	{ text = 'Show Dungeon and Raid Currency', checked = function() return ImprovedCurrency['Raid'] end, func = function()
		if ImprovedCurrency['Raid'] then ImprovedCurrency['Raid'] = false else ImprovedCurrency['Raid'] = true end
	end	},
	{ text = 'Show Cooking Awards', checked = function() return ImprovedCurrency['Cooking'] end, func = function()
		if ImprovedCurrency['Cooking'] then ImprovedCurrency['Cooking'] = false else ImprovedCurrency['Cooking'] = true end
	end	},
	{ text = 'Show Miscellaneous Currency', checked = function() return ImprovedCurrency['Miscellaneous'] end, func = function()
		if ImprovedCurrency['Miscellaneous'] then ImprovedCurrency['Miscellaneous'] = false else ImprovedCurrency['Miscellaneous'] = true end
	end	},
}

local DuffedUIImprovedCurrencyDropDown = CreateFrame('Frame', 'DuffedUIImprovedCurrencyDropDown', UIParent, 'UIDropDownMenuTemplate, BackdropTemplate')
DuffedUIImprovedCurrencyDropDown:SetTemplate('Transparent')

local function RESETGOLD()
	local myPlayerRealm = D['MyRealm']
	local myPlayerName  = UnitName('player')

	DuffedUIData['gold'] = {}
	DuffedUIData['gold'][myPlayerRealm] = {}
	DuffedUIData['gold'][myPlayerRealm][myPlayerName] = GetMoney()
end
SLASH_RESETGOLD1 = '/resetgold'
SlashCmdList['RESETGOLD'] = RESETGOLD

local OnMouseDown = function(self, btn)
	if btn == 'RightButton' and IsShiftKeyDown() then
		local myPlayerRealm = D['MyRealm']
		local myPlayerName  = UnitName('player')
	
		DuffedUIData['gold'] = {}
		DuffedUIData['gold'][myPlayerRealm] = {}
		DuffedUIData['gold'][myPlayerRealm][myPlayerName] = GetMoney()
	elseif btn == 'LeftButton' then
		ToggleAllBags()
	else
		EasyMenu(RightClickMenu, DuffedUIImprovedCurrencyDropDown, 'cursor', 0, 0, 'MENU', 2)
	end
end

local function Enable(self)
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
	self:RegisterEvent('SEND_MAIL_COD_CHANGED')
	self:RegisterEvent('PLAYER_TRADE_MONEY')
	self:RegisterEvent('TRADE_MONEY_CHANGED')
	--self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('PLAYER_LOGIN')
	self:SetScript('OnEvent', Update)
	self:SetScript('OnMouseDown', OnMouseDown)
	self:SetScript('OnEnter', OnEnter)
	self:SetScript('OnLeave', GameTooltip_Hide)
	self:Update()
end

local function Disable(self)
	self.Text:SetText('')
	self:UnregisterAllEvents()
	self:SetScript('OnEvent', nil)
	self:SetScript('OnMouseDown', nil)
	self:SetScript('OnEnter', nil)
	self:SetScript('OnLeave', nil)
end

DataText:Register(BONUS_ROLL_REWARD_MONEY, Enable, Disable, Update)