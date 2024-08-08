local MIN_HEIGHT = thelimit.MIN_HEIGHT
local BARRIER_BOTTOM = thelimit.BARRIER_BOTTOM
local WORLD_SEED = minetest.get_mapgen_setting("seed")
local MIDDLE = (thelimit.MAX_HEIGHT - thelimit.MIN_HEIGHT) * 0.5

local function set_rand_seed(seed, x, y)
	math.randomseed(x * 31000 + y + seed)
end

local voronoi_cache = {
	pos = {},
	data = {}
}

for i = 1, 9 do
	voronoi_cache.data[i] = {}
end

local function get_islands_voronoi(seed, x, y, z, depth)
	local ix = math.floor(x)
	local iz = math.floor(z)

	if voronoi_cache.pos.x ~= ix or voronoi_cache.pos.z ~= iz then
		voronoi_cache.pos.x = ix
		voronoi_cache.pos.z = iz
		local index = 1
		for i = -1, 1 do
			for j = -1, 1 do
				set_rand_seed(seed, ix + i, iz + j)
				local pos = voronoi_cache.data[index]
				pos.x = math.random() * 0.7 + i
				pos.z = math.random() * 0.7 + j
				pos.y = math.random() * 2 - 1
				pos.s = math.random() * 0.5 + 1
				index = index + 1
			end
		end
	end

	local sdx = x - ix
	local sdz = z - iz
	local min = 10000

	local dx, dy, dz, distance

	for i = 1, 9 do
		local pos = voronoi_cache.data[i]

		dx = pos.x - sdx
		dz = pos.z - sdz
		dy = pos.y - y

		if dy < 0 then
			dy = dy * 3
			distance = math.sqrt(dx * dx + dz * dz + dy * dy)
		else
			distance = math.sqrt(dx * dx + dz * dz) + dy * depth
		end

		distance = distance * pos.s
		if distance < min then
			min = distance
		end
	end
	
	return min
end

local function smooth_step(x)
	return x * x * x * (x * (x * 6 - 15) + 10)
end

local function lerp(a, b, delta)
	return a + delta * (b - a)
end

math.randomseed(WORLD_SEED)

local DISTORT_X_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 100, y = 100, z = 100},
	seed = math.random(0, 65535),
	octaves = 2,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
})

local DISTORT_Y_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 100, y = 100, z = 100},
	seed = math.random(0, 65535),
	octaves = 3,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
})

local DISTORT_Z_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 100, y = 100, z = 100},
	seed = math.random(0, 65535),
	octaves = 2,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
})

local DENSITY_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 200, y = 200, z = 200},
	seed = math.random(0, 65535),
	octaves = 2,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults, absvalue"
})

local dens_pos = {}
local layer_1_seed = math.random(0, 65535)
local layer_2_seed = math.random(0, 65535)
local layer_3_seed = math.random(0, 65535)

local function get_density(x, y, z)
	dens_pos.x = x
	dens_pos.y = z
	
	local dx = DISTORT_X_NOISE:get_2d(dens_pos)
	local dz = DISTORT_Z_NOISE:get_2d(dens_pos)
	
	dens_pos.x = x
	dens_pos.y = y
	dens_pos.z = z

	local dy = DISTORT_Y_NOISE:get_3d(dens_pos)
	local void = math.pow(1 - DENSITY_NOISE:get_3d(dens_pos), 6) * 4

	local density = 1.2 - get_islands_voronoi(layer_1_seed, x * 0.01 + dx * 0.2, (y - MIDDLE) * 0.01, z * 0.01 + dz * 0.2, 2) + dy * 0.7 - void
	if density > 0.51 then return density end

	density = math.max(density, 0.75 - get_islands_voronoi(layer_2_seed, x * 0.02 + dx * 0.1, (y - MIDDLE - 40) * 0.02, z * 0.02 + dz * 0.1, 0.5) + dy * 0.7 - void)
	if density > 0.51 then return density end

	density = math.max(density, 0.75 - get_islands_voronoi(layer_3_seed, x * 0.02 + dx * 0.1, (y - MIDDLE + 40) * 0.02, z * 0.02 + dz * 0.1, 0.5) + dy * 0.7 - void)

	return density
end

local GRID_SIZE = 8
local interpolation_cell = {}

local function fill_cell(emin, emax)
	local side = math.floor((emax.x - emin.x) / GRID_SIZE)
	
	for dx = 1, side do
		local slise_yz = interpolation_cell[dx]
		if not slise_yz then
			slise_yz = {}
			interpolation_cell[dx] = slise_yz
		end
		local wx = emin.x + dx * GRID_SIZE
		for dy = 1, side do
			local slise_y = slise_yz[dy]
			if not slise_y then
				slise_y = {}
				slise_yz[dy] = slise_y
			end
			local wy = emin.y + dy * GRID_SIZE - MIN_HEIGHT
			for dz = 1, side do
				local wz = emin.z + dz * GRID_SIZE
				slise_y[dz] = get_density(wx, wy, wz)
			end
		end
	end
end

local function interpolate_cell(x, y, z)
	local dx = x / GRID_SIZE
	local dy = y / GRID_SIZE
	local dz = z / GRID_SIZE

	local x1 = math.floor(dx)
	local y1 = math.floor(dy)
	local z1 = math.floor(dz)

	dx = dx - x1
	dy = dy - y1
	dz = dz - z1

	dx = lerp(dx, smooth_step(dx), 0.5)
	dy = lerp(dy, smooth_step(dy), 0.5)
	dz = lerp(dz, smooth_step(dz), 0.5)

	local x2 = x1 + 1
	local y2 = y1 + 1
	local z2 = z1 + 1
	
	local a = interpolation_cell[x1][y1][z1]
	local b = interpolation_cell[x2][y1][z1]
	local c = interpolation_cell[x1][y2][z1]
	local d = interpolation_cell[x2][y2][z1]
	local e = interpolation_cell[x1][y1][z2]
	local f = interpolation_cell[x2][y1][z2]
	local g = interpolation_cell[x1][y2][z2]
	local h = interpolation_cell[x2][y2][z2]
	
	a = lerp(a, b, dx)
	b = lerp(c, d, dx)
	c = lerp(e, f, dx)
	d = lerp(g, h, dx)
	
	a = lerp(a, b, dy)
	b = lerp(c, d, dy)
	
	return lerp(a, b, dz)
end

local BARRIER_ID = minetest.get_content_id("thelimit:barrier")

local node_data = {}
local param2_data = {}
local light_data = {}
local biome_map = {}

local side, side_max, array_side_dy, array_side_dz, size, place_index, max_chunk, center_chunk
local index_table = {}

local function get_node(pos)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	return node_data[index]
end

local function set_node(pos, node, param2)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	node_data[index] = node
	param2_data[index] = param2 or 0
end

local feature_context = {
	get_node = get_node,
	set_node = set_node
}

local function heightmap_place(feature, count, min_x, min_z, surface)
	for i = 1, count do
		local px = math.random(0, 15) + min_x
		local pz = math.random(0, 15) + min_z
		local i_xz = px + pz * array_side_dz
		for py = side_max, 16, -1 do
			local index = i_xz + py * array_side_dy
			if node_data[index] == surface then
				place_index = index + array_side_dy
				feature(feature_context)
			end
		end
	end
end

local function volume_place(feature, count, min_x, min_z)
	for i = 1, count do
		local px = math.random(0, 15) + min_x
		local pz = math.random(0, 15) + min_z
		local py = math.random(16, side_max)
		place_index = px + py * array_side_dy + pz * array_side_dz
		if node_data[place_index] == minetest.CONTENT_AIR then
			feature(feature_context)
		end
	end
end

local function fill_terrain(emin, emax)
	if not side then
		side = emax.x - emin.x
		side_max = side - 15
		array_side_dy = side + 1
		array_side_dz = array_side_dy * array_side_dy
		size = array_side_dy * array_side_dz
		max_chunk = math.floor(side / 16) - 1
		center_chunk = math.floor((max_chunk + 1) * 0.5)

		for index = 1, size do
			local index_dec = index - 1
			
			local x = index_dec % array_side_dy
			if x < 15 or x > side_max then goto index_end end
			
			local y = math.floor(index_dec / array_side_dy) % array_side_dy
			if y < 15 or y > side_max then goto index_end end
			
			local z = math.floor(index_dec / array_side_dz)
			if z < 15 or z > side_max then goto index_end end
			
			table.insert(index_table, index)
			
			::index_end::
		end

		feature_context.max_side = side_max
	end
	
	fill_cell(emin, emax)
	thelimit.biome_map.fill_map(emin, side, biome_map)
	
	for _, index in ipairs(index_table) do
		if node_data[index] ~= minetest.CONTENT_AIR then goto fill_end end

		local index_dec = index - 1
		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		local wy = y + emin.y

		if wy >= BARRIER_BOTTOM and wy < MIN_HEIGHT then
			node_data[index] = BARRIER_ID
			goto fill_end
		end
		
		local x = index_dec % array_side_dy
		local z = math.floor(index_dec / array_side_dz)
		
		if interpolate_cell(x, y, z) > 0.5 then
			local px = math.floor(x + math.sin(y * 0.7) * 5)
			local pz = math.floor(z + math.sin(y * 0.5) * 5)
			local biome = thelimit.biome_map.get_from_map(biome_map, px, pz)
			if interpolate_cell(x, y + 1, z) > 0.5 then
				node_data[index] = biome.filler
			else
				node_data[index] = biome.surface
			end
		end

		::fill_end::
	end

	for cx = 1, max_chunk do
		local min_x = cx * 16
		for cz = 1, max_chunk do
			local min_z = cz * 16
			local biome = thelimit.biome_map.get_from_map(biome_map, min_x + 8, min_z + 8)
			if biome.features then
				for _, entry in ipairs(biome.features) do
					local type = entry.place
					if type == "heightmap" then
						heightmap_place(entry.feature, entry.count, min_x, min_z, biome.surface)
					elseif type == "heightmap_center" then
						if cx == center_chunk and cz == center_chunk then
							heightmap_place(entry.feature, entry.count, min_x, min_z, biome.surface)
						end
					elseif type == "volume" then
						volume_place(entry.feature, entry.count, min_x, min_z)
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	
	if emax.y < BARRIER_BOTTOM then
		return
	end
	
	vm:get_data(node_data)
	vm:get_param2_data(param2_data)
	fill_terrain(emin, emax)
	vm:set_data(node_data)
	vm:set_param2_data(param2_data)
	vm:update_liquids()
	vm:calc_lighting()
	vm:get_light_data(light_data)
	thelimit.update_sky_light(emin, emax, node_data, light_data)
	vm:set_light_data(light_data)
	vm:write_to_map(false)
end)