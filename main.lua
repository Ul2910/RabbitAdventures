-- Author: Uliana Gubanova (github username: ul2910)

--[[ 
	Map width is 100 tiles or 170 px * 100 = 17000 px
	Platform area is 20/100 or 170 px * 20 = 3400 px
	Last part of the map is 5/100 or 170 px * 5 = 850 px 
]]--

require("map_creator")
require("objects_creator")
require("platform")
require("objects_animation")
require("win_or_gameover")

state = 'start'
lives_left = 3
invulnerable = false
invulnerable_timer = 2
rabbit_alpha_counter = 0
totalTime = 0
modes_range = {'for babies', 'easy', 'normal', 'hard', 'impossible'}
mode_y = 450
mode = 3
x = 0
y = 630
dx = 0
dy = 0
rabbit_current_frame = 1
timer = 1
direction = 1
rabbit_y = 570
rabbit_x = 0
gravity = -600
thorns_timer = 0  
thorns_direction = 1
obst_img = {}
veggies_img = {}
backgr_img = {}
obstacles = {}
backgrounds = {}
collectibles = {}
collectibles.got = 0
collectibles.total = 0

function love.load()
	music = love.audio.newSource("sounds/416778__mativve__happy-sandbox.wav", 'static')
	wait_music = love.audio.newSource("sounds/455109__slaking-97__free-music-background-loop-001.wav", 'static')
	win_sound = love.audio.newSource("sounds/580310__colorscrimsontears__fanfare-2-rpg.wav", 'static')
	lose_sound = love.audio.newSource("sounds/253174__suntemple__retro-you-lose-sfx.wav", 'static')
	chest_dmg_sound = love.audio.newSource("sounds/458867__raclure__damage-sound-effect.mp3", 'static')
	jump_sound = love.audio.newSource("sounds/350905__cabled-mess__jump-c-05.wav", 'static')
	carrot_sound = love.audio.newSource("sounds/171697__nenadsimic__menu-selection-click.wav", 'static')
    music:setLooping(true)
    wait_music:setLooping(true)
    wait_music:play()
    
   	background = love.graphics.newImage("images/ground_and_rabbit/background.png")
	ground = love.graphics.newImage("images/ground_and_rabbit/ground.png")
	empty = love.graphics.newImage("images/ground_and_rabbit/empty.png")
	obst_img[1] = love.graphics.newImage("images/obstacles/thorns_80_25.png")
	obst_img[2] = love.graphics.newImage("images/obstacles/bench_170_78.png")
	obst_img[3] = love.graphics.newImage("images/obstacles/box_72_70.png")
	obst_img[4] = love.graphics.newImage("images/obstacles/keg_58_75.png")
	obst_img[5] = love.graphics.newImage("images/obstacles/pumpkin_66_70.png")
	obst_img[6] = love.graphics.newImage("images/obstacles/sack_55_75.png")
	obst_img[7] = love.graphics.newImage("images/obstacles/stump_57_50.png")
	
	veggies_img[1] = love.graphics.newImage("images/veggies/broccoli_26_24.png")
	veggies_img[2] = love.graphics.newImage("images/veggies/cabbage_36_36.png")
	veggies_img[3] = love.graphics.newImage("images/veggies/marrow_39_36.png")
	veggies_img[4] = love.graphics.newImage("images/veggies/pepper_23_27.png")
	veggies_img[5] = love.graphics.newImage("images/veggies/tomato_23_22.png")

	backgr_img[1] = love.graphics.newImage("images/back_images/tree_300_300.png")
	backgr_img[2] = love.graphics.newImage("images/back_images/wheat_170_90.png")
	backgr_img[3] = love.graphics.newImage("images/back_images/clothes_170_130.png")
	backgr_img[4] = love.graphics.newImage("images/back_images/sunflowers_170_90.png")
	backgr_img[5] = love.graphics.newImage("images/back_images/scarecrow_109_150.png")
	backgr_img[6] = love.graphics.newImage("images/back_images/streetlamp_90_205.png")
	backgr_img[7] = love.graphics.newImage("images/back_images/bush_170_64.png")

	rabbit = love.graphics.newImage("images/ground_and_rabbit/rabbit_anim_376_60.png")
	rabbitAnim = {}
	rabbitAnim[1] = love.graphics.newQuad(0, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[2] = love.graphics.newQuad(94, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[3] = love.graphics.newQuad(188, 0, 94, 60, rabbit:getDimensions())
	rabbitAnim[4] = love.graphics.newQuad(282, 0, 94, 60, rabbit:getDimensions())

	chestAnim = {}
	chestAnim[1] = love.graphics.newImage("images/chest/chest1_80_68.png")
	chestAnim[2] = love.graphics.newImage("images/chest/chest2_80_78.png")
	chestAnim[3] = love.graphics.newImage("images/chest/chest3_80_82.png")
	chestAnim[4] = love.graphics.newImage("images/chest/chest4_80_87.png")
	   
	font24 = love.graphics.newFont(24)
	font26 = love.graphics.newFont(26)
	font20 = love.graphics.newFont(20)
	font14 = love.graphics.newFont(14)
	font36 = love.graphics.newFont(36)
	love.graphics.setFont(font24)
	
	ball = {
		img = love.graphics.newImage("images/obstacles/ball_27_27.png"),
		x = {4000, 5700, 7000, 9300, 11720, 13100, 14500, 15900, 16600, 16926},
		y = 500,
		status = {'off', 'off', 'off', 'off', 'off', 'off', 'off', 'off', 'off', 'off'},
		timer = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	}
	carrot = {
		img = love.graphics.newImage("images/veggies/carrot_50_19.png"),
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
		x = 12850,
		y = 550,
		direction = 1
	}
	chest = {
		width = 80,
		height = 68,
		jump_height = 1000,
		x = 16900,
		y = 555 - 68,
		fireable = true,
		shots = 10,
		frame = 1,
		frame_height = {68, 78, 82, 87},
		veggies = {},
		timer = 1.5
	}
	fill_map()
end

-- Drawing the start screen
function draw_start()	
	love.graphics.draw(ground, 1110, 630)	
	love.graphics.draw(ground, 940, 630)
	love.graphics.draw(rabbit, rabbitAnim[1], 593, 50)
	love.graphics.draw(backgr_img[5], 15, 570)
	love.graphics.draw(backgr_img[4], 0, 630)	
	love.graphics.draw(obst_img[5], 150, 650)
	love.graphics.draw(backgr_img[7], 385, 656)
	love.graphics.draw(obst_img[2], 555, 642)
	love.graphics.draw(backgr_img[7], 725, 656)
	love.graphics.draw(backgr_img[1], 980, 330)
	love.graphics.draw(chestAnim[1], 1165, 562)
	love.graphics.setColor(1,1,0)
	love.graphics.setFont(font36)
	love.graphics.print('RABBIT ADVENTURES', 445, 130)
	love.graphics.setFont(font26)
	love.graphics.print('Survive and collect all veggies!', 445, 170)
	love.graphics.print('Arrows - move', 445, 220)
	love.graphics.print('Space - jump', 445, 250)
	love.graphics.print('B - throw carrots', 445, 280)
	love.graphics.print('Mode:', 445, 330)
	love.graphics.print('Press \'space\' to start', 445, 570)
	love.graphics.setColor(1,1,0,0.5)
	love.graphics.rectangle('fill', 445, mode_y, 150, 30, 10, 10, 5)
	love.graphics.setColor(0.5,0.3,0.1)
	love.graphics.setFont(font20)
	for i = 1, 5 do
		love.graphics.print(modes_range[i], 450, 332 + i * 40)
	end	
	love.graphics.setFont(font24)
	love.graphics.setColor(1, 1, 1)
end

function love.focus(f) gameIsPaused = not f end

function love.update(dt)
	if gameIsPaused then return end
	dt = math.min(dt, 0.07)
	if state == 'win' or state == 'wait' or state == 'lose' or state == 'start' then 
		if state == 'win' and chest.timer > 0 then chest.timer = chest.timer - 1 * dt end
		return 
	end
	if invulnerable == true then 
		invulnerable_timer = invulnerable_timer - 1 * dt
		if invulnerable_timer < 0 then invulnerable_timer = 2 invulnerable = false end
	end
	totalTime = totalTime + 1 * dt
	chest_and_balls_animation(dt)
	thorns_animation(dt)
	if state == 'jump' or state == 'fall' then
		rabbit_current_frame = 2
		rabbit_y = rabbit_y + gravity * dt
		if state == 'jump' then
			curr_ground_y = current_ground_y(rabbit_x - dx) end
		if gravity >= 0 and rabbit_y >= curr_ground_y then
			state = 'walk'
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
			curr_ground_y = current_ground_y(rabbit_x - dx)
			if curr_ground_y > rabbit_y then 
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

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, 0, 0)

	if state == 'start' then draw_start() return end	
	love.graphics.draw(background, 0, 0)

	if state == 'walk' or state == 'jump' or state == 'fall' then changer() end
	love.graphics.translate(dx, dy)
    
    -- Drawing map
    for i = 1, 100 do
	    if map[i] == 1 then
	    	love.graphics.draw(ground, x, y)
	    elseif map[i] == 0 then
	    	love.graphics.draw(empty, x, y)	 
	    else   
	    	love.graphics.draw(ground, x, y)
	    	love.graphics.draw(ground, x, y - 75) 	
	    end	   
	    x = x + 170 
	end
	x = 0

	-- Drawing back images
	for i = 1, back_counter do
		love.graphics.draw(backgr_img[backgrounds[i].type], backgrounds[i].x, backgrounds[i].y)
	end

	-- Reminder in the platform area in case not all veggies collected
	love.graphics.setColor(1,1,0)
	if collectibles.got < collectibles.total then 
		love.graphics.print('Collect all veggies to', 12850, 600) 
		love.graphics.print('make the platform move!', 12850, 630) 
	end

	-- Drawing obstacles and veggies collected
	for i = 1, obst_counter do
		love.graphics.setColor(1, 1, 1, obstacles[i].alpha)
		if i < obst_counter then
			love.graphics.draw(obst_img[obstacles[i].type], obstacles[i].x, math.floor(obstacles[i].y + 0.5))
		else
			love.graphics.draw(chestAnim[chest.frame], chest.x, 555 - chest.frame_height[chest.frame])
		end
		if state ~= 'win' and state ~= 'wait' and state ~= 'lose' 
		and obstacles[i].fireable == true and i < obst_counter and #obstacles[i].veggies > 0 then
			love.graphics.setColor(1, 1, 1)
			for j = 1, #obstacles[i].veggies do
				if obstacles[i].veggies[j].status == 'on' then love.graphics.draw(veggies_img[obstacles[i].veggies[j].type], obstacles[i].veggies[j].x, obstacles[i].veggies[j].y) end
			end
		end
	end

	-- Drawing balls
	love.graphics.setColor(1, 1, 1)
	for i = 1, #ball.x do 
		if ball.status[i] == 'on' then love.graphics.draw(ball.img, ball.x[i], ball.y) end
	end

	--Ddrawing chest hp
	love.graphics.setColor(0.8, 0, 0)
	love.graphics.rectangle('fill', chest.x, 555 - chest.frame_height[chest.frame] - 20, 8 * chest.shots, 8)
	love.graphics.rectangle('line', chest.x + 8 * chest.shots, 555 - chest.frame_height[chest.frame] - 19, 80 - 8 * chest.shots, 6)

	-- Drawing platform
	love.graphics.setColor(0.5, 0.3, 0.1)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height, 10, 10, 5)

    love.graphics.setColor(1, 1, 1)

    if state == 'win' or state == 'wait' then win_animation() end  

    love.graphics.translate(-dx, 0)
    if state == 'wait' or state == 'lose' then print_final_info()

    -- Drawing rabbit and his carrot
    elseif carrot.state == 'on' then love.graphics.draw(carrot.img, carrot.x + 25, carrot.y, 0, carrot.direction, 1, 25, 0) end
    if invulnerable == true then
    	rabbit_alpha_counter = rabbit_alpha_counter + 1
    	if rabbit_alpha_counter > 5 and rabbit_alpha_counter < 11 then 
    		love.graphics.setColor(1, 1, 1, 0.5)
    	elseif rabbit_alpha_counter == 11 then 
    		rabbit_alpha_counter = 0
    	end
    end
    love.graphics.draw(rabbit, rabbitAnim[rabbit_current_frame], rabbit_x + 47, math.floor(rabbit_y + 0.5), 0, direction, 1, 47, 0)

    -- Printing info
    love.graphics.setColor(1,1,0)    
    love.graphics.print('Mode: '..modes_range[mode], 5, 5)
    love.graphics.print('Lives: '..lives_left, 5, 35) 
    love.graphics.print('Veggies: '..math.floor(collectibles.got * 100 / collectibles.total + 0.5)..'%', 1095, 5)
    love.graphics.print('Time: '..math.floor(totalTime), 1095, 35)
    if state ~= 'lose' and state ~= 'win' and state ~= 'wait' and invulnerable == false then check_if_gameover() end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif state == 'win' or ((state == 'wait' or state == 'lose') and key ~= 'space') then 
		return
	elseif (state == 'wait' or state == 'lose') and key == 'space' then 
		love.event.quit("restart")
	elseif state == 'start' and key == 'down' and mode_y < 530 then 
		mode_y = mode_y + 40
		mode = mode + 1
		lives_left = lives_left - 1
	elseif state == 'start' and key == 'up' and mode_y > 370 then 
		mode_y = mode_y - 40
		mode = mode - 1
		lives_left = lives_left + 1
	elseif state == 'start' and key == 'space' then 
		state = 'walk'
		wait_music:stop()
		music:play()
	elseif key == 'space' and state == "walk" then
      state = 'jump'
      jump_sound:play()
      gravity = -600
    elseif key == 'b' and carrot.state == 'off' then      
    	carrot_update() 	
    	carrot.state = 'on'
	end
end