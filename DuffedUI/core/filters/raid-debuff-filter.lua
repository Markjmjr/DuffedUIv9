local D, C, L = unpack(select(2, ...))

D['Debuffids'] = {
	-- Battle for Azeroth
	-- Mythic+ Dungeons
	[GetSpellInfo(196376)] = 3, -- Grievous Tear
	[GetSpellInfo(209858)] = 3, -- Necrotic
	[GetSpellInfo(226512)] = 3, -- Sanguine
	[GetSpellInfo(240443)] = 3, -- Bursting
	[GetSpellInfo(240559)] = 3, -- Grievous
	[GetSpellInfo(277242)] = 3, -- Symbiote of G'huun (Infested)
	[GetSpellInfo(288388)] = 3, -- Reap Soul
	[GetSpellInfo(288694)] = 3, -- Shadow Smash

	-- Dungeons
	-- Freehold
	[GetSpellInfo(258323)] = 3, -- Infected Wound
	[GetSpellInfo(257775)] = 3, -- Plague Step
	[GetSpellInfo(257908)] = 3, -- Oiled Blade
	[GetSpellInfo(257436)] = 3, -- Poisoning Strike
	[GetSpellInfo(274389)] = 3, -- Rat Traps
	[GetSpellInfo(274555)] = 3, -- Scabrous Bites
	[GetSpellInfo(258875)] = 3, -- Blackout Barrel
	[GetSpellInfo(256363)] = 3, -- Ripper Punch

	-- Shrine of the Storm
	[GetSpellInfo(264560)] = 3, -- Choking Brine
	[GetSpellInfo(268233)] = 3, -- Electrifying Shock
	[GetSpellInfo(268322)] = 3, -- Touch of the Drowned
	[GetSpellInfo(268896)] = 3, -- Mind Rend
	[GetSpellInfo(268104)] = 3, -- Explosive Void
	[GetSpellInfo(267034)] = 3, -- Whispers of Power
	[GetSpellInfo(276268)] = 3, -- Heaving Blow
	[GetSpellInfo(264166)] = 3, -- Undertow
	[GetSpellInfo(264526)] = 3, -- Grasp of the Depths
	[GetSpellInfo(274633)] = 3, -- Sundering Blow
	[GetSpellInfo(268214)] = 3, -- Carving Flesh
	[GetSpellInfo(267818)] = 3, -- Slicing Blast
	[GetSpellInfo(268309)] = 3, -- Unending Darkness
	[GetSpellInfo(268317)] = 3, -- Rip Mind
	[GetSpellInfo(268391)] = 3, -- Mental Assault
	[GetSpellInfo(274720)] = 3, -- Abyssal Strike

	-- Siege of Boralus
	[GetSpellInfo(257168)] = 3, -- Cursed Slash
	[GetSpellInfo(272588)] = 3, -- Rotting Wounds
	[GetSpellInfo(272571)] = 3, -- Choking Waters
	[GetSpellInfo(274991)] = 3, -- Putrid Waters
	[GetSpellInfo(275835)] = 3, -- Stinging Venom Coating
	[GetSpellInfo(273930)] = 3, -- Hindering Cut
	[GetSpellInfo(257292)] = 3, -- Heavy Slash
	[GetSpellInfo(261428)] = 3, -- Hangman"s Noose
	[GetSpellInfo(256897)] = 3, -- Clamping Jaws
	[GetSpellInfo(272874)] = 3, -- Trample
	[GetSpellInfo(273470)] = 3, -- Gut Shot
	[GetSpellInfo(272834)] = 3, -- Viscous Slobber
	[GetSpellInfo(257169)] = 3, -- Terrifying Roar
	[GetSpellInfo(272713)] = 3, -- Crushing Slam

	-- Tol Dagor
	[GetSpellInfo(258128)] = 3, -- Debilitating Shout
	[GetSpellInfo(265889)] = 3, -- Torch Strike
	[GetSpellInfo(257791)] = 3, -- Howling Fear
	[GetSpellInfo(258864)] = 3, -- Suppression Fire
	[GetSpellInfo(257028)] = 3, -- Fuselighter
	[GetSpellInfo(258917)] = 3, -- Righteous Flames
	[GetSpellInfo(257777)] = 3, -- Crippling Shiv
	[GetSpellInfo(258079)] = 3, -- Massive Chomp
	[GetSpellInfo(258058)] = 3, -- Squeeze
	[GetSpellInfo(260016)] = 3, -- Itchy Bite
	[GetSpellInfo(257119)] = 3, -- Sand Trap
	[GetSpellInfo(260067)] = 3, -- Vicious Mauling
	[GetSpellInfo(258313)] = 3, -- Handcuff
	[GetSpellInfo(259711)] = 3, -- Lockdown
	[GetSpellInfo(256198)] = 3, -- Azerite Rounds: Incendiary
	[GetSpellInfo(256101)] = 3, -- Explosive Burst
	[GetSpellInfo(256044)] = 3, -- Deadeye
	[GetSpellInfo(256474)] = 3, -- Heartstopper Venom

	-- Waycrest Manor
	[GetSpellInfo(260703)] = 3, -- Unstable Runic Mark
	[GetSpellInfo(263905)] = 3, -- Marking Cleave
	[GetSpellInfo(265880)] = 3, -- Dread Mark
	[GetSpellInfo(265882)] = 3, -- Lingering Dread
	[GetSpellInfo(264105)] = 3, -- Runic Mark
	[GetSpellInfo(264050)] = 3, -- Infected Thorn
	[GetSpellInfo(261440)] = 3, -- Virulent Pathogen
	[GetSpellInfo(263891)] = 3, -- Grasping Thorns
	[GetSpellInfo(264378)] = 3, -- Fragment Soul
	[GetSpellInfo(266035)] = 3, -- Bone Splinter
	[GetSpellInfo(266036)] = 3, -- Drain Essence
	[GetSpellInfo(260907)] = 3, -- Soul Manipulation
	[GetSpellInfo(260741)] = 3, -- Jagged Nettles
	[GetSpellInfo(264556)] = 3, -- Tearing Strike
	[GetSpellInfo(265760)] = 3, -- Thorned Barrage
	[GetSpellInfo(260551)] = 3, -- Soul Thorns
	[GetSpellInfo(263943)] = 3, -- Etch
	[GetSpellInfo(265881)] = 3, -- Decaying Touch
	[GetSpellInfo(261438)] = 3, -- Wasting Strike
	[GetSpellInfo(268202)] = 3, -- Death Lens
	[GetSpellInfo(278456)] = 3, -- Infest

	-- Atal"Dazar
	[GetSpellInfo(252781)] = 3, -- Unstable Hex
	[GetSpellInfo(250096)] = 3, -- Wracking Pain
	[GetSpellInfo(250371)] = 3, -- Lingering Nausea
	[GetSpellInfo(253562)] = 3, -- Wildfire
	[GetSpellInfo(255582)] = 3, -- Molten Gold
	[GetSpellInfo(255041)] = 3, -- Terrifying Screech
	[GetSpellInfo(255371)] = 3, -- Terrifying Visage
	[GetSpellInfo(252687)] = 3, -- Venomfang Strike
	[GetSpellInfo(254959)] = 3, -- Soulburn
	[GetSpellInfo(255814)] = 3, -- Rending Maul
	[GetSpellInfo(255421)] = 3, -- Devour
	[GetSpellInfo(255434)] = 3, -- Serrated Teeth
	[GetSpellInfo(256577)] = 3, -- Soulfeast

	-- King's Rest
	[GetSpellInfo(270492)] = 3, -- Hex
	[GetSpellInfo(267763)] = 3, -- Wretched Discharge
	[GetSpellInfo(276031)] = 3, -- Pit of Despair
	[GetSpellInfo(265773)] = 3, -- Spit Gold
	[GetSpellInfo(270920)] = 3, -- Seduction
	[GetSpellInfo(270865)] = 3, -- Hidden Blade
	[GetSpellInfo(271564)] = 3, -- Embalming Fluid
	[GetSpellInfo(270507)] = 3, -- Poison Barrage
	[GetSpellInfo(267273)] = 3, -- Poison Nova
	[GetSpellInfo(270003)] = 3, -- Suppression Slam
	[GetSpellInfo(270084)] = 3, -- Axe Barrage
	[GetSpellInfo(267618)] = 3, -- Drain Fluids
	[GetSpellInfo(267626)] = 3, -- Dessication
	[GetSpellInfo(270487)] = 3, -- Severing Blade
	[GetSpellInfo(266238)] = 3, -- Shattered Defenses
	[GetSpellInfo(266231)] = 3, -- Severing Axe
	[GetSpellInfo(266191)] = 3, -- Whirling Axes
	[GetSpellInfo(272388)] = 3, -- Shadow Barrage
	[GetSpellInfo(271640)] = 3, -- Dark Revelation
	[GetSpellInfo(268796)] = 3, -- Impaling Spear

	-- Motherlode
	[GetSpellInfo(263074)] = 3, -- Festering Bite
	[GetSpellInfo(280605)] = 3, -- Brain Freeze
	[GetSpellInfo(257337)] = 3, -- Shocking Claw
	[GetSpellInfo(270882)] = 3, -- Blazing Azerite
	[GetSpellInfo(268797)] = 3, -- Transmute: Enemy to Goo
	[GetSpellInfo(259856)] = 3, -- Chemical Burn
	[GetSpellInfo(269302)] = 3, -- Toxic Blades
	[GetSpellInfo(280604)] = 3, -- Iced Spritzer
	[GetSpellInfo(257371)] = 3, -- Tear Gas
	[GetSpellInfo(257544)] = 3, -- Jagged Cut
	[GetSpellInfo(268846)] = 3, -- Echo Blade
	[GetSpellInfo(262794)] = 3, -- Energy Lash
	[GetSpellInfo(262513)] = 3, -- Azerite Heartseeker
	[GetSpellInfo(260829)] = 3, -- Homing Missle (travelling)
	[GetSpellInfo(260838)] = 3, -- Homing Missle (exploded)
	[GetSpellInfo(263637)] = 3, -- Clothesline

	-- Temple of Sethraliss
	[GetSpellInfo(269686)] = 3, -- Plague
	[GetSpellInfo(268013)] = 3, -- Flame Shock
	[GetSpellInfo(268008)] = 3, -- Snake Charm
	[GetSpellInfo(273563)] = 3, -- Neurotoxin
	[GetSpellInfo(272657)] = 3, -- Noxious Breath
	[GetSpellInfo(267027)] = 3, -- Cytotoxin
	[GetSpellInfo(272699)] = 3, -- Venomous Spit
	[GetSpellInfo(263371)] = 3, -- Conduction
	[GetSpellInfo(272655)] = 3, -- Scouring Sand
	[GetSpellInfo(263914)] = 3, -- Blinding Sand
	[GetSpellInfo(263958)] = 3, -- A Knot of Snakes
	[GetSpellInfo(266923)] = 3, -- Galvanize
	[GetSpellInfo(268007)] = 3, -- Heart Attack

	-- Underrot
	[GetSpellInfo(265468)] = 3, -- Withering Curse
	[GetSpellInfo(278961)] = 3, -- Decaying Mind
	[GetSpellInfo(259714)] = 3, -- Decaying Spores
	[GetSpellInfo(272180)] = 3, -- Death Bolt
	[GetSpellInfo(272609)] = 3, -- Maddening Gaze
	[GetSpellInfo(269301)] = 3, -- Putrid Blood
	[GetSpellInfo(265533)] = 3, -- Blood Maw
	[GetSpellInfo(265019)] = 3, -- Savage Cleave
	[GetSpellInfo(265377)] = 3, -- Hooked Snare
	[GetSpellInfo(265625)] = 3, -- Dark Omen
	[GetSpellInfo(260685)] = 3, -- Taint of G"huun
	[GetSpellInfo(266107)] = 3, -- Thirst for Blood
	[GetSpellInfo(260455)] = 3, -- Serrated Fangs
	
	-- Operation: Mechagon
	[GetSpellInfo(291928)] = 3, -- Giga-Zap
	[GetSpellInfo(292267)] = 3, -- Giga-Zap
	[GetSpellInfo(302274)] = 3, -- Fulminating Zap
	[GetSpellInfo(298669)] = 3, -- Taze
	[GetSpellInfo(295445)] = 3, -- Wreck
	[GetSpellInfo(294929)] = 3, -- Blazing Chomp
	[GetSpellInfo(297257)] = 3, -- Electrical Charge
	[GetSpellInfo(294855)] = 3, -- Blossom Blast
	[GetSpellInfo(291972)] = 3, -- Explosive Leap
	[GetSpellInfo(285443)] = 3, -- "Hidden" Flame Cannon
	[GetSpellInfo(291974)] = 3, -- Obnoxious Monologue
	[GetSpellInfo(296150)] = 3, -- Vent Blast
	[GetSpellInfo(298602)] = 3, -- Smoke Cloud
	[GetSpellInfo(296560)] = 3, -- Clinging Static
	[GetSpellInfo(297283)] = 3, -- Cave In
	[GetSpellInfo(291914)] = 3, -- Cutting Beam
	[GetSpellInfo(302384)] = 3, -- Static Discharge

	-- Raids
	-- Nyalotha
	-- Wrathion
	[GetSpellInfo(313250)] = 3, -- Creeping Madness
	[GetSpellInfo(306163)] = 3, -- Incineration
	[GetSpellInfo(306015)] = 3, -- Searing Armor [tank]

	-- Maut
	[GetSpellInfo(307805)] = 3, -- Devour Magic
	[GetSpellInfo(314337)] = 3, -- Ancient Curse
	[GetSpellInfo(306301)] = 3, -- Forbidden Mana
	[GetSpellInfo(314992)] = 3, -- Darin Essence
	[GetSpellInfo(307399)] = 3, -- Shadow Claws [tank]

	-- Prophet Skitra
	[GetSpellInfo(306387)] = 3, -- Shadow Shock
	[GetSpellInfo(313276)] = 3, -- Shred Psyche

	-- Dark Inquisitor
	[GetSpellInfo(306311)] = 3, -- Soul Flay
	[GetSpellInfo(312406)] = 3, -- Void Woken
	[GetSpellInfo(311551)] = 3, -- Abyssal Strike [tank]

	-- Hivemind
	[GetSpellInfo(313461)] = 3, -- Corrosion
	[GetSpellInfo(313672)] = 3, -- Acid Pool
	[GetSpellInfo(313460)] = 3, -- Nullification

	-- Shadhar
	[GetSpellInfo(307471)] = 3, -- Crush [tank]
	[GetSpellInfo(307472)] = 3, -- Dissolve [tank]
	[GetSpellInfo(307358)] = 3, -- Debilitating Spit
	[GetSpellInfo(306928)] = 3, -- Umbral Breath
	[GetSpellInfo(312530)] = 3, -- Entropic Breath
	[GetSpellInfo(306929)] = 3, -- Bubbling Breath

	-- Drest
	[GetSpellInfo(310406)] = 3, -- Void Glare
	[GetSpellInfo(310277)] = 3, -- Volatile Seed [tank]
	[GetSpellInfo(310309)] = 3, -- Volatile Vulnerability
	[GetSpellInfo(310358)] = 3, -- Mutterings of Insanity
	[GetSpellInfo(310552)] = 3, -- Mind Flay
	[GetSpellInfo(310478)] = 3, -- Void Miasma

	-- Ilgy
	[GetSpellInfo(309961)] = 3, -- Eye of Nzoth [tank]
	[GetSpellInfo(310322)] = 3, -- Morass of Corruption
	[GetSpellInfo(311401)] = 3, -- Touch of the Corruptor
	[GetSpellInfo(314396)] = 3, -- Cursed Blood
	[GetSpellInfo(275269)] = 3, -- Fixate
	[GetSpellInfo(312486)] = 3, -- Recurring Nightmare

	-- Vexiona
	[GetSpellInfo(307317)] = 3, -- Encroaching Shadows
	[GetSpellInfo(307359)] = 3, -- Despair
	[GetSpellInfo(315932)] = 3, -- Brutal Smash
	[GetSpellInfo(307218)] = 3, -- Twilight Decimator
	[GetSpellInfo(307284)] = 3, -- Terrifying Presence
	[GetSpellInfo(307421)] = 3, -- Annihilation

	-- Raden
	[GetSpellInfo(306819)] = 3, -- Nullifying Strike [GetSpellInfo(tank]
	[GetSpellInfo(306279)] = 3, -- Insanity Exposure
	[GetSpellInfo(315258)] = 3, -- Dread Inferno
	[GetSpellInfo(306257)] = 3, -- Unstable Vita
	[GetSpellInfo(313227)] = 3, -- Decaying Wound
	[GetSpellInfo(310019)] = 3, -- Charged Bonds
	[GetSpellInfo(316065)] = 3, -- Corrupted Existence

	-- Carapace
	[GetSpellInfo(315954)] = 3, -- Black Scar [tank]
	[GetSpellInfo(306973)] = 3, -- Madness
	[GetSpellInfo(316848)] = 3, -- Adaptive Membrane
	[GetSpellInfo(307044)] = 3, -- Nightmare Antibody
	[GetSpellInfo(313364)] = 3, -- Mental Decay
	[GetSpellInfo(317627)] = 3, -- Infinite Void

	-- Nzoth
	[GetSpellInfo(318442)] = 3, -- Paranoia
	[GetSpellInfo(313400)] = 3, -- Corrupted Mind
	[GetSpellInfo(313793)] = 3, -- Flames of Insanity
	[GetSpellInfo(316771)] = 3, -- Mindwrack
	[GetSpellInfo(314889)] = 3, -- Probe Mind
	[GetSpellInfo(317112)] = 3, -- Evoke Anguish
	[GetSpellInfo(318976)] = 3, -- Stupefying Glare

	-- Eternal Palace
	--Lady Ashvane
	[GetSpellInfo(296693)] = 3, -- Waterlogged
	[GetSpellInfo(296725)] = 3, -- Barnacle Bash
	[GetSpellInfo(296942)] = 3, -- Arcing Azerite
	[GetSpellInfo(296938)] = 3, -- Arcing Azerite
	[GetSpellInfo(296941)] = 3, -- Arcing Azerite
	[GetSpellInfo(296939)] = 3, -- Arcing Azerite
	[GetSpellInfo(296943)] = 3, -- Arcing Azerite
	[GetSpellInfo(296940)] = 3, -- Arcing Azerite
	[GetSpellInfo(296752)] = 3, -- Cutting Coral
	[GetSpellInfo(297333)] = 3, -- Briny Bubble
	[GetSpellInfo(297397)] = 3, -- Briny Bubble

	--Abyssal Commander Sivara
	[GetSpellInfo(300701)] = 3, -- Rimefrost
	[GetSpellInfo(300705)] = 3, -- Septic Taint
	[GetSpellInfo(294847)] = 3, -- Unstable Mixture
	[GetSpellInfo(295850)] = 3, -- Delirious
	[GetSpellInfo(295421)] = 3, -- Overflowing Venom
	[GetSpellInfo(295348)] = 3, -- Overflowing Chill
	[GetSpellInfo(295807)] = 3, -- Frozen
	[GetSpellInfo(300883)] = 3, -- Inversion Sickness
	[GetSpellInfo(295705)] = 3, -- Toxic Bolt
	[GetSpellInfo(294711)] = 3, -- Frost Mark
	[GetSpellInfo(294715)] = 3, -- Toxic Brand

	--The Queen’s Court
	[GetSpellInfo(301830)] = 3, -- Pashmar's Touch
	[GetSpellInfo(296851)] = 3, -- Fanatical Verdict
	[GetSpellInfo(297836)] = 3, -- Potent Spark
	[GetSpellInfo(297586)] = 3, -- Suffering
	[GetSpellInfo(304410)] = 3, -- Repeat Performance
	[GetSpellInfo(299914)] = 3, -- Frenetic Charge
	[GetSpellInfo(303306)] = 3, -- Sphere of Influence
	[GetSpellInfo(300545)] = 3, -- Mighty Rupture

	--Radiance of Azshara
	[GetSpellInfo(296566)] = 3, -- Tide Fist
	[GetSpellInfo(296737)] = 3, -- Arcane Bomb
	[GetSpellInfo(296746)] = 3, -- Arcane Bomb
	[GetSpellInfo(295920)] = 3, -- Ancient Tempest
	[GetSpellInfo(296462)] = 3, -- Squall Trap
	[GetSpellInfo(299152)] = 3, -- Waterlogged

	--Orgozoa
	[GetSpellInfo(298156)] = 3, -- Desensitizing Sting
	[GetSpellInfo(298306)] = 3, -- Incubation Fluid

	--Blackwater Behemoth
	[GetSpellInfo(292127)] = 3, -- Darkest Depths
	[GetSpellInfo(292138)] = 3, -- Radiant Biomass
	[GetSpellInfo(292167)] = 3, -- Toxic Spine
	[GetSpellInfo(301494)] = 3, -- Piercing Barb

	--Za’qul
	[GetSpellInfo(295495)] = 3, -- Mind Tether
	[GetSpellInfo(295480)] = 3, -- Mind Tether
	[GetSpellInfo(295249)] = 3, -- Delirium Realm
	[GetSpellInfo(303819)] = 3, -- Nightmare Pool
	[GetSpellInfo(293509)] = 3, -- Manifest Nightmares
	[GetSpellInfo(295327)] = 3, -- Shattered Psyche
	[GetSpellInfo(294545)] = 3, -- Portal of Madness
	[GetSpellInfo(298192)] = 3, -- Dark Beyond
	[GetSpellInfo(292963)] = 3, -- Dread
	[GetSpellInfo(300133)] = 3, -- Snapped

	--Queen Azshara
	[GetSpellInfo(298781)] = 3, -- Arcane Orb
	[GetSpellInfo(297907)] = 3, -- Cursed Heart
	[GetSpellInfo(302999)] = 3, -- Arcane Vulnerability
	[GetSpellInfo(302141)] = 3, -- Beckon
	[GetSpellInfo(299276)] = 3, -- Sanction
	[GetSpellInfo(303657)] = 3, -- Arcane Burst
	[GetSpellInfo(298756)] = 3, -- Serrated Edge
	[GetSpellInfo(301078)] = 3, -- Charged Spear
	[GetSpellInfo(298014)] = 3, -- Cold Blast
	[GetSpellInfo(298018)] = 3, -- Frozen
	
	-- Uldir
	-- MOTHER
	[GetSpellInfo(268277)] = 3, -- Purifying Flame
	[GetSpellInfo(268253)] = 3, -- Surgical Beam
	[GetSpellInfo(268095)] = 3, -- Cleansing Purge
	[GetSpellInfo(267787)] = 3, -- Sundering Scalpel
	[GetSpellInfo(268198)] = 3, -- Clinging Corruption
	[GetSpellInfo(267821)] = 3, -- Defense Grid

	-- Vectis
	[GetSpellInfo(265127)] = 3, -- Lingering Infection
	[GetSpellInfo(265178)] = 3, -- Mutagenic Pathogen
	[GetSpellInfo(265206)] = 3, -- Immunosuppression
	[GetSpellInfo(265212)] = 3, -- Gestate
	[GetSpellInfo(265129)] = 3, -- Omega Vector
	[GetSpellInfo(267160)] = 3, -- Omega Vector
	[GetSpellInfo(267161)] = 3, -- Omega Vector
	[GetSpellInfo(267162)] = 3, -- Omega Vector
	[GetSpellInfo(267163)] = 3, -- Omega Vector
	[GetSpellInfo(267164)] = 3, -- Omega Vector

	-- Mythrax
	--[GetSpellInfo(272146)] = 3, -- Annihilation
	[GetSpellInfo(272536)] = 3, -- Imminent Ruin
	[GetSpellInfo(274693)] = 3, -- Essence Shear
	[GetSpellInfo(272407)] = 3, -- Oblivion Sphere

	-- Fetid Devourer
	[GetSpellInfo(262313)] = 3, -- Malodorous Miasma
	[GetSpellInfo(262292)] = 3, -- Rotting Regurgitation
	[GetSpellInfo(262314)] = 3, -- Deadly Disease

	-- Taloc
	[GetSpellInfo(270290)] = 3, -- Blood Storm
	[GetSpellInfo(275270)] = 3, -- Fixate
	[GetSpellInfo(271224)] = 3, -- Plasma Discharge
	[GetSpellInfo(271225)] = 3, -- Plasma Discharge

	-- Zul
	[GetSpellInfo(273365)] = 3, -- Dark Revelation
	[GetSpellInfo(273434)] = 3, -- Pit of Despair
	[GetSpellInfo(274195)] = 3, -- Corrupted Blood
	[GetSpellInfo(272018)] = 3, -- Absorbed in Darkness

	-- Zek'voz, Herald of N'zoth
	[GetSpellInfo(265237)] = 3, -- Shatter
	[GetSpellInfo(265264)] = 3, -- Void Lash
	[GetSpellInfo(265360)] = 3, -- Roiling Deceit
	[GetSpellInfo(265662)] = 3, -- Corruptor's Pact
	[GetSpellInfo(265646)] = 3, -- Will of the Corruptor

	-- G'huun
	[GetSpellInfo(263436)] = 3, -- Imperfect Physiology
	[GetSpellInfo(263227)] = 3, -- Putrid Blood
	[GetSpellInfo(263372)] = 3, -- Power Matrix
	[GetSpellInfo(272506)] = 3, -- Explosive Corruption
	[GetSpellInfo(267409)] = 3, -- Dark Bargain
	[GetSpellInfo(267430)] = 3, -- Torment
	[GetSpellInfo(263235)] = 3, -- Blood Feast
	[GetSpellInfo(270287)] = 3, -- Blighted Ground

	-- Siege of Zuldazar
	-- Ra'wani Kanae/Frida Ironbellows
	[GetSpellInfo(283573)] = 3, -- Sacred Blade
	[GetSpellInfo(283617)] = 3, -- Wave of Light
	[GetSpellInfo(283651)] = 3, -- Blinding Faith
	[GetSpellInfo(284595)] = 3, -- Penance
	[GetSpellInfo(283582)] = 3, -- Consecration

	-- Grong
	[GetSpellInfo(285998)] = 3, -- Ferocious Roar
	[GetSpellInfo(283069)] = 3, -- Megatomic Fire
	[GetSpellInfo(285671)] = 3, -- Crushed
	[GetSpellInfo(285875)] = 3, -- Rending Bite
	--[GetSpellInfo(282010)] = 3, -- Shaken

	-- Jaina
	[GetSpellInfo(285253)] = 3, -- Ice Shard
	[GetSpellInfo(287993)] = 3, -- Chilling Touch
	[GetSpellInfo(287365)] = 3, -- Searing Pitch
	[GetSpellInfo(288038)] = 3, -- Marked Target
	[GetSpellInfo(285254)] = 3, -- Avalanche
	[GetSpellInfo(287626)] = 3, -- Grasp of Frost
	[GetSpellInfo(287490)] = 3, -- Frozen Solid
	[GetSpellInfo(287199)] = 3, -- Ring of Ice
	[GetSpellInfo(288392)] = 3, -- Vengeful Seas

	-- Stormwall Blockade
	[GetSpellInfo(284369)] = 3, -- Sea Storm
	[GetSpellInfo(284410)] = 3, -- Tempting Song
	[GetSpellInfo(284405)] = 3, -- Tempting Song
	[GetSpellInfo(284121)] = 3, -- Thunderous Boom
	[GetSpellInfo(286680)] = 3, -- Roiling Tides

	-- Opulence
	[GetSpellInfo(286501)] = 3, -- Creeping Blaze
	[GetSpellInfo(283610)] = 3, -- Crush
	[GetSpellInfo(289383)] = 3, -- Chaotic Displacement
	[GetSpellInfo(285479)] = 3, -- Flame Jet
	[GetSpellInfo(283063)] = 3, -- Flames of Punishment
	[GetSpellInfo(283507)] = 3, -- Volatile Charge

	-- King Rastakhan
	[GetSpellInfo(284995)] = 3, -- Zombie Dust
	[GetSpellInfo(285349)] = 3, -- Plague of Fire
	[GetSpellInfo(285044)] = 3, -- Toad Toxin
	[GetSpellInfo(284831)] = 3, -- Scorching Detonation
	[GetSpellInfo(289858)] = 3, -- Crushed
	[GetSpellInfo(284662)] = 3, -- Seal of Purification
	[GetSpellInfo(284676)] = 3, -- Seal of Purification
	[GetSpellInfo(285178)] = 3, -- Serpent's Breath
	[GetSpellInfo(285010)] = 3, -- Poison Toad Slime

	-- Jadefire Masters
	[GetSpellInfo(282037)] = 3, -- Rising Flames
	[GetSpellInfo(284374)] = 3, -- Magma Trap
	[GetSpellInfo(285632)] = 3, -- Stalking
	[GetSpellInfo(288151)] = 3, -- Tested
	[GetSpellInfo(284089)] = 3, -- Successful Defense
	[GetSpellInfo(286988)] = 3, -- Searing Embers

	-- Mekkatorque
	[GetSpellInfo(288806)] = 3, -- Gigavolt Blast
	[GetSpellInfo(289023)] = 3, -- Enormous
	[GetSpellInfo(286646)] = 3, -- Gigavolt Charge
	[GetSpellInfo(288939)] = 3, -- Gigavolt Radiation
	[GetSpellInfo(284168)] = 3, -- Shrunk
	[GetSpellInfo(286516)] = 3, -- Anti-Tampering Shock
	[GetSpellInfo(286480)] = 3, -- Anti-Tampering Shock
	[GetSpellInfo(284214)] = 3, -- Trample

	-- Conclave of the Chosen
	[GetSpellInfo(284663)] = 3, -- Bwonsamdi's Wrath
	[GetSpellInfo(282444)] = 3, -- Lacerating Claws
	[GetSpellInfo(282592)] = 3, -- Bleeding Wounds
	[GetSpellInfo(282209)] = 3, -- Mark of Prey
	[GetSpellInfo(285879)] = 3, -- Mind Wipe
	[GetSpellInfo(282135)] = 3, -- Crawling Hex
	[GetSpellInfo(286060)] = 3, -- Cry of the Fallen
	[GetSpellInfo(282447)] = 3, -- Kimbul's Wrath
	[GetSpellInfo(282834)] = 3, -- Kimbul's Wrath
	[GetSpellInfo(286811)] = 3, -- Akunda's Wrath
	[GetSpellInfo(286838)] = 3, -- Static Orb

	-- Crucible of Storms
	-- The Restless Cabal
	[GetSpellInfo(282386)] = 3, -- Aphotic Blast
	[GetSpellInfo(282384)] = 3, -- Shear Mind
	[GetSpellInfo(282566)] = 3, -- Promises of Power
	[GetSpellInfo(282561)] = 3, -- Dark Herald
	[GetSpellInfo(282432)] = 3, -- Crushing Doubt
	[GetSpellInfo(282589)] = 3, -- Mind Scramble
	[GetSpellInfo(292826)] = 3, -- Mind Scramble

	-- Fa'thuul the Feared
	[GetSpellInfo(284851)] = 3, -- Touch of the End
	[GetSpellInfo(286459)] = 3, -- Feedback: Void
	[GetSpellInfo(286457)] = 3, -- Feedback: Ocean
	[GetSpellInfo(286458)] = 3, -- Feedback: Storm
	[GetSpellInfo(285367)] = 3, -- Piercing Gaze of N'Zoth
	[GetSpellInfo(284733)] = 3, -- Embrace of the Void
	[GetSpellInfo(284722)] = 3, -- Umbral Shell
	[GetSpellInfo(285345)] = 3, -- Maddening Eyes of N'Zoth
	[GetSpellInfo(285477)] = 3, -- Obscurity
	[GetSpellInfo(285652)] = 3, -- Insatiable Torment

	-- Legion Raids
	-- Antorus, the Burning Throne
	-- Garothi Worldbreaker
	[GetSpellInfo(244590)] = 3, -- Molten Hot Fel
	[GetSpellInfo(244761)] = 3, -- Annihilation
	[GetSpellInfo(246920)] = 3, -- Haywire Decimation
	[GetSpellInfo(246369)] = 3, -- Searing Barrage
	[GetSpellInfo(246848)] = 3, -- Luring Destruction
	[GetSpellInfo(246220)] = 3, -- Fel Bombardment
	[GetSpellInfo(247159)] = 3, -- Luring Destruction
	[GetSpellInfo(244122)] = 3, -- Carnage
	[GetSpellInfo(244410)] = 3, -- Decimation
	[GetSpellInfo(245294)] = 3, -- Empowered Decimation
	[GetSpellInfo(246368)] = 3, -- Searing Barrage

	-- Felhounds of Sargeras
	[GetSpellInfo(245022)] = 3, -- Burning Remnant
	[GetSpellInfo(251445)] = 3, -- Smouldering
	[GetSpellInfo(251448)] = 3, -- Burning Maw
	[GetSpellInfo(244086)] = 5, -- Molten Touch
	[GetSpellInfo(244091)] = 3, -- Singed
	[GetSpellInfo(244768)] = 3, -- Desolate Gaze
	[GetSpellInfo(244767)] = 3, -- Desolate Path
	[GetSpellInfo(244471)] = 4, -- Enflame Corruption
	[GetSpellInfo(248815)] = 4, -- Enflamed
	[GetSpellInfo(244517)] = 3, -- Lingering Flames
	[GetSpellInfo(245098)] = 3, -- Decay
	[GetSpellInfo(251447)] = 3, -- Corrupting Maw
	[GetSpellInfo(244131)] = 3, -- Consuming Sphere
	[GetSpellInfo(245024)] = 3, -- Consumed
	[GetSpellInfo(244071)] = 3, -- Weight of Darkness
	[GetSpellInfo(244578)] = 3, -- Siphon Corruption
	[GetSpellInfo(248819)] = 3, -- Siphoned
	[GetSpellInfo(254429)] = 3, -- Weight of Darkness
	[GetSpellInfo(244072)] = 3, -- Molten Touch

	-- Antoran High Command
	[GetSpellInfo(245121)] = 3, -- Entropic Blast
	[GetSpellInfo(244748)] = 3, -- Shocked
	[GetSpellInfo(244824)] = 3, -- Warp Field
	[GetSpellInfo(244892)] = 3, -- Exploit Weakness
	[GetSpellInfo(244172)] = 3, -- Psychic Assault
	[GetSpellInfo(244388)] = 3, -- Psychic Scarring
	[GetSpellInfo(244420)] = 3, -- Chaos Pulse
	[GetSpellInfo(254771)] = 3, -- Disruption Field
	[GetSpellInfo(257974)] = 5, -- Chaos Pulse
	[GetSpellInfo(244910)] = 3, -- Felshield
	[GetSpellInfo(244737)] = 6, -- Shock Grenade

	-- Portal Keeper Hasabel
	[GetSpellInfo(244016)] = 3, -- Reality Tear
	[GetSpellInfo(245157)] = 3, -- Everburning Light
	[GetSpellInfo(245075)] = 3, -- Hungering Gloom
	[GetSpellInfo(245240)] = 3, -- Oppressive Gloom
	[GetSpellInfo(244709)] = 3, -- Fiery Detonation
	[GetSpellInfo(246208)] = 3, -- Acidic Web
	[GetSpellInfo(246075)] = 3, -- Catastrophic Implosion
	[GetSpellInfo(244826)] = 3, -- Fel Miasma
	[GetSpellInfo(246316)] = 3, -- Poison Essence
	[GetSpellInfo(244849)] = 3, -- Caustic Slime
	[GetSpellInfo(245118)] = 3, -- Cloying Shadows
	[GetSpellInfo(245050)] = 3, -- Delusions
	[GetSpellInfo(245040)] = 3, -- Corrupt
	[GetSpellInfo(244607)] = 3, -- Flames of Xoroth
	[GetSpellInfo(244915)] = 3, -- Leech Essence
	[GetSpellInfo(244926)] = 3, -- Felsilk Wrap
	[GetSpellInfo(244949)] = 3, -- Felsilk Wrap
	[GetSpellInfo(244613)] = 3, -- Everburning Flames

	-- Eonar the Life-Binder
	[GetSpellInfo(248326)] = 3, -- Rain of Fel
	[GetSpellInfo(248861)] = 5, -- Spear of Doom
	[GetSpellInfo(249016)] = 3, -- Feedback - Targeted
	[GetSpellInfo(249015)] = 3, -- Feedback - Burning Embers
	[GetSpellInfo(249014)] = 3, -- Feedback - Foul Steps
	[GetSpellInfo(249017)] = 3, -- Feedback - Arcane Singularity
	[GetSpellInfo(250693)] = 3, -- Arcane Buildup
	[GetSpellInfo(250691)] = 3, -- Burning Embers
	[GetSpellInfo(248795)] = 3, -- Fel Wake
	[GetSpellInfo(248332)] = 4, -- Rain of Fel
	[GetSpellInfo(250140)] = 3, -- Foul Steps

	-- Imonar the Soulhunter
	[GetSpellInfo(248424)] = 3, -- Gathering Power
	[GetSpellInfo(247552)] = 5, -- Sleep Canister
	[GetSpellInfo(247565)] = 5, -- Slumber Gas
	[GetSpellInfo(250224)] = 3, -- Shocked
	[GetSpellInfo(248252)] = 3, -- Infernal Rockets
	[GetSpellInfo(247687)] = 3, -- Sever
	[GetSpellInfo(247716)] = 3, -- Charged Blasts
	[GetSpellInfo(247367)] = 4, -- Shock Lance
	[GetSpellInfo(250255)] = 3, -- Empowered Shock Lance
	[GetSpellInfo(247641)] = 4, -- Stasis Trap
	[GetSpellInfo(255029)] = 5, -- Sleep Canister
	[GetSpellInfo(248321)] = 3, -- Conflagration
	[GetSpellInfo(247932)] = 3, -- Shrapnel Blast
	[GetSpellInfo(248070)] = 3, -- Empowered Shrapnel Blast
	[GetSpellInfo(254183)] = 5, -- Seared Skin

	-- Kin'garoth
	[GetSpellInfo(233062)] = 3, -- Infernal Burning
	[GetSpellInfo(230345)] = 3, -- Crashing Comet
	[GetSpellInfo(244312)] = 5, -- Forging Strike
	[GetSpellInfo(246840)] = 3, -- Ruiner
	[GetSpellInfo(248061)] = 3, -- Purging Protocol
	[GetSpellInfo(249686)] = 3, -- Reverberating Decimation
	[GetSpellInfo(246706)] = 6, -- Demolish
	[GetSpellInfo(246698)] = 6, -- Demolish
	[GetSpellInfo(245919)] = 3, -- Meteor Swarm
	[GetSpellInfo(245770)] = 3, -- Decimation

	-- Varimathras
	[GetSpellInfo(244042)] = 5, -- Marked Prey
	[GetSpellInfo(243961)] = 5, -- Misery
	[GetSpellInfo(248732)] = 3, -- Echoes of Doom
	[GetSpellInfo(243973)] = 3, -- Torment of Shadows
	[GetSpellInfo(244005)] = 3, -- Dark Fissure
	[GetSpellInfo(244093)] = 6, -- Necrotic Embrace
	[GetSpellInfo(244094)] = 6, -- Necrotic Embrace

	-- The Coven of Shivarra
	[GetSpellInfo(244899)] = 4, -- Fiery Strike
	[GetSpellInfo(245518)] = 4, -- Flashfreeze
	[GetSpellInfo(245586)] = 5, -- Chilled Blood
	[GetSpellInfo(246763)] = 3, -- Fury of Golganneth
	[GetSpellInfo(245674)] = 3, -- Flames of Khaz'goroth
	[GetSpellInfo(245671)] = 3, -- Flames of Khaz'goroth
	[GetSpellInfo(245910)] = 3, -- Spectral Army of Norgannon
	[GetSpellInfo(253520)] = 3, -- Fulminating Pulse
	[GetSpellInfo(245634)] = 3, -- Whirling Saber
	[GetSpellInfo(253020)] = 3, -- Storm of Darkness
	[GetSpellInfo(245921)] = 3, -- Spectral Army of Norgannon
	[GetSpellInfo(250757)] = 3, -- Cosmic Glare

	-- Aggramar
	[GetSpellInfo(244291)] = 3, -- Foe Breaker
	[GetSpellInfo(255060)] = 3, -- Empowered Foe Breaker
	[GetSpellInfo(245995)] = 4, -- Scorching Blaze
	[GetSpellInfo(246014)] = 3, -- Searing Tempest
	[GetSpellInfo(244912)] = 3, -- Blazing Eruption
	[GetSpellInfo(247135)] = 3, -- Scorched Earth
	[GetSpellInfo(247091)] = 3, -- Catalyzed
	[GetSpellInfo(245631)] = 3, -- Unchecked Flame
	[GetSpellInfo(245916)] = 3, -- Molten Remnants
	[GetSpellInfo(245990)] = 4, -- Taeshalach's Reach
	[GetSpellInfo(254452)] = 3, -- Ravenous Blaze
	[GetSpellInfo(244736)] = 3, -- Wake of Flame
	[GetSpellInfo(247079)] = 3, -- Empowered Flame Rend

	-- Argus the Unmaker
	[GetSpellInfo(251815)] = 3, -- Edge of Obliteration
	[GetSpellInfo(248499)] = 4, -- Sweeping Scythe
	[GetSpellInfo(250669)] = 5, -- Soulburst
	[GetSpellInfo(251570)] = 6, -- Soulbomb
	[GetSpellInfo(248396)] = 6, -- Soulblight
	[GetSpellInfo(258039)] = 3, -- Deadly Scythe
	[GetSpellInfo(252729)] = 3, -- Cosmic Ray
	[GetSpellInfo(256899)] = 4, -- Soul Detonation
	[GetSpellInfo(252634)] = 4, -- Cosmic Smash
	[GetSpellInfo(252616)] = 4, -- Cosmic Beacon
	[GetSpellInfo(255200)] = 3, -- Aggramar's Boon
	[GetSpellInfo(255199)] = 4, -- Avatar of Aggramar
	[GetSpellInfo(258647)] = 3, -- Gift of the Sea
	[GetSpellInfo(253901)] = 3, -- Strength of the Sea
	[GetSpellInfo(257299)] = 4, -- Ember of Rage
	[GetSpellInfo(248167)] = 3, -- Death Fog
	[GetSpellInfo(258646)] = 3, -- Gift of the Sky
	[GetSpellInfo(253903)] = 3, -- Strength of the Sky
}