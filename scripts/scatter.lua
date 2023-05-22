local node_above, node_below
local scattered
local pos = {}

thelimit.plants.scatter_flat = function(get_node, set_node, radius, count, condition_node, place)
	local radius2 = radius * 2
	scattered = 0
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
				place(pos, get_node, set_node)
				scattered = scattered + 1
				goto place_break
			end
			node_above = node_below
		end
		if i > 10 and scattered == 0 then
			goto place_end
		end
		::place_break::
	end
	::place_end::
end

thelimit.plants.scatter_cube = function(get_node, set_node, radius, chance, place)
	--local radius2 = radius * 2
	--scattered = 0
	--for i = 1, count do
	--	pos.x = math.floor(math.random() * radius2 + 0.5) - radius
    --    pos.y = math.floor(math.random() * radius2 + 0.5) - radius
    --    pos.z = math.floor(math.random() * radius2 + 0.5) - radius
	--	if get_node(pos) == minetest.CONTENT_AIR then
	--		place(pos, get_node, set_node)
	--		scattered = scattered + 1
	--	end
	--	if i > 10 and scattered == 0 then
	--		goto place_end
	--	end
	--end
	--::place_end::

	for x = -radius, radius do
		pos.x = x
		for y = -radius, radius do
			pos.y = y
			for z = -radius, radius do
				pos.z = z
				if chance == 1 or math.floor(math.random() * chance) == 0 and get_node(pos) == minetest.CONTENT_AIR then
					place(pos, get_node, set_node)
				end
			end
		end
	end
end