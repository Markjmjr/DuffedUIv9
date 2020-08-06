local D, C, L = unpack(select(2, ...))

local function SkinDropDownList(level, index)
	for i = 1, UIDROPDOWNMENU_MAXLEVELS do
		local menubackdrop = _G['DropDownList'..i..'MenuBackdrop']
		if menubackdrop and not menubackdrop.isSkinned then
			menubackdrop:SetTemplate('Transparent')
			menubackdrop.isSkinned = true
		end

		local backdrop = _G['DropDownList'..i..'Backdrop']
		if backdrop and not backdrop.isSkinned then
			backdrop:SetTemplate('Transparent')
			backdrop.isSkinned = true
		end

		backdrop = _G['Lib_DropDownList'..i..'MenuBackdrop']
		if backdrop and not backdrop.IsSkinned then
			backdrop:SetTemplate('Transparent')
			backdrop.IsSkinned = true
		end

		backdrop = _G['Lib_DropDownList'..i..'Backdrop']
		if backdrop and not backdrop.IsSkinned then
			backdrop:SetTemplate('Transparent')
			backdrop.IsSkinned = true
		end
	end
end
hooksecurefunc('UIDropDownMenu_CreateFrames', SkinDropDownList)

local ChatMenus = {
	'ChatMenu',
	'EmoteMenu',
	'LanguageMenu',
	'VoiceMacroMenu',
}

for i = 1, getn(ChatMenus) do
	if _G[ChatMenus[i]] == _G['ChatMenu'] then
		_G[ChatMenus[i]]:HookScript('OnShow', function(self)
			self:SetTemplate('Transparent', true)
			self:SetBackdropColor(unpack(C['media']['backdropcolor']))
			self:ClearAllPoints()
			self:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, D['Scale'](30))
		end)
	else
		_G[ChatMenus[i]]:HookScript('OnShow', function(self)
			self:SetTemplate('Transparent', true)
			self:SetBackdropColor(unpack(C['media']['backdropcolor']))
		end)
	end
end