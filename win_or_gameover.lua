--[[ 
	Checking if game is over and printing lose/win info
]]--

-- Checking if the rabbit hit thorns or flying balls
function check_if_gameover()
	local left_rabbit_x = rabbit_x - dx
	local right_rabbit_x = rabbit_x - dx + 94
	local upper_rabbit_y = math.floor(rabbit_y + 0.5)
	local bottom_rabbit_y = math.floor(rabbit_y + 0.5) + 60
	if bottom_rabbit_y >= 695 
	or check_collision_with_thorns(left_rabbit_x, right_rabbit_x, bottom_rabbit_y) == true 
	or check_collision_with_balls(left_rabbit_x, right_rabbit_x, upper_rabbit_y, bottom_rabbit_y) == true then 
		lives_left = lives_left - 1
		if lives_left > 0 then 
			lose_sound:play() 
			invulnerable = true
		else
			state = 'lose' 
			music:stop() 
			lose_sound:play() 
		end
	end
end

function check_collision_with_thorns(left_rabbit_x, right_rabbit_x, bottom_rabbit_y)
	for i = 1, obst_counter - 1 do
		if obstacles[i].type == 1 and bottom_rabbit_y >= obstacles[i].y 
		and ((left_rabbit_x >= obstacles[i].x and left_rabbit_x <= obstacles[i].x + obstacles[i].width)
			or (right_rabbit_x >= obstacles[i].x and right_rabbit_x <= obstacles[i].x + obstacles[i].width)) then
			return true
		end
	end
	return false
end

function check_collision_with_balls(left_rabbit_x, right_rabbit_x, upper_rabbit_y, bottom_rabbit_y)
	for i = 1, #ball.x do
		if ((ball.x[i] > left_rabbit_x and ball.x[i] < right_rabbit_x)
			or (ball.x[i] + 27 > left_rabbit_x and ball.x[i] + 27 < right_rabbit_x))
		and ((ball.y > upper_rabbit_y and ball.y < bottom_rabbit_y) 
			or (ball.y + 27 > upper_rabbit_y and ball.y + 27 < bottom_rabbit_y)) then
			return true 
		end
	end
	return false
end

-- Printing info in case of win/game over
function print_final_info()
    love.graphics.setColor(1,1,0)
	love.graphics.setFont(font26)
	love.graphics.print('Press \'space\' to play again', 480, 220)
	if state == 'lose' then love.graphics.print('GAME OVER!', 560, 160)
	else 
		love.graphics.print('WIN!', 600, 160) 
		love.graphics.setFont(font20)
		love.graphics.print('Developed by Uliana (github: ul2910)', 880, 670)
		love.graphics.setColor(0.5,0.3,0.1)
		love.graphics.print('Art:', 20, 565)
		love.graphics.print('Music and sounds - from freesound.org:', 20, 305)
		love.graphics.setFont(font14)
		love.graphics.print('menu music - by Slaking_97', 20, 340)
		love.graphics.print('main theme - by Mativve', 20, 360)
		love.graphics.print('jump - by cabled_mess', 20, 380)
		love.graphics.print('win - by colorsCrimsonTears', 20, 400)
		love.graphics.print('lose - by suntemple', 20, 420)
		love.graphics.print('collecting veggies - by NenadSimic', 20, 440)
		love.graphics.print('damaging chest - by Raclure', 20, 460)
		love.graphics.print('background - Photo by Ferdinand Stöhr on unsplash.com', 20, 600)
		love.graphics.print('village assets - by Cainos on itch.io', 20, 620)
		love.graphics.print('bunny sprite - by felinoid on opengameart.org', 20, 640)
		love.graphics.print('vegetables - by ScratchIO on opengameart.org', 20, 660)
	end
	love.graphics.setFont(font24)
	love.graphics.setColor(1, 1, 1)
end

-- Animation of the openning chest and its veggies
function win_animation()
	if chest.frame < 4 then
		if chest.timer < 1 and chest.timer > 0.5 then chest.frame = 2
		elseif chest.timer < 0.5 and chest.timer > 0 then chest.frame = 3
		elseif chest.timer < 0 then chest.frame = 4 state = 'wait' wait_music:play() end
	else
		for i = 1, 13 do
			if chest.veggies[i].y <= 475 then love.graphics.draw(veggies_img[chest.veggies[i].type], chest.veggies[i].x, chest.veggies[i].y) end
			chest.veggies[i].y = chest.veggies[i].y - 3
			if chest.veggies[i].y < -40 then chest.veggies[i].y = 475 end
		end
	end
end