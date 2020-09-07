local D, C, L = unpack(select(2, ...))

-- Shadowlands Dungeon & Raid Debuffs

D['Debuffids'] = {
	--Shadowlands Dungeons & Raids
	-- Halls of Atonement
	[GetSpellInfo(335338)] = 3, -- Ritual of Woe
	[GetSpellInfo(326891)] = 3, -- Anguish
	[GetSpellInfo(329321)] = 3, -- Jagged Swipe
	[GetSpellInfo(319603)] = 3, -- Curse of Stone
	[GetSpellInfo(319611)] = 3, -- Turned to Stone
	[GetSpellInfo(325876)] = 3, -- Curse of Obliteration
	[GetSpellInfo(326632)] = 3, -- Stony Veins
	[GetSpellInfo(323650)] = 3, -- Haunting Fixation
	[GetSpellInfo(326874)] = 3, -- Ankle Bites

	-- Mists of Tirna Scithe
	[GetSpellInfo(325027)] = 3, -- Bramble Burst
	[GetSpellInfo(323043)] = 3, -- Bloodletting
	[GetSpellInfo(322557)] = 3, -- Soul Split
	[GetSpellInfo(331172)] = 3, -- Mind Link
	[GetSpellInfo(322563)] = 3, -- Marked Prey

	-- Plaguefall
	[GetSpellInfo(336258)] = 3, -- Solitary Prey
	[GetSpellInfo(331818)] = 3, -- Shadow Ambush
	[GetSpellInfo(329110)] = 3, -- Slime Injection
	[GetSpellInfo(325552)] = 3, -- Cytotoxic Slash
	[GetSpellInfo(336301)] = 3, -- Web Wrap

	-- The Necrotic Wake
	[GetSpellInfo(321821)] = 3, -- Disgusting Guts
	[GetSpellInfo(323365)] = 3, -- Clinging Darkness
	[GetSpellInfo(338353)] = 3, -- Goresplatter
	[GetSpellInfo(333485)] = 3, -- Disease Cloud
	[GetSpellInfo(338357)] = 3, -- Tenderize
	[GetSpellInfo(328181)] = 3, -- Frigid Cold
	[GetSpellInfo(320170)] = 3, -- Necrotic Bolt
	[GetSpellInfo(323464)] = 3, -- Dark Ichor
	[GetSpellInfo(323198)] = 3, -- Dark Exile

	-- Theater of Pain
	[GetSpellInfo(333299)] = 3, -- Curse of Desolation
	[GetSpellInfo(319539)] = 3, -- Soulless
	[GetSpellInfo(326892)] = 3, -- Fixate
	[GetSpellInfo(321768)] = 3, -- On the Hook
	[GetSpellInfo(323825)] = 3, -- Grasping Rift

	-- Sanguine Depths
	[GetSpellInfo(326827)] = 3, -- Dread Bindings
	[GetSpellInfo(326836)] = 3, -- Curse of Suppression
	[GetSpellInfo(322554)] = 3, -- Castigate
	[GetSpellInfo(321038)] = 3, -- Burden Soul

	-- Spires of Ascension
	[GetSpellInfo(338729)] = 3, -- Charged Stomp
	--[GetSpellInfo(338747)] = 3, -- Purifying Blast 	==> Throw error on Beta, maybe canceled skill, needs testing
	[GetSpellInfo(327481)] = 3, -- Dark Lance
	[GetSpellInfo(322818)] = 3, -- Lost Confidence
	[GetSpellInfo(322817)] = 3, -- Lingering Doubt

	-- De Other Side
	[GetSpellInfo(320786)] = 3, -- Power Overwhelming
	[GetSpellInfo(334913)] = 3, -- Master of Death
	[GetSpellInfo(325725)] = 3, -- Cosmic Artifice
	[GetSpellInfo(328987)] = 3, -- Zealous

	-- Castle Nathria
	-- Hungering Destroyer
	[GetSpellInfo(334228)] = 3, -- Volatile Ejection
	[GetSpellInfo(329298)] = 3, -- Gluttonous Miasma

	-- Lady Inerva Darkvein
	[GetSpellInfo(325936)] = 3, -- Shared Cognition
	[GetSpellInfo(335396)] = 3, -- Hidden Desire
	[GetSpellInfo(324983)] = 3, -- Shared Suffering
	[GetSpellInfo(324982)] = 3, -- Shared Suffering Partner
	[GetSpellInfo(332664)] = 3, -- Concentrate Anima
	[GetSpellInfo(325382)] = 3, -- Warped Desires

	-- Sun King's Salvation
	[GetSpellInfo(333002)] = 3, -- Vulgar Brand
	[GetSpellInfo(326078)] = 3, -- Infuser's Boon
	[GetSpellInfo(325251)] = 3, -- Sin of Pride

	-- Sludgefist
	[GetSpellInfo(335470)] = 3, -- Chain Slam
	[GetSpellInfo(339181)] = 3, -- Chain Slam (Root)
	[GetSpellInfo(331209)] = 3, -- Hateful Gaze
	[GetSpellInfo(335293)] = 3, -- Chain Link
	--[GetSpellInfo(335270)] = 3, -- Chain This One!	==> Throw error on Beta, maybe canceled skill, needs testing
	[GetSpellInfo(335295)] = 3, -- Shattering Chain

	-- Huntsman Altimor
	[GetSpellInfo(335304)] = 3, -- Sinseeker
	[GetSpellInfo(334971)] = 3, -- Jagged Claws
	[GetSpellInfo(335113)] = 3, -- Huntsman's Mark 1
	[GetSpellInfo(335112)] = 3, -- Huntsman's Mark 2
	[GetSpellInfo(335111)] = 3, -- Huntsman's Mark 3
	[GetSpellInfo(334945)] = 3, -- Bloody Thrash

	-- The Council of Blood
	[GetSpellInfo(327773)] = 3, -- Drain Essence 1
	[GetSpellInfo(327052)] = 3, -- Drain Essence 2
	[GetSpellInfo(328334)] = 3, -- Tactical Advance
	[GetSpellInfo(330848)] = 3, -- Wrong Moves
	[GetSpellInfo(331706)] = 3, -- Scarlet Letter
	[GetSpellInfo(331636)] = 3, -- Dark Recital 1
	[GetSpellInfo(331637)] = 3, -- Dark Recital 2

	-- Shriekwing
	[GetSpellInfo(328897)] = 3, -- Exsanguinated
	[GetSpellInfo(330713)] = 3, -- Reverberating Pain
	--[GetSpellInfo(329370)] = 3, -- Deadly Descent	==> Throw error on Beta, maybe canceled skill, needs testing
	--[GetSpellInfo(336494)] = 3, -- Echo Screech	==> Throw error on Beta, maybe canceled skill, needs testing

	-- Stone Legion Generals
	[GetSpellInfo(334498)] = 3, -- Seismic Upheaval
	[GetSpellInfo(333913)] = 3, -- Wicked Laceration
	[GetSpellInfo(337643)] = 3, -- Unstable Footing
	[GetSpellInfo(334765)] = 3, -- Stone Shatterer
	[GetSpellInfo(333377)] = 3, -- Wicked Mark
	[GetSpellInfo(334616)] = 3, -- Petrified
	[GetSpellInfo(334541)] = 3, -- Curse of Petrification

	-- Artificer Xy'mox
	[GetSpellInfo(327902)] = 3, -- Fixate
	[GetSpellInfo(326302)] = 3, -- Stasis Trap
	[GetSpellInfo(325236)] = 3, -- Glyph of Destruction
	[GetSpellInfo(327414)] = 3, -- Possession

	-- Sire Denathrius
	[GetSpellInfo(326851)] = 3, -- Blood Price
	[GetSpellInfo(327798)] = 3, -- Night Hunter
	[GetSpellInfo(327992)] = 3, -- Desolation
	[GetSpellInfo(328276)] = 3, -- March of the Penitent
	[GetSpellInfo(326699)] = 3, -- Burden of Sin
}