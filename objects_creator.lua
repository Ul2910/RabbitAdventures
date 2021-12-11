--[[ 
	Creation of objects: obstacles, back images, veggies
]]--

function obstacles_create(type_num, map_num, map_height)
	local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			width = 80,
			height = 25,
			jump_height = 25,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 20,		
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
			fireable = false,
			shots = 0,
			alpha = 1
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			width = 72,
			height = 70,
			jump_height = 70,
			x = 170 * map_num - 170 + 50,
			y = 630 - 75 * (map_height - 1) - 70,			
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
			fireable = false,
			shots = 0,
			alpha = 1
		}
	end
	return this
end

function veggies_create(type_num, x, y)
	local this = {}
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
	return this
end

function chest_veggies_create(type_num)
	local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			x = math.random(16900, 16940),
			y = 475
		}
	elseif type_num == 2 then
		this = {
			type = type_num,
			x = math.random(16900, 16940),
			y = 475
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			x = math.random(16900, 16940),
			y = 475
		}
	elseif type_num == 4 then
		this = {
			type = type_num,
			x = math.random(16900, 16940),
			y = 475
		}
	elseif type_num == 5 then
		this = {
			type = type_num,
			x = math.random(16900, 16940),
			y = 475
		}
	end
	return this
end

function backgrounds_create(type_num, map_num, map_height)
	local this = {}
	if type_num == 1 then
		this = {
			type = type_num,
			width = 300,
			height = 300,
			x = 170 * map_num - 170 - 65,
			y = 630 - 75 * (map_height - 1) - 300	
		}
	elseif type_num == 2 then
		this = {
			type = type_num,
			width = 170,
			height = 90,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 90		
		}
	elseif type_num == 3 then
		this = {
			type = type_num,
			width = 170,
			height = 130,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 130	
		}
	elseif type_num == 4 then
		this = {
			type = type_num,
			width = 170,
			height = 90,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 90	
		}
	elseif type_num == 5 then
		this = {
			type = type_num,
			width = 109,
			height = 150,
			x = 170 * map_num - 100,
			y = 630 - 75 * (map_height - 1) - 150	
		}
	elseif type_num == 6 then
		this = {
			type = type_num,
			width = 90,
			height = 205,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 205	
		}
	elseif type_num == 7 then
		this = {
			type = type_num,
			width = 170,
			height = 64,
			x = 170 * map_num - 170,
			y = 630 - 75 * (map_height - 1) - 64	
		}
	end
	return this
end