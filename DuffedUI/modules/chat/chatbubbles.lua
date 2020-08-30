local D, C, L = unpack(select(2, ...))
if C['chat']['newchatbubbles'] ~= true or IsAddOnLoaded('NiceBubbles') then	return end

local Module = D:NewModule('ChatBubbles', 'AceEvent-3.0', 'AceHook-3.0')

local _G = _G
local CreateFrame = _G.CreateFrame
local GetCVarBool = _G.GetCVarBool
local C_ChatBubbles_GetAllChatBubbles = _G.C_ChatBubbles.GetAllChatBubbles

local function getBackdrop()
	return {
		bgFile = C['media']['blank'],
		edgeFile = C['media']['glowTex'],
		edgeSize = 4,
		insets = {
			left = 4,
			right = 4,
			top = 4,
			bottom = 4
		}
	}
end

local function ReskinChatBubble(chatbubble)
	if chatbubble.styled then return end

	local frame = chatbubble:GetChildren()
	if frame and not frame:IsForbidden() then
		local bg = CreateFrame('frame', nil, parent, 'BackdropTemplate')
		bg:SetScale(UIParent:GetEffectiveScale())
		bg:SetInside(frame, 6, 6)

		bg:SetFrameStrata("BACKGROUND")
		frame:SetBackdrop(getBackdrop())
		frame:SetBackdropColor(C['general']['backdropcolor'][1], C['general']['backdropcolor'][2], C['general']['backdropcolor'][3], C['general']['backdropcolor'][4])
		frame:SetBackdropBorderColor(C['general']['bordercolor'][1], C['general']['bordercolor'][2], C['general']['bordercolor'][3], C['general']['bordercolor'][4])
		frame.Tail:SetAlpha(0)
		frame.String:SetFont(C['media']['font'], C['chat']['chatbubblesfontsize'], "OUTLINE")
	end

	chatbubble.styled = true
end

function Module:CreateChatBubbles()
	local events = {
		CHAT_MSG_SAY = "chatBubbles",
		CHAT_MSG_YELL = "chatBubbles",
		CHAT_MSG_MONSTER_SAY = "chatBubbles",
		CHAT_MSG_MONSTER_YELL = "chatBubbles",
		CHAT_MSG_PARTY = "chatBubblesParty",
		CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
		CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
	}

	local bubbleHook = CreateFrame("Frame")

	for event in next, events do
		bubbleHook:RegisterEvent(event)
	end

	bubbleHook:SetScript("OnEvent", function(self, event, msg)
		if GetCVarBool(events[event]) then
			self.elapsed = 0
			self:Show()
		end
	end)

	bubbleHook:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > .1 then
			for _, chatbubble in pairs(C_ChatBubbles_GetAllChatBubbles()) do
				if chatbubble and not chatbubble.styled then
				ReskinChatBubble(chatbubble)
					chatbubble.styled = true
				end
			end
			self:Hide()
		end
	end)

	bubbleHook:Hide()
end

function Module:OnInitialize()
	self.CreateChatBubbles()
end