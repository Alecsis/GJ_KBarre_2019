local function update(self, dt)
    if self.state == "moving" then
        local x, y = self:getPosition()
        local dist2 = math.pow(self.dst.x - x, 2) + math.pow(self.dst.y - y, 2)
        local vel2 = math.pow(self.vel * dt, 2)
        if dist2 < vel2 then
            self:setPosition(self.dst.x, self.dst.y)
            self:setState("idle")
        else
            local dx = math.cos(self.ang) * self.vel * dt
            local dy = math.sin(self.ang) * self.vel * dt
            self:move(dx, dy)
        end
    end
end

local function setDestination(self, px, py)
    self.dst.x = px
    self.dst.y = py
    local x, y = self:getPosition()
    local dx = px - x
    local dy = py - y
    self.ang = math.atan2(dy, dx)
    self:setState("moving")
end

local function setState(self, pstate)
    self.state = pstate
end

local function getState(self)
    return self.state
end

local function draw(self)
    love.graphics.setColor(0.5,0,0)
    love.graphics.circle("fill", self.pos.x, self.pos.y, 3)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("line", self.pos.x, self.pos.y, 3)
end

local function Unit()
    local self = require("src.objects.Pawn")()
    self.type = "unit"

    self.state = "idle" -- or moving
    self.setState = setState
    self.getState = getState

    self.dst = {x = 0, y = 0}
    self.ang = 0
    self.vel = 100
    self.setDestination = setDestination

    self.update = update
    self.draw = draw

    return self
end

return Unit
