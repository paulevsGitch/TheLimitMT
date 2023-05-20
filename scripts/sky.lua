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
	clouds = false
}

local players_sky = {}
local update_delta = 0

minetest.register_globalstep(function(dtime)
	update_delta = update_delta + dtime
	if update_delta < 2 then return end
	update_delta = 0
	
	for _, player in pairs(minetest.get_connected_players()) do
		local is_in_dim = thelimit.is_in_dimension(player)
		if is_in_dim and not players_sky[player] then
			player:set_sky(SKY)
			player:set_sun(INVISIBLE)
			player:set_moon(INVISIBLE)
			player:set_stars(STARS)
			players_sky[player] = 1
		elseif not is_in_dim and players_sky[player] then
			player:set_sky()
			player:set_sun()
			player:set_moon()
			player:set_stars()
			players_sky[player] = nil
		end
	end
end)

minetest.register_on_joinplayer(function(player, last_login)
	if thelimit.is_in_dimension(player) then
		player:set_sky(SKY)
		player:set_sun(INVISIBLE)
		player:set_moon(INVISIBLE)
		player:set_stars(STARS)
		players_sky[player] = 1
	end
end)