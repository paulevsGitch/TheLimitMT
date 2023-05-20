local MAX_HEIGHT = thelimit.MAX_HEIGHT
local MIN_HEIGHT = thelimit.MIN_HEIGHT
local BARRIER_BOTTOM = thelimit.BARRIER_BOTTOM
local WORLD_SEED = minetest.get_mapgen_setting("seed")

local function set_rand_seed(seed, x, y)
	math.randomseed(x  * 31000 + y + seed)
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

local function make_island_layer(height, distance, coverage)
	local voronoi_seed = math.floor(math.random() * 65536)
	return {
		terrain_noise = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 30, y = 30, z = 30},
			seed = math.floor(math.random() * 65536),
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
			seed = math.floor(math.random() * 65536),
			octaves = 2,
			persistence = 0.5,
			lacunarity = 2.0,
			flags = "defaults"
		}),
		distort_y_noise = PerlinNoise({
			offset = 0,
			scale = 1,
			spread = {x = 100, y = 100, z = 100},
			seed = math.floor(math.random() * 65536),
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

local function get_density(x, y, z)
	local density = get_layer_density(island_layer_1, x, y, z)
	if density > 0.55 then return density end
	
	density = math.max(density, get_layer_density(island_layer_2, x, y, z))
	if density > 0.55 then return density end
	
	density = math.max(density, get_layer_density(island_layer_3, x, y, z))
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
local GLAUCOLIT_ID = minetest.get_content_id("thelimit:glaucolit")
local HYPHUM_ID = minetest.get_content_id("thelimit:hyphum")
local GUTTARBA_ID = minetest.get_content_id("thelimit:guttarba_normal")
local AIR_ID = minetest.get_content_id("air")

local node_data = {}
local light_data = {}

local side, side_max, array_side_dy, array_side_dz, size, place_index

local function get_node(pos)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	return node_data[index]
end

local function set_node(pos, node)
	local index = place_index + pos.x + pos.y * array_side_dy + pos.z * array_side_dz
	node_data[index] = node
end

local function fill_terrain(emin, emax)
	--min_pos = emin
	
	if not side then
		side = emax.x - emin.x
		side_max = side - 15
		array_side_dy = side + 1
		array_side_dz = array_side_dy * array_side_dy
		size = array_side_dy * array_side_dz
	end
	
	fill_cell(emin, emax)
	
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
		elseif wy >= MIN_HEIGHT and node_data[index] == AIR_ID and interpolate_cell(x, y, z) > 0.5 then
			node_data[index] = GLAUCOLIT_ID
		end
		
		::worldgen_end::
	end
	
	for index = 1, size do
		if node_data[index] ~= GLAUCOLIT_ID then goto surface_fill_end end
		
		local index_dec = index - 1
		
		local x = index_dec % array_side_dy
		if x < 15 or x > side_max then goto surface_fill_end end
		
		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		if y < 15 or y > side_max then goto surface_fill_end end
		
		local z = math.floor(index_dec / array_side_dz)
		if z < 15 or z > side_max then goto surface_fill_end end
		
		local wy = y + emin.y
		if node_data[index + array_side_dy] == AIR_ID then
			node_data[index] = HYPHUM_ID
			if math.random() < 0.1 then
				node_data[index + array_side_dy] = GUTTARBA_ID
			end
		end
		
		::surface_fill_end::
	end
	
	local max_rand = side - 32
	for i = 1, 100 do
		local px = math.floor(16 + math.random() * max_rand)
		local pz = math.floor(16 + math.random() * max_rand)
		local i_xz = px + pz * array_side_dz
		for py = max_rand + 16, 16, -1 do
			local index = i_xz + py * array_side_dy
			if node_data[index] == HYPHUM_ID then
				place_index = index + array_side_dy
				thelimit.trees.stellata(get_node, set_node)
				goto population_end
			end
		end
		::population_end::
	end
	
	for i = 1, 50 do
		local px = math.floor(16 + math.random() * max_rand)
		local pz = math.floor(16 + math.random() * max_rand)
		local i_xz = px + pz * array_side_dz
		for py = max_rand + 16, 16, -1 do
			local index = i_xz + py * array_side_dy
			if node_data[index] == HYPHUM_ID then
				place_index = index + array_side_dy
				thelimit.trees.stellata_small(get_node, set_node)
				goto population_end
			end
		end
		::population_end::
	end
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	
	if emax.y < BARRIER_BOTTOM then
		return
	end
	
	vm:get_data(node_data)
	fill_terrain(emin, emax)
	vm:set_data(node_data)
	vm:calc_lighting()
	vm:get_light_data(light_data)
	thelimit.update_sky_light(emin, emax, node_data, light_data)
	vm:set_light_data(light_data)
	vm:write_to_map(false)
end)