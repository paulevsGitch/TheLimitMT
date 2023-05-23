thelimit = {}

thelimit.MAX_HEIGHT = 30928
thelimit.MIN_HEIGHT = thelimit.MAX_HEIGHT - 256
thelimit.TRANSITION = thelimit.MIN_HEIGHT - 128
thelimit.BARRIER_BOTTOM = thelimit.MIN_HEIGHT - 256

local path = minetest.get_modpath("thelimit")

thelimit.translator = minetest.get_translator("flowers")

thelimit.upper_case = function(str)
	return str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
end

thelimit.description_maker = function(str)
	str = thelimit.upper_case(str:gsub("_", " "))
	return thelimit.translator(str)
end

thelimit.is_in_dimension = function(player)
	local y = player:get_pos().y
	return y > thelimit.TRANSITION
end

thelimit.trees = {}
thelimit.plants = {}

thelimit.can_replace = function(node_id)
	local node_name = minetest.get_name_from_content_id(node_id)
	local node = minetest.registered_nodes[node_name]
	return node.buildable_to
end

dofile(path .. "/scripts/connected_textures.lua")
dofile(path .. "/scripts/emissive_textures.lua")

dofile(path .. "/scripts/pillars.lua")
dofile(path .. "/scripts/stairs.lua")
dofile(path .. "/scripts/nodes.lua")
dofile(path .. "/scripts/stones.lua")
dofile(path .. "/scripts/metals.lua")

dofile(path .. "/scripts/scatter.lua")

dofile(path .. "/scripts/stellata/stellata_nodes.lua")
dofile(path .. "/scripts/stellata/stellata_tree.lua")

dofile(path .. "/scripts/guttarba/guttarba_nodes.lua")
dofile(path .. "/scripts/guttarba/guttarba_scatter.lua")

dofile(path .. "/scripts/lucinus/lucinus_nodes.lua")
dofile(path .. "/scripts/lucinus/lucinus_scatter.lua")

dofile(path .. "/scripts/flocus/flocus_nodes.lua")
dofile(path .. "/scripts/flocus/flocus_scatter.lua")

dofile(path .. "/scripts/biome_map.lua")
dofile(path .. "/scripts/biomes.lua")
dofile(path .. "/scripts/worldgen.lua")
dofile(path .. "/scripts/ambient_light.lua")
dofile(path .. "/scripts/sky.lua")