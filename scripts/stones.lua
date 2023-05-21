local D = thelimit.description_maker

local sounds = default.node_sound_stone_defaults()

local function register_stone(name)
	minetest.register_node("thelimit:" .. name, {
		description = D(name),
		tiles = {"thelimit_" .. name .. ".png"},
		groups = {cracky = 3, stone = 1},
		sounds = sounds
	})
	
	thelimit.register_stairs(name .. "_stairs", {
		tiles = {"thelimit_" .. name .. ".png"},
		groups = {cracky = 3, stone = 1},
		sounds = sounds
	})
	
	thelimit.register_thin_pillar(name .. "_pillar", {
		groups = {cracky = 3, stone = 1},
		sounds = sounds
	})
end

register_stone("glaucolit")
register_stone("vitilit")