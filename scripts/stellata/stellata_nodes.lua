local S = thelimit.translator

minetest.register_node("thelimit:stellata_flower", {
	drawtype = "mesh",
	mesh = "thelimit_stellata_flower.obj",
	description = S("Stellata Flower"),
	tiles = {"thelimit_stellata_stem_flower.png", "thelimit_stellata_petals_top.png", "thelimit_stellata_petals_side.png"},
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	sunlight_propagates = true,
	paramtype = "light",
	light_source = 14,
	waving = 1
})

local stem_box = {
	type = "fixed",
	fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
}

local function place_stem(itemstack, placer, pointed_thing)
	local under = pointed_thing.under
	local above = pointed_thing.above
	
	local dx = above.x - under.x
	local dy = above.y - under.y
	local dz = above.z - under.z
	
	local param2 = 0
	if dx ~= 0 then param2 = 12
	elseif dz ~= 0 then param2 = 4 end
	
	local node_name = itemstack:get_name()
	itemstack:set_name("thelimit:stellata_stem_" .. math.floor(math.random() * 2 + 1))
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(node_name)
	return result
end

minetest.register_node("thelimit:stellata_stem_1", {
	drawtype = "nodebox",
	node_box = stem_box,
	selection_box = stem_box,
	collision_box = stem_box,
	description = S("Stellata Stem"),
	tiles = {"thelimit_stellata_stem_top.png", "thelimit_stellata_stem_top.png", "thelimit_stellata_stem_side_1.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	connect_sides = {"top", "bottom"},
	sunlight_propagates = true,
	paramtype2 = "facedir",
	paramtype = "light",
	drop = "thelimit:stellata_stem_1",
	on_place = place_stem
})

minetest.register_node("thelimit:stellata_stem_2", {
	drawtype = "nodebox",
	node_box = stem_box,
	selection_box = stem_box,
	collision_box = stem_box,
	description = S("Stellata Stem"),
	tiles = {"thelimit_stellata_stem_top.png", "thelimit_stellata_stem_top.png", "thelimit_stellata_stem_side_2.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	connect_sides = {"top", "bottom"},
	sunlight_propagates = true,
	paramtype2 = "facedir",
	paramtype = "light",
	drop = "thelimit:stellata_stem_1",
	on_place = place_stem
})

local branch_box = {
	type = "connected",
	fixed = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
	connect_top = {-0.25, 0.25, -0.25, 0.25, 0.5, 0.25},
	connect_bottom = {-0.25, -0.5, -0.25, 0.25, -0.25, 0.25},
	connect_front = {-0.25, -0.25, -0.5, 0.25, 0.25, -0.25},
	connect_left = {-0.5, -0.25, -0.25, -0.25, 0.25, 0.25},
	connect_back = {-0.25, -0.25, 0.25, 0.25, 0.25, 0.5},
	connect_right = {0.25, -0.25, -0.25, 0.5, 0.25, 0.25}
}

minetest.register_node("thelimit:stellata_branch", {
	drawtype = "nodebox",
	node_box = branch_box,
	selection_box = branch_box,
	collision_box = branch_box,
	description = S("Stellata Branch"),
	tiles = {"thelimit_stellata_branch.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	connects_to = {"group:thelimit_stellata_connect"},
	sunlight_propagates = true,
	paramtype = "light"
})

local function place_log(itemstack, placer, pointed_thing)
	local under = pointed_thing.under
	local above = pointed_thing.above
	
	local dx = above.x - under.x
	local dy = above.y - under.y
	local dz = above.z - under.z
	
	local param2 = 0
	if dx ~= 0 then param2 = 12
	elseif dz ~= 0 then param2 = 4 end
	
	local name = itemstack:get_name()
	itemstack:set_name("thelimit:stellata_log_" .. math.floor(math.random() * 3 + 1))
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(name)
	
	return result
end

minetest.register_node("thelimit:stellata_log_1", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_top.png", "thelimit_stellata_log_top.png", "thelimit_stellata_log_side_1.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_log_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_log
})

minetest.register_node("thelimit:stellata_log_2", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_top.png", "thelimit_stellata_log_top.png", "thelimit_stellata_log_side_2.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_log_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_log
})

minetest.register_node("thelimit:stellata_log_3", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_top.png", "thelimit_stellata_log_top.png", "thelimit_stellata_log_side_3.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_log_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_log
})

local function place_bark(itemstack, placer, pointed_thing)
	local under = pointed_thing.under
	local above = pointed_thing.above
	
	local dx = above.x - under.x
	local dy = above.y - under.y
	local dz = above.z - under.z
	
	local param2 = 0
	if dx ~= 0 then param2 = 12
	elseif dz ~= 0 then param2 = 4 end
	
	local name = itemstack:get_name()
	itemstack:set_name("thelimit:stellata_bark_" .. math.floor(math.random() * 3 + 1))
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(name)
	
	return result
end

minetest.register_node("thelimit:stellata_bark_1", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_side_1.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_bark_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_bark
})

minetest.register_node("thelimit:stellata_bark_2", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_side_2.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_bark_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_bark
})

minetest.register_node("thelimit:stellata_bark_3", {
	description = S("Stellata Log"),
	tiles = {"thelimit_stellata_log_side_3.png"},
	groups = {snappy = 3, flora = 1, flammable = 1, thelimit_stellata_connect = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "thelimit:stellata_bark_1",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	on_place = place_bark
})

minetest.register_on_mods_loaded(function()
	for name, node in pairs(minetest.registered_nodes) do
		if (not node.drawtype or node.drawtype == "normal") and not node.sunlight_propagates and node.paramtype ~= "light" then
			local groups = table.copy(node.groups or {})
			groups.thelimit_stellata_connect = 1
			minetest.override_item(name, {groups = groups})
		end
	end
end)