local function init(self, args)
    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.shadeTmr = 1

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(32)

    -- choices
    self.choices = self.data.choices

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

    ----- npc -----
    if self.choices["left"]["npc"] then
        self.npcLeft = require("src.objects.NPC")(self.choices["left"]["npc"])
        self.npcLeft.pos.x = self.platform.left + 50
        self.npcLeft.pos.y = self.platform.y
        self.npcLeft.xflip = -1
    end

    if self.choices["right"]["npc"] then
        self.npcRight = require("src.objects.NPC")(self.choices["right"]["npc"])
        self.npcRight.pos.x = self.platform.right - 50
        self.npcRight.pos.y = self.platform.y
    end

    ----- player ----
    self.player:setPosition(self.width / 2 - 1, 0)
    self.pikachu:setPosition(self.player.pos.x - 50, self.player.pos.y)
    self.ball:setPosition(0, self.height - 100)

    self.player:setVelocity(0, 0)
    self.pikachu:setVelocity(0, 0)
    self.ball:setVelocity(1000, -1000)

    self.playerSide = "left"
    self:choiceChanged(self.playerSide)

    if not self.currentMusic:isPlaying() then
        self.currentMusic = love.audio.newSource(
            'assets/' .. self.choices[self.playerSide].sound,
            "stream"
        )
        self.currentMusic:play()
        self.currentMusic:setLooping(true)
    end
end

local function update(self, dt)
    -- update pawns
    self:updatePawns(dt)

    -- change screen shading
    self.shadeTmr = self.shadeTmr - dt
    if self.shadeTmr <= 0 then self.shadeTmr = 0 end

    -- Change player direction
    if self.player.pos.x < self.width / 2 - 1 then
        -- Select left choice
        if self.playerSide ~= "left" then self:choiceChanged("left") end
    elseif self.player.pos.x > self.width / 2 + 1 then
        -- Select right choice
        if self.playerSide ~= "right" then self:choiceChanged("right") end
    end

    -- change volume
    local volume = math.abs(self.player.pos.x - self.width / 2) / (self.width / 2)
    volume = math.pow(volume, 1/3)
    self.currentMusic:setVolume(volume)

    -- change choice
    if self.player.pos.y > self.height + 2 * self.player.dimensions.h then self:validatedChoice() end
end

local function exit(self) end

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

    -- draw player and items
    if self.npcLeft then self.npcLeft:draw() end
    if self.npcRight then self.npcRight:draw() end

    if self.player.hasPikachu then self.pikachu:draw() end

    self.player:draw()

    if self.player.hasBall then self.ball:draw() end


    if self.shadeTmr > 0 then
        love.graphics.setColor(0, 0, 0, self.shadeTmr)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end
end

local function setChoices(self, choices) self.choices = choices end

local function keyPressed(self, k) if k == "escape" then self.manager:load("menu") end end

local function choiceChanged(self, newSide)
    -- print("Player choice changed: " .. self.playerSide)
    -- update music (if necessary)
    -- self.currentMusic:stop()
    if self.currentMusic then
        self.currentMusic:stop()
        self.currentMusic:release()
    end
    self.currentMusic = love.audio.newSource('assets/' .. self.choices[newSide].sound, "stream")
    self.currentMusic:play()
    self.currentMusic:setLooping(true)
    self.playerSide = newSide
end

local function validatedChoice(self)
    -- print("Player chose " .. self.playerSide)
    -- print("Going to: " .. destination)
    -- load new scene
    if self.choices[self.playerSide].action then
        self.choices[self.playerSide].action(self.player)
    end

    self.manager:load(
        "transition",
        {
            music = self.currentMusic,
            image = self.choices[self.playerSide].background,
            speed = 1,
            destination = self.choices[self.playerSide].destination
        }
    )
end

local function updatePawns(self, dt)
    if self.npcLeft then self.npcLeft:update(dt) end
    if self.npcRight then self.npcRight:update(dt) end

    self.player:update(dt)

    ---- Player movement ----

    -- keep Y velocity
    self.player:setVelocity(0, self.player.vel.y)

    -- keyboard input
    local isDown = love.keyboard.isDown
    local vel = 300
    if isDown('left') then
        if isDown("lshift") then
            self.player:accelerate(-vel * 2, 0)
        else
            self.player:accelerate(-vel, 0)
        end
        self.player.xflip = -1
    end
    if isDown('right') then
        if isDown("lshift") then
            self.player:accelerate(vel * 2, 0)
        else
            self.player:accelerate(vel, 0)
        end
        self.player.xflip = 1
    end
    if (isDown('space') or isDown("up")) and self.player.onGround then
        self.player:setVelocity(self.player.vel.x, -1000)
        self.player.onGround = false
    end

    self:handleCollisions(self.player, dt)

    -- pikachu movement
    if self.player.hasPikachu then
        self.pikachu:update(dt)
        self:handleCollisions(self.pikachu, dt)
    end

    -- ball movement
    if self.player.hasBall then
        self.ball:update(dt)

        local vy = self.ball.vel.y
        self:handleCollisions(self.ball, dt)
        local newvy = self.ball.vel.y

        if vy > 20 and newvy < 20 then self.ball.vel.y = -vy / 2 end

        if self.ball.pos.y > self.height + 100 then
            if self.ball.pos.x > self.width / 2 then
                self.ball:setPosition(0, self.height - 100)
                self.ball:setVelocity(1000, -1000)
            else
                self.ball:setPosition(self.width, self.height - 100)
                self.ball:setVelocity(-1000, -1000)
            end
        end
    end
end

local function handleCollisions(self, pawn, dt)
    -- accelerate
    local gravity = 3040 * dt
    pawn:accelerate(0, gravity)

    -- update position
    local vx, vy = pawn:getVelocity()
    pawn:move(vx * dt, vy * dt)

    ---- collision with platform ----
    -- player bounds
    local pw, ph = pawn:getDimensions()

    local ptop, pright, pbottom, pleft = pawn:getBounds()
    local goingDown = pawn.vel.y > 0
    local dy = 0
    if goingDown then
        pawn.onGround = false
        local collision = self:isInPlatform(pright - pw / 5, pbottom) or self:isInPlatform((pleft + pright) / 2, pbottom) or self:isInPlatform(pleft + pw / 5, pbottom)
        if collision then
            pawn:setVelocity(pawn.vel.x, 0)
            dy = self.platform.top - 0.1 - pbottom
            pawn.onGround = true
        end
    else
        local collision = self:isInPlatform(pright - pw / 5, ptop) or self:isInPlatform((pleft + pright) / 2, ptop) or self:isInPlatform(pleft + pw / 5, ptop)
        if collision then dy = self.platform.right + 0.1 - pleft end
    end
    pawn:move(0, dy)

    local ptop, pright, pbottom, pleft = pawn:getBounds()
    local goingRight = pawn.vel.x > 0
    local dx = 0
    if goingRight then
        local collision = self:isInPlatform(pright, ptop + ph / 5) or self:isInPlatform(pright, (ptop + pbottom) / 2) or self:isInPlatform(pright, pbottom - ph / 5)
        if collision then dx = self.platform.left + 0.1 - pright end
    else
        local collision = self:isInPlatform(pleft, ptop + ph / 5) or self:isInPlatform(pleft, (ptop + pbottom) / 2) or self:isInPlatform(pleft, pbottom - ph / 5)
        if collision then dx = self.platform.right - 0.1 - pleft end
    end
    pawn:move(dx, 0)
end

local function isInPlatform(self, x, y)
    return not (x < self.platform.left or x > self.platform.right or y < self.platform.top or y > self.platform.bottom)
end

local function SceneChoiceBase(pSceneManager, pData, player, pikachu, ball)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    self.data = pData
    self.player = player
    self.pikachu = pikachu
    self.ball = ball

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
    self.updatePawns = updatePawns
    self.handleCollisions = handleCollisions

    return self
end

return SceneChoiceBase
