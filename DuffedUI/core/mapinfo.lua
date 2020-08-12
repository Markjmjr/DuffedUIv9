local D, C, L = unpack(select(2, ...)) 

local _G = _G
local select = select
local pairs = pairs

local Enum = _G.Enum
local IsFalling = _G.IsFalling
local CreateFrame = _G.CreateFrame
local UnitPosition = _G.UnitPosition
local GetUnitSpeed = _G.GetUnitSpeed
local CreateVector2D = _G.CreateVector2D
local GetRealZoneText = _G.GetRealZoneText
local GetMinimapZoneText = _G.GetMinimapZoneText
local C_Map_GetMapInfo = _G.C_Map.GetMapInfo
local C_Map_GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local C_Map_GetWorldPosFromMapPos = _G.C_Map.GetWorldPosFromMapPos
local MapUtil = _G.MapUtil

D['MapInfo'] = {}

function D:MapInfo_Update()
	local mapID = C_Map_GetBestMapForUnit('player')

	local mapInfo = mapID and C_Map_GetMapInfo(mapID)
	D['MapInfo']['name'] = (mapInfo and mapInfo.name) or nil
	D['MapInfo']['mapType'] = (mapInfo and mapInfo.mapType) or nil
	D['MapInfo']['parentMapID'] = (mapInfo and mapInfo.parentMapID) or nil

	D['MapInfo']['mapID'] = mapID or nil
	D['MapInfo']['zoneText'] = (mapID and D:GetZoneText(mapID)) or nil
	D['MapInfo']['subZoneText'] = GetMinimapZoneText() or nil
	D['MapInfo']['realZoneText'] = GetRealZoneText() or nil

	local continent = mapID and MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true)
	D['MapInfo']['continentParentMapID'] = (continent and continent.parentMapID) or nil
	D['MapInfo']['continentMapType'] = (continent and continent.mapType) or nil
	D['MapInfo']['continentMapID'] = (continent and continent.mapID) or nil
	D['MapInfo']['continentName'] = (continent and continent.name) or nil

	D:MapInfo_CoordsUpdate()
end

local coordsWatcher = CreateFrame('Frame')
function D:MapInfo_CoordsStart()
	D['MapInfo']['coordsWatching'] = true
	D['MapInfo']['coordsFalling'] = nil
	coordsWatcher:SetScript('OnUpdate', D['MapInfo_OnUpdate'])

	if D['MapInfo']['coordsStopTimer'] then
		D:CancelTimer(D['MapInfo']['coordsStopTimer'])
		D['MapInfo']['coordsStopTimer'] = nil
	end
end

function D:MapInfo_CoordsStopWatching()
	D['MapInfo']['coordsWatching'] = nil
	D['MapInfo']['coordsStopTimer'] = nil
	coordsWatcher:SetScript('OnUpdate', nil)
end

function D:MapInfo_CoordsStop(event)
	if event == 'CRITERIA_UPDATE' then
		if not D['MapInfo']['coordsFalling'] then return end -- stop if we weren't falling
		if (GetUnitSpeed('player') or 0) > 0 then return end-- we are still moving!
		D['MapInfo']['coordsFalling'] = nil -- we were falling!
	elseif (event == 'PLAYER_STOPPED_MOVING' or event == 'PLAYER_CONTROL_GAINED') and IsFalling() then
		D['MapInfo']['coordsFalling'] = true
		return
	end

	if not D['MapInfo']['coordsStopTimer'] then D['MapInfo']['coordsStopTimer'] = D:ScheduleTimer('MapInfo_CoordsStopWatching', 0.5) end
end

function D:MapInfo_CoordsUpdate()
	if D['MapInfo']['mapID'] then
		D['MapInfo']['x'], D['MapInfo']['y'] = D:GetPlayerMapPos(D['MapInfo']['mapID'])
	else
		D['MapInfo']['x'], D['MapInfo']['y'] = nil, nil
	end

	if D['MapInfo']['x'] and D['MapInfo']['y'] then
		D['MapInfo']['xText'] = D['Round'](100 * D['MapInfo']['x'], 2)
		D['MapInfo']['yText'] = D['Round'](100 * D['MapInfo']['y'], 2)
	else
		D['MapInfo']['xText'], D['MapInfo']['yText'] = nil, nil
	end
end

function D:MapInfo_OnUpdate(elapsed)
	self.lastUpdate = (self.lastUpdate or 0) + elapsed
	if self.lastUpdate > 0.1 then
		D:MapInfo_CoordsUpdate()
		self.lastUpdate = 0
	end
end

-- This code fixes C_Map.GetPlayerMapPosition memory leak.
-- Fix stolen from NDui (and modified by Simpy). Credit: siweia.
local mapRects, tempVec2D = {}, CreateVector2D(0, 0)
function D:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition('player')
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {
			select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0))), 
			select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		}
		mapRect[2]:Subtract(mapRect[1])
		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return (tempVec2D.y / mapRect[2].y), (tempVec2D.x / mapRect[2].x)
end

-- Code taken from LibTourist-3.0 and rewritten to fit our purpose
local localizedMapNames = {}
local ZoneIDToContinentName = {
	[104] = 'Outland',
	[107] = 'Outland',
}

local MapIdLookupTable = {
	[101] = 'Outland',
	[104] = 'Shadowmoon Valley',
	[107] = 'Nagrand',
}

local function LocalizeZoneNames()
	local mapInfo
	for mapID, englishName in pairs(MapIdLookupTable) do
		mapInfo = C_Map_GetMapInfo(mapID)
		-- Add combination of English and localized name to lookup table
		if mapInfo and mapInfo.name and not localizedMapNames[englishName] then localizedMapNames[englishName] = mapInfo.name end
	end
end
LocalizeZoneNames()

-- Add ' (Outland)' to the end of zone name for Nagrand and Shadowmoon Valley, if mapID matches Outland continent.
-- We can then use this function when we need to compare the players own zone against return values from stuff like GetFriendInfo and GetGuildRosterInfo,
-- which adds the ' (Outland)' part unlike the GetRealZoneText() API.
function D:GetZoneText(mapID)
	if not (mapID and D['MapInfo']['name']) then return end

	local continent, zoneName = ZoneIDToContinentName[mapID]
	if continent and continent == 'Outland' then
		if D['MapInfo']['name'] == localizedMapNames.Nagrand or D['MapInfo']['name'] == 'Nagrand'  then
			zoneName = localizedMapNames.Nagrand..' ('..localizedMapNames.Outland..')'
		elseif D['MapInfo']['name'] == localizedMapNames['Shadowmoon Valley'] or D['MapInfo']['name'] == 'Shadowmoon Valley'  then
			zoneName = localizedMapNames['Shadowmoon Valley']..' ('..localizedMapNames.Outland..')'
		end
	end

	return zoneName or D['MapInfo']['name']
end

D:RegisterEvent('CRITERIA_UPDATE', 'MapInfo_CoordsStop') -- when the player goes into an animation (landing)
D:RegisterEvent('PLAYER_STARTED_MOVING', 'MapInfo_CoordsStart')
D:RegisterEvent('PLAYER_STOPPED_MOVING', 'MapInfo_CoordsStop')
D:RegisterEvent('PLAYER_CONTROL_LOST', 'MapInfo_CoordsStart')
D:RegisterEvent('PLAYER_CONTROL_GAINED', 'MapInfo_CoordsStop')
D:RegisterEvent('LOADING_SCREEN_DISABLED', 'MapInfo_Update')
D:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'MapInfo_Update')
D:RegisterEvent('ZONE_CHANGED_INDOORS', 'MapInfo_Update')
D:RegisterEvent('ZONE_CHANGED', 'MapInfo_Update')