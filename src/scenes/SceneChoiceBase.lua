local function init(self, args)
    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.shadeTmr = 1

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(32)

    -- choices
    self:setChoices(self.data.choices)

    ----- objects -----

    self.mariobg = {x = 0, y = 0, width = self.width, height = self.height}
    self.mariobg.image = love.graphics.newImage("assets/mario-export.png")
    self.mariobg.imgw = self.mariobg.image:getWidth()
    self.mariobg.imgh = self.mariobg.image:getHeight()
    self.mariobg.scale = math.max(
        self.mariobg.width / self.mariobg.imgw,
        self.mariobg.height / self.mariobg.imgh
    )
    local newH = self.mariobg.imgh * self.mariobg.scale
    self.mariobg.y = self.height - newH

    self.platform = {x = 0, y = 0, width = 800, height = 52}
    self.platform.x = (self.width - self.platform.width) / 2
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()
    self.platform.top = self.platform.y
    self.platform.bottom = self.platform.y + self.platform.height
    self.platform.left = self.platform.x
    self.platform.right = self.platform.x + self.platform.width

    self.background = {x = 0, y = 0, width = self.width, height = self.height}
    self.background.image = love.graphics.newImage("assets/background.png")
    self.background.scale = math.max(
        self.background.width / self.background.image:getWidth(),
        self.background.height / self.background.image:getHeight()
    )

    local frame = {width = self.width / 3, height = self.height / 3,}

    self.leftBkg = {
        x = self.width / 4,
        y = self.height / 3,
        width = frame.width,
        height = frame.height,
        image = love.graphics.newImage("assets/" .. self.choices.left.background)
    }
    self.leftBkg.imgw = self.leftBkg.image:getWidth()
    self.leftBkg.imgh = self.leftBkg.image:getHeight()
    self.leftBkg.scale = math.max(
        self.leftBkg.width / self.leftBkg.imgw,
        self.leftBkg.height / self.leftBkg.imgh
    )

    self.rightBkg = {
        x = 3 * self.width / 4,
        y = self.height / 3,
        width = frame.width,
        height = frame.height,
        image = love.graphics.newImage("assets/" .. self.choices.right.background)
    }
    self.rightBkg.imgw = self.rightBkg.image:getWidth()
    self.rightBkg.imgh = self.rightBkg.image:getHeight()
    self.rightBkg.scale = math.max(
        self.rightBkg.width / self.rightBkg.imgw,
        self.rightBkg.height / self.rightBkg.imgh
    )

    self.musicLeft = love.audio.newSource("assets/" .. self.choices.left.sound, "stream")
    self.musicRight = love.audio.newSource("assets/" .. self.choices.right.sound, "stream")

    ----- player ----
    self.player:setPosition(self.width / 2 - 1, 0)
    -- player:setVelocity(100, -100)
    self.playerSide = nil

    self.playerSide = "left"
    self:choiceChanged()
end

local function update(self, dt)
    self:updatePlayer(dt)

    self.shadeTmr = self.shadeTmr - dt
    if self.shadeTmr <= 0 then self.shadeTmr = 0 end

    if self.player.pos.x < self.width / 2 - 1 then
        -- Select left choice
        if self.playerSide ~= "left" then
            self.playerSide = "left"
            self:choiceChanged()
        end
    elseif self.player.pos.x > self.width / 2 + 1 then
        -- Select right choice
        if self.playerSide ~= "right" then
            self.playerSide = "right"
            self:choiceChanged()
        end
    end

    local volume = math.abs(self.player.pos.x - self.width / 2) / (self.width / 2)
    -- voume = math.pow(volume, 1/3)
    self.music = love.audio.newSource("assets/" .. self.choices.left.sound, "stream")
    self.music:setVolume(volume)

    if self.player.pos.y > self.height + 2 * self.player.dimensions.h then self:validatedChoice() end
end

local function exit(self)
    self.music:stop()
    self.music = nil
end

local function draw(self)
    love.graphics.print("Generic choice scene")

    -- draw background
    love.graphics.draw(
        self.mariobg.image,
        self.mariobg.x,
        self.mariobg.y,
        0,
        self.mariobg.scale
    )

    -- draw frames
    love.graphics.draw(
        self.leftBkg.image,
        self.leftBkg.x - self.leftBkg.width / 2,
        self.leftBkg.y - self.leftBkg.height / 2,
        0,
        self.leftBkg.scale
    )
    love.graphics.draw(
        self.rightBkg.image,
        self.rightBkg.x - self.rightBkg.width / 2,
        self.rightBkg.y - self.rightBkg.height / 2,
        0,
        self.rightBkg.scale
    )
    --[[
    love.graphics.setFont(self.chooseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        self.choices.left.text,
        self.leftBkg.x,
        self.leftBkg.y + 50,
        self.leftBkg.width,
        'center'
    )

    love.graphics.setFont(self.chooseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        self.choices.right.text,
        self.rightBkg.x,
        self.rightBkg.y + 50,
        self.rightBkg.width,
        'center'
    )]]

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

    if self.shadeTmr > 0 then
        love.graphics.setColor(0, 0, 0, self.shadeTmr)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end
end

local function setChoices(self, choices) self.choices = choices end

local function keyPressed(self, k) if k == "escape" then self.manager:load("menu") end end

local function choiceChanged(self)
    -- print("Player choice changed: " .. self.playerSide)

    -- update background image
    if self.playerSide == "left" then
        self.background.image = self.leftBkg.image
    else
        self.background.image = self.rightBkg.image
    end

    -- update background scale
    local xScale = self.background.width / self.background.image:getWidth()
    local yScale = self.background.height / self.background.image:getHeight()
    self.background.scale = math.max(xScale, yScale)

    -- center the background
    local xOffset = (self.background.scale - xScale) * self.background.image:getWidth() / 2
    local yOffset = (self.background.scale - yScale) * self.background.image:getHeight() / 2
    self.background.x = -xOffset
    self.background.y = -yOffset

    -- update music (if necessary)
    if self.choices.switchMusic then
        if self.music then self.music:stop() end

        if self.playerSide == "left" then
            self.music = love.audio.newSource("assets/" .. self.choices.left.sound, "stream")
        else
            self.music = love.audio.newSource("assets/" .. self.choices.right.sound, "stream")
        end

        self.music:setLooping(true)
        self.music:play()
    end
end

local function validatedChoice(self)
    -- print("Player chose " .. self.playerSide)
    -- print("Going to: " .. destination)
    self.manager:load(
        "transition",
        {
            music = self.music,
            image = self.choices[self.playerSide].background,
            speed = 1,
            destination = self.choices[self.playerSide].destination
        }
    )
end

local function updatePlayer(self, dt)
    self.player:update(dt)

    ---- Player movement ----
    local gravity = 3040 * dt

    -- keep Y velocity
    self.player:setVelocity(0, self.player.vel.y)

    -- keyboard input
    local isDown = love.keyboard.isDown
    local vel = 300
    if isDown('left') then
        self.player:accelerate(-vel, 0)
        self.player.xflip = -1
    end
    if isDown('right') then
        self.player:accelerate(vel, 0)
        self.player.xflip = 1
    end
    if (isDown('space') or isDown("up")) and self.player.onGround then
        self.player:setVelocity(self.player.vel.x, -1000)
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
        local collision = self:isInPlatform(pright - pw / 5, pbottom) or self:isInPlatform((pleft + pright) / 2, pbottom) or self:isInPlatform(pleft + pw / 5, pbottom)
        if collision then
            self.player:setVelocity(self.player.vel.x, 0)
            dy = self.platform.top - 0.1 - pbottom
            self.player.onGround = true
        end
    else
        local collision = self:isInPlatform(pright - pw / 5, ptop) or self:isInPlatform((pleft + pright) / 2, ptop) or self:isInPlatform(pleft + pw / 5, ptop)
        if collision then dy = self.platform.right + 0.1 - pleft end
    end
    self.player:move(0, dy)

    local ptop, pright, pbottom, pleft = self.player:getBounds()
    local goingRight = self.player.vel.x > 0
    local dx = 0
    if goingRight then
        local collision = self:isInPlatform(pright, ptop + ph / 5) or self:isInPlatform(pright, (ptop + pbottom) / 2) or self:isInPlatform(pright, pbottom - ph / 5)
        if collision then dx = self.platform.left + 0.1 - pright end
    else
        local collision = self:isInPlatform(pleft, ptop + ph / 5) or self:isInPlatform(pleft, (ptop + pbottom) / 2) or self:isInPlatform(pleft, pbottom - ph / 5)
        if collision then dx = self.platform.right - 0.1 - pleft end
    end
    self.player:move(dx, 0)
end

local function isInPlatform(self, x, y)
    return not (x < self.platform.left or x > self.platform.right or y < self.platform.top or y > self.platform.bottom)
end

local function SceneChoiceBase(pSceneManager, pData, player)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    self.data = pData
    self.player = player

    ----- interface functions ----
    self.isInPlatform = isInPlatform
    self.update = update
    self.exit = exit
    self.draw = draw
    self.init = init
    self.setChoices = setChoices
    self.keyPressed = keyPressed
    self.choiceChanged = choiceChanged
    self.validatedChoice = validatedChoice
    self.updatePlayer = updatePlayer

    return self
end

return SceneChoiceBase
