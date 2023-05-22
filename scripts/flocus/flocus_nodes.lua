local S = thelimit.translator

local function place(itemstack, placer, pointed_thing)
	local node_name = itemstack:get_name()
	itemstack:set_name("thelimit:flocus_" .. math.floor(math.random() * 2 + 1))
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(node_name)
	return result
end

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
	--light_source = 4,
	--on_place = place,
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

--for i = 1, 3 do
--	local groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3}
--	if i > 1 then groups.not_in_creative_inventory = 1 end
--
--	minetest.register_node("thelimit:flocus_" .. i, {
--		drawtype = "nodebox",
--		description = S("Flocus"),
--		wield_image = "thelimit_flocus_1.png",
--		inventory_image = "thelimit_flocus_1.png",
--		tiles = {"thelimit_flocus_" .. i .. ".png"},
--		groups = groups,
--		sunlight_propagates = true,
--		paramtype2 = "wallmounted",
--		paramtype = "light",
--		buildable_to = true,
--		walkable = false,
--		floodable = true,
--		light_source = 4,
--		on_place = place,
--		connects_to = {"group:thelimit_stellata_connect"},
--		drop = "thelimit:flocus_1",
--		node_box = {
--			type = "connected",
--			connect_top = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
--			connect_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
--			connect_front = {-0.5, -0.5, -0.5, 0.5, 0.5, -0.4375},
--			connect_back = {-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
--			connect_left = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
--			connect_right = {0.4375, -0.5, -0.5, 0.5, 0.5, 0.5}
--		}
--	})
--end
