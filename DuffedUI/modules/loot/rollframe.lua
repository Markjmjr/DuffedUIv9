local D, C, L = unpack(select(2, ...)) 
if not C['loot']['rolllootframe'] then return end

local pos = 'TOP'
local frames = {}
local cancelled_rolls = {}
local rolltypes = {'need', 'greed', 'disenchant', [0] = 'pass'}
local move = D['move']

local anchor = CreateFrame('Button', 'DuffedUIRollMover', UIParent)
anchor:Size(300, 22) 
move:RegisterFrame(anchor)

local function ClickRoll(frame) RollOnLoot(frame.parent.rollID, frame.rolltype) end

local function HideTip() GameTooltip:Hide() end
local function HideTip2() GameTooltip:Hide() ResetCursor() end

local function SetTip(frame)
	GameTooltip:SetOwner(frame, 'ANCHOR_TOPLEFT')
	GameTooltip:SetText(frame.tiptext)
	if not frame:IsEnabled() then GameTooltip:AddLine(frame.errtext, 1, .2, .2, 1) end
	for name, roll in pairs(frame.parent.rolls) do if roll == rolltypes[frame.rolltype] then GameTooltip:AddLine(name, 1, 1, 1) end end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	GameTooltip:SetOwner(frame, 'ANCHOR_TOPLEFT')
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick('DRESSUP') then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(frame)
	if GameTooltip:IsOwned(frame) then
		if IsShiftKeyDown() then
			GameTooltip_ShowCompareItem()
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
		end

		if IsControlKeyDown() then ShowInspectCursor() else ResetCursor() end
	end
end

local function LootClick(frame)
	if IsControlKeyDown() then
		DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then
		local _, item = GetItemInfo(frame.link)
		if ChatEdit_GetActiveWindow() then ChatEdit_InsertLink(item) else ChatFrame_OpenChat(item) end
	end
end

local function OnEvent(frame, event, rollID)
	cancelled_rolls[rollID] = true
	if frame.rollID ~= rollID then return end

	frame.rollID = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	if not frame.parent.rollID then return end
	local t = GetLootRollTimeLeft(frame.parent.rollID)
	local perc = t / frame.parent.time
	frame.spark:Point('CENTER', frame, 'LEFT', perc * frame:GetWidth(), 0)
	frame:SetValue(t)
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame('Button', nil, parent)
	f:SetPoint(...)
	f:SetSize(28, 28)
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript('OnEnter', SetTip)
	f:SetScript('OnLeave', HideTip)
	f:SetScript('OnClick', ClickRoll)
	f:SetMotionScriptsWhileDisabled(true)
	local txt = f:CreateFontString(nil, nil)
	txt:SetFont(C['media']['font'], 14, 'OUTLINE')
	txt:SetPoint('CENTER', 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
	return f, txt
end

local function CreateRollFrame()
	local frame = CreateFrame('Frame', nil, UIParent)
	frame:CreateBackdrop('Default')
	frame:SetSize(280, 22)
	frame:SetFrameStrata('MEDIUM')
	frame:SetFrameLevel(10)
	frame:SetScript('OnEvent', OnEvent)
	frame:RegisterEvent('CANCEL_LOOT_ROLL')
	frame:Hide()

	local button = CreateFrame('Button', nil, frame)
	button:SetPoint('LEFT', -29, 0)
	button:SetSize(22, 22)
	button:CreateBackdrop('Default')
	button:SetScript('OnEnter', SetItemTip)
	button:SetScript('OnLeave', HideTip2)
	button:SetScript('OnUpdate', ItemOnUpdate)
	button:SetScript('OnClick', LootClick)
	frame.button = button

	button.icon = button:CreateTexture(nil, 'OVERLAY')
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(.1, .9, .1, .9)

	local status = CreateFrame('StatusBar', nil, frame)
	status:SetSize(326, 20)
	status:SetPoint('TOPLEFT', 0, 0)
	status:SetPoint('BOTTOMRIGHT', 0, 0)
	status:SetScript('OnUpdate', StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel() - 1)
	status:SetStatusBarTexture(C['media']['normTex'])
	status:SetStatusBarColor(.8, .8, .8, .9)
	status.parent = frame
	frame.status = status

	status.bg = status:CreateTexture(nil, 'BACKGROUND')
	status.bg:SetAlpha(.1)
	status.bg:SetAllPoints()
	status.bg:SetDrawLayer('BACKGROUND', 2)

	local spark = frame:CreateTexture(nil, 'OVERLAY')
	spark:Width(14)
	spark:Height(50)
	spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
	spark:SetBlendMode('ADD')
	status.spark = spark

	local need, needtext = CreateRollButton(frame, 'Interface\\Buttons\\UI-GroupLoot-Dice-Up', 'Interface\\Buttons\\UI-GroupLoot-Dice-Highlight', 'Interface\\Buttons\\UI-GroupLoot-Dice-Down', 1, NEED, 'LEFT', frame.button, 'RIGHT', 5, -1)
	local greed, greedtext = CreateRollButton(frame, 'Interface\\Buttons\\UI-GroupLoot-Coin-Up', 'Interface\\Buttons\\UI-GroupLoot-Coin-Highlight', 'Interface\\Buttons\\UI-GroupLoot-Coin-Down', 2, GREED, 'LEFT', need, 'RIGHT', 0, -1)
	local de, detext = CreateRollButton(frame, 'Interface\\Buttons\\UI-GroupLoot-DE-Up', 'Interface\\Buttons\\UI-GroupLoot-DE-Highlight', 'Interface\\Buttons\\UI-GroupLoot-DE-Down', 3, ROLL_DISENCHANT, 'LEFT', greed, 'RIGHT', 0, -1)
	local pass, passtext = CreateRollButton(frame, 'Interface\\Buttons\\UI-GroupLoot-Pass-Up', nil, 'Interface\\Buttons\\UI-GroupLoot-Pass-Down', 0, PASS, 'LEFT', de or greed, 'RIGHT', 0, 2.2)
	frame.needbutt, frame.greedbutt, frame.disenchantbutt = need, greed, de
	frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, detext

	local bind = frame:CreateFontString()
	bind:SetPoint('LEFT', pass, 'RIGHT', 3, 1)
	bind:SetFont(C['media']['font'], 11, 'OUTLINE')
	frame.fsbind = bind

	local loot = frame:CreateFontString(nil, 'ARTWORK')
	loot:SetFont(C['media']['font'], 11, 'OUTLINE')
	loot:SetPoint('LEFT', bind, 'RIGHT', 0, 0)
	loot:SetPoint('RIGHT', frame, 'RIGHT', -5, 0)
	loot:SetSize(200, 10)
	loot:SetJustifyH('LEFT')
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local function GetFrame()
	for i, f in ipairs(frames) do if not f.rollID then return f end end

	local f = CreateRollFrame()
	if pos == 'TOP' then 
		f:SetPoint('TOPRIGHT', next(frames) and frames[#frames] or anchor, 'BOTTOMRIGHT', next(frames) and 0 or -2, next(frames) and -7 or -5)
	else
		f:SetPoint('BOTTOMRIGHT', next(frames) and frames[#frames] or anchor, 'TOPRIGHT', next(frames) and 0 or -2, next(frames) and 7 or 5)
	end
	table.insert(frames, f)
	return f
end

local function FindFrame(rollID)
	for _, f in ipairs(frames) do 
		if f.rollID == rollID then return f end
	end
end

local typemap = {[0] = 'pass', 'need', 'greed', 'disenchant'}
local function UpdateRoll(i, rolltype)
	local num = 0
	local rollID, itemLink, numPlayers, isDone = C_LootHistory.GetItem(i)

	if isDone or not numPlayers then return end

	local f = FindFrame(rollID)
	if not f then return end

	for j = 1, numPlayers do
		local name, class, thisrolltype = C_LootHistory.GetPlayerInfo(i, j)
		f.rolls[name] = typemap[thisrolltype]
		if rolltype == thisrolltype then num = num + 1 end
	end

	f[typemap[rolltype]]:SetText(num)
end

local function START_LOOT_ROLL(rollID, time)
	if cancelled_rolls[rollID] then return end

	local f = GetFrame()
	f.rollID = rollID
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)
	f.disenchant:SetText(0)

	local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(rollID)
	f.button.icon:SetTexture(texture)
	f.button.link = GetLootRollItemLink(rollID)

	if canNeed then
		f.needbutt:Enable()
		f.needbutt:SetAlpha(1)
		SetDesaturation(f.needbutt:GetNormalTexture(), false)
	else
		f.needbutt:Disable()
		f.needbutt:SetAlpha(.2)
		SetDesaturation(f.needbutt:GetNormalTexture(), true)
		f.needbutt.errtext = _G['LOOT_ROLL_INELIGIBLE_REASON'..reasonNeed]
	end

	if canGreed then
		f.greedbutt:Enable()
		f.greedbutt:SetAlpha(1)
		SetDesaturation(f.greedbutt:GetNormalTexture(), false)
	else
		f.greedbutt:Disable()
		f.greedbutt:SetAlpha(.2)
		SetDesaturation(f.greedbutt:GetNormalTexture(), true)
		f.greedbutt.errtext = _G['LOOT_ROLL_INELIGIBLE_REASON'..reasonGreed]
	end

	if canDisenchant then
		f.disenchantbutt:Enable()
		f.disenchantbutt:SetAlpha(1)
		SetDesaturation(f.disenchantbutt:GetNormalTexture(), false)
	else
		f.disenchantbutt:Disable()
		f.disenchantbutt:SetAlpha(.2)
		SetDesaturation(f.disenchantbutt:GetNormalTexture(), true)
		f.disenchantbutt.errtext = format(_G['LOOT_ROLL_INELIGIBLE_REASON'..reasonDisenchant], deSkillRequired)
	end

	f.fsbind:SetText(bop and 'BoP' or 'BoE')
	f.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetText(name)
	f.fsloot:SetVertexColor(color.r, color.g, color.b)

	f.status:SetStatusBarColor(color.r, color.g, color.b, .7)
	f.status.bg:SetColorTexture(color.r, color.g, color.b)

	f.backdrop:SetBackdropBorderColor(color.r, color.g, color.b, .7)
	f.button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b, .7)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:SetPoint('CENTER', WorldFrame, 'CENTER')
	f:Show()
end

local function LOOT_HISTORY_ROLL_CHANGED(rollindex, playerindex)
	local _, _, rolltype = C_LootHistory.GetPlayerInfo(rollindex, playerindex)
	UpdateRoll(rollindex, rolltype)
end

anchor:RegisterEvent('ADDON_LOADED')
anchor:SetScript('OnEvent', function(frame, event, addon)
	if addon ~= 'DuffedUI' then return end

	anchor:UnregisterEvent('ADDON_LOADED')
	anchor:RegisterEvent('START_LOOT_ROLL')
	anchor:RegisterEvent('LOOT_HISTORY_ROLL_CHANGED')

	UIParent:UnregisterEvent('START_LOOT_ROLL')
	UIParent:UnregisterEvent('CANCEL_LOOT_ROLL')

	anchor:SetScript('OnEvent', function(frame, event, ...)
		if event == 'LOOT_HISTORY_ROLL_CHANGED' then return LOOT_HISTORY_ROLL_CHANGED(...) else return START_LOOT_ROLL(...) end
	end)

	anchor:SetPoint('LEFT', UIParent, 'LEFT', 250, 0)
end)