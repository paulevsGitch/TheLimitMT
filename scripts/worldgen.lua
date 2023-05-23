local MIN_HEIGHT = thelimit.MIN_HEIGHT
local BARRIER_BOTTOM = thelimit.BARRIER_BOTTOM
local WORLD_SEED = minetest.get_mapgen_setting("seed")

local function set_rand_seed(seed, x, y)
	math.randomseed(x * 31000 + y + seed)
end

local function get_voronoi(seed, x, y)
	local ix = math.floor(x)
	local iy = math.floor(y)
	local sdx = x - ix
	local sdy = y - iy
	local min = 10000
	
	for  i = -1, 1 do
		for j = -1, 1 do
			set_rand_seed(seed, ix + i, iy + j)
			local dx = math.random() * 0.7 + i - sdx
			local dy = math.random() * 0.7 + j - sdy
			local distance = math.sqrt(dx * dx + dy * dy)
			if distance < min then
				min = distance
			end
		end
	end
	
	return min
end

--local function get_voronoi_islands(seed, x, y, z)
--	local ix = math.floor(x)
--	local iy = math.floor(y)
--	local iz = math.floor(z)
--
--	local sdx = x - ix
--	local sdy = y - iy
--	local sdz = z - iz
--
--	local distance, dx, dy, dz
--	local min = 10000
--	
--	for i = -1, 1 do
--		for j = -1, 1 do
--			for k = -1, 1 do
--				math.randomseed((ix + i) * 1000000 + (iz + k) * 1000 + (iy + j) + seed)
--
--				dx = math.random() + i - sdx
--				dy = math.random() + j - sdy
--				dz = math.random() + k - sdz
--
--				if dy < 0 then
--					dy = dy * 3
--					distance = math.sqrt(dx * dx + dy * dy + dz * dz)
--				else
--					distance = math.sqrt(dx * dx + dz * dz) + dy * 0.5
--				end
--
--				distance = distance * (math.random() + 1)
--				
--				--if dy < 0 then dy = dy * 3 end
--
--				--local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
--				
--				if distance < min then
--					min = distance
--				end
--			end
--		end
--	end
--	
--	return min
--end

local function make_island_layer(height, distance, coverage)
	local voronoi_seed = math.random(0, 65535)
	return {
		terrain_noise = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 30, y = 30, z = 30},
			seed = math.random(0, 65535),
			octaves = 1,
			persistence = 1.0,
			lacunarity = 1.0,
			flags = "defaults"
		}),
		island_noise = function(pos)
			return get_voronoi(voronoi_seed, pos.x, pos.y)
		end,
		distort_x_noise = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 100, y = 100, z = 100},
			seed = math.random(0, 65535),
			octaves = 2,
			persistence = 0.5,
			lacunarity = 2.0,
			flags = "defaults"
		}),
		distort_y_noise = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 100, y = 100, z = 100},
			seed = math.random(0, 65535),
			octaves = 2,
			persistence = 0.5,
			lacunarity = 2.0,
			flags = "defaults"
		}),
		height = height,
		distance = 1 / distance,
		coverage = coverage
	}
end

math.randomseed(WORLD_SEED)
local island_layer_1 = make_island_layer(120, 200, 1.0)
local island_layer_2 = make_island_layer(80, 200, 0.75)
local island_layer_3 = make_island_layer(160, 200, 0.75)

local function smooth_step(x)
	return x * x * x * (x * (x * 6 - 15) + 10)
end

local function lerp(a, b, delta)
	return a + delta * (b - a)
end

local function get_gradient(y, height, bottom, middle, top)
	local delta = math.abs(y - height) / 120
	delta = lerp(delta, smooth_step(delta), 0.75)
	if y < height then
		return lerp(middle, bottom, delta)
	else
		return lerp(middle, top, delta)
	end
end

local function get_layer_density(layer, x, y, z)
	local pos2d = {x = x, y = z}
	
	local dx = layer.distort_x_noise:get_2d(pos2d)
	local dz = layer.distort_y_noise:get_2d(pos2d)
	local dy = layer.terrain_noise:get_2d(pos2d) * 10
	
	pos2d.x = x * layer.distance + dx * 0.5
	pos2d.y = z * layer.distance + dz * 0.5
	
	local density = layer.coverage - layer.island_noise(pos2d)
	density = density + get_gradient(y + dy, layer.height, -1, 0, -6)
	
	return density
end

--math.randomseed(WORLD_SEED)
--
--local DISTORT_X_NOISE = PerlinNoise({
--	offset = 0,
--	scale = 1,
--	spread = {x = 100, y = 100, z = 100},
--	seed = math.random(0, 65535),
--	octaves = 2,
--	persistence = 0.5,
--	lacunarity = 2.0,
--	flags = "defaults"
--})
--
--local DISTORT_Y_NOISE = PerlinNoise({
--	offset = 0,
--	scale = 1,
--	spread = {x = 100, y = 100, z = 100},
--	seed = math.random(0, 65535),
--	octaves = 2,
--	persistence = 0.5,
--	lacunarity = 2.0,
--	flags = "defaults"
--})
--
--local DISTORT_Z_NOISE = PerlinNoise({
--	offset = 0,
--	scale = 1,
--	spread = {x = 100, y = 100, z = 100},
--	seed = math.random(0, 65535),
--	octaves = 2,
--	persistence = 0.5,
--	lacunarity = 2.0,
--	flags = "defaults"
--})
--
--local pos2d = {}

local function get_density(x, y, z)
	local density = get_layer_density(island_layer_1, x, y, z)
	if density > 0.55 then return density end
	
	density = math.max(density, get_layer_density(island_layer_2, x, y, z))
	if density > 0.55 then return density end
	
	density = math.max(density, get_layer_density(island_layer_3, x, y, z))
	return density

	--pos2d.x = x
	--pos2d.y = z
	--
	--local dx = DISTORT_X_NOISE:get_2d(pos2d)
	--local dy = DISTORT_Y_NOISE:get_2d(pos2d)
	--local dz = DISTORT_Z_NOISE:get_2d(pos2d)
	--
	--local islands1 = 0.9 - get_voronoi_islands(0, x * 0.01 + dx * 0.1, y * 0.03 + dy * 0.1, z * 0.01 + dz * 0.1)
	--local islands2 = 0.9 - get_voronoi_islands(0, x * 0.1 + dx * 0.1, y * 0.03 + dy * 0.1, z * 0.1 + dz * 0.1)
	--
	--return math.max(islands1, islands2)
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

local side, side_max, array_side_dy, array_side_dz, size, place_index, max_chunk

local function get_node(pos)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	return node_data[index]
end

local function set_node(pos, node, param2)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	node_data[index] = node
	param2_data[index] = param2 or 0
end

local function heightmap_place(feature, count, min_x, min_z, surface)
	for i = 1, count do
		local px = math.random(0, 15) + min_x
		local pz = math.random(0, 15) + min_z
		local i_xz = px + pz * array_side_dz
		for py = side_max, 16, -1 do
			local index = i_xz + py * array_side_dy
			if node_data[index] == surface then
				place_index = index + array_side_dy
				feature(get_node, set_node)
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
			feature(get_node, set_node)
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
	end
	
	fill_cell(emin, emax)

	thelimit.biome_map.fill_map(emin, side, biome_map)
	
	for index = 1, size do
		local index_dec = index - 1
		
		local x = index_dec % array_side_dy
		if x < 15 or x > side_max then goto worldgen_end end
		
		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		if y < 15 or y > side_max then goto worldgen_end end
		
		local z = math.floor(index_dec / array_side_dz)
		if z < 15 or z > side_max then goto worldgen_end end
		
		local wy = y + emin.y
		if wy >= BARRIER_BOTTOM and wy < MIN_HEIGHT then
			node_data[index] = BARRIER_ID
		elseif wy >= MIN_HEIGHT and node_data[index] == minetest.CONTENT_AIR and interpolate_cell(x, y, z) > 0.5 then
			local biome = thelimit.biome_map.get_from_map(biome_map, x, z)
			node_data[index] = biome.filler
		end
		
		::worldgen_end::
	end

	for index = 1, size do
		local index_dec = index - 1
		
		local x = index_dec % array_side_dy
		if x < 15 or x > side_max then goto surface_fill_end end
		
		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		if y < 15 or y > side_max then goto surface_fill_end end
		
		local z = math.floor(index_dec / array_side_dz)
		if z < 15 or z > side_max then goto surface_fill_end end

		local biome = thelimit.biome_map.get_from_map(biome_map, x, z)
		if node_data[index] ~= biome.filler then goto surface_fill_end end

		if node_data[index + array_side_dy] == minetest.CONTENT_AIR then
			node_data[index] = biome.surface
		end
		
		::surface_fill_end::
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
	vm:calc_lighting()
	vm:get_light_data(light_data)
	thelimit.update_sky_light(emin, emax, node_data, light_data)
	vm:set_light_data(light_data)
	vm:write_to_map(false)
end)