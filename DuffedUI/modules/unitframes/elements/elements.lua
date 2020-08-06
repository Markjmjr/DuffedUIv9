local D, C, L = unpack(select(2, ...))

local texture = C['media']['normTex']
local font, fontsize, fontflag = C['media']['font'], 11, 'THINOUTLINE'
local Color = RAID_CLASS_COLORS[D['Class']]
local move = D['move']
D['ClassRessource'] = {}

-- Mover for ressources
if not C['unitframes']['attached'] then
	local cba = CreateFrame('Frame', 'RessourceMover', UIParent)
	cba:Size(250, 15)
	cba:Point('BOTTOM', UIParent, 'BOTTOM', 0, 375)
	move:RegisterFrame(cba)
end

-- Function for oocHide
D['oocHide'] = function(frame)
	frame:RegisterEvent('PLAYER_REGEN_DISABLED')
	frame:RegisterEvent('PLAYER_REGEN_ENABLED')
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_REGEN_DISABLED' then
			UIFrameFadeIn(self, (0.3 * (1 - self:GetAlpha())), self:GetAlpha(), 1)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
		elseif event == 'PLAYER_ENTERING_WORLD' then
			if not InCombatLockdown() then frame:SetAlpha(0) end
		end
	end)
end

-- Energybar
D['ConstructEnergy'] = function(name, width, height)
	local eb = CreateFrame('StatusBar', name, UIParent)
	eb:SetPoint('TOP', RessourceMover, 'BOTTOM', 0, 5)
	eb:Size(D['Scale'](width), D['Scale'](height))
	eb:SetStatusBarTexture(texture)
	eb:SetStatusBarColor(Color.r, Color.g, Color.b)
	eb:SetMinMaxValues(0, 100)
	eb:CreateBackdrop()
	eb:SetParent(DuffedUIPetBattleHider)

	eb.text = eb:CreateFontString(nil, 'ARTWORK')
	eb.text:SetFont(C['media']['font'], 16, 'THINOUTLINE')
	eb.text:SetPoint('LEFT', eb, 'RIGHT', 4, 1)
	eb.text:SetTextColor(Color.r, Color.g, Color.b)
	
	eb.perctext = eb:CreateFontString(nil, 'ARTWORK')
	eb.perctext:SetFont(C['media']['font'], 16, 'THINOUTLINE')
	eb.perctext:SetPoint('RIGHT', eb, 'LEFT', -4, 1)
	eb.perctext:SetTextColor(Color.r, Color.g, Color.b)

	eb.TimeSinceLastUpdate = 0
	eb:SetScript('OnUpdate', function(self, elapsed)
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed 

		if self.TimeSinceLastUpdate > 0.07 then
			self:SetMinMaxValues(0, UnitPowerMax('player'))
			local power = UnitPower("player") or 0
			local maxPower = UnitPowerMax("player") or 0
			local perc = maxpower and maxpower > 0 and (math.floor(power/maxPower * 100)) or 0
			self:SetValue(power)
			if self.text then self.text:SetText(D['ShortValue'](power)) end
			if self.perctext and maxPower >= 0 then
				self.perctext:SetText(perc.."%")
			else
				self.perctext:SetFormattedText('%d%%', 0)
			end
			self.TimeSinceLastUpdate = 0
		end
	end)
	if C['unitframes']['oocHide'] then D['oocHide'](eb) end
end