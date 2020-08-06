local D, C, L = unpack(select(2, ...))

--[[Raid Utility(by Elv22)]]--
local move = D['move']
local anchor = CreateFrame('Frame', 'DuffedUIRaidUtilityAnchor', UIParent)
anchor:Size(175, 21)
anchor:Point('TOP', UIParent, 'TOP', -350, 0)
move:RegisterFrame(anchor)

local RaidUtilityPanel = CreateFrame('Frame', 'RaidUtilityPanel', UIParent)
RaidUtilityPanel:Point('TOPLEFT', anchor, 'TOPLEFT', 0, 0)
RaidUtilityPanel:SetTemplate('Transparent')
RaidUtilityPanel:Size(175, 120)

local function CheckRaidStatus()
	local _, instanceType = IsInInstance()
	if ((GetNumGroupMembers() > 0 and UnitIsGroupLeader('player') and not UnitInRaid('player')) or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and (instanceType ~= 'pvp' or instanceType ~= 'arena') then
		return true
	else
		return false
	end
end

local function CreateButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text)
	local b = CreateFrame('Button', name, parent, template)
	b:SetWidth(width)
	b:SetHeight(height)
	b:SetPoint(point, relativeto, point2, xOfs, yOfs)
	b:EnableMouse(true)
	b:StripTextures(true)
	b:SetTemplate()
	b:StyleButton()
	if text then
		b.t = b:CreateFontString(nil, 'OVERLAY')
		b.t:SetFont(C['media']['font'], 11, 'THINOUTLINE')
		b.t:SetPoint('CENTER', 0, -1)
		b.t:SetJustifyH('CENTER')
		b.t:SetText(text)
	end
end

CreateButton('RaidUtilityShowButton', UIParent, 'UIPanelButtonTemplate, SecureHandlerClickTemplate', RaidUtilityPanel:GetWidth(), 18, 'TOP', RaidUtilityPanel, 'TOP', 0, 0, RAID_CONTROL)
RaidUtilityShowButton:SetFrameRef('RaidUtilityPanel', RaidUtilityPanel)
RaidUtilityShowButton:SetAttribute('_onclick', [=[self:Hide(); self:GetFrameRef('RaidUtilityPanel'):Show();]=])
RaidUtilityShowButton:SetScript('OnMouseUp', function(self, button)
	if InCombatLockdown() then return end
	if button == 'RightButton' then
		if CheckRaidStatus() then DoReadyCheck() end
	elseif button == 'MiddleButton' then
		if CheckRaidStatus() then InitiateRolePoll() end
	elseif button == 'LeftButton' then
		RaidUtilityPanel.toggled = true
	end
end)

CreateButton('RaidUtilityCloseButton', RaidUtilityPanel, 'UIPanelButtonTemplate, SecureHandlerClickTemplate', RaidUtilityPanel:GetWidth(), 18, 'TOP', RaidUtilityPanel, 'BOTTOM', 0, -1, CLOSE)
RaidUtilityCloseButton:SetFrameRef('RaidUtilityShowButton', RaidUtilityShowButton)
RaidUtilityCloseButton:SetAttribute('_onclick', [=[self:GetParent():Hide(); self:GetFrameRef('RaidUtilityShowButton'):Show();]=])
RaidUtilityCloseButton:SetScript('OnMouseUp', function(self) RaidUtilityPanel.toggled = false end)

CreateButton('RaidUtilityDisbandButton', RaidUtilityPanel, 'UIPanelButtonTemplate', RaidUtilityPanel:GetWidth() * 0.8, 18, 'TOP', RaidUtilityPanel, 'TOP', 0, -5, L['group']['disband'])
RaidUtilityDisbandButton:SetScript('OnMouseUp', function(self) D.ShowPopup('DUFFEDUIDISBAND_RAID') end)

CreateButton('RaidUtilityConvertButton', RaidUtilityPanel, 'UIPanelButtonTemplate', RaidUtilityPanel:GetWidth() * 0.8, 18, 'TOP', RaidUtilityDisbandButton, 'BOTTOM', 0, -5, UnitInRaid('player') and CONVERT_TO_PARTY or CONVERT_TO_RAID)
RaidUtilityConvertButton:SetScript('OnMouseUp', function(self)
	if UnitInRaid('player') then
		ConvertToParty()
		RaidUtilityConvertButton.t:SetText(CONVERT_TO_RAID)
	elseif UnitInParty('player') then
		ConvertToRaid()
		RaidUtilityConvertButton.t:SetText(CONVERT_TO_PARTY)
	end
end)

CreateButton('RaidUtilityRoleButton', RaidUtilityPanel, 'UIPanelButtonTemplate', RaidUtilityPanel:GetWidth() * 0.8, 18, 'TOP', RaidUtilityConvertButton, 'BOTTOM', 0, -5, ROLE_POLL)
RaidUtilityRoleButton:SetScript('OnMouseUp', function(self) InitiateRolePoll() end)

CreateButton('RaidUtilityMainTankButton', RaidUtilityPanel, 'UIPanelButtonTemplate, SecureActionButtonTemplate', (RaidUtilityDisbandButton:GetWidth() / 2) - 2, 18, 'TOPLEFT', RaidUtilityRoleButton, 'BOTTOMLEFT', 0, -5, TANK)
RaidUtilityMainTankButton:SetAttribute('type', 'maintank')
RaidUtilityMainTankButton:SetAttribute('unit', 'target')
RaidUtilityMainTankButton:SetAttribute('action', 'toggle')

CreateButton('RaidUtilityMainAssistButton', RaidUtilityPanel, 'UIPanelButtonTemplate, SecureActionButtonTemplate', (RaidUtilityDisbandButton:GetWidth() / 2) - 2, 18, 'TOPRIGHT', RaidUtilityRoleButton, 'BOTTOMRIGHT', 0, -5, MAINASSIST)
RaidUtilityMainAssistButton:SetAttribute('type', 'mainassist')
RaidUtilityMainAssistButton:SetAttribute('unit', 'target')
RaidUtilityMainAssistButton:SetAttribute('action', 'toggle')

CreateButton('RaidUtilityReadyCheckButton', RaidUtilityPanel, 'UIPanelButtonTemplate', RaidUtilityRoleButton:GetWidth() * 0.75, 18, 'TOPLEFT', RaidUtilityMainTankButton, 'BOTTOMLEFT', 0, -5, READY_CHECK)
RaidUtilityReadyCheckButton:SetScript('OnMouseUp', function(self) DoReadyCheck() end)

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint('TOPRIGHT', RaidUtilityMainAssistButton, 'BOTTOMRIGHT', 0, -5)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent('RaidUtilityPanel')
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetHeight(18)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(RaidUtilityRoleButton:GetWidth() * 0.22)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:StripTextures(true)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetTemplate()
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:StyleButton()

local MarkTexture = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:CreateTexture(nil, 'OVERLAY')
MarkTexture:SetTexture('Interface\\RaidFrame\\Raid-WorldPing')
MarkTexture:SetPoint('CENTER', 0, -1)

local function ToggleRaidUtil(self, event)
	if InCombatLockdown() then
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		return
	end

	if CheckRaidStatus() then
		if RaidUtilityPanel.toggled == true then
			RaidUtilityShowButton:Hide()
			RaidUtilityPanel:Show()
		else
			RaidUtilityShowButton:Show()
			RaidUtilityPanel:Hide()
		end
	else
		RaidUtilityShowButton:Hide()
		RaidUtilityPanel:Hide()
	end

	if event == 'PLAYER_REGEN_ENABLED' then self:UnregisterEvent('PLAYER_REGEN_ENABLED') end
end

local LeadershipCheck = CreateFrame('Frame')
LeadershipCheck:RegisterEvent('PLAYER_ENTERING_WORLD')
LeadershipCheck:RegisterEvent('GROUP_ROSTER_UPDATE')
LeadershipCheck:SetScript('OnEvent', ToggleRaidUtil)