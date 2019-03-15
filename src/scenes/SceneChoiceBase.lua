local function update(self, dt)
    self.player:update()

    if self.player.pos.x < self.width / 2 then
        -- Select left choice
        if self.playerSide ~= "left" then
            self.playerSide = "left"
            self:choiceChanged()
        end
    else
        -- Select right choice
        if self.playerSide ~= "right" then
            self.playerSide = "right"
            self:choiceChanged()
        end
    end

    local gravity = 240 * dt
    self.player:accelerate(0, gravity)
    local vx, vy = self.player:getVelocity()
    self.player:move(vx * dt, vy * dt)
end

local function draw(self)
    love.graphics.print("Generic choice scene")

    -- draw left rectangle
    if self.playerSide == "left" then
        self.leftBkg.color[4] = 0.4
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("fill", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)

        self.leftBkg.color[4] = 0.8
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("line", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)
    else
        self.leftBkg.color[4] = 0.15
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("fill", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)

        self.leftBkg.color[4] = 0.3
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("line", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)
    end
    -- draw right rectangle
    if self.playerSide == "right" then
        self.rightBkg.color[4] = 0.4
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("fill", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)

        self.rightBkg.color[4] = 0.8
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("line", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)
    else
        self.rightBkg.color[4] = 0.15
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("fill", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)

        self.rightBkg.color[4] = 0.3
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("line", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)
    end

    -- reset colors
    love.graphics.setColor(1, 1, 1)

    -- draw platform
    love.graphics.draw(self.platform.sprite, self.platform.x, self.platform.y, 0, self.platform.scale)

    -- draw player
    self.player:draw()
end

local function choiceChanged(self)
    print("Player choice changed: " .. self.playerSide)
end

local function keyPressed(self, k)
    if k == "escape" then
        self.manager:load("start")
    end
end

local function SceneChoiceBase(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)

    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    ----- objects -----
    self.platform = { x=0, y=0, width=480, height=160 }
    self.platform.x = (self.width - self.platform.width) / 2
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()

    self.leftBkg = { x=0, y=0, width=self.width / 2, height=self.height }
    self.leftBkg.color = { 1, 0, 0, 0 }

    self.rightBkg = { x=self.width / 2, y=0, width=self.width / 2, height=self.height }
    self.rightBkg.color = { 0, 0, 1, 0 }

     ----- player ----    
    local player = require("src.objects.Player")()
    player:setPosition(self.width / 2 - 50, self.height / 2)
    player:setVelocity(100, -100)
    self.player = player
    self.playerSide = "left"
    
    ----- interface functions ----
    self.update = update
    self.draw = draw
    self.keyPressed = keyPressed
    self.choiceChanged = choiceChanged

    return self
end

return SceneChoiceBase
