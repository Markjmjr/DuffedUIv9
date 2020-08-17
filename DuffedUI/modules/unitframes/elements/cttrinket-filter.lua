local D, C, L = unpack(select(2, ...))

D['TrinketFilter'] = {
	--[[Proccs & Racials]]--
	D['CreateSpellEntry'](2825, true), D['CreateSpellEntry'](32182, true), D['CreateSpellEntry'](80353, true), -- Bloodlust/Heroism/Timewarp
	D['CreateSpellEntry'](90355, true), -- Ancient Hysteria, bloodlust from hunters pet
	D['CreateSpellEntry'](26297), -- Berserking (troll racial)
	D['CreateSpellEntry'](33702), D['CreateSpellEntry'](33697), D['CreateSpellEntry'](20572), -- Blood Fury (orc racial)
	D['CreateSpellEntry'](57933), -- Tricks of Trade (15% dmg buff)
	D['CreateSpellEntry'](121279), -- Lifeblood
	D['CreateSpellEntry'](45861), -- Nitro Boost (Engeneering)
	D['CreateSpellEntry'](68992), -- Darkflight (Worgen Sprint Racial)

	--[[Darkmoon-Trinkets]]--
	D['CreateSpellEntry'](162915), -- Spirit of the Warlords (Skull of War)
	D['CreateSpellEntry'](162913), -- Visions of the Future (Winged Hourglass)
	D['CreateSpellEntry'](162919), -- Nightmare Fire (Sandman's Pouch)
	D['CreateSpellEntry'](162917), -- Strength of Steel (Knight's Badge)

	--[[Legendarys]]--
	D['CreateSpellEntry'](235169), -- Archimonde's Hatred Reborn
}