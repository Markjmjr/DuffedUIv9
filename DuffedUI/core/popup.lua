local D, C, L = unpack(select(2, ...))

D['CreatePopup'] = {}
local frame = {}
local total = 4

local function Hide(self)
	local popup = self:GetParent()
	popup:Hide()
end

for i = 1, total do
	frame[i] = CreateFrame('Frame', 'DuffedUIPopupDialog' .. i, UIParent, 'BackdropTemplate')
	frame[i]:SetSize(250, 100)
	frame[i]:SetFrameLevel(3)
	frame[i]:SetTemplate('Transparent')
	frame[i]:SetPoint('TOP', UIParent, 'TOP', 0, -150)
	frame[i]:Hide()

	frame[i].Text = CreateFrame('MessageFrame', nil, frame[i])
	frame[i].Text:SetPoint('CENTER', 0, 10)
	frame[i].Text:SetSize(230, 60)
	frame[i].Text:SetFont(C['media']['font'], 11, 'THINOUTLINE')
	frame[i].Text:SetInsertMode('TOP')
	frame[i].Text:SetFading(false)
	frame[i].Text:AddMessage('')

	frame[i].button1 = CreateFrame('Button', 'DuffedUIPopupDialogButtonAccept' .. i, frame[i], 'BackdropTemplate')
	frame[i].button1:SetPoint('BOTTOMLEFT', frame[i], 'BOTTOMLEFT', 6, 7)
	frame[i].button1:SetSize(100, 20)
	frame[i].button1:SetTemplate('Default')
	frame[i].button1:FontString('Text', C['media']['font'], 11, 'THINOUTLINE')
	frame[i].button1.Text:SetPoint('CENTER')
	frame[i].button1.Text:SetText(ACCEPT)
	frame[i].button1:SetScript('OnClick', Hide)
	frame[i].button1:HookScript('OnClick', Hide)
	frame[i].button1:SkinButton()

	frame[i].button2 = CreateFrame('Button', 'DuffedUIPopupDialogButtonCancel' .. i, frame[i], 'BackdropTemplate')
	frame[i].button2:SetPoint('BOTTOMRIGHT', frame[i], 'BOTTOMRIGHT', -6, 7)
	frame[i].button2:SetSize(100, 20)
	frame[i].button2:SetTemplate('Default')
	frame[i].button2:FontString('Text', C['media']['font'], 11, 'THINOUTLINE')
	frame[i].button2.Text:SetPoint('CENTER')
	frame[i].button2.Text:SetText(CANCEL)
	frame[i].button2:SetScript('OnClick', Hide)
	frame[i].button2:HookScript('OnClick', Hide)
	frame[i].button2:SkinButton()

	frame[i].EditBox = CreateFrame('EditBox', 'DuffedUIPopupDialogEditBox' .. i, frame[i], 'BackdropTemplate')
	frame[i].EditBox:SetMultiLine(false)
	frame[i].EditBox:EnableMouse(true)
	frame[i].EditBox:SetAutoFocus(true)
	frame[i].EditBox:SetFontObject(ChatFontNormal)
	frame[i].EditBox:Width(230)
	frame[i].EditBox:Height(16)
	frame[i].EditBox:SetPoint('BOTTOM', frame[i], 0, 35)
	frame[i].EditBox:SetScript('OnEscapePressed', function() frame[i]:Hide() end)
	frame[i].EditBox:CreateBackdrop()
	frame[i].EditBox.backdrop:SetPoint('TOPLEFT', -4, 4)
	frame[i].EditBox.backdrop:SetPoint('BOTTOMRIGHT', 4, -4)
	frame[i].EditBox:Hide()
end

D['ShowPopup'] = function(self)
	local info = D['CreatePopup'][self]
	if not info then return end

	local selection = _G['DuffedUIPopupDialog1']
	for i = 1, total - 1 do
		if frame[i]:IsShown() then selection = _G['DuffedUIPopupDialog' .. i + 1] end
	end

	local popup = selection
	local question = popup.Text
	local btn1 = popup.button1
	local btn2 = popup.button2
	local eb = popup.EditBox

	question:Clear()

	eb:SetText('')

	if info.question then question:AddMessage(info.question) end

	if info.answer1 then btn1.Text:SetText(info.answer1) else btn1.Text:SetText(ACCEPT) end

	if info.answer2 then btn2.Text:SetText(info.answer2) else btn2.Text:SetText(CANCEL) end

	if info.function1 then btn1:SetScript('OnClick', info.function1) else btn1:SetScript('OnClick', Hide) end

	if info.function2 then btn2:SetScript('OnClick', info.function2) else btn2:SetScript('OnClick', Hide) end

	if info.editbox then eb:Show() else eb:Hide() end

	btn1:HookScript('OnClick', Hide)
	btn2:HookScript('OnClick', Hide)

	popup:Show()
end
