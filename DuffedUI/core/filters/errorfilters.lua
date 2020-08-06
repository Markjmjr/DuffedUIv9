local D, C, L = unpack(select(2, ...))

if C['general']['errorfilter'] ~= true then return end

D['errorfilter'] = {
	[INVENTORY_FULL] = true,
	[ERR_PARTY_LFG_BOOT_COOLDOWN_S] = true,
	[ERR_PARTY_LFG_BOOT_LIMIT] = true,
	[ERR_PETBATTLE_NOT_HERE] = true,
	[ERR_PETBATTLE_NOT_WHILE_IN_COMBAT] = true,
	[ERR_CANT_USE_ITEM] = true,
	[CANT_USE_ITEM] = true,
	[SPELL_FAILED_NOT_FISHABLE] = true,
}