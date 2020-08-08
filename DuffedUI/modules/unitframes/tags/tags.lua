local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'DuffedUI was unable to locate oUF install.')

local D, C, L = unpack(select(2, ...))

-- Tags
local function ShortenValue(value)
	if(value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

oUF.Tags.Events['DuffedUI:perchp'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
oUF.Tags.Methods['DuffedUI:perchp'] = function(unit)
	local m = UnitHealthMax(unit)
	if(m == 0) then
		return 0
	else
		return D['PanelColor']..math.floor(UnitHealth(unit) / m * 100 + 0.5)..'%'
	end
end

oUF.Tags.Events['DuffedUI:perchpnp'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
oUF.Tags.Methods['DuffedUI:perchpnp'] = function(unit)
	local m = UnitHealthMax(unit)
	if(m == 0) then
		return 0
	else
		return math.floor(UnitHealth(unit) / m * 100 + 0.5)..'%'
	end
end

oUF.Tags.Events['DuffedUI:threat'] = 'UNIT_THREAT_LIST_UPDATE'
oUF.Tags.Methods['DuffedUI:threat'] = function(unit)
	local tanking, status, percent = UnitDetailedThreatSituation('player', 'target')
	if(percent and percent > 0) then
		return ('%s%d%%|r'):format(Hex(GetThreatStatusColor(status)), percent)
	end
end

oUF.Tags.Methods['DuffedUI:health'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'

	if(status) then
		return status
	elseif(unit == 'target' and UnitCanAttack('player', unit)) then
		return ('%s (%d|cff0090ff%%|r)'):format(ShortenValue(min), min / max * 100)
	elseif(unit == 'player' and min ~= max) then
		return ('|cffff8080%d|r %d|cff0090ff%%|r'):format(min - max, min / max * 100)
	elseif(min ~= max) then
		return ('%s |cff0090ff/|r %s'):format(ShortenValue(min), ShortenValue(max))
	else
		return max
	end
end

oUF.Tags.Methods['DuffedUI:power'] = function(unit)
	local power = UnitPower(unit)
	if(power > 0 and not UnitIsDeadOrGhost(unit)) then
		local _, type = UnitPowerType(unit)
		local colors = _COLORS.power
		return ('%s%d|r'):format(Hex(colors[type] or colors['RUNES']), power)
	end
end

oUF.Tags.Methods['DuffedUI:druid'] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	if(UnitPowerType(unit) ~= 0 and min ~= max) then
		return ('|cff0090ff%d%%|r'):format(min / max * 100)
	end
end

oUF.Tags.Events['DuffedUI:diffcolor'] = 'UNIT_LEVEL'
oUF.Tags.Methods['DuffedUI:diffcolor'] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if (level < 1) then
		r, g, b = 0.69, 0.31, 0.31
	else
		local DiffColor = UnitLevel('target') - UnitLevel('player')
		if (DiffColor >= 5) then
			r, g, b = 0.69, 0.31, 0.31
		elseif (DiffColor >= 3) then
			r, g, b = 0.71, 0.43, 0.27
		elseif (DiffColor >= -2) then
			r, g, b = 0.84, 0.75, 0.65
		elseif (-DiffColor <= UnitQuestTrivialLevelRange('player')) then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

local utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

oUF.Tags.Events['DuffedUI:getnamecolor'] = 'UNIT_POWER_UPDATE'
oUF.Tags.Methods['DuffedUI:getnamecolor'] = function(unit)
	local UnitReaction = UnitReaction(unit, 'player')
	local _, UnitClass = UnitClass(unit)

	if (UnitIsPlayer(unit)) then
		local c = RAID_CLASS_COLORS[UnitClass]

		if not c then return '' end
		return D['RGBToHex'](c['r'], c['g'], c['b'] )
	elseif UnitReaction then
		local c = D['UnitColor']['reaction'][UnitReaction]
		return string.format('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = .84, .75, .65
		return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
	end
end

oUF.Tags.Events['DuffedUI:nameshort'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['DuffedUI:nameshort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 10, true)
end

oUF.Tags.Events['DuffedUI:namemedium'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['DuffedUI:namemedium'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 15, true)
end

oUF.Tags.Events['DuffedUI:namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['DuffedUI:namelong'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 20, true)
end

oUF.Tags.Events['DuffedUI:dead'] = 'UNIT_HEALTH'
oUF.Tags.Methods['DuffedUI:dead'] = function(unit)
	if UnitIsDeadOrGhost(unit) then
		return L['uf']['dead']
	end
end

oUF.Tags.Events['DuffedUI:afk'] = 'PLAYER_FLAGS_CHANGED'
oUF.Tags.Methods['DuffedUI:afk'] = function(unit)
	if UnitIsAFK(unit) then
		return CHAT_FLAG_AFK
	end
end

oUF.Tags.Events["DuffedUI:GroupNumber"] = "GROUP_ROSTER_UPDATE PLAYER_ROLES_ASSIGNED ROLE_CHANGED_INFORM PARTY_LEADER_CHANGED"
oUF.Tags.Methods["DuffedUI:GroupNumber"] = function(unit)
if not UnitInRaid("player") then return end
	for i = 1, GetNumGroupMembers() do
		local name, _, subgroup = GetRaidRosterInfo(i)
			if (name == D['MyName']) then
				return GROUP.." "..subgroup
			end
	end
end