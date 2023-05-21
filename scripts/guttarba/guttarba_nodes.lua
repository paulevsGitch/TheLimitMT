local S = thelimit.translator

minetest.register_node("thelimit:guttarba_short", {
	drawtype = "plantlike",
	description = S("Guttarba Short"),
	wield_image = "thelimit_guttarba_short.png",
	inventory_image = "thelimit_guttarba_short.png",
	tiles = {"thelimit_guttarba_short.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3},
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 0.25, 0.375}
	},
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 2,
	waving = 1
})

minetest.register_node("thelimit:guttarba_normal", {
	drawtype = "plantlike",
	description = S("Guttarba Normal"),
	wield_image = "thelimit_guttarba_normal.png",
	inventory_image = "thelimit_guttarba_normal.png",
	tiles = {"thelimit_guttarba_normal.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3},
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 0.375, 0.375}
	},
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 4,
	waving = 1
})

minetest.register_node("thelimit:guttarba_large", {
	drawtype = "plantlike",
	description = S("Guttarba Large"),
	wield_image = "thelimit_guttarba_tall_item.png",
	inventory_image = "thelimit_guttarba_tall_item.png",
	tiles = {"thelimit_guttarba_tall.png"},
	visual_scale = 2.0,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3},
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 1.25, 0.375}
	},
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 6,
	waving = 1
})