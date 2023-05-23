local SEED = minetest.get_mapgen_setting("seed")
local BIOME_SIZE = 256
local BIOMES = {}
local DATA = {}

thelimit.biome_map = {}

math.randomseed(SEED)

local octaves = math.floor(math.log(BIOME_SIZE) / math.log(2) + 0.5)

local DISTORT_X_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 1, y = 1, z = 1},
	seed = math.random(0, 65535),
	octaves = octaves,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
})

local DISTORT_Z_NOISE = PerlinNoise({
	offset = 0,
	scale = 1,
	spread = {x = 1, y = 1, z = 1},
	seed = math.random(0, 65535),
	octaves = octaves,
	persistence = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
})

local pos2d = {}

thelimit.biome_map.register_biome = function(def)
	def.surface = minetest.get_content_id(def.surface or "thelimit:glaucolit")
	def.filler = minetest.get_content_id(def.filler or "thelimit:glaucolit")
	def.id = #BIOMES + 1
	table.insert(BIOMES, def)
end

local fill_side

thelimit.biome_map.fill_map = function(pos, side, data)
	fill_side = side + 1
	for x = 0, side do
		for z = 0, side do
			local index = x * fill_side + z + 1
			data[index] = thelimit.biome_map.get_biome(x + pos.x, z + pos.z)
		end
	end
end

thelimit.biome_map.get_from_map = function(data, x, z)
	return data[x * fill_side + z + 1]
end

local function save_chunk(chunk, cx, cz)
	local data = ""

	for i = 1, 4096 do
		data = data .. string.char(chunk[i].id)
	end

	minetest.mkdir(minetest.get_worldpath() .. "/thelimit")
	local file = io.open(minetest.get_worldpath() .. "/thelimit/biome_chunk_" .. cx .. "_" .. cz .. ".txt", "w")
	if file then
		file:write(data)
		file:close()
	end
end

local function load_chunk(cx, cz)
	local file = io.open(minetest.get_worldpath() .. "/thelimit/biome_chunk_" .. cx .. "_" .. cz .. ".txt", "r")
	if file then
		local data = file:read("*all")
		file:close()

		local chunk = {}
		for i = 1, 4096 do
			local id = string.byte(data, i, i)
			chunk[i] = BIOMES[id]
		end

		return chunk
	end
	return nil
end

thelimit.biome_map.get_biome = function(x, z)
	pos2d.x = x / BIOME_SIZE
	pos2d.y = z / BIOME_SIZE

	local dx = DISTORT_X_NOISE:get_2d(pos2d)
	local dz = DISTORT_Z_NOISE:get_2d(pos2d)
	
	pos2d.x = pos2d.x + dx
	pos2d.y = pos2d.y + dz
	
	local cx = math.floor(pos2d.x / 64.0)
	local cz = math.floor(pos2d.y / 64.0)
	
	pos2d.x = bit.band(math.floor(pos2d.x), 63)
	pos2d.y = bit.band(math.floor(pos2d.y), 63)

	local index = cx * 1024 + cz
	local chunk = DATA[index]

	if not chunk then
		chunk = load_chunk(cx, cz)

		if not chunk then
			chunk = {}

			math.randomseed(cx * 31000 + cz + SEED)
			for i = 1, 4096 do
				chunk[i] = BIOMES[math.random(#BIOMES)]
			end
			
			save_chunk(chunk, cx, cz)
		end

		DATA[index] = chunk
	end

	index = pos2d.x * 64 + pos2d.y + 1
	return chunk[index]
end