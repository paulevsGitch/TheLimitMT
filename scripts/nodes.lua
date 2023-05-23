local S = thelimit.translator

minetest.register_node("thelimit:barrier", {
	drawtype = "airlike",
	description = S("Barrier"),
	sunlight_propagates = true,
	paramtype = "light",
	pointable = false
})

minetest.register_node("thelimit:hyphum", {
	description = S("Hyphum"),
	tiles = {"thelimit_hyphum_top.png", "thelimit_glaucolit.png", "thelimit_hyphum_side.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	})
})

minetest.register_node("thelimit:purple_hyphum", {
	description = S("Hyphum"),
	tiles = {"thelimit_purple_hyphum_top.png", "thelimit_vitilit.png", "thelimit_purple_hyphum_side.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	})
})