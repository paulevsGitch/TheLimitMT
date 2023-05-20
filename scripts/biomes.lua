local BIOME_MAX = 30928 - 256 - 128

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
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = BIOME_MAX,
    vertical_blend = 0,
    heat_point = 0,
    humidity_point = 50
})

minetest.register_on_mods_loaded(function()
	local biomes = table.copy(minetest.registered_biomes)
	minetest.clear_registered_biomes()
	
	for name, biome in pairs(biomes) do
		if name ~= "thelimit" and (not biome.y_max or biome.y_max > BIOME_MAX) then
			biome.y_max = BIOME_MAX
		end
		minetest.register_biome(biome)
	end
end)