local D, C, L = unpack(select(2, ...)) 
if not C['chat']['enable'] then return end

for i = 1, NUM_CHAT_WINDOWS do
	local editbox = _G['ChatFrame' .. i .. 'EditBox']
	editbox:HookScript('OnTextChanged', function(self)
		local text = self:GetText()
		if text:len() < 5 then
			if text:sub(1, 4) == '/tt ' then
				local unitname, realm = UnitName('target')
				if unitname then
					if unitname then unitname = gsub(unitname, ' ', '') end
					if unitname and not UnitIsSameServer('player', 'target') then unitname = unitname .. '-' .. gsub(realm, ' ', '') end
					ChatFrame_SendTell((unitname), ChatFrame1)
				end
			end
		end
	end)
end

SLASH_TELLTARGET1 = '/tt'
SlashCmdList.TELLTARGET = function(msg) SendChatMessage(msg, 'WHISPER') end