local D = thelimit.description_maker

local INDEX_TABLE = {
	[  0] =  15, [  1] =  15, [  2] =  14, [  3] =  14, [  4] =  15, [  5] =  15, [  6] =  14, [  7] =  14,
	[  8] =   3, [  9] =   3, [ 10] =  19, [ 11] =  19, [ 12] =   3, [ 13] =   3, [ 14] =   2, [ 15] =   2,
	[ 16] =  15, [ 17] =  15, [ 18] =  14, [ 19] =  14, [ 20] =  15, [ 21] =  15, [ 22] =  14, [ 23] =  14,
	[ 24] =   3, [ 25] =   3, [ 26] =  19, [ 27] =  19, [ 28] =   3, [ 29] =   3, [ 30] =   2, [ 31] =   2,
	[ 32] =  12, [ 33] =  12, [ 34] =  13, [ 35] =  13, [ 36] =  12, [ 37] =  12, [ 38] =  13, [ 39] =  13,
	[ 40] =  16, [ 41] =  16, [ 42] =  20, [ 43] =  20, [ 44] =  16, [ 45] =  16, [ 46] =  17, [ 47] =  17,
	[ 48] =  12, [ 49] =  12, [ 50] =  13, [ 51] =  13, [ 52] =  12, [ 53] =  12, [ 54] =  13, [ 55] =  13,
	[ 56] =   0, [ 57] =   0, [ 58] =  18, [ 59] =  18, [ 60] =   0, [ 61] =   0, [ 62] =   1, [ 63] =   1,
	[ 64] =  15, [ 65] =  15, [ 66] =  14, [ 67] =  14, [ 68] =  15, [ 69] =  15, [ 70] =  14, [ 71] =  14,
	[ 72] =   3, [ 73] =   3, [ 74] =  19, [ 75] =  19, [ 76] =   3, [ 77] =   3, [ 78] =   2, [ 79] =   2,
	[ 80] =  15, [ 81] =  15, [ 82] =  14, [ 83] =  14, [ 84] =  15, [ 85] =  15, [ 86] =  14, [ 87] =  14,
	[ 88] =   3, [ 89] =   3, [ 90] =  19, [ 91] =  19, [ 92] =   3, [ 93] =   3, [ 94] =   2, [ 95] =   2,
	[ 96] =  12, [ 97] =  12, [ 98] =  13, [ 99] =  13, [100] =  12, [101] =  12, [102] =  13, [103] =  13,
	[104] =  16, [105] =  16, [106] =  20, [107] =  20, [108] =  16, [109] =  16, [110] =  17, [111] =  17,
	[112] =  12, [113] =  12, [114] =  13, [115] =  13, [116] =  12, [117] =  12, [118] =  13, [119] =  13,
	[120] =   0, [121] =   0, [122] =  18, [123] =  18, [124] =   0, [125] =   0, [126] =   1, [127] =   1,
	[128] =  11, [129] =  11, [130] =  34, [131] =  10, [132] =  11, [133] =  11, [134] =  34, [135] =  10,
	[136] =   7, [137] =   7, [138] =  39, [139] =  24, [140] =   7, [141] =   7, [142] =  29, [143] =   6,
	[144] =  11, [145] =  11, [146] =  34, [147] =  10, [148] =  11, [149] =  11, [150] =  34, [151] =  10,
	[152] =   7, [153] =   7, [154] =  39, [155] =  24, [156] =   7, [157] =   7, [158] =  29, [159] =   6,
	[160] =  31, [161] =  31, [162] =  35, [163] =  32, [164] =  31, [165] =  31, [166] =  35, [167] =  32,
	[168] =  36, [169] =  36, [170] =  40, [171] =  46, [172] =  36, [173] =  36, [174] =  44, [175] =  37,
	[176] =  31, [177] =  31, [178] =  35, [179] =  32, [180] =  31, [181] =  31, [182] =  35, [183] =  32,
	[184] =  26, [185] =  26, [186] =  43, [187] =  41, [188] =  26, [189] =  26, [190] =  30, [191] =  27,
	[192] =  11, [193] =  11, [194] =  34, [195] =  10, [196] =  11, [197] =  11, [198] =  34, [199] =  10,
	[200] =   7, [201] =   7, [202] =  39, [203] =  24, [204] =   7, [205] =   7, [206] =  29, [207] =   6,
	[208] =  11, [209] =  11, [210] =  34, [211] =  10, [212] =  11, [213] =  11, [214] =  34, [215] =  10,
	[216] =   7, [217] =   7, [218] =  39, [219] =  24, [220] =   7, [221] =   7, [222] =  29, [223] =   6,
	[224] =   8, [225] =   8, [226] =  33, [227] =   9, [228] =   8, [229] =   8, [230] =  33, [231] =   9,
	[232] =  21, [233] =  21, [234] =  45, [235] =  25, [236] =  21, [237] =  21, [238] =  42, [239] =  22,
	[240] =   8, [241] =   8, [242] =  33, [243] =   9, [244] =   8, [245] =   8, [246] =  33, [247] =   9,
	[248] =   4, [249] =   4, [250] =  38, [251] =  23, [252] =   4, [253] =   4, [254] =  28, [255] =   5
}

local function is_transparent(node_name)
	local node = minetest.registered_nodes[node_name]
	if not node or not node.drawtype then
		return false
	else
		return node.drawtype ~= "normal"
	end
end

local mutable_pos = {}
local function get_node(x, y, z)
	mutable_pos.x = x
	mutable_pos.y = y
	mutable_pos.z = z
	return minetest.get_node(mutable_pos)
end

local function get_texture_index(pos, name, face)
	local index = 0
	if face.y == 1 then
		if get_node(pos.x - 1, pos.y, pos.z + 1).name == name then index = index + 1 end
		if get_node(pos.x, pos.y, pos.z + 1).name == name then index = index + 2 end
		if get_node(pos.x + 1, pos.y, pos.z + 1).name == name then index = index + 4 end
		if get_node(pos.x + 1, pos.y, pos.z).name == name then index = index + 8 end
		if get_node(pos.x + 1, pos.y, pos.z - 1).name == name then index = index + 16 end
		if get_node(pos.x, pos.y, pos.z - 1).name == name then index = index + 32 end
		if get_node(pos.x - 1, pos.y, pos.z - 1).name == name then index = index + 64 end
		if get_node(pos.x - 1, pos.y, pos.z).name == name then index = index + 128 end
	elseif face.y == -1 then
		if get_node(pos.x - 1, pos.y, pos.z - 1).name == name then index = index + 1 end
		if get_node(pos.x, pos.y, pos.z - 1).name == name then index = index + 2 end
		if get_node(pos.x + 1, pos.y, pos.z - 1).name == name then index = index + 4 end
		if get_node(pos.x + 1, pos.y, pos.z).name == name then index = index + 8 end
		if get_node(pos.x + 1, pos.y, pos.z + 1).name == name then index = index + 16 end
		if get_node(pos.x, pos.y, pos.z + 1).name == name then index = index + 32 end
		if get_node(pos.x - 1, pos.y, pos.z + 1).name == name then index = index + 64 end
		if get_node(pos.x - 1, pos.y, pos.z).name == name then index = index + 128 end
	elseif face.x == 1 then
		if get_node(pos.x, pos.y + 1, pos.z - 1).name == name then index = index + 1 end
		if get_node(pos.x, pos.y + 1, pos.z).name == name then index = index + 2 end
		if get_node(pos.x, pos.y + 1, pos.z + 1).name == name then index = index + 4 end
		if get_node(pos.x, pos.y, pos.z + 1).name == name then index = index + 8 end
		if get_node(pos.x, pos.y - 1, pos.z + 1).name == name then index = index + 16 end
		if get_node(pos.x, pos.y - 1, pos.z).name == name then index = index + 32 end
		if get_node(pos.x, pos.y - 1, pos.z - 1).name == name then index = index + 64 end
		if get_node(pos.x, pos.y, pos.z - 1).name == name then index = index + 128 end
	elseif face.x == -1 then
		if get_node(pos.x, pos.y + 1, pos.z + 1).name == name then index = index + 1 end
		if get_node(pos.x, pos.y + 1, pos.z).name == name then index = index + 2 end
		if get_node(pos.x, pos.y + 1, pos.z - 1).name == name then index = index + 4 end
		if get_node(pos.x, pos.y, pos.z - 1).name == name then index = index + 8 end
		if get_node(pos.x, pos.y - 1, pos.z - 1).name == name then index = index + 16 end
		if get_node(pos.x, pos.y - 1, pos.z).name == name then index = index + 32 end
		if get_node(pos.x, pos.y - 1, pos.z + 1).name == name then index = index + 64 end
		if get_node(pos.x, pos.y, pos.z + 1).name == name then index = index + 128 end
	elseif face.z == 1 then
		if get_node(pos.x + 1, pos.y + 1, pos.z).name == name then index = index + 1 end
		if get_node(pos.x, pos.y + 1, pos.z).name == name then index = index + 2 end
		if get_node(pos.x - 1, pos.y + 1, pos.z).name == name then index = index + 4 end
		if get_node(pos.x - 1, pos.y, pos.z).name == name then index = index + 8 end
		if get_node(pos.x - 1, pos.y - 1, pos.z).name == name then index = index + 16 end
		if get_node(pos.x, pos.y - 1, pos.z).name == name then index = index + 32 end
		if get_node(pos.x + 1, pos.y - 1, pos.z).name == name then index = index + 64 end
		if get_node(pos.x + 1, pos.y, pos.z).name == name then index = index + 128 end
	else
		if get_node(pos.x - 1, pos.y + 1, pos.z).name == name then index = index + 1 end
		if get_node(pos.x, pos.y + 1, pos.z).name == name then index = index + 2 end
		if get_node(pos.x + 1, pos.y + 1, pos.z).name == name then index = index + 4 end
		if get_node(pos.x + 1, pos.y, pos.z).name == name then index = index + 8 end
		if get_node(pos.x + 1, pos.y - 1, pos.z).name == name then index = index + 16 end
		if get_node(pos.x, pos.y - 1, pos.z).name == name then index = index + 32 end
		if get_node(pos.x - 1, pos.y - 1, pos.z).name == name then index = index + 64 end
		if get_node(pos.x - 1, pos.y, pos.z).name == name then index = index + 128 end
	end
	return INDEX_TABLE[index]
end

local box = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

minetest.register_entity("thelimit:connected_texture", {
    hp_max = 1,
    physical = false,
    collide_with_objects = false,
    collisionbox = box,
    selectionbox = box,
    pointable = false,
    visual = "mesh",
    visual_size = {x = 10.01, y = 10.01, z = 10.01},
    mesh = "thelimit_node_face_centered.obj",
    textures = {"no_texture_airlike.png"},
    backface_culling = true,
    static_save = false,
	shaded = true
})

local function create_entities(pos, name, node_name)
	local side_pos = {}
	for i = 0, 5 do
		local face = minetest.wallmounted_to_dir(i)
		side_pos.x = pos.x + face.x
		side_pos.y = pos.y + face.y
		side_pos.z = pos.z + face.z
		local node = minetest.get_node(side_pos)
		if is_transparent(node.name) then
			local index = get_texture_index(pos, node_name, face)
			if index ~= 5 then
				side_pos.x = pos.x + face.x * 0.505
				side_pos.y = pos.y + face.y * 0.505
				side_pos.z = pos.z + face.z * 0.505
				local e = minetest.add_entity(side_pos, "thelimit:connected_texture")
				e:set_properties({textures = {"thelimit_" .. name .. "_" .. index .. ".png"}})
				
				if face.y == -1 then
					e:set_rotation({x = math.pi, y = 0.0, z = 0.0})
				elseif face.y ~= 1 then
					local y = 0
					if face.x == 1 then y = math.pi * 0.5
					elseif face.z == 1 then y = math.pi
					elseif face.x == -1 then y = math.pi * 1.5 end
					e:set_rotation({x = math.pi * 0.5, y = y, z = 0.0})
				end
			end
		end
	end
end

local function remove_entities(pos)
	local p1 = {x = pos.x - 0.506, y = pos.y - 0.506, z = pos.z - 0.506}
	local p2 = {x = pos.x + 0.506, y = pos.y + 0.506, z = pos.z + 0.506}
	for _, obj in ipairs(minetest.get_objects_in_area(p1, p2)) do
		local entity = obj:get_luaentity()
		if entity and entity.name == "thelimit:connected_texture" then
			obj:remove()
		end
	end
end

local function update_side_nodes(pos, name, node_name)
	local side_pos = {}
	for dx = -1, 1 do
		side_pos.x = pos.x + dx
		for dy = -1, 1 do
			side_pos.y = pos.y + dy
			for dz = -1, 1 do
				side_pos.z = pos.z + dz
				local node = minetest.get_node(side_pos)
				if node.name == node_name then
					remove_entities(side_pos)
					create_entities(side_pos, name, node_name)
				end
			end
		end
	end
end

minetest.register_lbm({
    label = "TheLimit Connected Textures Update",
    name = "thelimit:update_connected",
    nodenames = {"group:thelimit_ctm"},
    run_at_every_load = true,
    action = function(pos, node, dtime_s)
		local name = string.match(node.name, ":(.*)")
		create_entities(pos, name, node.name)
	end
})

local D = thelimit.description_maker

thelimit.register_connected = function(name, def)
	local node_name = "thelimit:" .. name
	
	def.tiles = {"thelimit_" .. name .. "_5.png"}
	def.description = D(name)
	
	def.groups = def.groups or {}
	def.groups.thelimit_ctm = 1
	
	def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		create_entities(pos, name, node_name)
		update_side_nodes(pos, name, node_name)
	end
	
	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		remove_entities(pos)
		update_side_nodes(pos, name, node_name)
	end
	
	minetest.register_node("thelimit:" .. name, def)
end