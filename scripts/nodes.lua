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

minetest.register_node("thelimit:guttarba_short", {
	drawtype = "plantlike",
	description = S("Guttarba Short"),
	wield_image = "thelimit_guttarba_short.png",
	inventory_image = "thelimit_guttarba_short.png",
	tiles = {"thelimit_guttarba_short.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1},
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true
})

--thelimit.register_emissive("guttarba_normal", {
--	--drawtype = "mesh",
--	--mesh = "thelimit_plant.obj",
--	drawtype = "plantlike",
--	--description = S("Guttarba Normal"),
--	wield_image = "thelimit_guttarba_normal.png",
--	inventory_image = "thelimit_guttarba_normal.png",
--	--tiles = {{name = "thelimit_guttarba_normal.png", backface_culling = true}},
--	tiles = {"thelimit_guttarba_normal.png"},
--	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1},
--	sunlight_propagates = true,
--	paramtype = "light",
--	buildable_to = true,
--	walkable = false,
--	floodable = true,
--	thelimit_emissive = {
--		textures = {"thelimit_guttarba_normal_e.png"},
--		mesh = "thelimit_emissive_plant.obj"
--	}
--})

minetest.register_node("thelimit:guttarba_normal", {
	drawtype = "plantlike",
	description = S("Guttarba Normal"),
	wield_image = "thelimit_guttarba_normal.png",
	inventory_image = "thelimit_guttarba_normal.png",
	tiles = {"thelimit_guttarba_normal.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1},
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 4,
	waving = 1
})