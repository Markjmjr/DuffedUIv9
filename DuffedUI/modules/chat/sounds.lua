local D, C, L = unpack(select(2, ...)) 
if not C['chat']['enable'] then return end

if C['chat']['whispersound'] then
	local SoundSys = CreateFrame('Frame')
	SoundSys:RegisterEvent('CHAT_MSG_WHISPER')
	SoundSys:RegisterEvent('CHAT_MSG_BN_WHISPER')
	SoundSys:SetScript('OnEvent', function(self, event, msg, ...)
		if event == 'CHAT_MSG_WHISPER' or 'CHAT_MSG_BN_WHISPER' then
			if (msg:sub(1,3) == 'OQ,') then return false, msg, ... end
			PlaySoundFile(C['media']['whisper'])
		end
	end)
	DuffedUIChat.Sound = SoundSys
end