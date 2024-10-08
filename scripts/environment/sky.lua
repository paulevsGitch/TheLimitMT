local INVISIBLE = {
	visible = false,
	sunrise_visible = false
}

local STARS = {
	visible = true,
	day_opacity = 1.0,
	count = 3000,
	star_color = "#f9e5fe", --"#f3acf9",
	scale = 0.6
}

local SKY = {
	type = "skybox",
	textures = {
		"thelimit_sky_py.png",
		"thelimit_sky_ny.png",
		"thelimit_sky_nx.png",
		"thelimit_sky_px.png",
		"thelimit_sky_pz.png",
		"thelimit_sky_nz.png"
	},
	base_color = "#171235",
	clouds = false,
	fog = {
		fog_color = "#3f3786"
	}
}

local BIOME_PARTICLES = {
	size = 4,
	collisiondetection = true,
	collision_removal = false,
	object_collision = false,
	vertical = false,
	texture = {
		name = "thelimit_yellow_particle.png",
		blend = "screen",
		scale_tween = {
			style = "pulse",
			0, 1
		}
	},
	glow = 100,
	pos = {
		min = {x = -50, y = -50, z = -50},
		max = {x =  50, y =  50, z =  50}
	},
	jitter = {
		min = {x = -1, y = -1, z = -1},
		max = {x =  1, y =  1, z =  1}
	},
	vel = {
		min = {x = -1, y = -1, z = -1},
		max = {x =  1, y =  1, z =  1}
	},
	exptime = {min = 5, max = 10},
	amount = 100,
	time = 0
}

local players_sky = {}
local update_delta = 0

local function update_biome_particles(player)
	local pos = player:get_pos()
	local biome = thelimit.biome_map.get_biome(pos.x, pos.z)
	local data = players_sky[player]

	if not data then
		data = {}
		players_sky[player] = data
	end

	if data.biome ~= biome.id then
		data.biome = biome.id

		if data.particles then
			minetest.delete_particlespawner(data.particles, player:get_player_name())
		end

		local particles = biome.particles
		if particles then
			local def = table.copy(BIOME_PARTICLES)
			for k, v in pairs(particles) do
				def[k] = v
			end
			def.attached = player
			data.particles = minetest.add_particlespawner(def)
		else
			data.particles = nil
		end
	end
end

local function on_dimension_set(player)
	player:set_sky(SKY)
	player:set_sun(INVISIBLE)
	player:set_moon(INVISIBLE)
	player:set_stars(STARS)
	update_biome_particles(player)
end

minetest.register_globalstep(function(dtime)
	update_delta = update_delta + dtime
	if update_delta < 2 then return end
	update_delta = 0
	
	for _, player in pairs(minetest.get_connected_players()) do
		local is_in_dim = thelimit.is_in_dimension(player)

		if is_in_dim and not players_sky[player] then
			on_dimension_set(player)
		elseif not is_in_dim and players_sky[player] then
			player:set_sky()
			player:set_sun()
			player:set_moon()
			player:set_stars()
			local data = players_sky[player]
			minetest.delete_particlespawner(data.particles, player)
			players_sky[player] = nil
		end

		if is_in_dim then
			update_biome_particles(player)
		end
	end
end)

minetest.register_on_joinplayer(function(player, last_login)
	if thelimit.is_in_dimension(player) then
		on_dimension_set(player)
	end
end)