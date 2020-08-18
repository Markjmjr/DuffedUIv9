local D, C, L = unpack(select(2, ...))

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'DuffedUI was unable to locate oUF install.')

ns._Objects = {}
ns._Headers = {}

local class = select(2, UnitClass('player'))
local texture = C['media']['normTex']
local f, fs, ff = C['media']['font'], 8, 'THINOUTLINE'
local nWidth, nHeight = C['nameplate']['platewidth'], C['nameplate']['plateheight']
local pScale = C['nameplate']['platescale']
local pDebuffs = C['nameplate']['pDebuffs']

-- Set color for threat
local function ColorHealthbarOnThreat(self,unit)
	if self.colorThreat and self.colorThreatInvers and unit and UnitThreatSituation('player', unit) == 3 then
		self:SetStatusBarColor(0, 1, 0, .3)
		self.bg:SetVertexColor(0, 1 * .2, 0)
	elseif self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
		self:SetStatusBarColor(1, 0, 0, .3)
		self.bg:SetVertexColor(1 * .2, 0, 0)
	end
end

-- PostUpdateHealth
local function PostUpdateHealth(self, unit, min, max) ColorHealthbarOnThreat(self,unit) end

local function SetCastBarColorShielded(self) self.__owner:SetStatusBarColor(1, 0, 0, .3) end

local function SetCastBarColorDefault(self) self.__owner:SetStatusBarColor(unpack(C['castbar']['color'])) end

-- UpdateThreat
local function UpdateThreat(self,event,unit)
	if event == 'PLAYER_ENTER_COMBAT' or event == 'PLAYER_LEAVE_COMBAT' then
		--do natting
	elseif self.unit ~= unit then
		return
	end
	self.Health:ForceUpdate()
end

local function HighlightPlate(self)
	local Border = self.HealthBorder

	if Border then
		if UnitIsUnit('target', self.unit) then
			if not Border:IsShown() then Border:Show() end

			Border:SetBackdropBorderColor(.31, .45, .63)
		else
			if C['nameplate']['hidetargetglow'] then
				Border:Hide()
			else
				Border:SetBackdropBorderColor(.125, .125, .125, 1)
			end
		end
	end
end

D['ConstructNameplates'] = function(self)
	-- Initial Elements
	self.colors = D['UnitColor']

	-- health
	local health = CreateFrame('StatusBar', nil, self)
	health:SetAllPoints()
	health:SetStatusBarTexture(texture)
	health.colorTapping = true
	health.colorReaction = true
	health.frequentUpdates = true
	health.Smooth = true
	if C['nameplate']['classcolor'] then health.colorClass = true else health.colorClass = false end
	if C['nameplate']['threat'] then
		health.colorThreat = true
		health.colorThreatInvers = true
	else
		health.colorThreat = false
		health.colorThreatInvers = false
	end
	health.PostUpdate = PostUpdateHealth

	-- threat
	if health.colorThreat and health.colorThreatInvers then
		table.insert(self.__elements, D['UpdateThreat'])
		self:RegisterEvent('PLAYER_ENTER_COMBAT', UpdateThreat)
		self:RegisterEvent('PLAYER_LEAVE_COMBAT', UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
	end

	-- health border
	local HealthBorder = CreateFrame('Frame', nil, health, 'BackdropTemplate')
	HealthBorder:Point('TOPLEFT', health, 'TOPLEFT', -1, 1)
	HealthBorder:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', 1, -1)
	HealthBorder:SetTemplate('Transparent')
	HealthBorder:SetFrameLevel(2)
	self.HealthBorder = HealthBorder

	-- background
	bg = health:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints()
	bg:SetColorTexture(.2, .2, .2)

	-- name
	name = health:CreateFontString(nil, 'OVERLAY')
	name:Point('LEFT', health, 'LEFT', 0, 10)
	name:SetJustifyH('LEFT')
	name:SetFont(f, fs, ff)
	name:SetShadowOffset(1.25, -1.25)
	self:Tag(name, '[difficulty][level][shortclassification] [DuffedUI:getnamecolor][DuffedUI:namelong]')

	-- perc on health
	if C['nameplate']['showperc'] then
		perc = health:CreateFontString(nil, 'OVERLAY')
		perc:Point('CENTER', health, 0, 0)
		perc:SetJustifyH('LEFT')
		perc:SetFont(f, fs, ff)
		perc:SetShadowOffset(1.25, -1.25)
		self:Tag(perc, '[DuffedUI:perchpnp]')
	end

	-- debuffs
	local debuffs = CreateFrame('Frame', 'NameplateDebuffs', self)
	debuffs:SetPoint('BOTTOMLEFT', health, 'TOPLEFT', 0, 18)
	debuffs:SetSize(nWidth, 15)
	debuffs.size = 18
	debuffs.num = 5
	debuffs.disableCooldown = true
	debuffs.onlyShowPlayer = pDebuffs
	debuffs.filter = 'HARMFUL|INCLUDE_NAME_PLATE_ONLY'
	debuffs.spacing = 4
	debuffs.initialAnchor = 'TOPLEFT'
	debuffs['growth-y'] = 'UP'
	debuffs['growth-x'] = 'RIGHT'
	debuffs.PostCreateIcon = D['PostCreateAura']
	debuffs.PostUpdateIcon = D['PostUpdateAura']

	-- castbar
	local castbar = CreateFrame('StatusBar', self:GetName() .. 'CastBar', self)
	castbar:SetStatusBarTexture(texture)
	castbar:Width(nWidth - 2)
	castbar:Height(5)
	castbar:Point('TOP', health, 'BOTTOM', 0, -4)

	castbar.CustomTimeText = D['CustomTimeText']
	castbar.CustomDelayText = CustomDelayText
	castbar.PostCastStart = D['CastBar']
	castbar.PostChannelStart = D['CastBar']

	castbar.time = castbar:CreateFontString(nil, 'OVERLAY')
	castbar.time:SetFont(f, 6, ff)
	castbar.time:Point('RIGHT', castbar, 'RIGHT', -5, 0)
	castbar.time:SetTextColor(.84, .75, .65)
	castbar.time:SetJustifyH('RIGHT')

	castbar.Text = castbar:CreateFontString(nil, 'OVERLAY')
	castbar.Text:SetFont(f, 6, ff)
	castbar.Text:Point('LEFT', castbar, 'LEFT', 6, 0)
	castbar.Text:SetTextColor(.84, .75, .65)
	castbar:CreateBackdrop()
	
	local shield = castbar:CreateTexture(nil, 'BACKGROUND', nil, -8)
	shield.__owner = castbar
	castbar.Shield = shield
	hooksecurefunc(shield, 'Show', SetCastBarColorShielded)
	hooksecurefunc(shield, 'Hide', SetCastBarColorDefault)

	castbar.button = CreateFrame('Frame', nil, castbar, 'BackdropTemplate')
	castbar.button:SetTemplate('Default')

	castbar.button:Size(nHeight + 12)
	castbar.button:Point('BOTTOMLEFT', castbar, 'BOTTOMRIGHT', 3, -2)
	castbar.icon = castbar.button:CreateTexture(nil, 'ARTWORK')
	castbar.icon:Point('TOPLEFT', castbar.button, 2, -2)
	castbar.icon:Point('BOTTOMRIGHT', castbar.button, -2, 2)
	castbar.icon:SetTexCoord(unpack(D['IconCoord']))

	local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetTexture(C['media']['RaidIcons'])
	RaidIcon:Size(20, 20)
	RaidIcon:Point('LEFT', health, 'LEFT', -25, 0)

	-- NazjatarFollowerXP
	local bar = CreateFrame('StatusBar', self:GetDebugName() .. 'NazjatarFollowerXP', self, 'BackdropTemplate')
	bar:SetFrameStrata(self:GetFrameStrata())
	bar:SetFrameLevel(5)
	bar:SetHeight(9)
	bar:SetPoint('TOPLEFT', health, 'BOTTOMLEFT', 0, -3)
	bar:SetPoint('TOPRIGHT', health, 'BOTTOMRIGHT', 0, -3)
	bar:SetStatusBarTexture(texture)
	bar:SetStatusBarColor(0.529, 0.808, 0.922)
	bar:SetTemplate('Transparent')
	
	bar.spark = bar:CreateTexture(nil, 'OVERLAY')
	bar.spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
	bar.spark:SetHeight(9)
	bar.spark:SetBlendMode('ADD')
	bar.spark:SetAlpha(0.4)
	bar.spark:SetPoint('CENTER', bar:GetStatusBarTexture(), 'RIGHT', 0, 0)

	bar.progressText = bar:CreateFontString(nil, 'OVERLAY')
	bar.progressText:SetPoint('CENTER', bar, 'CENTER', 0, 0)
	bar.progressText:SetFont(f, fs, ff)
	bar.progressText:SetTextColor(0.84, 0.75, 0.65)
	bar.progressText:SetShadowOffset(1.25, -1.25)

	self.NazjatarFollowerXP = bar

	-- Eliteicon
	if C['nameplate']['eliteicon'] then
		local ClassificationIndicator = health:CreateTexture(nil, 'OVERLAY')
		ClassificationIndicator:ClearAllPoints()
		ClassificationIndicator:SetSize(health:GetHeight() + 12, health:GetHeight() + 12)
		ClassificationIndicator:SetPoint('LEFT', health, 'RIGHT', 4, -2)
		
		self.ClassificationIndicator = ClassificationIndicator
	end

	-- QuestIcons
	if C['nameplate']['questicons'] then
		if unit == 'player' then return end

		local size = 11

		QuestIcons = CreateFrame('Frame', self:GetDebugName() .. 'QuestIcons', self)
		QuestIcons:ClearAllPoints()
		QuestIcons:SetPoint('RIGHT', health, 'LEFT', -4, 0)
		QuestIcons:Hide()
		QuestIcons:SetSize(size + 2, size + 2)

		for _, object in pairs({'Default', 'Item', 'Skull', 'Chat'}) do			
			local icon = QuestIcons:CreateTexture(nil, 'BORDER', nil, 1)
			icon:SetPoint('CENTER')
			icon:SetSize(size, size)
			icon.Text = QuestIcons:CreateFontString(nil, 'OVERLAY')
			icon.Text:SetFont(f, fs, ff)
			icon.Text:SetPoint('BOTTOMLEFT', QuestIcons, 'BOTTOMLEFT', -2, -0.8)
			icon.Text:SetShadowOffset(1.25, -1.25)
			icon:Hide()

			QuestIcons[object] = icon
		end
		
		QuestIcons.Default:SetSize(size + 2, size + 2)
		QuestIcons.Item:SetTexCoord(unpack(D['IconCoord']))
		QuestIcons.Skull:SetSize(size + 2, size + 2)
		QuestIcons.Chat:SetSize(size + 2, size + 2)
		QuestIcons.Chat:SetTexture([[Interface\WorldMap\ChatBubble_64.PNG]])
		QuestIcons.Chat:SetTexCoord(0, 0.5, 0.5, 1)
		QuestIcons.ForceUpdate = ForceUpdate

		self.QuestIcons = QuestIcons
	end

	-- Floating combattext
	if C['nameplate']['floatingct'] then
		local fcf = CreateFrame('Frame', nil, self)
		fcf:SetSize(32, 32)
		fcf:SetPoint('CENTER')
		fcf:SetFrameStrata('TOOLTIP')

		for i = 1, 12 do
			fcf[i] = fcf:CreateFontString('$parentFCFText' .. i, 'OVERLAY')
			fcf[i]:SetShadowOffset(1.25, -1.25)
		end

		fcf.font = C['media']['font']
		fcf.fontHeight = 12
		fcf.fontFlags = 'OUTLINE'
		fcf.useCLEU = true
		fcf.abbreviateNumbers = C['nameplate']['floatingan']
		fcf.scrollTime = C['nameplate']['floatingst']
		fcf.format = '%1$s |T%2$s:0:0:0:0:64:64:4:60:4:60|t'
		self.FloatingCombatFeedback = fcf

		-- Hide blizzard combat text
		SetCVar('floatingCombatTextCombatHealing', 1) -- Dont hide healing?
		SetCVar('floatingCombatTextCombatDamage', 0)
			
		local frame = CreateFrame('Frame')
		frame:RegisterEvent('PLAYER_LOGOUT')
		frame:SetScript('OnEvent', function(self, event)
			if event == 'PLAYER_LOGOUT' then
				SetCVar('floatingCombatTextCombatHealing', 1)
				SetCVar('floatingCombatTextCombatDamage', 1)
			end
		end)
	end
		
	self:RegisterEvent('PLAYER_TARGET_CHANGED', HighlightPlate, true)
	self:RegisterEvent('NAME_PLATE_UNIT_ADDED', HighlightPlate, true)
	self:RegisterEvent('NAME_PLATE_UNIT_REMOVED', HighlightPlate, true)
	
	-- size
	self:SetSize(nWidth, nHeight)
	self:SetPoint('CENTER', 0, 0)
	self:SetScale(pScale * UIParent:GetScale())

	-- Init
	self.Health = health
	self.Health.bg = bg
	self.Name = name
	self.Debuffs = debuffs
	self.Castbar = castbar
	self.Castbar.Time = castbar.time
	self.Castbar.Icon = castbar.icon
	self.RaidTargetIndicator = RaidIcon

	if C['nameplate']['combat'] then
		local combat = CreateFrame('Frame')
		combat:RegisterEvent('PLAYER_REGEN_DISABLED')
		combat:RegisterEvent('PLAYER_REGEN_ENABLED')
		combat:SetScript('OnEvent', function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				SetCVar('nameplateShowEnemies', 1)
			elseif 	event == 'PLAYER_REGEN_ENABLED' then
				SetCVar('nameplateShowEnemies', 0)
			end
		end)
	end
end