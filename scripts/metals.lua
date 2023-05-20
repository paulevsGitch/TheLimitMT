local METAL_SOUNDS = {
	footstep = {name = "thelimit_step_metal", gain = 0.2},
	dig = {name = "thelimit_step_metal", gain = 0.5},
	dug = {name = "thelimit_step_metal", gain = 0.5},
	place = {name = "thelimit_step_metal", gain = 0.5}
}

local D = thelimit.description_maker

local function register_metal(name)
	minetest.register_node("thelimit:" .. name, {
		description = D(name),
		tiles = {"thelimit_" .. name .. ".png"},
		groups = {cracky = 3, metal = 1},
		sounds = METAL_SOUNDS
	})
end

register_metal("bismuth_block")
register_metal("bismuth_tiles")
register_metal("bismuth_large_tile")

thelimit.register_connected("bismuth_decorated", {
	groups = {cracky = 3, metal = 1},
	sounds = METAL_SOUNDS
})

thelimit.register_stairs("bismuth_stairs", {
	tiles = {"thelimit_bismuth_block.png"},
	groups = {cracky = 3, metal = 1},
	sounds = METAL_SOUNDS
})

minetest.register_node("thelimit:bismuth_lantern", {
	description = D("Bismuth Lantern"),
	tiles = {"thelimit_bismuth_lantern.png"},
	groups = {cracky = 3, metal = 1},
	sounds = METAL_SOUNDS,
	light_source = 14
})

thelimit.register_thin_pillar("bismuth_pillar", {
	groups = {cracky = 3, metal = 1},
	sounds = METAL_SOUNDS
})