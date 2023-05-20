local D = thelimit.description_maker

local pillar_box = {
	type = "connected",
	fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
	disconnected_top = {
		{-0.4375, 0.3125, -0.4375, 0.4375, 0.5, 0.4375},
		{-0.375, 0.125, -0.375, 0.375, 0.3125, 0.375}
	},
	disconnected_bottom = {
		{-0.4375, -0.3125, -0.4375, 0.4375, -0.5, 0.4375},
		{-0.375, -0.125, -0.375, 0.375, -0.3125, 0.375}
	}
}

local box_middle = {
	type = "fixed",
	fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125}
}

local box_top = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.5, -0.3125, 0.3125, 0.45, 0.3125},
		{-0.4375, 0.3125, -0.4375, 0.4375, 0.5, 0.4375},
		{-0.375, 0.125, -0.375, 0.375, 0.3125, 0.375}
	}
}

local box_bottom = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.45, -0.3125, 0.3125, 0.5, 0.3125},
		{-0.4375, -0.3125, -0.4375, 0.4375, -0.5, 0.4375},
		{-0.375, -0.125, -0.375, 0.375, -0.3125, 0.375}
	}
}

local box_small = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.45, -0.3125, 0.3125, 0.45, 0.3125},
		{-0.4375, 0.3125, -0.4375, 0.4375, 0.5, 0.4375},
		{-0.375, 0.125, -0.375, 0.375, 0.3125, 0.375},
		{-0.4375, -0.3125, -0.4375, 0.4375, -0.5, 0.4375},
		{-0.375, -0.125, -0.375, 0.375, -0.3125, 0.375}
	}
}

local mutable_pos = {}
local function is_pillar(x, y, z, param2)
	mutable_pos.x = x
	mutable_pos.y = y
	mutable_pos.z = z
	local node = minetest.get_node(mutable_pos)
	return node.param2 == param2 and minetest.get_item_group(node.name, "thelimit_thin_pillar") == 1
end

local pillar_pos = {}
local function update_pillar(x, y, z)
	pillar_pos.x = x
	pillar_pos.y = y
	pillar_pos.z = z
	
	local node = minetest.get_node(pillar_pos)
	
	if minetest.get_item_group(node.name, "thelimit_thin_pillar") ~= 1 then return end
	
	local bottom = false
	local top = false
	
	if node.param2 == 12 then
		bottom = is_pillar(x - 1, y, z, node.param2)
		top = is_pillar(x + 1, y, z, node.param2)
	elseif node.param2 == 4 then
		bottom = is_pillar(x, y, z - 1, node.param2)
		top = is_pillar(x, y, z + 1, node.param2)
	else
		bottom = is_pillar(x, y - 1, z, node.param2)
		top = is_pillar(x, y + 1, z, node.param2)
	end
	
	local name = node.name:match("^(.+)%_(.+)$")
	if bottom and top then name = name .. "_middle"
	elseif bottom and not top then name = name .. "_top"
	elseif not bottom and top then name = name .. "_bottom"
	else name = name .. "_small" end
	
	if name ~= node.name then
		node.name = name
		minetest.set_node(pillar_pos, node)
	end
end

local function place_pillar(itemstack, placer, pointed_thing)
	local under = pointed_thing.under
	local above = pointed_thing.above
	
	local dx = above.x - under.x
	local dy = above.y - under.y
	local dz = above.z - under.z
	
	local node_name = itemstack:get_name()
	local bottom = false
	local top = false
	local param2 = 0
	
	if dx ~= 0 then
		param2 = 12
		bottom = is_pillar(under.x - 1, under.y, under.z, param2)
		top = is_pillar(under.x + 1, under.y, under.z, param2)
	elseif dz ~= 0 then
		param2 = 4
		bottom = is_pillar(under.x, under.y, under.z - 1, param2)
		top = is_pillar(under.x, under.y, under.z + 1, param2)
	else
		bottom = is_pillar(under.x, under.y - 1, under.z, param2)
		top = is_pillar(under.x, under.y + 1, under.z, param2)
	end
	
	local place_name = node_name:match("^(.+)%_(.+)$")
	if bottom and top then place_name = place_name .. "_middle"
	elseif bottom and not top then place_name = place_name .. "_top"
	elseif not bottom and top then place_name = place_name .. "_bottom"
	else place_name = place_name .. "_small" end
	
	itemstack:set_name(place_name)
	local result = minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(node_name)
	
	update_pillar(above.x, above.y, above.z)
	
	if dx ~= 0 then
		update_pillar(above.x - 1, above.y, above.z)
		update_pillar(above.x + 1, above.y, above.z)
	elseif dz ~= 0 then
		update_pillar(above.x, above.y, above.z - 1)
		update_pillar(above.x, above.y, above.z + 1)
	else
		update_pillar(above.x, above.y - 1, above.z)
		update_pillar(above.x, above.y + 1, above.z)
	end
	
	return result
end

local function after_break_pillar(pos, oldnode, oldmetadata, digger)
	minetest.chat_send_all(oldnode.param2)
	if oldnode.param2 == 12 then
		update_pillar(pos.x - 1, pos.y, pos.z)
		update_pillar(pos.x + 1, pos.y, pos.z)
	elseif oldnode.param2 == 4 then
		update_pillar(pos.x, pos.y, pos.z - 1)
		update_pillar(pos.x, pos.y, pos.z + 1)
	else
		update_pillar(pos.x, pos.y - 1, pos.z)
		update_pillar(pos.x, pos.y + 1, pos.z)
	end
end

thelimit.register_thin_pillar = function(name, def)
	def.groups = def.groups or {}
	def.groups.thelimit_thin_pillar = 1
	
	def.description = D(name)
	def.paramtype2 = "facedir"
	def.paramtype = "light"
	def.drawtype = "mesh"
	
	def.on_place = place_pillar
	def.after_dig_node = after_break_pillar
	
	local small = "thelimit:" .. name .. "_small"
	def.drop = small
	
	def.mesh = "thelimit_thin_pillar_small.obj"
	def.tiles = {"thelimit_" .. name .. "_ends.png", "thelimit_" .. name .. "_top.png"}
	def.selection_box = box_small
	def.collision_box = box_small
	minetest.register_node(small, def)
	
	def = table.copy(def)
	def.groups.not_in_creative_inventory = 1
	def.selection_box = box_bottom
	def.collision_box = box_bottom
	def.mesh = "thelimit_thin_pillar_bottom.obj"
	def.tiles = {"thelimit_" .. name .. "_ends.png", "thelimit_" .. name .. "_top.png", "thelimit_" .. name .. "_middle.png"}
	minetest.register_node("thelimit:" .. name .. "_bottom", def)
	
	def = table.copy(def)
	def.mesh = "thelimit_thin_pillar_top.obj"
	def.selection_box = box_top
	def.collision_box = box_top
	minetest.register_node("thelimit:" .. name .. "_top", def)
	
	def = table.copy(def)
	def.selection_box = box_middle
	def.collision_box = box_middle
	def.mesh = "thelimit_thin_pillar_middle.obj"
	def.tiles = {"thelimit_" .. name .. "_middle.png"}
	minetest.register_node("thelimit:" .. name .. "_middle", def)
end