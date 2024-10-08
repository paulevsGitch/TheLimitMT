local RADIUS = 5
local COUNT = 30

local HYPHUM_ID = minetest.get_content_id("thelimit:hyphum")
local GUTTARBA_ID = {
	minetest.get_content_id("thelimit:guttarba_large"),
	minetest.get_content_id("thelimit:guttarba_normal"),
	minetest.get_content_id("thelimit:guttarba_short")
}

local function place(pos, context)
	local distance = math.floor(math.sqrt(pos.x * pos.x + pos.y * pos.y + pos.z * pos.z) / RADIUS + 0.5)
	local type = math.floor(distance * 4 + math.random() * 0.25) + 1
	if type > 3 then type = 3 end
	context.set_node(pos, GUTTARBA_ID[type])
end

thelimit.plants.guttarba = function(context)
	thelimit.plants.scatter_flat(context, RADIUS, COUNT, HYPHUM_ID, place)
end