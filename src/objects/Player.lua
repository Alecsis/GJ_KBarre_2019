local function draw(self)
    local x = self.pos.x
    local y = self.pos.y
    local w = self.dimensions.w
    local h = self.dimensions.h
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", x - w / 2, y - h, w / 2, h)
    love.graphics.setColor(1,0,1)
    love.graphics.rectangle("line", x - w / 2, y - h, w / 2, h)
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
    self.draw = draw

    return self
end

return Player