
local D, C, L = unpack(select(2, ...))

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'DuffedUI was unable to locate oUF install.')

local function add(i, v)
	local p = {v:GetPoint()}
	local P = v:GetParent()
	DuffedUIData['checkall'][i] = {
		self = tostring(v),
		GetName   = v:GetName() or '<nameless>',
		GetParent = '<' .. tostring(P or 'no parent') .. '>',
		GetParent_Name = (P ~= nil and P['GetName']) and '<' .. tostring(P:GetName() or 'nameless') .. '>' or '<no parent>',
		GetPointParent = p[2] ~= nil and '<'.. tostring(p[2]) ..'>' or '<nil>',
		IsShown   = v['IsShown'] == nil   and '<nil>' or v:IsShown(),
		IsVisible = v['IsVisible'] == nil and '<nil>' or v:IsVisible(),
		GetAlpha  = v['GetAlpha'] == nil  and '<nil>' or v:GetAlpha(),
		GetScale  = v['GetScale'] == nil  and '<nil>' or v:GetScale()
	}
end

local function checkAll()
	if DuffedUIData['checkall'] == nil then
		DuffedUIData['checkall'] = {}
	end
	wipe(DuffedUIData['checkall'])
	add('UIParent', UIParent)
	add('WorldFrame', WorldFrame)
	for i, v in pairs(_G) do
		if v ~= nil then
			local s, t = issecurevariable(_G, i)
			if (type(i) == 'string' and i:match('Duffed')) or (type(t) == 'string' and t:match('Duffed')) then
				if type(v) == 'table' and v['GetObjectType'] then
					add(i, v)
				end
			end
		end
	end
end

local f = CreateFrame('Frame')
f:SetScript('OnEvent',function(self,event)
	C_Timer.After(10, checkAll)
end)
f:RegisterEvent('PLAYER_ENTERING_WORLD')
