local D, C, L = unpack(select(2, ...)) 
if not C['misc']['corruption'] then return end

local barHeight, barWidth = C['misc']['corruptionheight'], C['misc']['corruptionwidth']
local barTex, flatTex = C['media']['normTex']
local color = RAID_CLASS_COLORS[D.Class]
local move = D['move']

local backdrop = CreateFrame('Frame', 'Corruption_Backdrop', UIParent, 'BackdropTemplate')
backdrop:SetSize(barWidth, barHeight)
backdrop:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 392, 5)
backdrop:SetBackdropColor(C['general']['backdropcolor'])
backdrop:SetBackdropBorderColor(C['general']['backdropcolor'])
backdrop:CreateBackdrop('Transparent')
backdrop:SetFrameStrata('LOW')
move:RegisterFrame(backdrop)

local corruptionBar = CreateFrame('StatusBar',  'Corruption_corruptionBar', backdrop, 'TextStatusBar')
corruptionBar:SetWidth(barWidth)
corruptionBar:SetHeight(barHeight)
corruptionBar:SetPoint('TOP', backdrop, 'TOP', 0, 0)
corruptionBar:SetStatusBarTexture(barTex)
corruptionBar:SetStatusBarColor(0.584, 0.428, 0.82)
corruptionBar:SetFrameLevel(backdrop:GetFrameLevel() + 2)

local CorruptionmouseFrame = CreateFrame('Frame', 'Corruption_mouseFrame', backdrop)
CorruptionmouseFrame:SetAllPoints(backdrop)
CorruptionmouseFrame:EnableMouse(true)
CorruptionmouseFrame:SetFrameLevel(backdrop:GetFrameLevel() + 3)

function updateStatus()
	local corruption = GetCorruption()
	local corruptionResistance = GetCorruptionResistance()
	local totalCorruption = math.max(corruption - corruptionResistance, 0)

	if (event == "PLAYER_ENTERING_WORLD") then corruptionBar.eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD") end

	if corruption > 0 then
		corruptionBar:Show()
		backdrop:Show()
	end

	if corruption and corruption > 0 and not InCombatLockdown() then
		corruptionBar:Show()
		
		local current = totalCorruption
		local max = corruption

		if max == 0 then
			max = 1
		end
		
		corruptionBar:SetMinMaxValues(0, max)
		corruptionBar:SetValue(current)		
		corruptionBar:SetOrientation('VERTICAL')
	else
		corruptionBar:Hide()
		backdrop:Hide()
	end
end

local function SortCorruptionEffects(a, b)
	return a.minCorruption < b.minCorruption;
end

CorruptionmouseFrame:SetScript('OnEnter', function()
		GameTooltip:SetOwner(CorruptionmouseFrame, 'ANCHOR_TOPRIGHT', 2, 5)
		GameTooltip:ClearLines()

		local corruption = GetCorruption()
		local corruptionResistance = GetCorruptionResistance()
		local totalCorruption = math.max(corruption - corruptionResistance, 0)
		if corruption and corruption > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(CORRUPTION_TOOLTIP_TITLE)
			GameTooltip:AddDoubleLine(CORRUPTION_TOOLTIP_LINE, corruption, 1, 1, 1)
			GameTooltip:AddDoubleLine(CORRUPTION_RESISTANCE_TOOLTIP_LINE, corruptionResistance, 1, 1, 1)
			GameTooltip:AddDoubleLine(TOTAL_CORRUPTION_TOOLTIP_LINE, totalCorruption, 0.584, 0.428, 0.82, 0.584, 0.428, 0.82)

			if C['misc']['corruptioneffects'] then
				GameTooltip:AddLine(" ")
				local corruptionEffects = GetNegativeCorruptionEffectInfo()
				table.sort(corruptionEffects, SortCorruptionEffects)

				for i = 1, #corruptionEffects do
					local corruptionInfo = corruptionEffects[i]

					-- We only show 1 effect above the player's current corruption.
					local lastEffect = (corruptionInfo.minCorruption > totalCorruption)

					GameTooltip_AddColoredLine(GameTooltip, CORRUPTION_EFFECT_HEADER:format(corruptionInfo.name, corruptionInfo.minCorruption), lastEffect and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR, noWrap)
					GameTooltip_AddColoredLine(GameTooltip, corruptionInfo.description, lastEffect and GRAY_FONT_COLOR or CORRUPTION_COLOR, wrap, descriptionXOffset)

					if lastEffect then
						break
					end
				end
			end
		end
		GameTooltip:Show()
end)

CorruptionmouseFrame:SetScript('OnLeave', function() GameTooltip:Hide() end)

local frame = CreateFrame('Frame',nil,UIParent)
frame:RegisterEvent('COMBAT_RATING_UPDATE')
frame:RegisterEvent('SPELL_TEXT_UPDATE')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', updateStatus)