local S = thelimit.translator

local function place(itemstack, placer, pointed_thing)
	local node_name = itemstack:get_name()
	itemstack:set_name("thelimit:lucinus_" .. math.floor(math.random() * 2 + 1))
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(node_name)
	return result
end

local box = {
	type = "fixed",
	fixed = {-0.4375, -0.5, -0.4375, 0.4375, 0.0, 0.4375}
}

minetest.register_node("thelimit:lucinus_1", {
	drawtype = "mesh",
	mesh = "thelimit_lucinus_1.obj",
	description = S("lucinus"),
	tiles = {"thelimit_lucinus.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3},
	drop = "thelimit:lucinus_1",
	selection_box = box,
	on_place = place,
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 14
})

minetest.register_node("thelimit:lucinus_2", {
	drawtype = "mesh",
	mesh = "thelimit_lucinus_2.obj",
	description = S("lucinus"),
	tiles = {"thelimit_lucinus.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1, dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "thelimit:lucinus_1",
	selection_box = box,
	on_place = place,
	sunlight_propagates = true,
	paramtype = "light",
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 14
})