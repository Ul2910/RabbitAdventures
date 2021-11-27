text = "Hello"
text1 = "Hello"
text_x = 100
text_y = 300
x = 0
y = 630
dx = 0
dy = 0
rabbit_current_frame = 1
timer = 1
direction = 1
rabbit_y = 570
rabbit_x = 0
state = 'walk'
gravity = -600
ball_x = {4450, 5700, 6000, 6300, 6720, 8100, 8500, 9900, 10600, 16000}
ball_y = 500
obst_img = {}
veggies_img = {}

collectibles = {}
collectibles.got = 0
collectibles.total = 0

-- map width = 25 or 170 px * 25 = 4250 px
-- with platform 6800 px

obstacles = {}

-- obstacles.__index = obstacles

function obstacles.create(type_num, map_num, map_height)
	-- local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			width = 80,
			height = 25,
			jump_height = 25,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 25,			
			deadly = true,
			fireable = false,
			shots = 0,
			alpha = 1
		}
	elseif type_num == 2 then
		this = {
			type = type_num,
			width = 170,
			height = 78,
			jump_height = 30,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 78,			
			deadly = false,
			fireable = false,
			shots = 0,
			alpha = 1
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			width = 77,
			height = 75,
			jump_height = 75,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 75,			
			deadly = false,
			fireable = false,
			shots = 0,
			alpha = 1
		}
	elseif type_num == 4 then
		this = {
			type = type_num,
			width = 58,
			height = 75,
			jump_height = 75,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 75,			
			deadly = false,
			fireable = true,
			shots = 3,
			alpha = 1,
			veggies = {}
		}
	elseif type_num == 5 then
		this = {
			type = type_num,
			width = 66,
			height = 70,
			jump_height = 50,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 70,			
			deadly = false,
			fireable = true,
			shots = 1,
			alpha = 1,
			veggies = {}
		}
	elseif type_num == 6 then
		this = {
			type = type_num,
			width = 55,
			height = 75,
			jump_height = 75,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 75,			
			deadly = false,
			fireable = true,
			shots = 2,
			alpha = 1,
			veggies = {}
		}
	elseif type_num == 7 then
		this = {
			type = type_num,
			width = 57,
			height = 50,
			jump_height = 50,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 50,			
			deadly = false,
			fireable = false,
			shots = 0,
			alpha = 1
		}
	end
	-- setmetatable(this, obstacles)
	return this
end

function veggies_create(type_num, x, y)
	-- local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			width = 26,
			height = 24,
			x = x - 13,
			y = y - 24,			
			state = 'off'
		}
	elseif type_num == 2 then
		this = {
			type = type_num,
			width = 36,
			height = 36,
			x = x - 18,
			y = y - 36,			
			state = 'off'
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			width = 39,
			height = 36,
			x = x - 19,
			y = y - 36,			
			state = 'off'
		}
	elseif type_num == 4 then
		this = {
			type = type_num,
			width = 23,
			height = 27,
			x = x - 11,
			y = y - 27,			
			state = 'off'
		}
	elseif type_num == 5 then
		this = {
			type = type_num,
			width = 23,
			height = 22,
			x = x - 11,
			y = y - 22,			
			state = 'off'
		}
	end
	-- setmetatable(this, obstacles)
	return this
end

function fill_map()
	math.randomseed(os.time())
	map = {}
	back = {}
	obst_counter = 0
	for i = 1, 25 do
		local rand = math.random(5)
		if i > 1 and i < 25 and rand == 1 and map[i-1] ~= 0 then
			map[i] = 0
			back[i] = 0
		elseif i > 1 and rand == 2 then
		 	map[i] = 2
		else
			map[i] = 1
			rand = math.random(4)
			if rand == 1 then back[i] = 'tree'
			elseif rand == 2 then back[i] = 'sunflowers'
			elseif rand == 3 then back[i] = 'wheat'
			elseif rand == 4 then back[i] = 'clothes' end
		end
		if map[i] == 2 or map[i] == 1 and i > 1 and i < 25 and math.random(3) > 1 then
			obst_counter = obst_counter + 1
			obstacles[obst_counter] = obstacles.create(math.random(7), i, map[i])
			collectibles.total = collectibles.total + obstacles[obst_counter].shots
			for i = 1, obstacles[obst_counter].shots do 
				local middle = obstacles[obst_counter].x + math.floor(obstacles[obst_counter].width / 2)
				obstacles[obst_counter].veggies[i] = veggies_create(math.random(5), middle, obstacles[obst_counter].y) 
			end
		end
	end
end

function love.load()
   	background = love.graphics.newImage("ground_and_rabbit/background.png")
	ground = love.graphics.newImage("ground_and_rabbit/ground.png")
	empty = love.graphics.newImage("ground_and_rabbit/empty.png")
	obst_img[1] = love.graphics.newImage("obstacles/thorns_80_25.png")
	obst_img[2] = love.graphics.newImage("obstacles/bench_170_78.png")
	obst_img[3] = love.graphics.newImage("obstacles/box_77_75.png")
	obst_img[4] = love.graphics.newImage("obstacles/keg_58_75.png")
	obst_img[5] = love.graphics.newImage("obstacles/pumpkin_66_70.png")
	obst_img[6] = love.graphics.newImage("obstacles/sack_55_75.png")
	obst_img[7] = love.graphics.newImage("obstacles/stump_57_50.png")
	
	veggies_img[1] = love.graphics.newImage("veggies/broccoli_26_24.png")
	veggies_img[2] = love.graphics.newImage("veggies/cabbage_36_36.png")
	veggies_img[3] = love.graphics.newImage("veggies/marrow_39_36.png")
	veggies_img[4] = love.graphics.newImage("veggies/pepper_23_27.png")
	veggies_img[5] = love.graphics.newImage("veggies/tomato_23_22.png")

	ball = love.graphics.newImage("obstacles/ball.png")
	tree = love.graphics.newImage("back_front/tree.png")
	wheat = love.graphics.newImage("back_front/wheat.png")
	clothes = love.graphics.newImage("back_front/clothes.png")
	sunflowers = love.graphics.newImage("back_front/sunflowers.png")
	rabbit = love.graphics.newImage("ground_and_rabbit/rabbit_anim_376_60.png")
	rabbitAnim = {}
	rabbitAnim[1] = love.graphics.newQuad(0, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[2] = love.graphics.newQuad(94, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[3] = love.graphics.newQuad(188, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[4] = love.graphics.newQuad(282, 0, 94, 60, rabbit:getDimensions())
	   
	love.graphics.setNewFont(22)
	-- love.graphics.setColor(0,0,0)
	-- love.graphics.setBackgroundColor(1, 0.85490196078431, 0.72549019607843)
	love.graphics.setDefaultFilter('nearest', 'nearest')
	fill_map()

	carrot = {
		img = love.graphics.newImage("carrot_50_19.png"),
		width = 50,
		height = 19,
		x = rabbit_x - dx + 44,
		y = math.floor(rabbit_y + 0.5) + 25,
		state = 'off',
		distance = 300,
		direction = direction
	}
	platform = {
		width = 300,
		height = 15,
		x = 4300,
		y = 550,
		direction = 1
	}
end



function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, 0, 0)
	changer()
	love.graphics.translate(dx, dy)
    
    for i = 1, 25 do
	    if map[i] == 1 then
	    	love.graphics.draw(ground, x, y)
	    	if back[i] == 'tree' then love.graphics.draw(tree, x - 65, y - 300)
	    	elseif back[i] == 'sunflowers' then love.graphics.draw(sunflowers, x, y - 90)
	    	elseif back[i] == 'wheat' then love.graphics.draw(wheat, x, y - 90)
	    	elseif back[i] == 'clothes' then love.graphics.draw(clothes, x, y - 130) end
	    elseif map[i] == 0 then
	    	love.graphics.draw(empty, x, y)	 
	    else   
	    	love.graphics.draw(ground, x, y)
	    	love.graphics.draw(ground, x, y - 75) 	
	    end	   
	    x = x + 170 
	end

	-- drawing platform area
	for i = 1, 10 do 
		love.graphics.draw(empty, x, y) 
		x = x + 170 
	end
	for i = 1, 5 do 
		love.graphics.draw(ground, x, y)
		love.graphics.draw(ground, x, y - 75)
		x = x + 170 
	end


	x = 0
	-- drawing obstacles
	for i = 1, obst_counter do
		love.graphics.setColor(1, 1, 1, obstacles[i].alpha)
		love.graphics.draw(obst_img[obstacles[i].type], obstacles[i].x, obstacles[i].y)
		if obstacles[i].fireable == true and #obstacles[i].veggies > 0 then
			love.graphics.setColor(1, 1, 1)
			for j = 1, #obstacles[i].veggies do
				if obstacles[i].veggies[j].status == 'on' then love.graphics.draw(veggies_img[obstacles[i].veggies[j].type], obstacles[i].veggies[j].x, obstacles[i].veggies[j].y) end
			end
		end
	end
	love.graphics.setColor(1, 1, 1)
	for i = 1, 10 do love.graphics.draw(ball, ball_x[i], ball_y) end

	-- platform drawing
	love.graphics.setColor(0.5, 0.3, 0.1)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height, 10, 10, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.translate(-dx, 0)
    if carrot.state == 'on' then love.graphics.draw(carrot.img, carrot.x + 25, carrot.y, 0, carrot.direction, 1, 25, 0) end
    love.graphics.draw(rabbit, rabbitAnim[rabbit_current_frame], rabbit_x + 47, math.floor(rabbit_y + 0.5), 0, direction, 1, 47, 0)
    

    

    love.graphics.setColor(0,0,0)
    love.graphics.print(collectibles.got..'/'..collectibles.total, 500, 50)
    love.graphics.print(text, text_x, text_y)
    love.graphics.print(text1, text_x, text_y + 20)

    
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
	  	text = "Hi!"
	  	text_x = x
	  	text_y = y
   end
end

function love.update(dt)
	-- text_x = text_x + 10 * dt -- this would increment num by 10 per second
	-- text_y = text_y - 10 * dt
	if state == 'jump' or state == 'fall' then
		rabbit_current_frame = 2
		rabbit_y = rabbit_y + gravity * dt
		local curr_ground_y = current_ground_y(rabbit_x - dx)
		if gravity >= 0 and rabbit_y >= curr_ground_y then
			state = 'walk'
			-- gravity = -600
			rabbit_y = curr_ground_y
		end
	end
	if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
		if love.keyboard.isDown("right") then direction = 1
		elseif love.keyboard.isDown("left") then direction = -1 end
		if state == 'walk' then
			timer = timer + 6 * dt
			if timer > 4 then timer = 1 end
			rabbit_current_frame = math.floor(timer + 0.5)
			if current_ground_y(rabbit_x - dx) > rabbit_y then 
				gravity = 0
				state = 'fall'
			end
		end		
	else
		if state == 'walk' then
			timer = 1
			rabbit_current_frame = 1
		end
	end
end

function current_ground_y(current_rabbit_x)
	local left_corner = math.floor(current_rabbit_x / 170 + 1)
	local right_corner = math.floor((current_rabbit_x + 94) / 170 + 1)
	-- text = left_corner
	-- text1 = right_corner
	local level1 = 720
	if map[left_corner] == 0 and map[right_corner] == 0 then
		return 660
	elseif map[left_corner] == 2 or map[right_corner] == 2 then
		level1 = 495
	else
		level1 = 570
	end
	local level2 = level1
	local highest_obst
	for i = 1, obst_counter do
			if (obstacles[i].x < current_rabbit_x + 94 and obstacles[i].x > current_rabbit_x)
			 or (obstacles[i].x + obstacles[i].width < current_rabbit_x + 94 and obstacles[i].x + obstacles[i].width > current_rabbit_x) 
			 or (obstacles[i].type == 2 and current_rabbit_x >= obstacles[i].x and current_rabbit_x + 94 <= obstacles[i].x + obstacles[i].width) then
				highest_obst = obstacles[i].y + obstacles[i].height - obstacles[i].jump_height - 60
				if level2 > highest_obst then level2 = highest_obst end
			end
	end
	text = current_rabbit_x
	-- text1 = level2
	return math.min(level1, level2)
end

function is_obstacle(check_x)
	local i = math.floor(check_x / 170 + 1)
	if map[i] == 2 and math.floor(rabbit_y + 0.5) + 60 > 555 then return true
	elseif map[i] == 1 and math.floor(rabbit_y + 0.5) + 60 > 630 then return true
	else
		for i = 1, obst_counter do
			if check_x >= obstacles[i].x and check_x <= obstacles[i].x + obstacles[i].width and math.floor(rabbit_y + 0.5) + 60 > obstacles[i].y + obstacles[i].height - obstacles[i].jump_height then return true end
		end
	end
	return false
end


function changer()
	carrot_update()
	veggies_update()
	platform_update()
	for i = 1, 10 do 
		ball_x[i] = ball_x[i] - 7
		if ball_x[i] < -26 then ball_x[i] = 6800 end
	end
	if state == 'jump' or state == 'fall' then gravity = gravity + 25 end
	if state == 'fall' then return end
	if love.keyboard.isDown("left") and dx + 5 <= 0 and rabbit_x == 590 and is_obstacle(rabbit_x - (dx + 4)) == false then
		dx = dx + 5
		-- for i = 1, 3 do 
		-- 	ball_x[i] = ball_x[i] + i * 2
		-- 	if ball_x[i] < -26 then ball_x[i] = 1280 end
		-- end
	elseif love.keyboard.isDown("left") and rabbit_x - 5 >= 0 and is_obstacle(rabbit_x - dx - 4) == false then
		rabbit_x = rabbit_x - 5
	elseif love.keyboard.isDown("right") and dx - 5 >= -5520 and rabbit_x == 590 and is_obstacle(rabbit_x + 94 - (dx - 4)) == false then
		dx = dx - 5
		-- for i = 1, 3 do 
		-- 	ball_x[i] = ball_x[i] - i * 2
		-- 	if ball_x[i] < -26 then ball_x[i] = 1280 end
		-- end
	elseif love.keyboard.isDown("right") and rabbit_x + 5 <= 1186 and is_obstacle(rabbit_x + 94 - dx + 4) == false then
		rabbit_x = rabbit_x + 5
	end
end

function platform_update()
	if platform.direction == 1 and platform.x + platform.width <= 5900 then
		platform.x = platform.x + 5
	elseif platform.direction == -1 and platform.x >= 4300 then
		platform.x = platform.x - 5
	else
		platform.direction = platform.direction * -1
	end

end

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

function veggies_update()
	for i = 1, obst_counter do
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

function carrot_collision(check_x)
	if carrot.direction == -1 then check_x = check_x - 50 end
	local i = math.floor(check_x / 170 + 1)
	if map[i] == 2 and carrot.y + 19 > 555 then return true
	elseif map[i] == 1 and carrot.y + 19 > 630 then return true
	else
		for i = 1, obst_counter do
			if check_x >= obstacles[i].x and check_x <= obstacles[i].x + obstacles[i].width and carrot.y + 19 > obstacles[i].y + obstacles[i].height - obstacles[i].jump_height then 
				if obstacles[i].fireable == true and obstacles[i].shots > 0 then 
					local j = 1
					while j <= #obstacles[i].veggies and obstacles[i].veggies[j].status == 'on' do j = j + 1 end
					obstacles[i].veggies[j].status = 'on'
					obstacles[i].shots = obstacles[i].shots - 1
					collectibles.got = collectibles.got + 1
					if obstacles[i].shots == 0 then obstacles[i].alpha = 0.8 end
				end
				return true 
			end
		end
	end
	return false
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'space' and state == "walk" then
      state = 'jump'
      gravity = -600
    elseif key == 'lalt' and carrot.state == 'off' then      
    	carrot_update() 	
    	carrot.state = 'on'
    	text1 = carrot.x
	end
end
