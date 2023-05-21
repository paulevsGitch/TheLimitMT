thelimit.node_sound = function(table)
	table = table or {}
	table.footstep = table.footstep or {name = "", gain = 1.0}
	table.dug = table.dug or {name = "default_dug_node", gain = 0.25}
	table.place = table.place or {name = "default_place_node_hard", gain = 1.0}
	return table
end

thelimit.simple_sound = function(name)
	return {
		footstep = {name = name, gain = 1.0},
		dig = {name = name, gain = 0.25},
		dug = {name = name, gain = 0.25},
		place = {name = name, gain = 1.0}
	}
end