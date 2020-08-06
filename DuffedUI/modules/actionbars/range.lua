local D, C, L = unpack(select(2, ...)) 
if not C['actionbar']['enable'] then return end

local _G = _G
local unpack = unpack
local DuffedUIRange = CreateFrame('Frame')
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local ActionHasRange = ActionHasRange
local HasAction = HasAction

function DuffedUIRange:RangeOnUpdate(elapsed)
	if not self.rangeTimer then return end
	DuffedUIRange.RangeUpdate(self)
end

function DuffedUIRange:RangeUpdate()
	local Name = self:GetName()
	local Icon = _G[Name..'Icon']
	local NormalTexture = _G[Name..'NormalTexture']
	local ID = self.action
	local IsUsable, NotEnoughMana = IsUsableAction(ID)
	local HasRange = ActionHasRange(ID)
	local InRange = IsActionInRange(ID)

	if IsUsable then
		if (HasRange and InRange == false) then
			Icon:SetVertexColor(.8, .1, .1)
			NormalTexture:SetVertexColor(.8, .1, .1)
		else
			Icon:SetVertexColor(1.0, 1.0, 1.0)
			NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
		end
	elseif NotEnoughMana then
		Icon:SetVertexColor(.1, .3, 1.0)
		NormalTexture:SetVertexColor(.1, .3, 1.0)
	else
		Icon:SetVertexColor(.3, .3, .3)
		NormalTexture:SetVertexColor(.3, .3, .3)
    end
end

--hooksecurefunc('ActionButton_OnUpdate', DuffedUIRange.RangeOnUpdate)
--hooksecurefunc('ActionButton_Update', DuffedUIRange.RangeUpdate)
--hooksecurefunc('ActionButton_UpdateUsable', DuffedUIRange.RangeUpdate)