local L = select(2,...)

CurrencyData = CurrencyData or {}
CurrencyData['order'] = CurrencyData['order'] or {}
CurrencyData['collapsed'] = CurrencyData['collapsed'] or {}

local oldGetCurrencyListInfo = GetCurrencyListInfo
local oldExpandCurrencyList = ExpandCurrencyList
local oldGetCurrencyListLink = GetCurrencyListLink
local oldSetCurrencyUnused = SetCurrencyUnused
local oldSetCurrencyBackpack = SetCurrencyBackpack
local oldGameTooltipSetCurrencyToken = GameTooltip.SetCurrencyToken
local oldTokenFrameUpdate = TokenFrame_Update

local data = {}
local jagged = {}
local headers = {}

local indexOf = function(table, value)
	for i = 1, #table do
		if table[i] == value then return i end
	end
	return nil
end

local SortLists = function(jaggedList, currentOrder, desiredOrder)
	local curIndex = 0
	for i = 1, #desiredOrder do
		local nextCategory = desiredOrder[i]
		local index = indexOf(currentOrder, nextCategory)
		if index then
			curIndex = curIndex + 1
			tremove(currentOrder, index)
			tinsert(currentOrder, curIndex, nextCategory)

			local data = jaggedList[index]
			tremove(jaggedList, index)
			tinsert(jaggedList, curIndex, data)
		end
	end
end

local FlattenList = function(jaggedList, flatList)
	flatList = flatList and type(flatList) == 'table' and wipe(flatList) or {}

	for i = 1, #jaggedList do
		for j = 1, #jaggedList[i] do tinsert(flatList, jaggedList[i][j]) end
	end
	return flatList
end

local InitList = function(self)
	wipe(headers)
	wipe(jagged)
	wipe(data)

	local curIndex = 0
	for i = 1,GetCurrencyListSize() do
		local name, isHeader = GetCurrencyListInfo(i)

		if isHeader then
			curIndex = curIndex + 1
			tinsert(headers, name)
			tinsert(jagged, {i})

			if not tContains(CurrencyData['order'], name) then tinsert(CurrencyData['order'], name) end
		else
			tinsert(jagged[curIndex], i)
		end
	end

	SortLists(jagged, headers, CurrencyData['order'])
	FlattenList(jagged, data)
end

SortedCurrencyTab_MoveUp = function(name)
	local activeIndex = indexOf(headers, name)
	local storageIndex = indexOf(CurrencyData['order'], name)

	if not activeIndex or not storageIndex or activeIndex == 1 then return end

	local offset = 1
	while CurrencyData['order'][storageIndex-offset] and not tContains(headers, CurrencyData['order'][storageIndex-offset]) do offset = offset + 1 end

	tremove(CurrencyData['order'], storageIndex)
	tinsert(CurrencyData['order'], storageIndex-offset, name)
	TokenFrame_Update()
end

SortedCurrencyTab_MoveDown = function(name)
	local activeIndex = indexOf(headers, name)
	local storageIndex = indexOf(CurrencyData['order'], name)

	if not activeIndex or not storageIndex or activeIndex == #headers then return end

	local offset = 1
	while CurrencyData['order'][storageIndex+offset] and not tContains(headers, CurrencyData['order'][storageIndex+offset]) do offset = offset + 1 end

	tremove(CurrencyData['order'], storageIndex)
	tinsert(CurrencyData['order'], storageIndex+offset, name)
	TokenFrame_Update()
end

local CreateArrows = function()
	if (not TokenFrameContainer.buttons) then return end

	local scrollFrame = TokenFrameContainer
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numButtons = #buttons
	local button, index
	for i = 1, numButtons do
		button = buttons[i]

		button.highlight:SetAlpha(.5)

		if not button.MoveUp then
			local b = CreateFrame('Button', nil, button)
			button.MoveUp = b
			b:SetAlpha(.6)
			b:SetPoint('TOPRIGHT', -1, -5)
			b:SetSize(16, 8)

			local t = b:CreateTexture(nil, 'BACKGROUND')
			t:SetTexture('Interface\\PaperDollInfoFrame\\StatSortArrows.blp')
			t:SetTexCoord(0, 1, 0, .5)
			t:SetAllPoints()
			b.texture = t

			b:SetScript('OnEnter', function(self) self.texture:SetAlpha(1) end)
			b:SetScript('OnLeave', function(self) self.texture:SetAlpha(.6) end)
			b:SetScript('OnClick', function(self) SortedCurrencyTab_MoveUp(self:GetParent().name:GetText()) end)
		end

		if not button.MoveDown then
			local b = CreateFrame('Button', nil, button)
			button.MoveDown = b
			b:SetAlpha(.6)
			b:SetPoint('RIGHT', button.MoveUp, 'LEFT', 0, 0)
			b:SetSize(16, 8)

			local t = b:CreateTexture(nil, 'BACKGROUND')
			t:SetTexture('Interface\\PaperDollInfoFrame\\StatSortArrows.blp')
			t:SetTexCoord(0, 1, .5, 1)
			t:SetAllPoints()
			b.texture = t

			b:SetScript('OnEnter', function(self) self.texture:SetAlpha(1) end)
			b:SetScript('OnLeave', function(self) self.texture:SetAlpha(.6) end)
			b:SetScript('OnClick', function(self) SortedCurrencyTab_MoveDown(self:GetParent().name:GetText()) end)
		end

		if not button.scriptsChanged then
			button.scriptsChanged = true

			button.oldOnEnter = button:GetScript('OnEnter')
			button.oldOnLeave = button:GetScript('OnLeave')
		end

		if button.isHeader then
			button.MoveUp:Show()
			button.MoveDown:Show()
		end

		if not button.isHeader then
			button.MoveUp:Hide()
			button.MoveDown:Hide()
		end
	end
end

GetCurrencyListInfo = function(index)
	if index < 1 then
		return nil
	elseif index > #data then
		return oldGetCurrencyListInfo(index)
	end

	return oldGetCurrencyListInfo(data[index])
end

ExpandCurrencyList = function(index, value)
	if index < 1 then
		return nil
	elseif index > #data then
		return oldExpandCurrencyList(index, value)
	end

	local name = GetCurrencyListInfo(index)
	CurrencyData['collapsed'][name] = value == 0 and 0 or nil

	local returnValues = { oldExpandCurrencyList(data[index], value) }
	InitList()
	return unpack(returnValues)
end

SetCurrencyUnused = function(index, value)
	if index < 1 then
		return nil
	elseif index > #data then
		return oldSetCurrencyUnused(index, value)
	end

	local returnValues = { oldSetCurrencyUnused(data[index], value) }
	InitList()
	return unpack(returnValues)
end

SetCurrencyBackpack = function(index, value)
	if index < 1 then
		return nil
	elseif index > #data then
		return oldSetCurrencyBackpack(index, value)
	end

	return oldSetCurrencyBackpack(data[index], value)
end

GameTooltip.SetCurrencyToken = function(self, index)
	if index < 1 then
		return nil
	elseif index > #data then
		return oldGameTooltipSetCurrencyToken(GameTooltip, index)
	end

	return oldGameTooltipSetCurrencyToken(GameTooltip, data[index])
end

TokenFrame_Update = function()
	InitList()
	oldTokenFrameUpdate()
	CreateArrows()
end

local UnusedHidingFrame = CreateFrame('Frame')
UnusedHidingFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
UnusedHidingFrame:SetScript('OnEvent', function()
	for i = 1,GetCurrencyListSize() do
		local name, _, isExpanded = GetCurrencyListInfo(i)
		if CurrencyData['collapsed'][name] and CurrencyData['collapsed'][name] == 0 and isExpanded then ExpandCurrencyList(i, 0) end
	end
end)