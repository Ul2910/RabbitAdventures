--[[ 
	Randomly generating map, filling it with obstacles and back images
]]--

-- Randomly generating map, obstacles and background images
function fill_map()
	math.randomseed(os.time())
	map = {}
	back = {}
	obst_counter = 0
	back_counter = 0
	local middle = 0
	for i = 1, 100 do
		local rand = math.random(5)
		if (i > 1 and i < 75 and rand == 1 and map[i-1] ~= 0) or (i > 75 and i < 96) then
			map[i] = 0
			back[i] = 0
		elseif (i == 75 or (i > 1 and rand == 2) or i > 95) and check_obst_reachable(i, obst_counter) == true then
		 	map[i] = 2
		else
			map[i] = 1
		end
		if map[i] == 1 or map[i] == 2 and math.random(3) > 1 then 
			back_counter = back_counter + 1
			backgrounds[back_counter] = backgrounds_create(math.random(7), i, map[i])
		end
		if (map[i] == 2 or map[i] == 1) and i > 1 and i < 75 and math.random(5) > 2 then
			obst_counter = obst_counter + 1
			obstacles[obst_counter] = obstacles_create(math.random(7), i, map[i])
			if obstacles[obst_counter].type == 1 and obst_counter % 2 == 0 then obstacles[obst_counter].y = obstacles[obst_counter].y + 26 end
			collectibles.total = collectibles.total + obstacles[obst_counter].shots
			for i = 1, obstacles[obst_counter].shots do 
				middle = obstacles[obst_counter].x + math.floor(obstacles[obst_counter].width / 2)
				obstacles[obst_counter].veggies[i] = veggies_create(math.random(5), middle, obstacles[obst_counter].y) 
			end
		end
	end

	-- Adding chest
	obst_counter = obst_counter + 1
	obstacles[obst_counter] = chest
	middle = obstacles[obst_counter].x + math.floor(obstacles[obst_counter].width / 2)

	-- Veggies inside the chest
	for i = 1, 13 do
		chest.veggies[i] = chest_veggies_create(math.random(5))
		if i > 1 then chest.veggies[i].y = chest.veggies[i - 1].y + 40 end
	end
end

-- If map height is 2, then we need to make sure that the previous obstacle is reachable (is not between two map tiles of height 2)
function check_obst_reachable(i, obst_counter)
	if obst_counter == 0 then return true end
	if map[i-1] == 1 
	and (i == 2 or map[i-2] == 2)
	and obstacles[obst_counter].fireable == true 
	and obstacles[obst_counter].x >= 170 * (i - 2) then 
		return false
	else
		return true end
end