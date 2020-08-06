local D, C, L = unpack(select(2, ...))

D['FadeOut'] = function()
	local DuffedUIBar3Group = CreateAnimationGroup(DuffedUIBar3)
	local FadeOut = DuffedUIBar3Group:CreateAnimation('Fade')
	FadeOut:SetDuration(.5)
	FadeOut:SetFromAlpha(1)
	FadeOut:SetToAlpha(0)
	FadeOut:Play()
end

D['FadeIn'] = function()
	local DuffedUIBar3Group = CreateAnimationGroup(DuffedUIBar3)
	local FadeIn = DuffedUIBar3Group:CreateAnimation('Fade')
	FadeIn:SetDuration(.5)
	FadeIn:SetFromAlpha(1)
	FadeIn:SetToAlpha(0)
	FadeIn:Play()
end