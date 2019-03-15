local function draw(self)
    love.graphics.setColor(0.5, 0.5, 0)
    love.graphics.rectangle("line", self.pos.x - 3, self.pos.y - 3, 6, 6)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.pos.x - 3, self.pos.y - 3, 6, 6)
end

local function Building()
    local self = require("src.objects.Pawn")()
    self.type = "building"

    self.draw = draw

    return self
end

return Building
