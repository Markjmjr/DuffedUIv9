local D, C, L = unpack(select(2, ...))

local DataText = D['DataTexts']
local NameColor = DataText.NameColor
local ValueColor = DataText.ValueColor

local classcolor = ('|cff%.2x%.2x%.2x'):format(D['Color'].r * 255, D['Color'].g * 255, D['Color'].b * 255)

local UNKNOWN = UNKNOWN
local QUICK_JOIN = QUICK_JOIN

local next, pairs, select, type = next, pairs, select, type
local twipe = table.wipe
local format, join = string.format, string.join

local C_LFGList = C_LFGList
local C_SocialQueue = C_SocialQueue
local SocialQueueUtil_GetNameAndColor = SocialQueueUtil_GetNameAndColor
local SocialQueueUtil_GetQueueName = SocialQueueUtil_GetQueueName
local SocialQueueUtil_SortGroupMembers = SocialQueueUtil_SortGroupMembers
local ToggleQuickJoinPanel = ToggleQuickJoinPanel

local displayModifierString = ''
local quickJoinGroups, quickJoin = nil, {}

function SocialQueueIsLeader(playerName, leaderName)
	if leaderName == playerName then
		return true
	end

	local numGameAccounts, accountName, isOnline, gameCharacterName, gameClient, realmName, _
	for i = 1, BNGetNumFriends() do
		_, accountName, _, _, _, _, _, isOnline = BNGetFriendInfo(i);
		if isOnline then
			numGameAccounts = BNGetNumFriendGameAccounts(i);
			if numGameAccounts > 0 then
				for y = 1, numGameAccounts do
					_, gameCharacterName, gameClient, realmName = BNGetFriendGameAccountInfo(i, y);
					if (gameClient == BNET_CLIENT_WOW) and (accountName == playerName) then
						playerName = gameCharacterName
						if realmName ~= D['MyRealm'] then
							playerName = format('%s-%s', playerName, gsub(realmName,'[%s%-]',''))
						end
						if leaderName == playerName then
							return true
						end
					end
				end
			end
		end
	end
end

local MODULE
local function Update(self, event)
	twipe(quickJoin)
	quickJoinGroups = C_SocialQueue.GetAllGroups()

	local coloredName, players, members, playerName, nameColor, firstMember, numMembers, extraCount, isLFGList, firstQueue, queues, numQueues, activityID, activityName, comment, leaderName, isLeader, activityFullName, activity, output, outputCount, queueCount, queueName, _

	for _, guid in pairs(quickJoinGroups) do
		coloredName, players = UNKNOWN, C_SocialQueue.GetGroupMembers(guid)
		members = players and SocialQueueUtil_SortGroupMembers(players)
		playerName, nameColor = '', ''
		if members then
			firstMember, numMembers, extraCount = members[1], #members, ''
			playerName, nameColor = SocialQueueUtil_GetNameAndColor(firstMember)
			if numMembers > 1 then
				extraCount = format('[+%s]', numMembers - 1)
			end
			if playerName then
				coloredName = format('%s%s|r%s', nameColor, playerName, extraCount)
			else
				coloredName = format('{%s%s}', UNKNOWN, extraCount)
			end
		end

		queues = C_SocialQueue.GetGroupQueues(guid)
		firstQueue, numQueues = queues and queues[1], queues and #queues or 0
		isLFGList = firstQueue and firstQueue.queueData and firstQueue.queueData.queueType == 'lfglist'

		if isLFGList and firstQueue and firstQueue.eligible then

			if firstQueue.queueData.lfgListID then
				_, activityID, activityName, comment, _, _, _, _, _, _, _, _, leaderName = C_LFGList.GetSearchResultInfo(firstQueue.queueData.lfgListID)
				isLeader = SocialQueueIsLeader(playerName, leaderName)
			end

			if isLeader then
				coloredName = format('|TInterface\\GroupFrame\\UI-Group-LeaderIcon:16:16|t%s', coloredName)
			end

			activity = activityName or UNKNOWN
			if numQueues > 1 then
				activity = format('[+%s]%s', numQueues - 1, activity)
			end
		elseif firstQueue then
			output, outputCount, queueCount = '', '', 0
			for _, queue in pairs(queues) do
				if type(queue) == 'table' and queue.eligible then
					queueName = (queue.queueData and SocialQueueUtil_GetQueueName(queue.queueData)) or ''
					if queueName ~= '' then
						if output == '' then
							output = queueName:gsub('\n.+','')
							queueCount = queueCount + select(2, queueName:gsub('\n',''))
						else
							queueCount = queueCount + 1 + select(2, queueName:gsub('\n',''))
						end
					end
				end
			end
			if output ~= '' then
				if queueCount > 0 then
					activity = format('%s[+%s]', output, queueCount)
				else
					activity = output
				end
			end
		end

		quickJoin[coloredName] = activity
	end
	if next(quickJoin) then
		self.Text:SetText(NameColor ..QUICK_JOIN, #quickJoinGroups)
	else
		self.Text:SetText(ValueColor .. QUICK_JOIN)
	end
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnEnter = function(self)
	if not C['datatext']['ShowInCombat'] then
		if InCombatLockdown() then return end
	end
	
	GameTooltip:SetOwner(self:GetTooltipAnchor())
	GameTooltip:ClearLines()

	if not next(quickJoin) then
		GameTooltip:AddLine(L['dt']['noquickjoin'], 1, 1, 1, 1)
		GameTooltip:Show() return
	end

	GameTooltip:AddLine(QUICK_JOIN, nil, nil, nil, true);
	GameTooltip:AddLine(' ');
	for name, activity in pairs(quickJoin) do
		GameTooltip:AddDoubleLine(name, activity, nil, nil, nil, 1, 1, 1);
	end
	GameTooltip:Show()
end

local OnMouseDown = function(self)
	ToggleQuickJoinPanel()
end

local function Enable(self)
	self:RegisterEvent('SOCIAL_QUEUE_UPDATE')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:SetScript('OnEvent', Update)
	self:SetScript('OnMouseDown', OnMouseDown)
	self:SetScript('OnEnter', OnEnter)
	self:SetScript('OnLeave', OnLeave)
	self:Update()
end

local function Disable(self)
	self.Text:SetText('')
	self:UnregisterAllEvents()
	self:SetScript('OnMouseDown', nil)
	self:SetScript('OnEnter', nil)
	self:SetScript('OnLeave', nil)
	self:SetScript('OnEvent', nil)
end

DataText:Register('QuickJoin', Enable, Disable, Update)