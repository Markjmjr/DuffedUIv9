local D, C, L = unpack(select(2, ...))
local Module = D:NewModule('Corruption Merchant', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')

-- All the fame to siweia

local contaminantsLevel = {
	[177955] = 'I',
	[177965] = 'II',
	[177966] = 'III',
	[177967] = 'III',
	[177968] = 'II',
	[177969] = 'I',	
	[177970] = 'I',
	[177971] = 'II',
	[177972] = 'III',
	[177973] = 'I',
	[177974] = 'II',
	[177975] = 'III',
	[177976] = '',
	[177977] = '',
	[177978] = 'I',
	[177979] = 'II',
	[177980] = 'III',
	[177981] = 'I',
	[177982] = 'II',
	[177983] = 'I',
	[177984] = 'II',
	[177985] = 'III',
	[177986] = 'I',
	[177987] = 'II',
	[177988] = 'III',
	[177989] = 'I',
	[177990] = 'II',
	[177991] = 'III',
	[177992] = 'I',
	[177993] = 'II',
	[177994] = 'III',
	[177995] = 'I',
	[177996] = 'II',
	[177997] = 'III',
	[177998] = 'I',
	[177999] = 'II',
	[178000] = 'III',
	[178001] = 'I',
	[178002] = 'II',
	[178003] = 'III',
	[178004] = 'I',
	[178005] = 'II',
	[178006] = 'III',
	[178007] = 'I',
	[178008] = 'II',
	[178009] = 'III',
	[178010] = 'I',
	[178011] = 'II',
	[178012] = 'III',
	[178013] = 'I',
	[178014] = 'II',
	[178015] = 'III',
}
function Module:ReplaceContaminantName()
	local itemString

	local function updateItemString()
		local itemName = GetItemInfo(177981)
		if itemName then
			return strmatch(itemName, '(.+'..HEADER_COLON..')')..'(.+)'
		end
	end

	local function setupMerchant()
		if not itemString then
			itemString = updateItemString()
		end
		if not itemString then return end

		local numItems = GetMerchantNumItems()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
			if index > numItems then return end

			local button = _G['MerchantItem'..i..'ItemButton']
			if button and button:IsShown() then
				local name = _G['MerchantItem'..i..'Name']
				local text = name and name:GetText()
				local newString = text and strmatch(text, itemString)
				if newString then
					name:SetText(newString)
				end

				local id = GetMerchantItemID(index)
				local level = id and contaminantsLevel[id]
				if not button.levelString then
					button.levelString = D.CreateFontString(button, 14, '', nil, nil, 'TOPLEFT', 3, -3)
				end
				button.levelString:SetText(level or '')
			end
		end
	end
	hooksecurefunc('MerchantFrame_UpdateMerchantInfo', setupMerchant)
end

function Module:OnEnable()
	if not C['tooltip']['CorruptionMerchant'] then return end
	self:ReplaceContaminantName()
end