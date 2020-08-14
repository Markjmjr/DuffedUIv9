if AddOnSkins.Classic then return end
local AS = unpack(AddOnSkins)

function AS:Blizzard_AbilityButton()
	--[[ZoneAbilityFrame.SpellButtonContainer.NormalTexture:SetAlpha(0)
	AS:SetTemplate(ZoneAbilityFrame.SpellButtonContainer)
	AS:StyleButton(ZoneAbilityFrame.SpellButtonContainer)
	AS:SkinTexture(ZoneAbilityFrame.SpellButtonContainer.Icon)
	AS:SetInside(ZoneAbilityFrame.SpellButtonContainer.Icon)
	AS:SetInside(ZoneAbilityFrame.SpellButtonContainer.Cooldown)
	ZoneAbilityFrame.SpellButtonContainer.Cooldown:SetSwipeColor(0, 0, 0, 1)
	ZoneAbilityFrame.SpellButtonContainer.Cooldown:SetDrawBling(false)
	hooksecurefunc("ZoneAbilityFrame_Update", function(self) self.SpellButtonContainer.Style:SetTexture() end)]]--
end

function AS:Blizzard_ExtraActionButton()
	ExtraActionButton1:SetNormalTexture('')
	AS:SetTemplate(ExtraActionButton1)
	AS:StyleButton(ExtraActionButton1)
	AS:SkinTexture(ExtraActionButton1.icon)
	AS:SetInside(ExtraActionButton1.icon)
	hooksecurefunc("ExtraActionBar_Update", function() ExtraActionBarFrame.button.style:SetTexture() end)
end

AS:RegisterSkin('Blizzard_AbilityButton', AS.Blizzard_AbilityButton)
AS:RegisterSkin('Blizzard_ExtraActionButton', AS.Blizzard_ExtraActionButton)
