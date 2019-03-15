local function init(self)
    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(28)

    ----- music -----
    if self.music then
        self.music:stop()
        self.music = nil
    end

    ----- objects -----
    self.platform = {x = 0, y = 0, width = 480, height = 160}
    self.platform.x = (self.width - self.platform.width) / 2
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()
    self.platform.top = self.platform.y
    self.platform.bottom = self.platform.y + self.platform.height
    self.platform.left = self.platform.x
    self.platform.right = self.platform.x + self.platform.width

    self.background = { x=0, y=0, width=self.width, height=self.height }
    self.background.image = love.graphics.newImage("assets/background.png")
    self.background.scale = math.max(self.background.width / self.background.image:getWidth(), self.background.height / self.background.image:getHeight())

    self.leftBkg = { x=0, y=0, width=self.width / 2, height=self.height }
    self.leftBkg.color = { 1, 0, 0, 0 }

    self.rightBkg = {
        x = self.width / 2,
        y = 0,
        width = self.width / 2,
        height = self.height
    }
    self.rightBkg.color = {0, 0, 1, 0}

    ----- player ----    
    local player = require("src.objects.Player")()
    player:setPosition(self.width / 2 - 1, 0)
    --player:setVelocity(100, -100)
    self.player = player
    --self.playerSide = "left"
end

local function update(self, dt)
    self:updatePlayer(dt)

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

    if self.player.pos.y > self.height + 2 * self.player.dimensions.h then
        self:validatedChoice()
    end
end

local function draw(self)
    love.graphics.print("Generic choice scene")

    -- draw background
    love.graphics.draw(
        self.background.image,
        self.background.x,
        self.background.y,
        0,
        self.background.scale
    )

    -- draw left rectangle
    if self.playerSide == "left" then
        self.leftBkg.color[4] = 0.4
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle(
            "fill",
            self.leftBkg.x,
            self.leftBkg.y,
            self.leftBkg.width,
            self.leftBkg.height
        )

        self.leftBkg.color[4] = 0.8
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle(
            "line",
            self.leftBkg.x,
            self.leftBkg.y,
            self.leftBkg.width,
            self.leftBkg.height
        )

        love.graphics.setFont(self.chooseFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            self.choices.left.text,
            self.leftBkg.x,
            self.leftBkg.y + 50,
            self.leftBkg.width,
            'center'
        )
    else
        self.leftBkg.color[4] = 0.15
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle(
            "fill",
            self.leftBkg.x,
            self.leftBkg.y,
            self.leftBkg.width,
            self.leftBkg.height
        )

        self.leftBkg.color[4] = 0.3
        love.graphics.setColor(self.leftBkg.color)
        love.graphics.rectangle(
            "line",
            self.leftBkg.x,
            self.leftBkg.y,
            self.leftBkg.width,
            self.leftBkg.height
        )
    end
    -- draw right rectangle
    if self.playerSide == "right" then
        self.rightBkg.color[4] = 0.4
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle(
            "fill",
            self.rightBkg.x,
            self.rightBkg.y,
            self.rightBkg.width,
            self.rightBkg.height
        )

        self.rightBkg.color[4] = 0.8
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle(
            "line",
            self.rightBkg.x,
            self.rightBkg.y,
            self.rightBkg.width,
            self.rightBkg.height
        )

        love.graphics.setFont(self.chooseFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            self.choices.right.text,
            self.rightBkg.x,
            self.rightBkg.y + 50,
            self.rightBkg.width,
            'center'
        )
    else
        self.rightBkg.color[4] = 0.15
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle(
            "fill",
            self.rightBkg.x,
            self.rightBkg.y,
            self.rightBkg.width,
            self.rightBkg.height
        )

        self.rightBkg.color[4] = 0.3
        love.graphics.setColor(self.rightBkg.color)
        love.graphics.rectangle(
            "line",
            self.rightBkg.x,
            self.rightBkg.y,
            self.rightBkg.width,
            self.rightBkg.height
        )
    end

    -- reset drawing options
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont())

    -- draw platform
    love.graphics.draw(
        self.platform.sprite,
        self.platform.x,
        self.platform.y,
        0,
        self.platform.scale
    )

    -- draw player
    self.player:draw()
end

local function setChoices(self, choices)
    self.choices = choices
end

local function keyPressed(self, k)
    if k == "escape" then
        self.manager:load("start")
    end
end

local function choiceChanged(self)
    print("Player choice changed: " .. self.playerSide)

    if self.music then
        self.music:stop()
    end

    if self.playerSide == "left" then
        self.music = love.audio.newSource("assets/" .. self.choices.left.sound, "stream")
        self.music:setLooping(true)
    else
        self.music = love.audio.newSource("assets/" .. self.choices.right.sound, "stream")
        self.music:setLooping(true)
    end

    self.music:play()
end

local function validatedChoice(self)
    print("Player chose " .. self.playerSide)
    self.manager:load("choicebase")
end

local function updatePlayer(self, dt)
    self.player:update()

    ---- Player movement ----
    local gravity = 3040 * dt

    -- keep Y velocity
    self.player:setVelocity(0, self.player.vel.y)

    -- keyboard input
    local isDown = love.keyboard.isDown
    local vel = 300
    if isDown('left') then self.player:accelerate(-vel, 0) end
    if isDown('right') then self.player:accelerate(vel, 0) end
    if isDown('space') and self.player.onGround then
        self.player:setVelocity(self.player.vel.x, - 1000)
        self.player.onGround = false
    end

    -- accelerate
    self.player:accelerate(0, gravity)

    -- update position
    local vx, vy = self.player:getVelocity()
    self.player:move(vx * dt, vy * dt)

    ---- collision with platform ----
    -- player bounds
    local pw, ph = self.player:getDimensions()
    
    local ptop, pright, pbottom, pleft = self.player:getBounds()
    local goingDown = self.player.vel.y > 0
    local dy = 0
    if goingDown then 
        self.player.onGround = false
        local collision = self:isInPlatform(pright - pw / 5, pbottom) 
                        or self:isInPlatform((pleft + pright) / 2, pbottom) 
                        or self:isInPlatform(pleft + pw / 5, pbottom)
        if collision then
            self.player:setVelocity(self.player.vel.x, 0)
            dy = self.platform.top - 0.1 - pbottom
            self.player.onGround = true
        end
    else
        local collision = self:isInPlatform(pright - pw / 5, ptop) 
                        or self:isInPlatform((pleft + pright) / 2, ptop) 
                        or self:isInPlatform(pleft + pw / 5, ptop)
        if collision then
            dy = self.platform.right + 0.1 - pleft
        end
    end
    self.player:move(0, dy)

    local ptop, pright, pbottom, pleft = self.player:getBounds()
    local goingRight = self.player.vel.x > 0
    local dx = 0
    if goingRight then 
        local collision = self:isInPlatform(pright, ptop + ph / 5) 
                        or self:isInPlatform(pright, (ptop + pbottom) / 2) 
                        or self:isInPlatform(pright, pbottom - ph / 5)
        if collision then
            dx = self.platform.left + 0.1 - pright 
        end
    else
        local collision = self:isInPlatform(pleft, ptop + ph / 5) 
                        or self:isInPlatform(pleft, (ptop + pbottom) / 2) 
                        or self:isInPlatform(pleft, pbottom - ph / 5)
        if collision then
            dx = self.platform.right - 0.1 - pleft
        end
    end
    self.player:move(dx, 0)
end

local function isInPlatform(self, x, y)
    return not (x < self.platform.left or x > self.platform.right or y < self.platform.top or y > self.platform.bottom)
end

local function SceneChoiceBase(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    
    ----- interface functions ----
    self.isInPlatform = isInPlatform
    self.update = update
    self.draw = draw
    self.init = init
    self.setChoices = setChoices
    self.keyPressed = keyPressed
    self.choiceChanged = choiceChanged
    self.validatedChoice = validatedChoice
    self.updatePlayer = updatePlayer

    choices = {
        left = {
            text = "Olive et Tom",
            sound = "Olive-et-Tom-preview.mp3"
        },
        right = {
            text = "Princesse Sarah",
            sound = "Princesse-Sarah-preview.mp3"
        }
    }
    self:setChoices(choices)

    return self
end

return SceneChoiceBase
