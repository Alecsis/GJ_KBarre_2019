local function Mouse()
    local mouse = {}

    mouse.x = 0
    mouse.y = 0
    mouse.clic = true
    mouse.clic2 = true
    mouse.pressed = false
    mouse.pressed2 = false
    mouse.xClic = 0
    mouse.yClic = 0
    mouse.released = true
    mouse.released2 = true
    mouse.oldPressed = false
    mouse.oldPressed2 = false

    function mouse:getPosition()
        return self.x, self.y
    end

    function mouse:update(dt)
        -- update position
        self.x = love.mouse.getX()
        self.y = love.mouse.getY()

        -- store old state
        self.oldPressed = self.pressed
        self.oldPressed2 = self.pressed2

        -- reset flags
        self.pressed = false
        self.pressed2 = false
        self.clic = false
        self.clic2 = false
        self.drag = false
        self.released = false
        self.released2 = false

        -- check for pressed
        if love.mouse.isDown(1) then
            self.pressed = true
        end
        if love.mouse.isDown(2) then
            self.pressed2 = true
        end

        -- clic event
        if self.pressed and not self.oldPressed then
            self.clic = true
            self.xClic = self.x
            self.yClic = self.y
        end
        if self.pressed2 and not self.oldPressed2 then
            self.clic2 = true
        end

        -- release event
        if not self.pressed and self.oldPressed then
            self.release = true
        end
        if not self.pressed2 and self.oldPressed2 then
            self.release2 = true
        end

        -- drag
        if self.pressed and self.oldPressed then
            if self.x ~= self.xClic or self.y ~= self.yClic then
                self.drag = true
            end
        end
    end

    function mouse:draw()
        if self.drag then
            local w = self.x - self.xClic
            local h = self.y - self.yClic
            love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", self.xClic, self.yClic, w, h)
            love.graphics.rectangle("line", self.xClic, self.yClic, w, h)
            love.graphics.setColor(1, 1, 1)
        end
    end

    return mouse
end

return Mouse
