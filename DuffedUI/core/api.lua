local D, C, L = unpack(select(2, ...))

local noop = D['Dummy']
local floor = math.floor
local class = D['Class']
local texture = C['media']['blank']
local backdropr, backdropg, backdropb = unpack(C['general']['backdropcolor'])
local borderr, borderg, borderb = unpack(C['general']['bordercolor'])
local backdropa = 1
local bordera = 1
local template
local inset = 0
local noinset = C['media']['noinset']
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local Mixin = Mixin
local mult = 768 / string.match(GetCVar('gxWindowedResolution'), '%d+x(%d+)') / C['general']['uiscale']
local Scale = function(x) return mult * math.floor(x / mult + 0.5) end

D['Scale'] = function(x) return Scale(x) end
D['mult'] = mult
D['noscalemult'] = D['mult'] * C['general']['uiscale']
D['raidscale'] = 1

if noinset then inset = D['mult'] end

local function FadeIn(f) UIFrameFadeIn(f, .4, f:GetAlpha(), 1) end

local function FadeOut(f) UIFrameFadeOut(f, .8, f:GetAlpha(), 0) end

local function CreateBorder(f, bLayer, bOffset, bPoints, strip)
	if f.Backgrounds then
		return
	end

	bLayer = bLayer or 0
	bOffset = bOffset or 4
	bPoints = bPoints or 0

	if strip then
		f:StripTextures()
	end

	D['CreateBorder'](f, bOffset)

	local backgrounds = f:CreateTexture(nil, 'BACKGROUND')
	backgrounds:SetDrawLayer('BACKGROUND', bLayer)
	backgrounds:SetPoint('TOPLEFT', f ,'TOPLEFT', bPoints, -bPoints)
	backgrounds:SetPoint('BOTTOMRIGHT', f ,'BOTTOMRIGHT', -bPoints, bPoints)
	backgrounds:SetColorTexture(C['general']['backdropcolor'][1], C['general']['backdropcolor'][2], C['general']['backdropcolor'][3], C['general']['backdropcolor'][4])

	f:SetBorderColor()

	f.Backgrounds = backgrounds
end

local function UpdateColor(t)
	if t == template then return end

	if t == 'ClassColor' or t == 'Class Color' or t == 'Class' then
		local c = D['UnitColor']['class'][class]
		borderr, borderg, borderb = c[1], c[2], c[3]
		backdropr, backdropg, backdropb = unpack(C['general']['backdropcolor'])
		backdropa = 1
	else
		local balpha = 1
		if t == 'Transparent' then balpha = 0.8 end
		borderr, borderg, borderb = unpack(C['general']['bordercolor'])
		backdropr, backdropg, backdropb = unpack(C['general']['backdropcolor'])
		backdropa = balpha
	end
	template = t
end

local UIHider = CreateFrame('Frame', 'DuffedUIUIHider', UIParent)
UIHider:Hide()

local PetBattleHider = CreateFrame('Frame', 'DuffedUIPetBattleHider', UIParent, 'SecureHandlerStateTemplate');
RegisterStateDriver(PetBattleHider, 'visibility', '[petbattle] hide; show')

--[[DuffedUI API START HERE]]--
local function Size(frame, width, height) frame:SetSize(D['Scale'](width), D['Scale'](height or width)) end

local function Width(frame, width) frame:SetWidth(D['Scale'](width)) end

local function Height(frame, height) frame:SetHeight(D['Scale'](height)) end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	if type(arg1)=='number' then arg1 = D['Scale'](arg1) end
	if type(arg2)=='number' then arg2 = D['Scale'](arg2) end
	if type(arg3)=='number' then arg3 = D['Scale'](arg3) end
	if type(arg4)=='number' then arg4 = D['Scale'](arg4) end
	if type(arg5)=='number' then arg5 = D['Scale'](arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end
	obj:Point('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
	obj:Point('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
end

local function SetTemplate(f, t, tex)
	if tex then texture = C['media']['normTex'] else texture = C['media']['blank'] end

	if not f.SetBackdrop then Mixin(f, BackdropTemplateMixin) end
	UpdateColor(t)
	f:SetBackdrop({
	  bgFile = texture,
	  edgeFile = C['media']['blank'],
	  tile = false, tileSize = 0, edgeSize = D['mult'],
	})

	if not noinset and not f.isInsetDone then
		f.insettop = f:CreateTexture(nil, 'BORDER')
		f.insettop:Point('TOPLEFT', f, 'TOPLEFT', -1, 1)
		f.insettop:Point('TOPRIGHT', f, 'TOPRIGHT', 1, -1)
		f.insettop:Height(1)
		f.insettop:SetColorTexture(0, 0, 0)
		f.insettop:SetDrawLayer('BORDER', -7)

		f.insetbottom = f:CreateTexture(nil, 'BORDER')
		f.insetbottom:Point('BOTTOMLEFT', f, 'BOTTOMLEFT', -1, -1)
		f.insetbottom:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 1, -1)
		f.insetbottom:Height(1)
		f.insetbottom:SetColorTexture(0, 0, 0)
		f.insetbottom:SetDrawLayer('BORDER', -7)

		f.insetleft = f:CreateTexture(nil, 'BORDER')
		f.insetleft:Point('TOPLEFT', f, 'TOPLEFT', -1, 1)
		f.insetleft:Point('BOTTOMLEFT', f, 'BOTTOMLEFT', 1, -1)
		f.insetleft:Width(1)
		f.insetleft:SetColorTexture(0, 0, 0)
		f.insetleft:SetDrawLayer('BORDER', -7)

		f.insetright = f:CreateTexture(nil, 'BORDER')
		f.insetright:Point('TOPRIGHT', f, 'TOPRIGHT', 1, 1)
		f.insetright:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, -1)
		f.insetright:Width(1)
		f.insetright:SetColorTexture(0, 0, 0)
		f.insetright:SetDrawLayer('BORDER', -7)

		f.insetinsidetop = f:CreateTexture(nil, 'BORDER')
		f.insetinsidetop:Point('TOPLEFT', f, 'TOPLEFT', 1, -1)
		f.insetinsidetop:Point('TOPRIGHT', f, 'TOPRIGHT', -1, 1)
		f.insetinsidetop:Height(1)
		f.insetinsidetop:SetColorTexture(0, 0, 0)
		f.insetinsidetop:SetDrawLayer('BORDER', -7)

		f.insetinsidebottom = f:CreateTexture(nil, 'BORDER')
		f.insetinsidebottom:Point('BOTTOMLEFT', f, 'BOTTOMLEFT', 1, 1)
		f.insetinsidebottom:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, 1)
		f.insetinsidebottom:Height(1)
		f.insetinsidebottom:SetColorTexture(0, 0, 0)
		f.insetinsidebottom:SetDrawLayer('BORDER', -7)

		f.insetinsideleft = f:CreateTexture(nil, 'BORDER')
		f.insetinsideleft:Point('TOPLEFT', f, 'TOPLEFT', 1, -1)
		f.insetinsideleft:Point('BOTTOMLEFT', f, 'BOTTOMLEFT', -1, 1)
		f.insetinsideleft:Width(1)
		f.insetinsideleft:SetColorTexture(0, 0, 0)
		f.insetinsideleft:SetDrawLayer('BORDER', -7)

		f.insetinsideright = f:CreateTexture(nil, 'BORDER')
		f.insetinsideright:Point('TOPRIGHT', f, 'TOPRIGHT', -1, -1)
		f.insetinsideright:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 1, 1)
		f.insetinsideright:Width(1)
		f.insetinsideright:SetColorTexture(0, 0, 0)
		f.insetinsideright:SetDrawLayer('BORDER', -7)

		f.isInsetDone = true
	end
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

local borders = {
	'insettop',
	'insetbottom',
	'insetleft',
	'insetright',
	'insetinsidetop',
	'insetinsidebottom',
	'insetinsideleft',
	'insetinsideright',
}

local function HideInsets(f)
	for i, border in pairs(borders) do
		if f[border] then f[border]:SetColorTexture(0, 0, 0, 0) end
	end
end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	if not t then t = 'Default' end

	local b = CreateFrame('Frame', nil, f, 'BackdropTemplate')
	b:SetOutside()
	b:SetTemplate(t, tex)

	if f:GetFrameLevel() - 1 >= 0 then b:SetFrameLevel(f:GetFrameLevel() - 1) else b:SetFrameLevel(0) end
	f.backdrop = b
end

local function CreateOverlay(frame)
	if frame.overlay then return end

	local overlay = frame:CreateTexture(frame:GetName() and frame:GetName() .. 'Overlay' or nil, 'BORDER', frame)
	overlay:ClearAllPoints()
	overlay:Point('TOPLEFT', 2, -2)
	overlay:Point('BOTTOMRIGHT', -2, 2)
	overlay:SetTexture(C['media']['normTex'])
	overlay:SetVertexColor(.05, .05, .05)
	frame.overlay = overlay
end

local function Kill(object)
	if object.UnregisterAllEvents then object:UnregisterAllEvents() end
	object.Show = noop
	object:Hide()
end

local function StyleButton(button)
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture('frame', nil, self)
		hover:SetColorTexture(1, 1, 1, .3)
		hover:SetInside(button, 1, 1)
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture('frame', nil, self)
		pushed:SetColorTexture(.9, .8, .1, .3)
		pushed:SetInside(button, 1, 1)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture('frame', nil, self)
		checked:SetColorTexture(0, 1, 0, .1)
		checked:SetInside(button, 1, 1)
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName()..'Cooldown']
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetInside(button, 1, 1)
	end
end

local function FontString(parent, name, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, 'OVERLAY')
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetJustifyH('LEFT')
    fs:SetShadowColor(0, 0, 0)
    fs:SetShadowOffset(D['mult'], -D['mult'])

    if not name then parent.Text = fs else parent[name] = fs end
    return fs
end

local function HighlightTarget(self, event, unit)
	if self.unit == 'target' then return end
	if UnitIsUnit('target', self.unit) then self.HighlightTarget:Show() else self.HighlightTarget:Hide() end
end

local function HighlightUnit(f, r, g, b)
	if f.HighlightTarget then return end
	local glowBorder = {edgeFile = C['media']['blank'], edgeSize = 1}
	f.HighlightTarget = CreateFrame('Frame', nil, f, 'BackdropTemplate')
	f.HighlightTarget:Point('TOPLEFT', f, 'TOPLEFT', -2, 2)
	f.HighlightTarget:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, -2)
	f.HighlightTarget:SetBackdrop(glowBorder)
	f.HighlightTarget:SetFrameLevel(f:GetFrameLevel() + 1)
	f.HighlightTarget:SetBackdropBorderColor(r,g,b,1)
	f.HighlightTarget:Hide()
	f:RegisterEvent('PLAYER_TARGET_CHANGED', HighlightTarget)
end

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == 'Texture' then
			if kill then region:Kill() else region:SetTexture(nil) end
		end
	end
end

-- Horizontal Animationcode from Hydra
local Frame = CreateFrame('Frame')
local strlower = string.lower
local select = select
local unpack = unpack
local modf = math.modf

local Show = Frame.Show
local Hide = Frame.Hide
local GetPoint = Frame.GetPoint
local GetWidth = Frame.GetWidth
local GetHeight = Frame.GetHeight

local OnUpdateHorizontalMove = function(self)
	local Point, RelativeTo, RelativePoint, XOfs, YOfs = GetPoint(self)

	if (self.MoveType == 'Positive') then
		if (XOfs + self.MoveSpeed > self.EndX) then self:SetPoint(Point, RelativeTo, RelativePoint, XOfs + 1, YOfs) else self:SetPoint(Point, RelativeTo, RelativePoint, XOfs + self.MoveSpeed, YOfs) end
		if (XOfs >= self.EndX) then
			self:SetScript('OnUpdate', nil)
			self:Point(Point, RelativeTo, RelativePoint, self.EndX, YOfs)
			self.IsMoving = false
			self:AnimCallback('move', self.MoveDirection, self.ValueX, self.MoveSpeed)
		end
	else
		if (XOfs - self.MoveSpeed < self.EndX) then self:SetPoint(Point, RelativeTo, RelativePoint, XOfs - 1, YOfs) else self:SetPoint(Point, RelativeTo, RelativePoint, XOfs - self.MoveSpeed, YOfs) end
		if (XOfs <= self.EndX) then
			self:SetScript('OnUpdate', nil)
			self:Point(Point, RelativeTo, RelativePoint, self.EndX, YOfs)
			self.IsMoving = false
			self:AnimCallback('move', self.MoveDirection, self.ValueX, self.MoveSpeed)
		end
	end
end

local MoveFrameHorizontal = function(self, x, speed)
	if self.IsMoving then return end

	self.MoveSpeed = speed
	if (x < 0) then self.MoveType = 'Negative' else self.MoveType = 'Positive' end
	self.ValueX = x
	self.EndX = select(4, GetPoint(self)) + x
	self:SetScript('OnUpdate', OnUpdateHorizontalMove)
end

local MoveFrame = function(self, direction, offset, speed)
	if (not direction) then direction = 'horizontal' end

	MoveFrameHorizontal(self, offset or 100, speed or 6)
	self.MoveDirection = direction
end

local Functions = {
	['move'] = MoveFrame,
}

local Callbacks = {
	['move'] = {},
}

local AnimCallback = function(self, handler, ...)
	local Function = Callbacks[handler][self]
	if Function then Function(self, ...) end
end

local AnimOnFinished = function(self, handler, func)
	if (type(handler) ~= 'string' or type(func) ~= 'function') then return end
	Callbacks[strlower(handler)][self] = func
end

local SetAnimation = function(self, handler, ...)
	local Function = Functions[strlower(handler)]
	if Function then Function(self, ...) else return print("Invalid 'SetAnimation' handler: " .. handler) end
end

-- Skinning
local function SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[D['Class']]
	self:SetBackdropColor(color.r * .15, color.g * .15, color.b * .15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self) self:SetTemplate() end

local function SkinButton(f, strip)
	if f:GetName() then
		local l = _G[f:GetName()..'Left']
		local m = _G[f:GetName()..'Middle']
		local r = _G[f:GetName()..'Right']

		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.SetNormalTexture then f:SetNormalTexture('') end
	if f.SetHighlightTexture then f:SetHighlightTexture('') end
	if f.SetPushedTexture then f:SetPushedTexture('') end
	if f.SetDisabledTexture then f:SetDisabledTexture('') end
	if strip then StripTextures(f) end

	SetTemplate(f, 'Default')
	f:HookScript('OnEnter', SetModifiedBackdrop)
	f:HookScript('OnLeave', SetOriginalBackdrop)
end

function SkinScrollBar(frame, thumbTrim)
	if frame:GetName() then
		if frame.Background then frame.Background:SetTexture(nil) end
		if frame.trackBG then frame.trackBG:SetTexture(nil) end
		if frame.Middle then frame.Middle:SetTexture(nil) end
		if frame.Top then frame.Top:SetTexture(nil) end
		if frame.Bottom then frame.Bottom:SetTexture(nil) end
		if frame.ScrollBarTop then frame.ScrollBarTop:SetTexture(nil) end
		if frame.ScrollBarBottom then frame.ScrollBarBottom:SetTexture(nil) end
		if frame.ScrollBarMiddle then frame.ScrollBarMiddle:SetTexture(nil) end
		if _G[frame:GetName()..'BG'] then _G[frame:GetName()..'BG']:SetTexture(nil) end
		if _G[frame:GetName()..'Track'] then _G[frame:GetName()..'Track']:SetTexture(nil) end
		if _G[frame:GetName()..'Top'] then _G[frame:GetName()..'Top']:SetTexture(nil) end
		if _G[frame:GetName()..'Bottom'] then _G[frame:GetName()..'Bottom']:SetTexture(nil) end
		if _G[frame:GetName()..'Middle'] then _G[frame:GetName()..'Middle']:SetTexture(nil) end
		if _G[frame:GetName()..'ScrollUpButton'] and _G[frame:GetName()..'ScrollDownButton'] then
			_G[frame:GetName()..'ScrollUpButton']:StripTextures()
			if not _G[frame:GetName()..'ScrollUpButton'].texture then
				_G[frame:GetName()..'ScrollUpButton'].texture = _G[frame:GetName()..'ScrollUpButton']:CreateTexture(nil, 'OVERLAY')
				_G[frame:GetName()..'ScrollUpButton'].texture:Point('TOPLEFT', 2, -2)
				_G[frame:GetName()..'ScrollUpButton'].texture:Point('BOTTOMRIGHT', -2, 2)
				_G[frame:GetName()..'ScrollUpButton'].texture:SetTexture([[Interface\AddOns\DuffedUI\media\textures\arrowup.tga]])
				_G[frame:GetName()..'ScrollUpButton'].texture:SetVertexColor(unpack(C['media']['bordercolor']))
			end
			_G[frame:GetName()..'ScrollDownButton']:StripTextures()
			if not _G[frame:GetName()..'ScrollDownButton'].texture then
				_G[frame:GetName()..'ScrollDownButton'].texture = _G[frame:GetName()..'ScrollDownButton']:CreateTexture(nil, 'OVERLAY')
				_G[frame:GetName()..'ScrollDownButton'].texture:Point('TOPLEFT', 2, -2)
				_G[frame:GetName()..'ScrollDownButton'].texture:Point('BOTTOMRIGHT', -2, 2)
				_G[frame:GetName()..'ScrollDownButton'].texture:SetTexture([[Interface\AddOns\DuffedUI\media\textures\arrowdown.tga]])
				_G[frame:GetName()..'ScrollDownButton'].texture:SetVertexColor(unpack(C['media']['bordercolor']))
			end
			if not frame.trackbg then
				frame.trackbg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
				frame.trackbg:Point('TOPLEFT', _G[frame:GetName()..'ScrollUpButton'], 'BOTTOMLEFT', 0, -1)
				frame.trackbg:Point('BOTTOMRIGHT', _G[frame:GetName()..'ScrollDownButton'], 'TOPRIGHT', 0, 1)
				frame.trackbg:SetTemplate('Transparent')
			end
			if frame:GetThumbTexture() then
				if not thumbTrim then thumbTrim = 3 end
				frame:GetThumbTexture():SetTexture(nil)
				if not frame.thumbbg then
					frame.thumbbg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
					frame.thumbbg:Point('TOPLEFT', frame:GetThumbTexture(), 'TOPLEFT', 2, -thumbTrim)
					frame.thumbbg:Point('BOTTOMRIGHT', frame:GetThumbTexture(), 'BOTTOMRIGHT', -2, thumbTrim)
					frame.thumbbg:SetTemplate('Default', true)
					if frame.trackbg then frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel()) end
				end
			end
		end
	else
		if frame.Background then frame.Background:SetTexture(nil) end
		if frame.trackBG then frame.trackBG:SetTexture(nil) end
		if frame.Middle then frame.Middle:SetTexture(nil) end
		if frame.Top then frame.Top:SetTexture(nil) end
		if frame.Bottom then frame.Bottom:SetTexture(nil) end
		if frame.ScrollBarTop then frame.ScrollBarTop:SetTexture(nil) end
		if frame.ScrollBarBottom then frame.ScrollBarBottom:SetTexture(nil) end
		if frame.ScrollBarMiddle then frame.ScrollBarMiddle:SetTexture(nil) end
		if frame.ScrollUpButton and frame.ScrollDownButton then
			if not frame.ScrollUpButton.icon then
				frame.ScrollUpButton:SkinNextPrevButton(true, true)
				frame.ScrollUpButton:Size(frame.ScrollUpButton:GetWidth() + 7, frame.ScrollUpButton:GetHeight() + 7)
			end
			if not frame.ScrollDownButton.icon then
				frame.ScrollDownButton:SkinNextPrevButton(true)
				frame.ScrollDownButton:Size(frame.ScrollDownButton:GetWidth() + 7, frame.ScrollDownButton:GetHeight() + 7)
			end

			if not frame.trackbg then
				frame.trackbg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
				frame.trackbg:Point('TOPLEFT', frame.ScrollUpButton, 'BOTTOMLEFT', 0, -1)
				frame.trackbg:Point('BOTTOMRIGHT', frame.ScrollDownButton, 'TOPRIGHT', 0, 1)
				frame.trackbg:SetTemplate('Transparent')
			end

			if frame:GetThumbTexture() then
				if not thumbTrim then thumbTrim = 3 end
				frame:GetThumbTexture():SetTexture(nil)
				if not frame.thumbbg then
					frame.thumbbg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
					frame.thumbbg:Point('TOPLEFT', frame:GetThumbTexture(), 'TOPLEFT', 2, -thumbTrim)
					frame.thumbbg:Point('BOTTOMRIGHT', frame:GetThumbTexture(), 'BOTTOMRIGHT', -2, thumbTrim)
					frame.thumbbg:SetTemplate('Default', true)
					if frame.trackbg then frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel()) end
				end
			end
		end
	end
end

local function SkinNextPrevButton(btn, horizonal)
	SetTemplate(btn, 'Default')
	Size(btn, btn:GetWidth() - 7, btn:GetHeight() - 7)

	if horizonal then
		btn:GetNormalTexture():SetTexCoord(.3, .29, .3, .72, .65, .29, .65, .72)
		btn:GetPushedTexture():SetTexCoord(.3, .35, .3, .8, .65, .35, .65, .8)
		btn:GetDisabledTexture():SetTexCoord(.3, .29, .3, .75, .65, .29, .65, .75)
	else
		btn:GetNormalTexture():SetTexCoord(.3, .29, .3, .81, .65, .29, .65, .81)
		if btn:GetPushedTexture() then btn:GetPushedTexture():SetTexCoord(.3, .35, .3, .81, .65, .35, .65, .81) end
		if btn:GetDisabledTexture() then btn:GetDisabledTexture():SetTexCoord(.3, .29, .3, .75, .65, .29, .65, .75) end
	end

	btn:GetNormalTexture():ClearAllPoints()
	Point(btn:GetNormalTexture(), 'TOPLEFT', 2, -2)
	Point(btn:GetNormalTexture(), 'BOTTOMRIGHT', -2, 2)
	if btn:GetDisabledTexture() then btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture()) end
	if btn:GetPushedTexture() then btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture()) end
	btn:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

local function SkinEditBox(frame)
	frame:CreateBackdrop('Default')

	if frame.TopLeftTex then frame.TopLeftTex:Kill() end
	if frame.TopRightTex then frame.TopRightTex:Kill() end
	if frame.TopTex then frame.TopTex:Kill() end
	if frame.BottomLeftTex then frame.BottomLeftTex:Kill() end
	if frame.BottomRightTex then frame.BottomRightTex:Kill() end
	if frame.BottomTex then frame.BottomTex:Kill() end
	if frame.LeftTex then frame.LeftTex:Kill() end
	if frame.RightTex then frame.RightTex:Kill() end
	if frame.MiddleTex then frame.MiddleTex:Kill() end

	if frame:GetName() then
		if _G[frame:GetName()..'Left'] then _G[frame:GetName()..'Left']:Kill() end
		if _G[frame:GetName()..'Middle'] then _G[frame:GetName()..'Middle']:Kill() end
		if _G[frame:GetName()..'Right'] then _G[frame:GetName()..'Right']:Kill() end
		if _G[frame:GetName()..'Mid'] then _G[frame:GetName()..'Mid']:Kill() end

		if frame:GetName():find('Silver') or frame:GetName():find('Copper') then frame.backdrop:Point('BOTTOMRIGHT', -12, -2) end
	end

	if(frame.Left) then frame.Left:Kill() end
	if(frame.Right) then frame.Right:Kill() end
	if(frame.Middle) then frame.Middle:Kill() end
end

local function SkinCheckBox(frame)
	StripTextures(frame)
	CreateBackdrop(frame, 'Default')
	Point(frame.backdrop, 'TOPLEFT', 4, -4)
	Point(frame.backdrop, 'BOTTOMRIGHT', -4, 4)

	if frame.SetCheckedTexture then frame:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check') end
	if frame.SetDisabledCheckedTexture then frame:SetDisabledCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled') end

	frame:HookScript('OnDisable', function(self)
		if not self.SetDisabledTexture then return end
		if self:GetChecked() then self:SetDisabledTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled') else self:SetDisabledTexture('') end
	end)

	frame.SetNormalTexture = D['Dummy']
	frame.SetPushedTexture = D['Dummy']
	frame.SetHighlightTexture = D['Dummy']
end

local function SkinCloseButton(f, point)
	if point then Point(f, 'TOPRIGHT', point, 'TOPRIGHT', 2, 2) end

	f:SetNormalTexture('')
	f:SetPushedTexture('')
	f:SetHighlightTexture('')
	f:SetDisabledTexture('')

	f.t = f:CreateFontString(nil, 'OVERLAY')
	f.t:SetFont(C['media']['font'], 11, 'OUTLINE')
	f.t:SetPoint('CENTER', 0, 1)
	f.t:SetText('x')
end

-- Tab Regions
local tabs = {
	'LeftDisabled',
	'MiddleDisabled',
	'RightDisabled',
	'Left',
	'Middle',
	'Right',
}
local function SkinTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then tex:SetTexture(nil) end
	end

	if tab.GetHighlightTexture and tab:GetHighlightTexture() then tab:GetHighlightTexture():SetTexture(nil) else StripTextures(tab) end

	tab.backdrop = CreateFrame('Frame', nil, tab, 'BackdropTemplate')
	SetTemplate(tab.backdrop, 'Default')
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	Point(tab.backdrop, 'TOPLEFT', 10, -3)
	Point(tab.backdrop, 'BOTTOMRIGHT', -10, 3)
end

function SkinMaxMinFrame(Frame)
	Frame:StripTextures(true)

	for _, name in pairs({"MaximizeButton", "MinimizeButton"}) do
		local button = Frame[name]

		if button then
			button:SetSize(16, 16)
			button:ClearAllPoints()
			button:SetPoint('CENTER')
			button:SetHitRectInsets(1, 1, 1, 1)
			button:StripTextures(nil, true)
			button:SetTemplate()

			button.Text = button:CreateFontString(nil, 'OVERLAY')
			button.Text:SetFont([[Interface\AddOns\DuffedUI\media\fonts\Arial.ttf]], 12)
			button.Text:SetText(name == 'MaximizeButton' and '▲' or '▼')
			button.Text:SetPoint('CENTER', 0, 0)

			button:HookScript('OnShow', function(self)
				if not self:IsEnabled() then
					self.Text:SetTextColor(.3, .3, .3)
				end
			end)

			button:HookScript('OnEnter', SetModifiedBackdrop)
			button:HookScript('OnLeave', SetOriginalBackdrop)
		end
	end
end

local function SkinDropDownBox(frame, width)
	local button = _G[frame:GetName()..'Button']
	if not width then width = 155 end

	frame:StripTextures()
	frame:Width(width)

	_G[frame:GetName()..'Text']:ClearAllPoints()
	_G[frame:GetName()..'Text']:Point('RIGHT', button, 'LEFT', -2, 0)

	button:ClearAllPoints()
	button:Point('RIGHT', frame, 'RIGHT', -10, 3)
	hooksecurefunc(button, 'SetPoint', function(self, point, attachTo, anchorPoint, xOffset, yOffset, noReset)
		if not noReset then
			button:ClearAllPoints()
			button:SetPoint('RIGHT', frame, 'RIGHT', -10, 3, true)
		end
	end)
	button.SetPoint = D['Dummy']

	button:SkinNextPrevButton(true)

	frame:CreateBackdrop('Default')
	frame.backdrop:Point('TOPLEFT', 20, -2)
	frame.backdrop:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 2, -2)
end

local function SkinSlideBar(frame, height, movetext)
	frame:SetTemplate( 'Default' )
	frame:SetBackdropColor( 0, 0, 0, .8 )

	if not height then height = frame:GetHeight() end

	if movetext then
		if(_G[frame:GetName() .. 'Low']) then _G[frame:GetName() .. 'Low']:Point('BOTTOM', 0, -18) end
		if(_G[frame:GetName() .. 'High']) then _G[frame:GetName() .. 'High']:Point('BOTTOM', 0, -18) end
		if(_G[frame:GetName() .. 'Text']) then _G[frame:GetName() .. 'Text']:Point('TOP', 0, 19) end
	end

	_G[frame:GetName()]:SetThumbTexture( [[Interface\AddOns\DuffedUI\media\textures\blank.tga]] )
	_G[frame:GetName()]:GetThumbTexture():SetVertexColor(unpack( C['media']['bordercolor']))
	if( frame:GetWidth() < frame:GetHeight() ) then
		frame:Width(height)
		_G[frame:GetName()]:GetThumbTexture():Size(frame:GetWidth(), frame:GetWidth() + 4)
	else
		frame:Height(height)
		_G[frame:GetName()]:GetThumbTexture():Size(height + 4, height)
	end
end

-- merge api
local function addapi(object)
	local mt = getmetatable(object).__index

	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreateBackdrop then mt.CreateBackdrop = CreateBackdrop end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.FontString then mt.FontString = FontString end
	if not object.HighlightUnit then mt.HighlightUnit = HighlightUnit end
	if not object.SkinButton then mt.SkinButton = SkinButton end
	if not object.SkinScrollBar then mt.SkinScrollBar = SkinScrollBar end
	if not object.SkinNextPrevButton then mt.SkinNextPrevButton = SkinNextPrevButton end
	if not object.SkinEditBox then mt.SkinEditBox = SkinEditBox end
	if not object.SkinCheckBox then mt.SkinCheckBox = SkinCheckBox end
	if not object.SkinCloseButton then mt.SkinCloseButton = SkinCloseButton end
	if not object.SkinTab then mt.SkinTab = SkinTab end
	if not object.SkinMaxMinFrame then mt.SkinMaxMinFrame = SkinMaxMinFrame end
	if not object.SkinDropDownBox then mt.SkinDropDownBox = SkinDropDownBox end
	if not object.SkinSlideBar then mt.SkinSlideBar = SkinSlideBar end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.SetAnimation then mt.SetAnimation = SetAnimation end
	if not object.AnimCallback then mt.AnimCallback = AnimCallback end
	if not object.AnimOnFinished then mt.AnimOnFinished = AnimOnFinished end
	if not object.CreateBorder then	mt.CreateBorder = CreateBorder end
end

local handled = {['Frame'] = true}
local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end
