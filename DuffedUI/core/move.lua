local D, C, L = unpack(select(2, ...))

local Move = CreateFrame('Frame')
Move:RegisterEvent('PLAYER_ENTERING_WORLD')
Move:RegisterEvent('PLAYER_REGEN_DISABLED')

Move.Frames = {}
Move.Defaults = {}

function Move:SaveDefaults(frame, a1, p, a2, x, y)
	if not a1 then return end
	if not p then p = UIParent end

	local Data = Move.Defaults
	local Frame = frame:GetName()

	Data[Frame] = {a1, p:GetName(), a2, x, y}
end

function Move:RestoreDefaults(button)
	local FrameName = self.Parent:GetName()
	local Data = Move.Defaults[FrameName]
	local SavedVariables = DuffedUIDataPerChar['Move']

	if (button == 'RightButton') and (Data) then
		local Anchor1, ParentName, Anchor2, X, Y = unpack(Data)
		local Frame = _G[FrameName]
		local Parent = _G[ParentName]

		Frame:ClearAllPoints()
		Frame:SetPoint(Anchor1, Parent, Anchor2, X, Y)

		Frame.DragInfo:ClearAllPoints()
		Frame.DragInfo:SetAllPoints(Frame)

		SavedVariables[FrameName] = nil
	end
end

function Move:RegisterFrame(frame)
	local Anchor1, Parent, Anchor2, X, Y = frame:GetPoint()

	tinsert(self.Frames, frame)
	self:SaveDefaults(frame, Anchor1, Parent, Anchor2, X, Y)
end

function Move:OnDragStart() self:StartMoving() end

function Move:OnDragStop()
	self:StopMovingOrSizing()

	local Data = DuffedUIDataPerChar.Move
	local Anchor1, Parent, Anchor2, X, Y = self:GetPoint()
	local FrameName = self.Parent:GetName()
	local Frame = self.Parent

	Frame:ClearAllPoints()
	if not Parent then Parent = UIParent end	
	Frame:SetPoint(Anchor1, Parent, Anchor2, X, Y)

	Data[FrameName] = {Anchor1, Parent:GetName(), Anchor2, X, Y}
end

function Move:CreateDragInfo()
	self.DragInfo = CreateFrame('Button', nil, self)
	self.DragInfo:SetAllPoints(self)
	self.DragInfo:SetTemplate('Transparent')
	self.DragInfo:SetBackdropBorderColor(1, 0, 0)
	self.DragInfo:FontString('Text', C['media']['font'], 11)
	self.DragInfo.Text:SetText(self:GetName())
	self.DragInfo.Text:SetPoint('CENTER')
	self.DragInfo:SetFrameLevel(100)
	self.DragInfo:SetFrameStrata('HIGH')
	self.DragInfo:SetMovable(true)
	self.DragInfo:SetClampedToScreen(true)
	self.DragInfo:RegisterForDrag('LeftButton')
	self.DragInfo:Hide()
	self.DragInfo:SetScript('OnMouseUp', Move.RestoreDefaults)

	self.DragInfo.Parent = self.DragInfo:GetParent()
end

local enable = true
local gridsize = function()
	local defsize = 8
	local w = D['ScreenWidth']
	local h = D['ScreenHeight']
	local x = tonumber(gridsize) or defsize

	function Grid()
		ali = CreateFrame('Frame', nil, UIParent)
		ali:SetFrameLevel(0)
		ali:SetFrameStrata('BACKGROUND')

		for i = - (w / x / 2), w / x / 2 do
			local aliv = ali:CreateTexture(nil, 'BACKGROUND')
			aliv:SetColorTexture(.3, 0, 0, .7)
			aliv:Point('CENTER', UIParent, 'CENTER', i * x, 0)
			aliv:SetSize(1, h)
		end

		for i = - (h / x / 2), h / x / 2 do
			local alih = ali:CreateTexture(nil, 'BACKGROUND')
			alih:SetColorTexture(.3, 0, 0, .7)
			alih:Point('CENTER', UIParent, 'CENTER', 0, i * x)
			alih:SetSize(w, 1)
		end
	end

	if Ali then
		if ox ~= x then
			ox = x
			ali:Hide()
			Grid()
			Ali = true
		else
			ali:Hide()
			Ali = false
		end
	else
		ox = x
		Grid()
		Ali = true
	end
end

function Move:OnEnter()
	local a1, Parent, a2, X, Y = self:GetPoint()

	if (Parent and Parent.GetName) then
		Parent = Parent:GetName()
	end

	GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')
	
	GameTooltip:AddLine('Frame Info')
	GameTooltip:AddLine(' ')
	GameTooltip:AddDoubleLine('Anchor 1:', a1, 1, 1, 1)
	GameTooltip:AddDoubleLine('Parent:', Parent, 1, 1, 1)
	GameTooltip:AddDoubleLine('Anchor 2:', a2, 1, 1, 1)
	GameTooltip:AddDoubleLine('X offset:', floor(X), 1, 1, 1)
	GameTooltip:AddDoubleLine('Y offset:', floor(Y), 1, 1, 1)
	GameTooltip:Show()
end

function Move:OnLeave(self)
	GameTooltip:Hide()
end

function Move:StartOrStopMoving()
	if InCombatLockdown() then return print(ERR_NOT_IN_COMBAT) end

	if not self.IsEnabled then self.IsEnabled = true else self.IsEnabled = false end

	for i = 1, #self.Frames do
		local Frame = Move.Frames[i]

		if self.IsEnabled then
			if not Frame.DragInfo then self.CreateDragInfo(Frame) end

			if Frame.unit then
				Frame.oldunit = Frame.unit
				Frame.unit = 'player'
				Frame:SetAttribute('unit', 'player')
			end

			Frame.DragInfo:SetScript('OnDragStart', self.OnDragStart)
			Frame.DragInfo:SetScript('OnDragStop', self.OnDragStop)
			Frame.DragInfo:SetScript('OnEnter', self.OnEnter)
			Frame.DragInfo:SetScript('OnLeave', self.OnLeave)
			Frame.DragInfo:SetParent(UIParent)
			Frame.DragInfo:Show()

			if Frame.DragInfo:GetFrameLevel() ~= 100 then Frame.DragInfo:SetFrameLevel(100) end
			if Frame.DragInfo:GetFrameStrata() ~= 'HIGH' then Frame.DragInfo:SetFrameStrata('HIGH') end

			if Frame.DragInfo:GetHeight() < 15 then
				Frame.DragInfo:ClearAllPoints()
				Frame.DragInfo:SetWidth(Frame:GetWidth())
				Frame.DragInfo:SetHeight(23)
				Frame.DragInfo:SetPoint('TOP', Frame)
			end
		else
			if Frame.unit then
				Frame.unit = Frame.oldunit
				Frame:SetAttribute('unit', Frame.unit)
			end

			if Frame.DragInfo then
				Frame.DragInfo:SetParent(Frame.DragInfo.Parent)
				Frame.DragInfo:Hide()
				Frame.DragInfo:SetScript('OnDragStart', nil)
				Frame.DragInfo:SetScript('OnDragStop', nil)
				Frame.DragInfo:SetScript('OnEnter', nil)
				Frame.DragInfo:SetScript('OnLeave', nil)

				if Frame.DragInfo.CurrentHeight then
					Frame.DragInfo:ClearAllPoints()
					Frame.DragInfo:SetAllPoints(Frame)
				end
			end
		end
	end

	if enable then
		enable = false
		gridsize()
	else
		enable = true
		gridsize()
	end
end

function Move:IsRegisteredFrame(frame)
	local Match = false

	for i = 1, #self.Frames do
		if self.Frames[i] == frame then Match = true end
	end

	return Match
end

Move:SetScript('OnEvent', function(self, event)
	if event == 'PLAYER_ENTERING_WORLD' then
		if DuffedUIDataPerChar == nil then D.SetPerCharVariable('DuffedUIDataPerChar', {}) end
		if not DuffedUIDataPerChar['Move'] then DuffedUIDataPerChar['Move'] = {} end

		local Data = DuffedUIDataPerChar['Move']

		for Frame, Position in pairs(Data) do
			local Frame = _G[Frame]
			local IsRegistered = self:IsRegisteredFrame(Frame)

			if Frame and IsRegistered then
				local Anchor1, Parent, Anchor2, X, Y = Frame:GetPoint()

				self:SaveDefaults(Frame, Anchor1, Parent, Anchor2, X, Y)

				Anchor1, Parent, Anchor2, X, Y = unpack(Position)
				Frame:ClearAllPoints()
				Frame:SetPoint(Anchor1, _G[Parent], Anchor2, X, Y)
			end
		end
	elseif event == 'PLAYER_REGEN_DISABLED' then
		if self.IsEnabled then self:StartOrStopMoving() end
	end
end)

SLASH_MOVING1 = '/moveui'
SLASH_MOVING2 = '/mm'
SlashCmdList['MOVING'] = function()
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end

	local Move = D['move']
	Move:StartOrStopMoving()
end

local protection = CreateFrame('Frame')
protection:RegisterEvent('PLAYER_REGEN_DISABLED')
protection:SetScript('OnEvent', function(self, event)
	if enable then return end
	print(ERR_NOT_IN_COMBAT)
	enable = false
	Move:StartOrStopMoving()
end)

D['move'] = Move
