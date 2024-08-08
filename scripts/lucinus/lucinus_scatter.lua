local RADIUS = 2
local COUNT = 20

local HYPHUM_ID = minetest.get_content_id("thelimit:hyphum")
local LUCINUS_ID = {
	minetest.get_content_id("thelimit:lucinus_1"),
	minetest.get_content_id("thelimit:lucinus_2")
}

local function place(pos, context)
	local type = math.floor(math.random() * 2) + 1
	context.set_node(pos, LUCINUS_ID[type])
end

thelimit.plants.lucinus = function(context)
	thelimit.plants.scatter_flat(context, RADIUS, COUNT, HYPHUM_ID, place)
end