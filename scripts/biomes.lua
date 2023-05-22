local BIOME_MAX = thelimit.TRANSITION

minetest.register_biome({
    name = "thelimit",
    node_top = "default:dirt_with_snow",
    depth_top = 1,
    node_filler = "default:permafrost",
    depth_filler = 3,
    node_stone = "default:stone",
    node_water_top = "default:ice",
    depth_water_top = 10,
    node_water = "",
    node_river_water = "default:ice",
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_cave_liquid = "default:lava_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 32000,
    y_min = BIOME_MAX,
    vertical_blend = 0,
    heat_point = 0,
    humidity_point = 50
})

minetest.register_on_mods_loaded(function()
	local biomes = table.copy(minetest.registered_biomes)
	for name, biome in pairs(biomes) do
		if name ~= "thelimit" and (not biome.y_max or biome.y_max > BIOME_MAX) then
            minetest.unregister_biome(name)
			biome.y_max = BIOME_MAX
            minetest.register_biome(biome)
		end
	end
end)