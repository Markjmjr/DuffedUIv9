local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local hide = DuffedUIUIHider
local frames = {
	MainMenuBar, MainMenuBarArtFrame, PossessBarFrame, 
	PetActionBarFrame, IconIntroTracker, ShapeshiftBarLeft,
	ShapeshiftBarMiddle, ShapeshiftBarRight,
}

for i, f in pairs(frames) do
	f:UnregisterAllEvents()
	f.ignoreFramePositionManager = true
	f:SetParent(hide)
end

IconIntroTracker:UnregisterAllEvents()
IconIntroTracker:SetParent(hide)
MainMenuBar.slideOut.IsPlaying = function() return true end
SetCVar('alwaysShowActionBars', 1)

hooksecurefunc('TalentFrame_LoadUI', function() PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED') end)

--hooksecurefunc('ActionButton_OnEvent', function(self, event, ...)
	if event == 'PLAYER_ENTERING_WORLD' then
		self:UnregisterEvent('ACTIONBAR_SHOWGRID')
		self:UnregisterEvent('ACTIONBAR_HIDEGRID')
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	end
--end)