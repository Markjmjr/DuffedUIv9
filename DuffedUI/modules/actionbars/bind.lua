local D, C, L = unpack(select(2, ...))
if not C['actionbar']['enable'] then return end

local bind = CreateFrame('Frame')

function bind:OnEvent(event, addon)
	if addon ~= "Blizzard_BindingUI" then return end
	
	local Frame = QuickKeybindFrame
	local Header = Frame.Header
	local Title = Frame.Header.Text
	local Background = Frame.BG
	local Tooltip = QuickKeybindTooltip
	local CheckBox = Frame.characterSpecificButton
	local Extra = Frame.phantomExtraActionButton
	local Buttons = {
		"okayButton",
		"defaultsButton",
		"cancelButton"
	}
	
	Frame:StripTextures()
	Frame:SetTemplate('Transparent')
	Background:StripTextures()
	Header:StripTextures()
	Title:Hide()
	Tooltip:SetTemplate()
	CheckBox:SkinCheckBox()
	
	for _, Button in pairs(Buttons) do Frame[Button]:SkinButton() end
	MultiBarBottomLeft.QuickKeybindGlow:SetAlpha(0)
	MultiBarBottomRight.QuickKeybindGlow:SetAlpha(0)

	
	Extra:SetParent(DuffedUIHider)
end

function bind:Enable()
	self:RegisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", self.OnEvent)
end

bind:RegisterEvent('ADDON_LOADED')
bind:RegisterEvent('PLAYER_ENTERING_WORLD')
bind:SetScript('OnEvent', function(self, event, ...)
	bind:Enable()
end)

D['BindingUI'] = function()
	if QuickKeybindFrame and QuickKeybindFrame:IsShown() then return end
	GameMenuButtonKeybindings:Click()
	KeyBindingFrame.quickKeybindButton:Click()
end
D:RegisterChatCommand('dkb', D['BindingUI'])

if not IsAddOnLoaded('Bartender4') and not IsAddOnLoaded('Dominos') then D:RegisterChatCommand('kb', D['BindingUI']) end
if not IsAddOnLoaded('HealBot') then D:RegisterChatCommand('hb', D['BindingUI']) end