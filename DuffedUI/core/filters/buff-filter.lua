local D, C, L = unpack(select(2, ...))

-- Raid Buffs (Squared Aura Tracking List)
D['BuffsTracking'] = {
	PRIEST = {
		[194384] = D['AuraWatch_AddSpell'](194384, "TOPRIGHT", {1, 1, 0.66}), -- Atonement
		[214206] = D['AuraWatch_AddSpell'](214206, "TOPRIGHT", {1, 1, 0.66}), -- Atonement (PvP)
		[41635] = D['AuraWatch_AddSpell'](41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}), -- Prayer of Mending
		[193065] = D['AuraWatch_AddSpell'](193065, "BOTTOMRIGHT", {0.54, 0.21, 0.78}), -- Masochism
		[139] = D['AuraWatch_AddSpell'](139, "BOTTOMLEFT", {0.4, 0.7, 0.2}), -- Renew
		[6788] = D['AuraWatch_AddSpell'](6788, "BOTTOMLEFT", {0.89, 0.1, 0.1}), -- Weakened Soul
		[17] = D['AuraWatch_AddSpell'](17, "TOPLEFT", {0.7, 0.7, 0.7}, true), -- Power Word: Shield
		[47788] = D['AuraWatch_AddSpell'](47788, "LEFT", {0.86, 0.45, 0}, true), -- Guardian Spirit
		[33206] = D['AuraWatch_AddSpell'](33206, "LEFT", {0.47, 0.35, 0.74}, true), -- Pain Suppression
	},
	DRUID = {
		[774] = D['AuraWatch_AddSpell'](774, "TOPRIGHT", {0.8, 0.4, 0.8}), 		-- Rejuvenation
		[155777] = D['AuraWatch_AddSpell'](155777, "RIGHT", {0.8, 0.4, 0.8}), 		-- Germination
		[8936] = D['AuraWatch_AddSpell'](8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),		-- Regrowth
		[33763] = D['AuraWatch_AddSpell'](33763, "TOPLEFT", {0.4, 0.8, 0.2}), 		-- Lifebloom
		[48438] = D['AuraWatch_AddSpell'](48438, "BOTTOMRIGHT", {0.8, 0.4, 0}),		-- Wild Growth
		[207386] = D['AuraWatch_AddSpell'](207386, "TOP", {0.4, 0.2, 0.8}), 		-- Spring Blossoms
		[102351] = D['AuraWatch_AddSpell'](102351, "LEFT", {0.2, 0.8, 0.8}), 		-- Cenarion Ward (Initial Buff)
		[102352] = D['AuraWatch_AddSpell'](102352, "LEFT", {0.2, 0.8, 0.8}), 		-- Cenarion Ward (HoT)
		[200389] = D['AuraWatch_AddSpell'](200389, "BOTTOM", {1, 1, 0.4}), 		-- Cultivation
	},
	PALADIN = {
		[53563] = D['AuraWatch_AddSpell'](53563, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Beacon of Light
		[156910] = D['AuraWatch_AddSpell'](156910, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Beacon of Faith
		[200025] = D['AuraWatch_AddSpell'](200025, "TOPRIGHT", {0.7, 0.3, 0.7}), -- Beacon of Virtue
		[1022] = D['AuraWatch_AddSpell'](1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true), -- Hand of Protection
		[1044] = D['AuraWatch_AddSpell'](1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true), -- Hand of Freedom
		[6940] = D['AuraWatch_AddSpell'](6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[223306] = D['AuraWatch_AddSpell'](223306, 'BOTTOMLEFT', {0.7, 0.7, 0.3}), -- Bestow Faith
		[287280] = D['AuraWatch_AddSpell'](287280, 'TOPLEFT', {0.2, 0.8, 0.2}), -- Glimmer of Light (Artifact HoT)
	},
	SHAMAN = {
		[61295] = D['AuraWatch_AddSpell'](61295, "TOPRIGHT", {0.7, 0.3, 0.7}), 	 -- Riptide
		[974] = D['AuraWatch_AddSpell'](974, "BOTTOMRIGHT", {0.2, 0.2, 1}), 	 -- Earth Shield
	},
	MONK = {
		[119611] = D['AuraWatch_AddSpell'](119611, "TOPLEFT", {0.3, 0.8, 0.6}), -- Renewing Mist
		[116849] = D['AuraWatch_AddSpell'](116849, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Life Cocoon
		[124682] = D['AuraWatch_AddSpell'](124682, "BOTTOMLEFT", {0.8, 0.8, 0.25}), -- Enveloping Mist
		[191840] = D['AuraWatch_AddSpell'](191840, "BOTTOMRIGHT", {0.27, 0.62, 0.7}), -- Essence Font
	},
	ROGUE = {
		[57934] = D['AuraWatch_AddSpell'](57934, "TOPRIGHT", {0.89, 0.09, 0.05}),		 -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = D['AuraWatch_AddSpell'](114030, "TOPLEFT", {0.2, 0.2, 1}), 	 -- Vigilance
		[3411] = D['AuraWatch_AddSpell'](3411, "TOPRIGHT", {0.89, 0.09, 0.05}), 	 -- Intervene
	},
	PET = {
		-- Warlock Pets
		[193396] = D['AuraWatch_AddSpell'](193396, 'TOPRIGHT', {0.6, 0.2, 0.8}, true), -- Demonic Empowerment
		-- Hunter Pets
		[272790] = D['AuraWatch_AddSpell'](272790, 'TOPLEFT', {0.89, 0.09, 0.05}, true), -- Frenzy
		[136] = D['AuraWatch_AddSpell'](136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true) -- Mend Pet
	},
	HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	DEMONHUNTER = {},
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},
}