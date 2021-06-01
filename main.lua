love.graphics.setNewFont(45)
love.keyboard.setKeyRepeat(true)

local Circle = require("Circle")

local circles = {}
local spots = {}

local notification_message = "Notification"
local notification_transparency = 0
local total = 3
local speed = 5

function love.load()
	local stencil_data = love.image.newImageData("stencil.png")
	local w, h = stencil_data:getDimensions()
	love.window.setMode(w, h)

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local r, g, b = stencil_data:getPixel(x, y)
			local brigthness = (r + g + b) / 3
			if brigthness > 0.9 then table.insert(spots, {x, y}) end
		end
	end
end

local function dist(x1, y1, x2, y2)
	return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
end

local function isInCircle(x, y)
	for _, circle in ipairs(circles) do
		local d = dist(circle.x, circle.y, x, y)
		if d < circle.r then return true end
	end
end

local function areCirclesOverlapping(circle1, circle2)
	local d = dist(circle1.x, circle1.y, circle2.x, circle2.y)
	if d - 2 < circle1.r + circle2.r then return true end
end

local function isCircleOverlapping(circle)
	for _, other_circle in ipairs(circles) do
		if other_circle ~= circle and areCirclesOverlapping(circle, other_circle) then
			return true
		end
	end
end

local function createCircle()
	local w, h = love.graphics.getDimensions()
	-- local x = love.math.random(0, w)
	-- local y = love.math.random(0, h)

	local index = love.math.random(1, #spots)
	local x = spots[index][1]
	local y = spots[index][2]

	if isInCircle(x, y) then return end

	return Circle:new(x, y)
end

local function showNotification(msg)
	notification_transparency = 1
	notification_message = msg
end

function love.keypressed(key)
	if key == "space" then
		showNotification("Reset")
		circles = {}
	elseif key == "e" then
		showNotification("Increase speed")
		speed = speed * 1.2
	elseif key == "q" then
		showNotification("Decrease speed")
		speed = speed * 0.8
	elseif key == "d" then
		showNotification("Increase density")
		total = total * 1.2
	elseif key == "a" then
		showNotification("Decrease density")
		total = total * 0.8
	end
end

function love.update(dt)
	notification_transparency = notification_transparency * dt * 59
	for _ = 1, total do
		local c = createCircle()

		if c then table.insert(circles, c) end
	end

	for _, circle in ipairs(circles) do
		if circle.growing then
			if isCircleOverlapping(circle) then circle.growing = false end
			if circle:edges() then circle.growing = false end
		end
		circle:grow(speed * dt)
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	for _, circle in ipairs(circles) do circle:draw() end

	love.graphics.setColor(0.8, 0.1, 0.1, notification_transparency)
	love.graphics.print(notification_message, 10, 10)
end

