local function draw(self)
    local x = self.pos.x
    local y = self.pos.y
    local w = self.dimensions.w
    local h = self.dimensions.h
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", x - w / 2, y - h, w, h)
    love.graphics.setColor(1,0,1)
    love.graphics.rectangle("line", x - w / 2, y - h, w, h)
end

local function getBounds(self)
    local top = self.pos.y - self.dimensions.h
    local bottom = self.pos.y    
    local right = self.pos.x + self.dimensions.w / 2
    local left = self.pos.x - self.dimensions.w / 2
    return top, right, bottom, left
end

local function getDimensions(self)
    return self.dimensions.w, self.dimensions.h
end

local function Player()
    local Pawn = require("src.objects.Pawn")
    local self = Pawn()

    -- attributes
    self.type = "player"

    self.dimensions = {
        w = 32,
        h = 64,
    }

    -- methods
    self.getDimensions = getDimensions
    self.getBounds = getBounds
    self.draw = draw

    return self
end

return Player