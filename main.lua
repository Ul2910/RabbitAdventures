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



obstacles = {}
-- obstacles.__index = obstacles

function obstacles.create(type_num, map_num, map_height)
	-- local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			width = 80,
			height = 25,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 25,			
			deadly = true,
			fireable = false
		}
	elseif type_num == 2 then
		this = {
			type = type_num,
			width = 85,
			height = 39,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 39,			
			deadly = false,
			fireable = false
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			width = 45,
			height = 44,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 44,			
			deadly = false,
			fireable = false
		}
	elseif type_num == 4 then
		this = {
			type = type_num,
			width = 27,
			height = 35,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 35,			
			deadly = false,
			fireable = true
		}
	elseif type_num == 5 then
		this = {
			type = type_num,
			width = 30,
			height = 32,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 32,			
			deadly = false,
			fireable = false
		}
	elseif type_num == 6 then
		this = {
			type = type_num,
			width = 25,
			height = 34,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 34,			
			deadly = false,
			fireable = true
		}
	elseif type_num == 7 then
		this = {
			type = type_num,
			width = 31,
			height = 27,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 27,			
			deadly = false,
			fireable = false
		}
	end
	-- setmetatable(this, obstacles)
	return this
end

-- map width = 25 or 170 px * 25 = 4250 px
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
		end
	end
end

function love.load()
   	background = love.graphics.newImage("ground_and_rabbit/background.png")
	ground = love.graphics.newImage("ground_and_rabbit/ground.png")
	empty = love.graphics.newImage("ground_and_rabbit/empty.png")
	obst_img[1] = love.graphics.newImage("obstacles/thorns_80_25.png")
	obst_img[2] = love.graphics.newImage("obstacles/bench_85_39.png")
	obst_img[3] = love.graphics.newImage("obstacles/box_45_44.png")
	obst_img[4] = love.graphics.newImage("obstacles/keg_27_35.png")
	obst_img[5] = love.graphics.newImage("obstacles/pumpkin_30_32.png")
	obst_img[6] = love.graphics.newImage("obstacles/sack_25_34.png")
	obst_img[7] = love.graphics.newImage("obstacles/stump_31_27.png")
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
	x = 0
	-- drawing obstacles
	for i = 1, obst_counter do
		love.graphics.draw(obst_img[obstacles[i].type], obstacles[i].x, obstacles[i].y)
	end

	for i = 1, 10 do love.graphics.draw(ball, ball_x[i], ball_y) end
    love.graphics.translate(-dx, 0)
    love.graphics.draw(rabbit, rabbitAnim[rabbit_current_frame], rabbit_x + 47, math.floor(rabbit_y + 0.5), 0, direction, 1, 47, 0)
    -- for i = 1, 3 do love.graphics.draw(ball, ball_x[i], ball_y) end
    love.graphics.setColor(0,0,0)
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
	text = left_corner
	text1 = right_corner
	if map[left_corner] == 2 or map[right_corner] == 2 then
		return 495
	elseif map[left_corner] == 0 and map[right_corner] == 0 then
		return 660
	else
		return 570
	end
end

function is_obstacle(check_x)
	local i = math.floor(check_x / 170 + 1)
	if map[i] == 2 and math.floor(rabbit_y + 0.5) + 60 > 555 then return true
	elseif map[i] == 1 and math.floor(rabbit_y + 0.5) + 60 > 630 then return true
	else return false end
end


function changer()
	for i = 1, 10 do 
		ball_x[i] = ball_x[i] - 7
		if ball_x[i] < -26 then ball_x[i] = 4250 end
	end
	if state == 'jump' or state == 'fall' then gravity = gravity + 25 end
	if state == 'fall' then return end
	if love.keyboard.isDown("left") and dx + 5 <= 0 and rabbit_x == 590 and is_obstacle(rabbit_x - (dx + 5)) == false then
		dx = dx + 5
		-- for i = 1, 3 do 
		-- 	ball_x[i] = ball_x[i] + i * 2
		-- 	if ball_x[i] < -26 then ball_x[i] = 1280 end
		-- end
	elseif love.keyboard.isDown("left") and rabbit_x - 5 >= 0 and is_obstacle(rabbit_x - dx - 5) == false then
		rabbit_x = rabbit_x - 5
	elseif love.keyboard.isDown("right") and dx - 5 >= -2970 and rabbit_x == 590 and is_obstacle(rabbit_x + 94 - (dx - 5)) == false then
		dx = dx - 5
		-- for i = 1, 3 do 
		-- 	ball_x[i] = ball_x[i] - i * 2
		-- 	if ball_x[i] < -26 then ball_x[i] = 1280 end
		-- end
	elseif love.keyboard.isDown("right") and rabbit_x + 5 <= 1186 and is_obstacle(rabbit_x + 94 - dx + 5) == false then
		rabbit_x = rabbit_x + 5
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'space' and state == "walk" then
      state = 'jump'
      gravity = -600
	end
end
