local D, C, L = unpack(select(2, ...)) 
if not C['chat']['enable'] then return end

local gsub = gsub
local color = 'C41F3B'

local function PrintURL(url)
	url = '|cff'..color..'|Hurl:'..url..'|h['..url..']|h|r '
	return url
end

local FindURL = function(self, event, msg, ...)
	local newMsg, found = gsub(msg, '(%a+)://(%S+)%s?', PrintURL('%1://%2'))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, 'www%.([_A-Za-z0-9-]+)%.(%S+)%s?', PrintURL('www.%1.%2'))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, '([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?', PrintURL('%1@%2%3%4'))
	if found > 0 then return false, newMsg, ... end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_GUILD', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_OFFICER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND_LEADER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', FindURL)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_CONVERSATION', FindURL)

local currentLink = nil
local ChatFrame_OnHyperlinkShow_Original = ChatFrame_OnHyperlinkShow
ChatFrame_OnHyperlinkShow = function(self, link, ...)
	if (link):sub(1, 3) == 'url' then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then ChatEdit_ActivateChat(ChatFrameEditBox) end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		currentLink = nil
		return
	end
	ChatFrame_OnHyperlinkShow_Original(self, link, ...)
end