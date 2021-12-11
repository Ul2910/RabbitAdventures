--[[ 
	Calculations of different animations: carrot, veggies,
	flying balls, thorns, moving system of coordinates.
	Checking if colliding with an obstacle.
	Calculating current ground level under the rabbit.
]]--

-- Animation of moving thorns on the ground
function thorns_animation(dt)
	thorns_timer = thorns_timer + 20 * dt
	if thorns_timer < 0 then return end
	for i = 1, obst_counter do
		if obstacles[i].type == 1 and i % 2 == 0 then 
			obstacles[i].y = obstacles[i].y - thorns_direction * 20 * dt
		elseif obstacles[i].type == 1 and i % 2 == 1 then 
			obstacles[i].y = obstacles[i].y + thorns_direction * 20 * dt
		end
	end
	if thorns_timer > 26 then thorns_timer = -35 thorns_direction = thorns_direction * -1 end
end

-- Animation of the deadly balls and chest firing them
function chest_and_balls_animation(dt)
	for i = 1, #ball.x do 
		if ball.status[i] == 'on' then
			ball.x[i] = math.floor(ball.x[i] - 350 * dt + 0.5)
			if ball.x[i] < -26 then 
				ball.status[i] = 'off' 
				ball.x[i] = 16926 
			end
			if ball.timer[i] < 1 then 
				ball.timer[i] = ball.timer[i] - 1 * dt
				if ball.timer[i] < 0 then 
					ball.timer[i] = 1 
					chest.frame = 1
				end
			end
		elseif ball.status[i] == 'off' then
			chest.frame = 2
			ball.timer[i] = ball.timer[i] - 1 * dt
			if ball.timer[i] < 0.5 then ball.status[i] = 'on' end
		end
	end
end


-- Calculating the current ground level or 'y' under the rabbit
function current_ground_y(current_rabbit_x)
	local left_corner = math.floor(current_rabbit_x / 170 + 1)
	local right_corner = math.floor((current_rabbit_x + 94) / 170 + 1)
	local level1 = 660
	if map[left_corner] == 0 and map[right_corner] == 0 and right_corner < 75 then
		return 660
	elseif map[left_corner] == 2 or map[right_corner] == 2 then
		level1 = 495
	elseif map[left_corner] == 1 or map[right_corner] == 1 then
		level1 = 570
	end
	local level2 = level1
	local highest_obst
	for i = 1, obst_counter - 1 do
			if obstacles[i].type ~= 1 then
				if (obstacles[i].x < current_rabbit_x + 94 and obstacles[i].x > current_rabbit_x)
				 or (obstacles[i].x + obstacles[i].width < current_rabbit_x + 94 and obstacles[i].x + obstacles[i].width > current_rabbit_x) 
				 or (obstacles[i].type == 2 and current_rabbit_x >= obstacles[i].x and current_rabbit_x + 94 <= obstacles[i].x + obstacles[i].width) then
					highest_obst = obstacles[i].y + obstacles[i].height - obstacles[i].jump_height - 60
					if level2 > highest_obst then level2 = highest_obst end
				end
			end
	end
	-- Check if the rabbit is above the platform
	if current_rabbit_x + 94 > platform.x and current_rabbit_x < platform.x + platform.width and platform.y - 60 < level2 then level2 = platform.y - 60 end
	return math.floor(math.min(level1, level2) + 0.5)
end

-- Calculating placement of rabbit, carrot, veggies and the system of coordinates
function changer()
	if gameIsPaused then return end
	carrot_update()
	veggies_update()
	local platform_distance = platform_update()
	
	if state == 'jump' or state == 'fall' then gravity = gravity + 25 end
	if state == 'fall' then dx = dx + platform_push_rabbit() return end
	if love.keyboard.isDown("left") and dx + 5 <= 0 and rabbit_x == 590 and is_obstacle(rabbit_x - (dx + 4)) == false then
		dx = dx + 5 - platform_distance * platform.direction
	elseif love.keyboard.isDown("left") and rabbit_x - 5 >= 0 and is_obstacle(rabbit_x - dx - 4) == false then
		rabbit_x = rabbit_x - 5
	elseif love.keyboard.isDown("right") and dx - 5 >= -15720 and rabbit_x == 590 and is_obstacle(rabbit_x + 94 - (dx - 4 - platform_distance * platform.direction)) == false then
		dx = dx - 5 - platform_distance * platform.direction
	elseif love.keyboard.isDown("right") and rabbit_x + 5 <= 1186 and is_obstacle(rabbit_x + 94 - dx + 4) == false then
		rabbit_x = rabbit_x + 5
	else dx = dx - platform_distance * platform.direction
	end
end

-- Checking if the rabbit is about to collide with obstacles or higher ground
function is_obstacle(check_x)
	local i = math.floor(check_x / 170 + 1)
	if map[i] == 2 and math.floor(rabbit_y + 0.5) + 60 > 555 then return true
	elseif map[i] == 1 and math.floor(rabbit_y + 0.5) + 60 > 630 then return true
	else
		for i = 1, obst_counter do
			if obstacles[i].type ~= 1 and check_x >= obstacles[i].x and check_x <= obstacles[i].x + obstacles[i].width and math.floor(rabbit_y + 0.5) + 60 > obstacles[i].y + obstacles[i].height - obstacles[i].jump_height then return true end
		end
		-- Check platform collision
		if check_x >= platform.x and check_x <= platform.x + platform.width and math.floor(rabbit_y + 0.5) < platform.y + platform.height and math.floor(rabbit_y + 0.5) + 60 > platform.y then return true end
	end
	return false
end

-- Animation of the carrot
function carrot_update()
	if carrot.state == 'off' then
		carrot.distance = 300
		carrot.direction = direction
	    carrot.y = math.floor(rabbit_y + 0.5) + 25
	    if carrot.direction == -1 then carrot.x = rabbit_x
	    else carrot.x = rabbit_x + 44 end
	else
		if carrot.direction == 1 then carrot.x = carrot.x + 7
		else carrot.x = carrot.x - 7 end
		carrot.distance = carrot.distance - 7
		if carrot.distance < -7 or carrot_collision(carrot.x - dx + 50) == true then carrot.state = 'off' end
	end
end

-- Animation of the collected veggies
function veggies_update()
	for i = 1, obst_counter - 1 do
		if obstacles[i].fireable == true then
			local j = 1
			while j <= #obstacles[i].veggies and obstacles[i].veggies[j].status == 'on' do
				obstacles[i].veggies[j].y = obstacles[i].veggies[j].y - 3 
				if obstacles[i].y - obstacles[i].veggies[j].y > 250 then
					table.remove(obstacles[i].veggies, j)
					j = j - 1
				end
				j = j + 1
			end
		end
	end
end

-- Checking carrot collision and if it hits obstacles with veggies inside of them
function carrot_collision(check_x)
	if carrot.direction == -1 then check_x = check_x - 50 end
	local i = math.floor(check_x / 170 + 1)
	if map[i] == 2 and carrot.y + 19 > 555 then return true
	elseif map[i] == 1 and carrot.y + 19 > 630 then return true
	else
		for i = 1, obst_counter do
			if check_x >= obstacles[i].x and check_x <= obstacles[i].x + obstacles[i].width and carrot.y + 19 > obstacles[i].y + obstacles[i].height - obstacles[i].jump_height then 
				if obstacles[i].fireable == true and obstacles[i].shots > 0 and i < obst_counter then 
					carrot_sound:play()
					local j = 1
					while j <= #obstacles[i].veggies and obstacles[i].veggies[j].status == 'on' do j = j + 1 end
					obstacles[i].veggies[j].status = 'on'
					obstacles[i].shots = obstacles[i].shots - 1
					collectibles.got = collectibles.got + 1
					if obstacles[i].shots == 0 then obstacles[i].alpha = 0.8 end
				elseif i == obst_counter and obstacles[i].shots > 0 then 
					obstacles[i].shots = obstacles[i].shots - 1
					chest_dmg_sound:play()
					if obstacles[i].shots == 0 then 
						state = 'win' 
						music:stop()
						win_sound:play()
						chest.frame = 1 
						for i = 1, #ball.x do ball.status[i] = 'off' end
					end
				end
				return true 
			end
		end
	end
	return false
end