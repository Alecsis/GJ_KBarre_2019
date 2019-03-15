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

    -- draw background
    love.graphics.draw(self.background.image, self.background.x, self.background.y, 0, self.background.scale)

    -- draw left rectangle
    if self.playerSide == "left" then
        self.leftBkg.color[4] = 0.4
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("fill", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)

        self.leftBkg.color[4] = 0.8
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle("line", self.leftBkg.x, self.leftBkg.y, self.leftBkg.width, self.leftBkg.height)

        love.graphics.setFont(self.chooseFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press y to confirm",  self.leftBkg.x, self.leftBkg.y + 50, self.leftBkg.width, 'center')
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

        love.graphics.setFont(self.chooseFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press x to doubt",  self.rightBkg.x, self.rightBkg.y + 50, self.rightBkg.width, 'center')
    else
        self.rightBkg.color[4] = 0.15
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("fill", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)

        self.rightBkg.color[4] = 0.3
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle("line", self.rightBkg.x, self.rightBkg.y, self.rightBkg.width, self.rightBkg.height)
    end

    -- reset drawing options
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont())

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

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(28)

    ----- objects -----
    self.platform = { x=0, y=0, width=480, height=160 }
    self.platform.x = (self.width - self.platform.width) / 2
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()

    self.background = { x=0, y=0, width=self.width, height=self.height }
    self.background.image = love.graphics.newImage("assets/background.png")
    self.background.scale = math.max(self.background.width / self.background.image:getWidth(), self.background.height / self.background.image:getHeight())

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
