local Circle = {}
Circle.__index = Circle

function Circle.new(class, x, y)
	local self = setmetatable({}, class)

	self.x = x
	self.y = y
	self.r = 1

	self.growing = true

	return self
end

function Circle:grow(grow_speed)
	if self.growing then
		self.r = self.r + (grow_speed or 1)
	end
end

function Circle:edges()
	local w, h = love.graphics.getDimensions()
	return self.x + self.r > w or self.x - self.r < 0 or self.y + self.r > h or
		       self.y - self.r < 0
end

function Circle:draw()
	love.graphics.circle("line", self.x, self.y, self.r)
end

return Circle
