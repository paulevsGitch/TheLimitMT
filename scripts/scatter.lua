thelimit.plants.scatter = function(get_node, set_node, radius, count, condition_node, place)
	local radius2 = radius * 2
	local pos = {}
	local node_above, node_below
	for i = 1, count do
		pos.x = math.floor(math.random() * radius2 + 0.5) - radius
        pos.z = math.floor(math.random() * radius2 + 0.5) - radius
        pos.y = 5
		node_above = get_node(pos)
		for j = 1, 11 do
			pos.y = pos.y - 1
			node_below = get_node(pos)
			if node_above == minetest.CONTENT_AIR and node_below == condition_node then
				pos.y = pos.y + 1
				place(pos, set_node)
				goto place_break
			end
			node_above = node_below
		end
		::place_break::
	end
end