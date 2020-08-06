local D, C, L = unpack(select(2, ...)) 

if not C['datatext']['battleground'] then return end

local bgframe = DuffedUIInfoLeftBattleGround
bgframe:SetScript('OnEnter', function(self)
	if not C['datatext']['ShowInCombat'] then
		if InCombatLockdown() then return end
	end

	local numScores = GetNumBattlefieldScores()
	local numExtraStats = GetNumBattlefieldStats()
	for i = 1, numScores do
		local Name, KillingBlows, HonorableKills, Deaths, HonorGained, _, _, _, _, DamageDone, HealingDone = GetBattlefieldScore(i)
		if (Name and Name == D['MyName']) then
			local color = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
			local classcolor = ('|cff%.2x%.2x%.2x'):format(color.r * 255, color.g * 255, color.b * 255)
			GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, D['Scale'](4))
			GameTooltip:ClearLines()
			GameTooltip:Point('BOTTOM', self, 'TOP', 0, 1)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(L['dt']['stats'], classcolor .. Name .. '|r')
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(KILLING_BLOWS .. ':', KillingBlows, 1, 1, 1)
			GameTooltip:AddDoubleLine(HONORABLE_KILLS .. ':', HonorableKills, 1, 1, 1)
			GameTooltip:AddDoubleLine(DEATHS .. ':', Deaths, 1, 1, 1)
			GameTooltip:AddDoubleLine(HONOR .. ':', format("%d", HonorGained), 1, 1, 1)
			GameTooltip:AddDoubleLine(DAMAGE .. ':', DamageDone, 1, 1, 1)
			GameTooltip:AddDoubleLine(HEALS .. ':', HealingDone, 1, 1, 1)

			for j = 1, numExtraStats do
				GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(j), GetBattlefieldStatData(i, j), 1,1,1)
			end
			
			break
		end
	end	
	GameTooltip:Show()
end) 
bgframe:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

local f, fs, ff = C['media']['font'], 11, 'THINOUTLINE'
local Stat = CreateFrame('Frame', 'DuffedUIStatBattleGround', UIParent)
Stat:EnableMouse(true)
Stat.Option = C['datatext']['battleground']
Stat.Color1 = D['RGBToHex'](unpack(C['media']['datatextcolor1']))
Stat.Color2 = D['RGBToHex'](unpack(C['media']['datatextcolor2']))

local Text1  = DuffedUIInfoLeftBattleGround:CreateFontString('DuffedUIStatBattleGroundText1', 'OVERLAY')
Text1:SetFont(f, fs, ff)
Text1:SetPoint('LEFT', 30, .5)
Text1:SetHeight(DuffedUIInfoLeft:GetHeight())

local Text2  = DuffedUIInfoLeftBattleGround:CreateFontString('DuffedUIStatBattleGroundText2', 'OVERLAY')
Text2:SetFont(f, fs, ff)
Text2:SetPoint('CENTER', 0, .5)
Text2:SetHeight(DuffedUIInfoLeft:GetHeight())

local Text3  = DuffedUIInfoLeftBattleGround:CreateFontString('DuffedUIStatBattleGroundText3', 'OVERLAY')
Text3:SetFont(f, fs, ff)
Text3:SetPoint('RIGHT', -30, .5)
Text3:SetHeight(DuffedUIInfoLeft:GetHeight())

local int = 2
local function Update(self, t)
	int = int - t
	if int < 0 then
		local dmgtxt
		RequestBattlefieldScoreData()
		local numScores = GetNumBattlefieldScores()
		for i = 1, numScores do
			local name, killingBlows, _, _, honorGained, _, _, _, _, damageDone, healingDone = GetBattlefieldScore(i)
			if healingDone > damageDone then
				dmgtxt = (Stat.Color1 .. SHOW_COMBAT_HEALING .. ': ' .. '|r' .. Stat.Color2 .. healingDone .. '|r')
			else
				dmgtxt = (Stat.Color1 .. DAMAGE .. ': ' .. '|r' .. Stat.Color2 .. damageDone .. '|r')
			end
			if name and name == D['MyName'] then
				Text2:SetText(Stat.Color1..HONOR..': '..'|r'..Stat.Color2..format('%d', honorGained)..'|r')
				Text1:SetText(dmgtxt)
				Text3:SetText(Stat.Color1..KILLING_BLOWS..': '..'|r'..Stat.Color2..killingBlows..'|r')
			end
		end
		int = 2
	end
end



--hide text when not in an bg
local function OnEvent(self, event)
	if event == 'PLAYER_ENTERING_WORLD' then
		local inInstance, instanceType = IsInInstance()
		if inInstance and (instanceType == 'pvp') then
			bgframe:Show()
		else
			Text1:SetText('')
			Text2:SetText('')
			Text3:SetText('')
			bgframe:Hide()
		end
	end
end

Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
Stat:SetScript('OnEvent', OnEvent)
Stat:SetScript('OnUpdate', Update)
Update(Stat, 2)