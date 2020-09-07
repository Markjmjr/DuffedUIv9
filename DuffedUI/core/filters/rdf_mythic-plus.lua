local D, C, L = unpack(select(2, ...))

-- Mythic+ Debuffs
D['Debuffids'] = {
	-- General Affix
	[GetSpellInfo(209858)] = 3, -- Necrotic
	[GetSpellInfo(226512)] = 3, -- Sanguine
	[GetSpellInfo(240559)] = 3, -- Grievous
	[GetSpellInfo(240443)] = 3, -- Bursting
	[GetSpellInfo(196376)] = 3, -- Grievous Tear
	-- 8.3 Affix
	[GetSpellInfo(314531)] = 3, -- Tear Flesh
	[GetSpellInfo(314308)] = 3, -- Spirit Breaker
	[GetSpellInfo(314478)] = 3, -- Cascading Terror
	[GetSpellInfo(314483)] = 3, -- Cascading Terror
	[GetSpellInfo(314592)] = 3, -- Mind Flay
	[GetSpellInfo(314406)] = 3, -- Crippling Pestilence
	[GetSpellInfo(314411)] = 3, -- Lingering Doubt
	[GetSpellInfo(314565)] = 3, -- Defiled Ground
	[GetSpellInfo(314392)] = 3, -- Vile Corruption
	-- 9.0 Shadowlands
	[GetSpellInfo(342494)] = 3, -- Belligerent Boast (Prideful)
}