local D, C, L = unpack(select(2, ...))
if C['chat']['newchatbubbles'] ~= true or IsAddOnLoaded('NiceBubbles') then	return end

local Module = D:NewModule('ChatBubbles', 'AceEvent-3.0', 'AceHook-3.0')

local _G = _G
local math_abs = math.abs
local math_floor = math.floor
local pairs = pairs
local select = select

local CreateFrame = _G.CreateFrame
local IsInInstance = _G.IsInInstance
local WorldFrame = _G.WorldFrame

local bubbles = {}
local numChildren, numBubbles = -1, 0

local fontsize = C['chat']['chatbubblesfontsize']
local offsetX, offsetY = 0, 0

-- Textures
local BUBBLE_TEXTURE = [[Interface\Tooltips\ChatBubble-Background]]

local function getPadding()
	return fontsize / 1.2
end

local function getMaxWidth()
	return 400 + math_floor((fontsize - C['chat']['chatbubblesfontsize']) / 22 * 260)
end

local function getBackdrop(scale)
	return {
		bgFile = C['media']['blank'],
		edgeFile = C['media']['glowTex'],
		edgeSize = 4 * scale,
		insets = {
			left = 4 * scale,
			right = 4 * scale,
			top = 4 * scale,
			bottom = 4 * scale
		}
	}
end

local Updater = CreateFrame('Frame', nil, WorldFrame)
Updater:SetFrameStrata('TOOLTIP')

Updater.IsBubble = function(_, bubble)
	if (bubble.IsForbidden and bubble:IsForbidden()) then
		return
	end
	local name = bubble.GetName and bubble:GetName()
	local region = bubble.GetRegions and bubble:GetRegions()
	if name or not region then
		return
	end
	local texture = region.GetTexture and region:GetTexture()
	return texture and texture == BUBBLE_TEXTURE
	end or function(_, bubble)
	local name = bubble.GetName and bubble:GetName()
	local region = bubble.GetRegions and bubble:GetRegions()
	if name or not region then
		return
	end
	local texture = region.GetTexture and region:GetTexture()
	return texture and texture == BUBBLE_TEXTURE
end

function Updater:OnUpdate()
	local children = select('#', WorldFrame:GetChildren())
	if numChildren ~= children then
		for i = 1, children do
			local frame = select(i, WorldFrame:GetChildren())
			if not (bubbles[frame]) and self:IsBubble(frame) then
				self:InitBubble(frame)
			end
		end
		numChildren = children
	end

	local scale = WorldFrame:GetHeight() / UIParent:GetHeight()
	for bubble in pairs(bubbles) do
		local msg = bubble and bubble.text:GetText()
		if bubble:IsShown() and msg and (msg ~= '') then
			bubbles[bubble]:SetFrameLevel(bubble:GetFrameLevel())

			local blizzTextWidth = math_floor(bubble.text:GetWidth())
			local blizzTextHeight = math_floor(bubble.text:GetHeight())
			local point, _, rpoint, blizzX, blizzY = bubble.text:GetPoint()
			local r, g, b = bubble.text:GetTextColor()
			bubbles[bubble].color[1] = r
			bubbles[bubble].color[2] = g
			bubbles[bubble].color[3] = b
			if blizzTextWidth and blizzTextHeight and point and rpoint and blizzX and blizzY then
				if (not bubbles[bubble]:IsShown()) then
					bubbles[bubble]:Show()
				end
				local msg = bubble.text:GetText()
				if msg and (bubbles[bubble].last ~= msg) then
					bubbles[bubble].text:SetText(msg or '')
					bubbles[bubble].text:SetTextColor(r, g, b)
					bubbles[bubble].last = msg
					local sWidth = bubbles[bubble].text:GetStringWidth()
					local maxWidth = getMaxWidth()
					if sWidth > maxWidth then
						bubbles[bubble].text:SetWidth(maxWidth)
					else
						bubbles[bubble].text:SetWidth(sWidth)
					end
				end
				local space = getPadding()
				local ourTextWidth = bubbles[bubble].text:GetWidth()
				local ourTextHeight = bubbles[bubble].text:GetHeight()
				local ourX = math_floor((blizzX - blizzTextWidth / 2) / scale - (ourTextWidth - blizzTextWidth) / 2)
				local ourY = math_floor(blizzY / scale - (ourTextHeight - blizzTextHeight) / 2)
				local ourWidth = math_floor(ourTextWidth + space * 2)
				local ourHeight = math_floor(ourTextHeight + space * 2)
				bubbles[bubble]:Hide()
				bubbles[bubble]:SetSize(ourWidth, ourHeight)
				local oldX, oldY = select(4, bubbles[bubble]:GetPoint())
				if not (oldX and oldY) or ((math_abs(oldX - ourX) > .5) or (math_abs(oldY - ourY) > .5)) then
					bubbles[bubble]:ClearAllPoints()
					bubbles[bubble]:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', ourX, ourY)
				end
				bubbles[bubble]:SetBackdropColor(C['general']['backdropcolor'][1], C['general']['backdropcolor'][2], C['general']['backdropcolor'][3], C['general']['backdropcolor'][4])
				bubbles[bubble]:SetBackdropBorderColor(r * 0.5, g * 0.5, b * 0.5, 0.9)
				bubbles[bubble]:Show()
			end
			bubble.text:SetTextColor(r, g, b, 0)
		else
			if bubbles[bubble]:IsShown() then
				bubbles[bubble]:Hide()
			else
				bubbles[bubble].last = nil
			end
		end
	end
end

function Updater:HideBlizzard(bubble)
	local r, g, b = bubble.text:GetTextColor()
	bubbles[bubble].color[1] = r
	bubbles[bubble].color[2] = g
	bubbles[bubble].color[3] = b
	bubble.text:SetTextColor(r, g, b, 0)
	for region, _ in pairs(bubbles[bubble].regions) do
		region:SetTexture(nil)
	end
end

function Updater:ShowBlizzard(bubble)
	bubble.text:SetTextColor(bubbles[bubble].color[1], bubbles[bubble].color[2], bubbles[bubble].color[3], 1)
	for region, texture in pairs(bubbles[bubble].regions) do
		region:SetTexture(texture)
	end
end

function Updater:InitBubble(bubble)
	numBubbles = numBubbles + 1

	local space = getPadding()
	bubbles[bubble] = CreateFrame('Frame', nil, self.BubbleBox)
	bubbles[bubble]:Hide()
	bubbles[bubble]:SetFrameStrata('BACKGROUND')
	bubbles[bubble]:SetFrameLevel(numBubbles % 128 + 1)
	bubbles[bubble]:SetBackdrop(getBackdrop(1))

	bubbles[bubble].text = bubbles[bubble]:CreateFontString()
	bubbles[bubble].text:SetPoint('BOTTOMLEFT', space, space)
	bubbles[bubble].text:SetFontObject(ChatFont)
	bubbles[bubble].text:SetFont(C['media']['font'], C['chat']['chatbubblesfontsize'], '')
	bubbles[bubble].text:SetShadowOffset(-.75, -.75)
	bubbles[bubble].text:SetShadowColor(0, 0, 0, 1)

	bubbles[bubble].regions = {}
	bubbles[bubble].color = {1, 1, 1, 1}

	for i = 1, bubble:GetNumRegions() do
		local region = select(i, bubble:GetRegions())
		if region:GetObjectType() == 'Texture' then
			bubbles[bubble].regions[region] = region:GetTexture()
		elseif region:GetObjectType() == 'FontString' then
			bubble.text = region
		end
	end

	self:HideBlizzard(bubble)
end

function Module:OnInitialize()
	self.Updater = Updater

	self.BubbleBox = CreateFrame('Frame', nil, UIParent)
	self.BubbleBox:SetAllPoints()
	self.BubbleBox:Hide()

	self.Updater.BubbleBox = self.BubbleBox

	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateBubbleDisplay')
end

function Module:UpdateBubbleDisplay()
	local _, instanceType = IsInInstance()
	if (instanceType == 'none') then
		self.Updater:SetScript('OnUpdate', self.Updater.OnUpdate)
	else
		self.Updater:SetScript('OnUpdate', nil)
		for bubble in pairs(bubbles) do
			bubbles[bubble]:Hide()
		end
	end
end

function Module:OnEnable()
	self:UpdateBubbleDisplay()
	self.BubbleBox:Show()
	for bubble in pairs(bubbles) do
		self.Updater:HideBlizzard(bubble)
	end
end

function Module:OnDisable()
	self:UpdateBubbleDisplay()
	self.BubbleBox:Hide()
	for bubble in pairs(bubbles) do
		self.Updater:ShowBlizzard(bubble)
	end
end