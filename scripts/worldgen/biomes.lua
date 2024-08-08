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

thelimit.biome_map.register_biome({
    name = "Stellata Forest",
    surface = "thelimit:hyphum",
    filler = "thelimit:glaucolit",
    features = {
        {feature = thelimit.trees.stellata, count = 4, place = "heightmap"},
        {feature = thelimit.trees.stellata_small, count = 2, place = "heightmap"},
        {feature = thelimit.plants.guttarba, count = 4, place = "heightmap"},
        {feature = thelimit.plants.lucinus, count = 2, place = "heightmap"},
        {feature = thelimit.plants.flocus, count = 20, place = "volume"}
    },
    particles = {
        texture = {
            name = "thelimit_yellow_particle.png",
            blend = "screen",
            scale_tween = {
                style = "pulse",
                0, 1
            }
        }
    }
})

thelimit.biome_map.register_biome({
    name = "Void Lakeside",
    surface = "thelimit:purple_hyphum",
    filler = "thelimit:vitilit",
    features = {
        {feature = thelimit.terrain.void_lake, count = 1, place = "heightmap_center"}
    },
    particles = {
        texture = {
            name = "thelimit_purple_particle.png",
            blend = "screen",
            animation={
                type = "vertical_frames",
                aspect_w = 8,
                aspect_h = 8,
                length = -1
            }
        },
        exptime = {min = 1, max = 2},
    }
})
