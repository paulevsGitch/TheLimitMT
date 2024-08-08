local STELLATA_BRANCH_ID = minetest.get_content_id("thelimit:stellata_branch")
local STELLATA_FLOWER_ID = minetest.get_content_id("thelimit:stellata_flower")
local STELLATA_STEM_ID = {
	minetest.get_content_id("thelimit:stellata_stem_1"),
	minetest.get_content_id("thelimit:stellata_stem_2")
}
local STELLATA_BARK_ID = {
	minetest.get_content_id("thelimit:stellata_bark_1"),
	minetest.get_content_id("thelimit:stellata_bark_2"),
	minetest.get_content_id("thelimit:stellata_bark_3")
}
local STELLATA_LOG_ID = {
	minetest.get_content_id("thelimit:stellata_log_1"),
	minetest.get_content_id("thelimit:stellata_log_2"),
	minetest.get_content_id("thelimit:stellata_log_3")
}

local function rnd(count)
	return math.floor(math.random() * count + 1)
end

local function makeTrunk(pos, height, context)
	local result_height = height
	for i = 1, height do
		context.set_node(pos, STELLATA_LOG_ID[rnd(3)])
		pos.y = pos.y + 1
		if not thelimit.can_replace(context.get_node(pos)) then
			result_height = i
			goto trunk_break
		end
	end
	::trunk_break::
	context.set_node(pos, STELLATA_BARK_ID[rnd(3)])
	return result_height
end

local function makeRoots(pos, height, context)
	local rnd_h = 3
	if rnd_h > height then rnd_h = height end
	
	for i = 1, 4 do
		local dir = minetest.fourdir_to_dir(i)
		pos.y = math.floor(math.random() * rnd_h)
		pos.x = dir.x
		pos.z = dir.z
		if thelimit.can_replace(context.get_node(pos)) then
			pos.x = dir.x
			pos.z = dir.z
			context.set_node(pos, STELLATA_BRANCH_ID)
			for j = 1, 4 do
				pos.y = pos.y - 1
				if not thelimit.can_replace(context.get_node(pos)) then
					goto root_break
				end
				context.set_node(pos, STELLATA_STEM_ID[rnd(2)])
			end
			pos.y = pos.y - 1
			if thelimit.can_replace(context.get_node(pos)) then
				context.set_node(pos, STELLATA_BRANCH_ID)
			end
		end
		::root_break::
	end
end

local function makeBranches(pos, height, context)
	for i = 1, 4 do
		local dir = minetest.fourdir_to_dir(i)
		pos.y = height - math.floor(math.random() * 5) - 1
		if pos.y < 0 then pos.y = 0 end
		pos.x = dir.x
		pos.z = dir.z
		if thelimit.can_replace(context.get_node(pos)) then
			pos.x = dir.x
			pos.z = dir.z
			context.set_node(pos, STELLATA_BRANCH_ID)
			local branchHeight = math.floor(math.random() * 5);
			for j = 1, branchHeight do
				pos.y = pos.y + 1
				if not thelimit.can_replace(context.get_node(pos)) then
					goto branch_break
				end
				context.set_node(pos, STELLATA_STEM_ID[rnd(2)])
			end
			pos.y = pos.y + 1
			if thelimit.can_replace(context.get_node(pos)) then
				context.set_node(pos, STELLATA_FLOWER_ID)
			end
		end
		::branch_break::
	end
	
	pos.y = height + 1
	pos.x = 0
	pos.z = 0
	
	if thelimit.can_replace(context.get_node(pos)) then
		context.set_node(pos, STELLATA_BRANCH_ID)
		local branchHeight = math.floor(math.random() * 3) + 2;
		for j = 1, branchHeight do
			pos.y = pos.y + 1
			if not thelimit.can_replace(context.get_node(pos)) then
				goto branch_end
			end
			context.set_node(pos, STELLATA_STEM_ID[rnd(2)])
		end
		pos.y = pos.y + 1
		if thelimit.can_replace(context.get_node(pos)) then
			context.set_node(pos, STELLATA_FLOWER_ID)
		end
	end
	
	::branch_end::
end

thelimit.trees.stellata = function(context)
	local pos = {x = 0, y = 0, z = 0}
	local height = math.floor(math.random() * 4 + 8)
	for i = 1, height + 3, 2 do
		pos.y = i
		if context.get_node(pos) ~= minetest.CONTENT_AIR then
			goto place_end
		end
	end
	pos.y = 0
	height = makeTrunk(pos, height, context)
	makeRoots(pos, height, context)
	makeBranches(pos, height, context)
	::place_end::
end

thelimit.trees.stellata_small = function(context)
	local pos = {x = 0, y = 0, z = 0}
	local height = math.floor(math.random() * 3 + 1)
	
	for i = 1, height do
		context.set_node(pos, STELLATA_STEM_ID[rnd(2)])
		pos.y = pos.y + 1
		if not thelimit.can_replace(context.get_node(pos)) then
			goto small_end
		end
	end
	
	context.set_node(pos, STELLATA_FLOWER_ID)
	
	::small_end::
end