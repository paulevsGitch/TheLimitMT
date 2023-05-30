local VOID_FLUID_SOURCE_ID = minetest.get_content_id("thelimit:void_fluid_source")
local VOID_FLUID_FLOWING_ID = minetest.get_content_id("thelimit:void_fluid_flowing")
local VITILIT_ID = minetest.get_content_id("thelimit:vitilit")
local HYPHUM_ID = minetest.get_content_id("thelimit:purple_hyphum")

local noise_map = {}
local pos = {y = 0}
local side_pos = {y = 0}

local function is_wall(node)
	return node == VITILIT_ID or node == HYPHUM_ID or node == VOID_FLUID_SOURCE_ID
end

local function has_walls(get_node)
	side_pos.x = pos.x
	side_pos.z = pos.z
	side_pos.y = pos.y - 1

	local node = get_node(side_pos)
	if not is_wall(node) then return false end

	side_pos.y = pos.y
	for i = 1, 4 do
		local dir = minetest.fourdir_to_dir(i)
		side_pos.x = pos.x + dir.x
		side_pos.z = pos.z + dir.z
		node = get_node(side_pos)
		if not is_wall(node) then return false end
	end

	return true
end

thelimit.terrain.void_lake = function(get_node, set_node)
	local radius = math.random(9, 13)
	local x2, z2, d, node
	for z = -radius, radius do
		z2 = z * z
		pos.z = z
		for x = -radius, radius do
			x2 = x * x
			pos.x = x
			d = math.sqrt(x2 + z2)
			if d < radius then
				for y = 5, -5, -1 do
					pos.y = y
					node = get_node(pos)
					if node == HYPHUM_ID and has_walls(get_node) then
						set_node(pos, VOID_FLUID_SOURCE_ID)
						goto iter_break
					end
				end
				::iter_break::
			end
		end
	end
end


--thelimit.terrain.void_lake = function(get_node, set_node)
--	local radius = math.random(9, 13)
--	local radius_height = math.floor(radius * 0.5)
--	local radius_inner = radius - 2
--	local x2, y2, z2, d
--
--	local side = radius * 2 + 1
--	local side_h = radius_height * 2 + 1
--	local noise = PerlinNoiseMap({
--		offset = 0,
--		scale = 1,
--		spread = {x = 5, y = 5, z = 5},
--		seed = math.random(0, 65535),
--		octaves = 2,
--		persistence = 0.5,
--		lacunarity = 2.0,
--		flags = "defaults"
--	}, {x = side, y = side_h, z = side})
--	noise:get_3d_map_flat({x = 0, y = 0, z = 0}, noise_map)
--
--	local index = 1
--	for z = -radius, radius do
--		z2 = z * z
--		pos.z = z
--		for y = -radius_height, radius_height do
--			y2 = y * 2
--			y2 = y2 * y2
--			pos.y = y - 1
--			for x = -radius, radius do
--				x2 = x * x
--				pos.x = x
--
--				d = math.sqrt(x2 + y2 + z2) + (noise_map[index] + 1) * 3
--				index = index + 1
--
--				if d < radius then
--					local node = get_node(pos)
--					if y > 0 then
--						if node == VITILIT_ID or node == HYPHUM_ID then
--							--set_node(pos, minetest.CONTENT_AIR)
--						elseif node == VOID_FLUID_SOURCE_ID or node == VOID_FLUID_FLOWING_ID then
--							if d >= radius_inner then
--								set_node(pos, VITILIT_ID)
--							else
--								set_node(pos, minetest.CONTENT_AIR)
--							end
--						end
--					else
--						if d < radius_inner then
--							if y == 0 then
--								set_node(pos, VOID_FLUID_SOURCE_ID)
--							else
--								set_node(pos, VITILIT_ID)
--							end
--						else
--							if y == 0 then
--								set_node(pos, HYPHUM_ID)
--							else
--								set_node(pos, VITILIT_ID)
--							end
--						end
--					end
--				end
--			end
--		end
--	end
--end