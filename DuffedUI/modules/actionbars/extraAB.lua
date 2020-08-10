local D, C, L = unpack(select(2, ...))

local ab = D['Actions']
local move = D['move']
local Button = ExtraActionButton1
local Icon = ExtraActionButton1Icon
local Container = ExtraAbilityContainer
local ZoneAbilities = ZoneAbilityFrame

function ab:DisableExtraButtonTexture()
	local Bar = ExtraActionBarFrame
	
	if (HasExtraActionBar()) then
		Button.style:SetTexture("")
		Icon:SetInside()
	end
end

function ab:SkinZoneAbilities()
	for SpellButton in ZoneAbilities.SpellButtonContainer:EnumerateActive() do
		if not SpellButton.IsSkinned then
			SpellButton:CreateBackdrop()
			SpellButton:StyleButton()
			SpellButton.Backdrop:SetFrameLevel(SpellButton:GetFrameLevel() - 1)
			SpellButton.Icon:SetTexCoord(unpack(D['IconCoord']))
			SpellButton.Icon:ClearAllPoints()
			SpellButton.Icon:SetInside(SpellButton.Backdrop)
			SpellButton.NormalTexture:SetAlpha(0)
			SpellButton.IsSkinned = true
		end
	end
end

function ab:SetupExtraButton()
	local Holder = CreateFrame("Frame", "DuffedUIExtraActionButton", UIParent)
	local Bar = ExtraActionBarFrame
	local Icon = ExtraActionButton1Icon

	Holder:SetSize(160, 80)
	Holder:SetPoint("BOTTOM", 0, 250)
	
	Container:SetParent(Holder)
	Container:ClearAllPoints()
	Container:SetPoint("CENTER", Holder, "CENTER", 0, 0)
	Container.ignoreFramePositionManager = true
	
	Button:StripTextures()
	Button:CreateBackdrop()
	Button:StyleButton()
	Button:SetNormalTexture("")
	Button.HotKey:Kill()
	
	Icon:SetDrawLayer("ARTWORK")
	Icon:SetTexCoord(unpack(D['IconCoord']))
	
	ZoneAbilities.Style:SetAlpha(0)
	move:RegisterFrame(Holder)

	hooksecurefunc("ExtraActionBar_Update", self.DisableExtraButtonTexture)
	hooksecurefunc(ZoneAbilities, "UpdateDisplayedZoneAbilities", ab.SkinZoneAbilities)
end