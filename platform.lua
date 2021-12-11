--[[ 
	Moving platform
]]--

-- Animation of moving platform
function platform_update()
	local platform_delta = 0
	if collectibles.got < collectibles.total then return 0 end
	if platform.direction == 1 and platform.x + platform.width <= 16050 then
		platform_delta = 5
	elseif platform.direction == -1 and platform.x >= 12850 then
		platform_delta = 5
	else
		platform.direction = platform.direction * -1
	end
	platform.x = platform.x + platform_delta * platform.direction
	if rabbit_on_platform(rabbit_x - dx) == false then 
		return 0 
	else
		return platform_delta
	end
end

-- Checking if the rabbit on platform or not
function rabbit_on_platform(current_rabbit_x)
	if current_rabbit_x + 94 > platform.x and current_rabbit_x < platform.x + platform.width and math.floor(rabbit_y + 0.5) + 60 == 550 then return true
	else return false end
end

-- If the rabbit falls of the platform and collides with it, the platform pushes him
function platform_push_rabbit()
	if platform.direction == 1 
	and state == 'fall'
	and platform.x + platform.width >= rabbit_x - dx 
	and platform.x + platform.width < rabbit_x - dx + 94 
	and math.floor(rabbit_y + 0.5) + 60 >= platform.y
	and math.floor(rabbit_y + 0.5) <= platform.y + platform.height then
		return -5
	elseif platform.direction == -1 
	and state == 'fall'
	and platform.x > rabbit_x - dx 
	and platform.x <= rabbit_x - dx + 94 
	and math.floor(rabbit_y + 0.5) + 60 >= platform.y
	and math.floor(rabbit_y + 0.5) <= platform.y + platform.height then
		return 5
	else
		return 0
	end
end