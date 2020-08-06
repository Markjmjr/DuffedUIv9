local D, C, L = unpack(select(2, ...))

if C['bags']['Enable'] then return end

local function LoadSkin()
	for i = 1, 12 do
		local Bag = _G["ContainerFrame"..i]
		Bag:CreateBackdrop()
		Bag:SetTemplate('Transparent')

		for j = 1, 36 do
			local ItemButton = _G["ContainerFrame"..i.."Item"..j]
			ItemButton:CreateBorder()
			ItemButton.icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
			ItemButton:SetNormalTexture("")
			ItemButton:SetPushedTexture("")
			ItemButton.icon:SetInside()

			ItemButton.IconBorder:SetAlpha(0)
			ItemButton.NewItemTexture:SetAtlas(nil)
			ItemButton.NewItemTexture.SetAtlas = D.Noop

			_G["ContainerFrame"..i.."Item"..j.."IconQuestTexture"]:SetAlpha(0)

			ItemButton:CreateBackdrop()
			ItemButton.backdrop:Hide()

			hooksecurefunc(ItemButton.NewItemTexture, "Show", function()
				ItemButton.backdrop:Show()
			end)

			hooksecurefunc(ItemButton.NewItemTexture, "Hide", function()
				ItemButton.backdrop:Hide()
			end)

			ItemButton.backdrop:SetAllPoints()
			ItemButton.backdrop:SetFrameStrata(ItemButton:GetFrameStrata())
			ItemButton.backdrop:SetFrameLevel(ItemButton:GetFrameLevel() + 4)
			ItemButton.backdrop:SetScript("OnUpdate", function(self)
				local isQuestItem, questId, isActive = GetContainerItemQuestInfo(ItemButton:GetParent():GetID(), ItemButton:GetID())
				local Quality = select(4, GetContainerItemInfo(ItemButton:GetParent():GetID(), ItemButton:GetID()))
				ItemButton:SetBackdropBorderColor()

				if Quality and BAG_ITEM_QUALITY_COLORS[Quality] then
					self:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[Quality].r, BAG_ITEM_QUALITY_COLORS[Quality].g, BAG_ITEM_QUALITY_COLORS[Quality].b)
				elseif isQuestItem then
					self:SetBackdropBorderColor(1, .82, 0)
				else
					self:SetBackdropBorderColor(1, 1, 1)
				end

				self:SetAlpha(self:GetParent().NewItemTexture:GetAlpha())
			end)

			ItemButton.backdrop:SetScript("OnHide", function(self)
				local Quality = select(4, GetContainerItemInfo(ItemButton:GetParent():GetID(), ItemButton:GetID()))
				local isQuestItem, questId, isActive = GetContainerItemQuestInfo(ItemButton:GetParent():GetID(), ItemButton:GetID())

				if Quality and (Quality > Enum.ItemQuality.Common and BAG_ITEM_QUALITY_COLORS[Quality]) then
					ItemButton:SetBackdropBorderColor(BAG_ITEM_QUALITY_COLORS[Quality].r, BAG_ITEM_QUALITY_COLORS[Quality].g, BAG_ITEM_QUALITY_COLORS[Quality].b)
				elseif isQuestItem then
					ItemButton:SetBackdropBorderColor(1, .82, 0)
				else
					ItemButton:SetBackdropBorderColor()
				end
			end)

			ItemButton.searchOverlay:SetAllPoints(ItemButton.icon)
			ItemButton.searchOverlay:SetColorTexture(0, 0, 0, .8)

			ItemButton:SetNormalTexture("")
			ItemButton:StyleButton()
			hooksecurefunc(ItemButton.IconBorder, "SetVertexColor", function(self, r, g, b, a)
				local Quality = select(4, GetContainerItemInfo(ItemButton:GetParent():GetID(), ItemButton:GetID()))
				local isQuestItem, questId, isActive = GetContainerItemQuestInfo(ItemButton:GetParent():GetID(), ItemButton:GetID())
				if Quality and Quality > Enum.ItemQuality.Common then
					ItemButton:SetBackdropBorderColor(r, g, b)
				elseif isQuestItem then
					ItemButton:SetBackdropBorderColor(1, .82, 0)
				else
					ItemButton:SetBackdropBorderColor()
				end
			end)

			hooksecurefunc(ItemButton.IconBorder, "Hide", function(self)
				ItemButton:SetBackdropBorderColor()
			end)
		end

		Bag.backdrop:SetPoint("TOPLEFT", 4, -2)
		Bag.backdrop:SetPoint("BOTTOMRIGHT", 1, 1)

		_G["ContainerFrame"..i.."BackgroundTop"]:Kill()
		_G["ContainerFrame"..i.."BackgroundMiddle1"]:Kill()
		_G["ContainerFrame"..i.."BackgroundMiddle2"]:Kill()
		_G["ContainerFrame"..i.."BackgroundBottom"]:Kill()
		_G["ContainerFrame"..i.."CloseButton"]:SetPoint("TOPRIGHT", 5, 2)
		_G["ContainerFrame"..i.."CloseButton"]:SkinCloseButton()

		Bag.PortraitButton:SetSize(38, 38)
		Bag.PortraitButton:SetTemplate()
		Bag.PortraitButton.Highlight:SetAlpha(0)
	end

	local function UpdateBagIcon()
		for i = 1, 12 do
			local Portrait = _G["ContainerFrame"..i.."PortraitButton"]
			if i == 1 then
				Portrait:SetNormalTexture("Interface\\ICONS\\INV_Misc_Bag_36")
			elseif i <= 5 and i >= 2 then
				Portrait:SetNormalTexture(_G["CharacterBag"..(i - 2).."SlotIconTexture"]:GetTexture())
			elseif i <= 12 and i >= 6 then
				Portrait:SetNormalTexture(BankSlotsFrame["Bag"..(i-5)].icon:GetTexture())
			end

			if Portrait:GetNormalTexture() then
				Portrait:GetNormalTexture():SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				Portrait:GetNormalTexture():SetInside()
			end

			for j = 1, 30 do
				local ItemButton = _G["ContainerFrame"..i.."Item"..j]
				if ItemButton then
					local QuestIcon = _G["ContainerFrame"..i.."Item"..j.."IconQuestTexture"]
					local QuestTexture = QuestIcon:GetTexture()
					if QuestTexture == TEXTURE_ITEM_QUEST_BANG then
						QuestIcon:SetAlpha(1)
					else
						QuestIcon:SetAlpha(0)
					end
				end
			end
		end
	end

	hooksecurefunc("BankFrameItemButton_Update", UpdateBagIcon)
	hooksecurefunc("ContainerFrame_Update", UpdateBagIcon)

	BagItemSearchBox:StripTextures()
	BagItemSearchBox:CreateBorder()
	BackpackTokenFrame:StripTextures()

	BagItemAutoSortButton:SkinButton()
	BagItemAutoSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
	BagItemAutoSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
	BagItemAutoSortButton:GetNormalTexture():SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])

	BagItemAutoSortButton:GetNormalTexture():SetInside()
	BagItemAutoSortButton:GetPushedTexture():SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
	BagItemAutoSortButton:GetPushedTexture():SetInside()
	BagItemAutoSortButton:SetSize(22, 22)

	BagItemAutoSortButton:SetScript("OnShow", function(self)
		local a, b, c, d, e = self:GetPoint()
		self:SetPoint(a, b, c, d - 3, e - 1)
		self.SetPoint = D.Noop
		self:SetScript("OnShow", nil)
	end)

	for i = 1, 3 do
		local Token = _G["BackpackTokenFrameToken"..i]
		Token.icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
		Token:CreateBackdrop()
		Token.backdrop:SetFrameLevel(2)
		Token.backdrop:SetOutside(Token.icon)
	end

	BankFrame:CreateBackdrop()
	BankFrame.NineSlice:Kill()
	BankFrame:StripTextures()
	BankFrameCloseButton:SkinCloseButton()
	BankFrameMoneyFrameBorder:Kill()
	BankFrameMoneyFrameInset:Kill()
	BankSlotsFrame:StripTextures()

	BankFramePurchaseButton:SkinButton()
	BankFramePurchaseButton:SetHeight(22)

	BankItemSearchBox:StripTextures()
	BankItemSearchBox:SetSize(159, 16)
	BankItemSearchBox:CreateBorder()

	BankItemAutoSortButton:SkinButton()
	BankItemAutoSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
	BankItemAutoSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
	BankItemAutoSortButton:GetNormalTexture():SetInside()
	BankItemAutoSortButton:GetPushedTexture():SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
	BankItemAutoSortButton:GetPushedTexture():SetInside()
	BankItemAutoSortButton:SetSize(20, 20)
	BankItemAutoSortButton:SetPoint("LEFT", BankItemSearchBox, "RIGHT", 4, 0)

	for i = 1, 7 do
		local BankBag = BankSlotsFrame["Bag"..i]
		BankBag:CreateBorder()
		--BankBag.HighlightFrame.HighlightTexture:SetTexture(1, 1, 1, .2)
		BankBag:StyleButton()
		BankBag.icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
		BankBag.icon:SetInside()

		hooksecurefunc(BankBag.IconBorder, "SetVertexColor", function(self, r, g, b, a)
			BankBag:SetBackdropBorderColor(r, g, b)
		end)

		hooksecurefunc(BankBag.IconBorder, "Hide", function(self)
			BankBag:SetBackdropBorderColor()
		end)
	end

	for i = 1, 28 do
		local ItemButton = _G["BankFrameItem"..i]
		ItemButton:CreateBorder()
		ItemButton.icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
		ItemButton.icon:SetInside()

		ItemButton.searchOverlay:SetAllPoints(ItemButton.icon)
		ItemButton.searchOverlay:SetTexture(0, 0, 0, .8)

		ItemButton:SetNormalTexture(nil)
		ItemButton:StyleButton()

		hooksecurefunc(ItemButton.IconBorder, "SetVertexColor", function(self, r, g, b, a)
			ItemButton:SetBackdropBorderColor(r, g, b)
		end)
		hooksecurefunc(ItemButton.IconBorder, "Hide", function(self)
			ItemButton:SetBackdropBorderColor()
		end)
	end

	ReagentBankFrame.DespositButton:SkinButton()
	ReagentBankFrame:HookScript("OnShow", function(self)
		if ReagentBankFrame.slots_initialized and not ReagentBankFrame.isSkinned then
			for i = 1, 98 do
				local ItemButton = _G["ReagentBankFrameItem"..i]
				ItemButton:CreateBorder()
				ItemButton.icon:SetTexCoord(D['IconCoord'][1], D['IconCoord'][2], D['IconCoord'][3], D['IconCoord'][4])
				ItemButton.icon:SetInside()

				ItemButton.searchOverlay:SetAllPoints(ItemButton.icon)
				ItemButton.searchOverlay:SetTexture(0, 0, 0, .8)

				ItemButton:SetNormalTexture(nil)
				ItemButton:StyleButton()

				hooksecurefunc(ItemButton.IconBorder, "SetVertexColor", function(self, r, g, b, a)
					ItemButton:SetBackdropBorderColor(r, g, b)
				end)

				hooksecurefunc(ItemButton.IconBorder, "Hide", function(self)
					ItemButton:SetBackdropBorderColor()
				end)

				BankFrameItemButton_Update(ItemButton)
			end

			ReagentBankFrame:StripTextures(true)
			self.isSkinned = true
		end
	end)

	BankFrameTab1:SkinTab()
	BankFrameTab2:SkinTab()
end

tinsert(D['SkinFuncs']['DuffedUI'], LoadSkin)