local stairs_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
		{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5}
	}
}

-- 0 = y+,   1 = z+,   2 = z-,   3 = x+,   4 = x-,   5 = y-
local function simple_facedir(dir)
	if dir.x == 1 then
		return 4
	elseif dir.x == -1 then
		return 3
	elseif dir.y == 1 then
		return 5
	elseif dir.y == -1 then
		return 0
	elseif dir.z == 1 then
		return 2
	else
		return 1
	end
end

local stairs_angles = {5, 7, 11, 9}

local function stairs_place(itemstack, placer, pointed_thing)
	local dir = vector.subtract(pointed_thing.under, pointed_thing.above)
	local vec = placer:get_look_dir()
	
	local index = 0
	
	if dir.y ~= 0 then
		local ax = math.abs(vec.x)
		local az = math.abs(vec.z)
		local mx = math.max(ax, az)
		local rotation = 0
		
		if dir.y < 0 then
			if mx == ax then
				if vec.x > 0 then
					rotation = 1
				else
					rotation = 3
				end
			else
				if vec.z > 0 then
					rotation = 0
				else
					rotation = 2
				end
			end
		else
			if mx == ax then
				if vec.x > 0 then
					rotation = 3
				else
					rotation = 1
				end
			else
				if vec.z > 0 then
					rotation = 0
				else
					rotation = 2
				end
			end
		end
		
		index = bit.bor(bit.lshift(simple_facedir(dir), 2), rotation)
	else
		local rotation = math.atan2(vec.x, vec.z)
		rotation = math.floor((rotation + math.pi) * 2.0 / math.pi)
		rotation = bit.band(rotation + 1, 3) + 1
		index = stairs_angles[rotation]
	end
	
	return minetest.item_place(itemstack, placer, pointed_thing, index)
end

local D = thelimit.description_maker

thelimit.register_stairs = function(name, def)
	def.description = D(name)
	
	def.drawtype = "nodebox"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.node_box = stairs_box
	def.on_place = stairs_place
	
	minetest.register_node("thelimit:" .. name, def)
end