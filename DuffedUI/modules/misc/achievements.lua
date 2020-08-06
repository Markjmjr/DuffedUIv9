local D, C, L = unpack(select(2, ...)) 

local move = D['move']
local AchievementHolder = CreateFrame('Frame', 'DuffedUIAchievementMover', UIParent)
AchievementHolder:Size(180, 20)
AchievementHolder:SetPoint('LEFT', UIParent, 'LEFT', 312, 25)
move:RegisterFrame(AchievementHolder)

AlertFrame:SetParent(AchievementHolder)
AlertFrame:SetPoint('TOP', AchievementHolder, 0, -30)

--[[SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound(17316)
	AchievementFrame_LoadUI()
	AchievementAlertFrame_ShowAlert(5780)
	AchievementAlertFrame_ShowAlert(5000)
	GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	ChallengeModeAlertFrame_ShowAlert()
	CriteriaAlertFrame_GetAlertFrame()
	AlertFrame_AnimateIn(CriteriaAlertFrame1)
	AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
	AlertFrame_AnimateIn(ScenarioAlertFrame1)
	MoneyWonAlertFrame_ShowAlert(1)
	
	local _, itemLink = GetItemInfo(6948)
	LootWonAlertFrame_ShowAlert(itemLink, -1, 1, 1)
	AlertFrame_FixAnchors()
end
SLASH_TEST_ACHIEVEMENT1 = '/testalerts']]