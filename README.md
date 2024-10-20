CM's mode is added to PhalanxBot(7.37).

Currently, both teams required to have a human captain.

Copy and paste hero_selection.lua file to folder \Steam\steamapps\workshop\content\570\2873408973. AP game mode remains unchanged.

Captain's mode utilizes picks order for role decision.So:

Pick 1 and 5 -> Safe lane

Pick 2 -> Mid lane

Pick 3 and 4 -> Offlane

You must be sure that the hero that you pick for the role is included in PhalanxRoles file in directory \Steam\steamapps\workshop\content\570\2873408973\Library

You may find below a list of heroes that the bot can play for each role as well by defualt.

PRoles["SafeLane"] = {
	"npc_dota_hero_nevermore",
	"npc_dota_hero_sven",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_antimage",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_luna",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_meepo",
	"npc_dota_hero_medusa",
	"npc_dota_hero_ursa",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_slark",
	"npc_dota_hero_spectre",
	"npc_dota_hero_razor",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_sniper",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_zuus",
	"npc_dota_hero_riki",
	"npc_dota_hero_lina",
	"npc_dota_hero_weaver",
}

PRoles["MidLane"] = {
	"npc_dota_hero_nevermore",
	"npc_dota_hero_sniper",
	"npc_dota_hero_viper",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_huskar",
	"npc_dota_hero_storm_spirit",
	"npc_dota_hero_obsidian_destroyer",
	"npc_dota_hero_riki",
	"npc_dota_hero_lina",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_pugna",
	"npc_dota_hero_meepo",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_batrider",
	"npc_dota_hero_tiny",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_razor",
	"npc_dota_hero_invoker",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_pudge",
	"npc_dota_hero_zuus",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_magnataur",
}

PRoles["OffLane"] = {
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_viper",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_razor",
	"npc_dota_hero_axe",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_slardar",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_enigma",
	"npc_dota_hero_pudge",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_mars",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_batrider",
	"npc_dota_hero_sand_king",
	"npc_dota_hero_centaur",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_broodmother",
	"npc_dota_hero_lycan",
	"npc_dota_hero_furion",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_kunkka",
	"npc_dota_hero_shredder",
	"npc_dota_hero_magnataur",
}

PRoles["SoftSupport"] = {
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_silencer",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_grimstroke",
	"npc_dota_hero_venomancer",
	"npc_dota_hero_earthshaker",
	"npc_dota_hero_treant",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_nyx_assassin",
	"npc_dota_hero_shadow_demon",
	"npc_dota_hero_oracle",
	"npc_dota_hero_tusk",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_disruptor",
}

PRoles["HardSupport"] = {
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_warlock",
	"npc_dota_hero_silencer",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_grimstroke",
	"npc_dota_hero_jakiro",
	"npc_dota_hero_treant",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_lich",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_bane",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_ancient_apparition",
	"npc_dota_hero_lion",
	"npc_dota_hero_undying",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_shadow_demon",
	"npc_dota_hero_oracle",
	"npc_dota_hero_winter_wyvern",
	"npc_dota_hero_disruptor",
}
