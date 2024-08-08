local S = thelimit.translator

minetest.register_node("thelimit:flocus", {
	drawtype = "nodebox",
	description = S("Flocus"),
	wield_image = "thelimit_flocus_1.png",
	inventory_image = "thelimit_flocus_1.png",
	tiles = {{name = "thelimit_flocus_random.png", align_style = "world", scale = 8}},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3},
	sunlight_propagates = true,
	paramtype2 = "wallmounted",
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	connects_to = {"group:thelimit_stellata_connect"},
	node_box = {
		type = "connected",
		connect_top = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
		connect_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		connect_front = {-0.5, -0.5, -0.5, 0.5, 0.5, -0.4375},
		connect_back = {-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		connect_left = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
		connect_right = {0.4375, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
})