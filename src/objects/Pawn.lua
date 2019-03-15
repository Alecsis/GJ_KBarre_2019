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

local function Pawn()
    local self = require("lib.EntityBase")()
    self.type = "pawn"

    self.pos = {x = 0, y = 0}
    self.setPosition = setPosition
    self.getPosition = getPosition
    self.move = move

    self.update = update
    self.draw = draw

    return self
end

return Pawn
