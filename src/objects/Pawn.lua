local function update(self, dt)
    --local x, y = self:getPosition()
    --self:setPosition(x + dt, y + dt)
end

local function draw(self)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("line", self.pos.x, self.pos.y, 3)
end

local function setPosition(self, x, y)
    self.pos.x = x
    self.pos.y = y
end

local function getPosition(self)
    return self.pos.x, self.pos.y
end

local function move(self, dx, dy)
    local x, y = self:getPosition()
    self:setPosition(x + dx, y + dy)
end

local function setVelocity(self, vx, vy)
    self.vel.x = vx
    self.vel.y = vy
end

local function getVelocity(self)
    return self.vel.x, self.vel.y
end

local function accelerate(self, dvx, dvy)
    local vx, vy = self:getVelocity()
    self:setVelocity(vx + dvx, vy + dvy)
end


local function getBounds(self)
    local top = self.pos.y - self.dimensions.h
    local bottom = self.pos.y
    local right = self.pos.x + self.dimensions.w / 2
    local left = self.pos.x - self.dimensions.w / 2
    return top, right, bottom, left
end

local function getDimensions(self) return self.dimensions.w, self.dimensions.h end

local function onCollision(pSide)
    if pSide == "top" then
        self.vel.y = - self.vel.y
    elseif pSide == "bottom" then
        self.vel.y = - self.vel.y
    elseif pSide == "left" then
        self.vel.x = - self.vel.x
    elseif pSide == "right" then
        self.vel.x = - self.vel.x
    end
end

local function Pawn()
    local self = require("lib.EntityBase")()
    self.type = "pawn"

    self.pos = {x = 0, y = 0}
    self.vel = {x = 0, y = 0}
    self.dimensions = {w = 0, h = 0}
    self.setPosition = setPosition
    self.getPosition = getPosition
    self.move = move
    self.getDimensions = getDimensions
    self.getBounds = getBounds
    self.setVelocity = setVelocity
    self.getVelocity = getVelocity
    self.accelerate = accelerate
    self.onCollision = onCollision

    self.update = update
    self.draw = draw

    return self
end

return Pawn
