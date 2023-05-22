local RADIUS = 4
local CHANCE = 2

local FLOCUS_ID = minetest.get_content_id("thelimit:flocus")

local side_pos = {}

local function place(pos, get_node, set_node)
	for i = 0, 5 do
		local dir = minetest.wallmounted_to_dir(i)
		side_pos.x = pos.x + dir.x
		side_pos.y = pos.y + dir.y
		side_pos.z = pos.z + dir.z
		local node_id = get_node(side_pos)
		local node_name = minetest.get_name_from_content_id(node_id)
		if minetest.get_item_group(node_name, "thelimit_stellata_connect") == 1 then
			set_node(pos, FLOCUS_ID, i)
			goto place_break
		end
	end
	::place_break::
end

thelimit.plants.flocus = function(get_node, set_node)
	thelimit.plants.scatter_cube(get_node, set_node, RADIUS, CHANCE, place)
end