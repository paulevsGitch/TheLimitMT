local S = thelimit.translator

local texture = {
	name = "void_fluid_2.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 64,
		aspect_h = 64,
		length = 3
	},
	align_style = "world",
	scale = 4
}

local texture2 = {
	name = "void_fluid_flowing.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 6
	},
	align_style = "world",
	scale = 4
}

minetest.register_node("thelimit:void_fluid_source", {
	description = S("Void Fluid"),
	drawtype = "liquid",
	liquid_range = 1,
	waving = 3,
	tiles = {texture, texture},
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "thelimit:void_fluid_flowing",
	liquid_alternative_source = "thelimit:void_fluid_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	light_source = 8
})

minetest.register_node("thelimit:void_fluid_flowing", {
	description = S("Void Fluid"),
	drawtype = "flowingliquid",
	liquid_range = 1,
	waving = 3,
	tiles = {texture, texture},
	special_tiles = {texture2, texture2},
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "thelimit:void_fluid_flowing",
	liquid_alternative_source = "thelimit:void_fluid_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	light_source = 8
})