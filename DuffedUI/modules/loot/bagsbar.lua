local D, C, L = unpack(select(2, ...))
local Module = D:NewModule('Bagsbar')

local _G = _G
local unpack = unpack
local tinsert = tinsert

local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local NUM_BAG_FRAMES = NUM_BAG_FRAMES

local move = D['move']

local function OnEnter()
	if not C['bags'].BagBarMouseover then return end
	UIFrameFadeIn(DuffedUIBags, 0.2, DuffedUIBags:GetAlpha(), 1)
end

local function OnLeave()
	if not C['bags'].BagBarMouseover then return end
	UIFrameFadeOut(DuffedUIBags, 0.2, DuffedUIBags:GetAlpha(), 0.2)
end

function Module:SkinBag(bag)
	local icon = _G[bag:GetName()..'IconTexture']
	bag.oldTex = icon:GetTexture()
	bag.IconBorder:SetAlpha(0)

	bag:CreateBorder(nil, nil, nil, true)
	bag:StyleButton(true)
	icon:SetTexture(bag.oldTex)
	icon:SetInside()
	icon:SetTexCoord(unpack(D['IconCoord']))
end

function Module:SizeAndPositionBagBar()
	if not DuffedUIBags then return	end

	local buttonPadding = 0
	local buttonSpacing = 6
	local bagBarSize = 30

	local visibility = '[petbattle] hide; show'
	if visibility and visibility:match('[\n\r]') then
		visibility = visibility:gsub('[\n\r]','')
	end

	RegisterStateDriver(DuffedUIBags, 'visibility', visibility)

	if C['bags'].BagBarMouseover then
		DuffedUIBags:SetAlpha(0.2)
	else
		DuffedUIBags:SetAlpha(1)
	end

	for i = 1, #DuffedUIBags.buttons do
		local button = DuffedUIBags.buttons[i]
		local prevButton = DuffedUIBags.buttons[i-1]
		button:SetSize(bagBarSize, bagBarSize)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('RIGHT', DuffedUIBags, 'RIGHT', 0, 0)
		elseif prevButton then
			button:SetPoint('RIGHT', prevButton, 'LEFT', -buttonSpacing, 0)
		end

		if i ~= 1 then
			button.IconBorder:SetSize(bagBarSize, bagBarSize)
		end
	end

	DuffedUIBags:SetWidth(bagBarSize * (NUM_BAG_FRAMES + 1) + buttonSpacing * (NUM_BAG_FRAMES) + buttonPadding * 2)
	DuffedUIBags:SetHeight(bagBarSize + buttonPadding * 2)
end

function Module:OnEnable()
	if not C['bags'].BagBar then return	end

	local DuffedUIBags = CreateFrame('Frame', 'DuffedUIBags', UIParent)
	if C['actionbar'].microbar then
		DuffedUIBags:SetPoint('BOTTOMRIGHT', DuffedUI_MicroBar, 'TOPRIGHT', -4, 4)
	elseif DuffedUIChatBackgroundRight then
		DuffedUIBags:SetPoint('BOTTOMRIGHT', DuffedUIChatBackgroundRight, 'TOPRIGHT', 0, 3)
	else
		DuffedUIBags:SetPoint('BOTTOMRIGHT', DuffedUIInfoRight, 'TOPRIGHT', 0, 3)
	end
	DuffedUIBags:CreateBackdrop()
	DuffedUIBags.buttons = {}
	DuffedUIBags:EnableMouse(true)
	DuffedUIBags:SetScript('OnEnter', OnEnter)
	DuffedUIBags:SetScript('OnLeave', OnLeave)

	_G.MainMenuBarBackpackButton:SetParent(DuffedUIBags)
	_G.MainMenuBarBackpackButton.SetParent = D.Noop
	_G.MainMenuBarBackpackButton:ClearAllPoints()
	_G.MainMenuBarBackpackButtonCount:SetFont(C['media']['font'], 11, 'THINOUTLINE')
	_G.MainMenuBarBackpackButtonCount:ClearAllPoints()
	_G.MainMenuBarBackpackButtonCount:SetPoint('BOTTOMRIGHT', _G.MainMenuBarBackpackButton, 'BOTTOMRIGHT', 4, 2)
	_G.MainMenuBarBackpackButton:HookScript('OnEnter', OnEnter)
	_G.MainMenuBarBackpackButton:HookScript('OnLeave', OnLeave)

	tinsert(DuffedUIBags.buttons, _G.MainMenuBarBackpackButton)
	self:SkinBag(_G.MainMenuBarBackpackButton)

	for i = 0, NUM_BAG_FRAMES-1 do
		local b = _G['CharacterBag'..i..'Slot']
		b:SetParent(DuffedUIBags)
		b.SetParent = D.Noop
		b:HookScript('OnEnter', OnEnter)
		b:HookScript('OnLeave', OnLeave)

		self:SkinBag(b)
		tinsert(DuffedUIBags.buttons, b)
	end

	-- Hide And Show To Update Assignment Textures On First Load
	DuffedUIBags:Hide()
	DuffedUIBags:Show()

	self:SizeAndPositionBagBar()
	move:RegisterFrame(DuffedUIBags)
end