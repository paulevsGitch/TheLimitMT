local TRANSITION = thelimit.TRANSITION
local AIR_ID = minetest.get_content_id("air")

local light_data = {}
local node_data = {}

local function process_light(value, sun_light)
	local night = math.floor(value / 16)
	night = math.max(night, 1)
	return night * 16 + sun_light
end

local TRANSPARENT_NODES = {}
--local LIGHT_NODES = {}

thelimit.update_sky_light = function(emin, emax, node_data, light_data)
	local side = emax.x - emin.x
	local side_max = side - 2
	local array_side_dy = side + 1
	local array_side_dz = array_side_dy * array_side_dy
	local size = array_side_dy * array_side_dz
	local index_dec, p
	
	for index = 1, size do
		--light_data[index] = 0
		--if LIGHT_NODES[node_data[index]] then
		--	goto light_fill_end
		--end
		
		if not TRANSPARENT_NODES[node_data[index]] then
			light_data[index] = 0
			goto light_fill_end
		end
		
		index_dec = index - 1
		p = index_dec % array_side_dy
		if p < 2 or p > side_max then
			light_data[index] = process_light(light_data[index], 1)
			goto light_fill_end
		end
		
		p = math.floor(index_dec / array_side_dy) % array_side_dy
		if p < 2 or p > side_max then
			light_data[index] = process_light(light_data[index], 1)
			goto light_fill_end
		end
		
		p = math.floor(index_dec / array_side_dz)
		if p < 2 or p > side_max then
			light_data[index] = process_light(light_data[index], 1)
			goto light_fill_end
		end
		
		local sky_light = 15
		
		for dx = -2, 2 do
			for dy = -2, 2 do
				for dz = -2, 2 do
					local index_p = index + dx + dy * array_side_dy + dz * array_side_dz
					if node_data[index_p] ~= AIR_ID then
						sky_light = 1
						goto light_end_iterator
					end
				end
			end
		end
		
		::light_end_iterator::
		
		light_data[index] = process_light(light_data[index], sky_light)
		
		::light_fill_end::
	end
end

local function update_light(pos)
	local p1 = {x = pos.x - 15, y = pos.y - 15, z = pos.z - 15}
	local p2 = {x = pos.x + 15, y = pos.y + 15, z = pos.z + 15}
	local vm = minetest.get_voxel_manip(p1, p2)
	
	vm:get_data(node_data)
	vm:get_light_data(light_data)
	
	local p1, p2 = vm:get_emerged_area()
	local area = VoxelArea(p1, p2)
	
	p1.x = p1.x + 2
	p1.y = p1.y + 2
	p1.z = p1.z + 2
	
	p2.x = p2.x - 2
	p2.y = p2.y - 2
	p2.z = p2.z - 2
	
	for index in area:iterp(p1, p2) do
		if not TRANSPARENT_NODES[node_data[index]] then
			light_data[index] = 0
		else
			pos = area:position(index)
			local sky_light = 15
			
			for dx = -2, 2 do
				for dy = -2, 2 do
					for dz = -2, 2 do
						local index_p = area:index(pos.x + dx, pos.y + dy, pos.z + dz)
						if node_data[index_p] ~= AIR_ID then
							sky_light = 1
							goto light_fill_end
						end
					end
				end
			end
			
			::light_fill_end::
			
			light_data[index] = process_light(light_data[index], sky_light)
		end
	end
	
	vm:set_light_data(light_data)
	vm:write_to_map(false)
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	if pos.y > TRANSITION then
		update_light(pos)
	end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if pos.y > TRANSITION then
		update_light(pos)
	end
end)

minetest.register_on_mods_loaded(function()
	for name, node in pairs(minetest.registered_nodes) do
		if node.paramtype == "light" then
			TRANSPARENT_NODES[minetest.get_content_id(name)] = 1
		end
		--if node.light_source then
		--	LIGHT_NODES[minetest.get_content_id(name)] = 1
		--end
	end
end)