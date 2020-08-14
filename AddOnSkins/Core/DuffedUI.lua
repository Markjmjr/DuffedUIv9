local AS, ASL = unpack(AddOnSkins)
if not AS:CheckAddOn('DuffedUI') then return end

local select, floor = select, floor
local IsAddOnLoaded = IsAddOnLoaded
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local CreateFrame = CreateFrame
local D, C, L = unpack(DuffedUI)

function AS:UpdateMedia()
	AS.DataTextFontSize = C['datatext'].fontsize

	AS.InfoLeft = DuffedUIInfoLeft
	AS.InfoRight = DuffedUIInfoRight
	AS.ChatBackgroundRight = DuffedUIChatBackgroundRight
	AS.ChatBackgroundLeft = DuffedUIChatBackgroundLeft
	AS.TabsRightBackground = DuffedUITabsRightBackground
	AS.TabsLeftBackground = DuffedUITabsLeftBackground
	AS.Minimap = DuffedUIMinimap
	AS.ActionBar1 = DuffedUIBar1
	AS.ActionBar2 = DuffedUIBar2
	AS.ActionBar3 = DuffedUIBar3
	AS.ActionBar4 = DuffedUIBar4

	AS.GlossTex = C['media']['normTex']
	AS.Blank = C['media']['blank']
	AS.NormTex = C['media']['normTex']
	AS.GlowTex = C['media']['glowTex']
	AS.Font = C['media']['font']
	AS.UIScale = UIParent:GetScale()
	AS.BackdropColor = C['general']['backdropcolor']
	AS.BorderColor = C['general']['bordercolor']
end