local RADIUS = 2
local COUNT = 20

local HYPHUM_ID = minetest.get_content_id("thelimit:hyphum")
local LUCINUS_ID = {
	minetest.get_content_id("thelimit:lucinus_1"),
	minetest.get_content_id("thelimit:lucinus_2")
}

local function place(pos, get_node, set_node)
	local type = math.floor(math.random() * 2) + 1
	set_node(pos, LUCINUS_ID[type])
end

thelimit.plants.lucinus = function(get_node, set_node)
	thelimit.plants.scatter_flat(get_node, set_node, RADIUS, COUNT, HYPHUM_ID, place)
end