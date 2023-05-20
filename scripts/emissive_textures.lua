local D = thelimit.description_maker

local box = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

minetest.register_entity("thelimit:emissive_texture", {
    hp_max = 1,
    physical = false,
    collide_with_objects = false,
    collisionbox = box,
    selectionbox = box,
    pointable = false,
    visual = "mesh",
    visual_size = {x = 10, y = 10, z = 10},
    mesh = "thelimit_emissive_plant.obj",
    textures = {"no_texture_airlike.png"},
    backface_culling = true,
    static_save = false,
	shaded = false,
	glow = 100,
})

local function create_entity(pos, node_name)
	local node = minetest.registered_nodes[node_name]
	local emissive = node.thelimit_emissive
	local e = minetest.add_entity(pos, "thelimit:emissive_texture")
	e:set_rotation({x = 0, y = 0.02, z = 0})
	e:set_properties({
		mesh = emissive.mesh,
		textures = emissive.textures
	})
end

local function remove_entity(pos)
	for _, obj in ipairs(minetest.get_objects_in_area(pos, pos)) do
		local entity = obj:get_luaentity()
		if entity and entity.name == "thelimit:emissive_texture" then
			obj:remove()
		end
	end
end

minetest.register_lbm({
    label = "TheLimit Emissive Textures Update",
    name = "thelimit:update_emissive",
    nodenames = {"group:thelimit_emissive"},
    run_at_every_load = true,
    action = function(pos, node, dtime_s)
		create_entity(pos, node.name)
	end
})

local D = thelimit.description_maker

thelimit.register_emissive = function(name, def)
	local node_name = "thelimit:" .. name
	def.description = D(name)
	
	def.groups = def.groups or {}
	def.groups.thelimit_emissive = 1
	
	def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		create_entity(pos, node_name)
	end
	
	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		remove_entity(pos)
	end
	
	minetest.register_node("thelimit:" .. name, def)
end