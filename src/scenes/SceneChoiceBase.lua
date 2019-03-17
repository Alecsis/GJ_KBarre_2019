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
    self.player.pikachu:setPosition(self.player.pos.x - 50, self.player.pos.y)
    self.player.ball:setPosition(0, self.height - 100)
    self.player.goldenSnitch:setPosition(self.player.pos.x, self.height - 100)

    self.player:setVelocity(0, 0)
    self.player.pikachu:setVelocity(0, 0)
    self.player.ball:setVelocity(1000, -1000)
    self.player.goldenSnitch:setVelocity(0, 0)

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

    localSelf = self
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
    volume = math.pow(volume, 1 / 3)
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

    -- draw platform
    love.graphics.draw(
        self.platform.sprite,
        self.platform.x,
        self.platform.y,
        0,
        self.platform.scale
    )

    -- draw text
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.setColor(0, 0, 0)

    if self.playerSide == "left" then
        love.graphics.stencil(self.leftStencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.printf(self.choices[self.playerSide].text, 100, 100, self.width / 2 - 100, "center")
        love.graphics.setStencilTest()
    else
        love.graphics.stencil(self.rightStencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.printf(self.choices[self.playerSide].text, self.width / 2, 100, self.width / 2 - 100, "center")
        love.graphics.setStencilTest()
    end

    love.graphics.setFont(love.graphics.newFont())
    love.graphics.setColor(1, 1, 1)

    -- draw npcs and player
    if self.npcLeft then self.npcLeft:draw() end
    if self.npcRight then self.npcRight:draw() end
    self.player:draw()

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
    if self.choices[self.playerSide].action then self.choices[self.playerSide].action(self.player) end

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

local function playerLogic(self)
    ---- Player movement ----
    -- keep Y velocity
    self.player:setVelocity(0, self.player.vel.y)

    -- keyboard input
    local isDown = love.keyboard.isDown
    local vel = 300
    if isDown('left') then
        if isDown('lshift') or isDown('down') then
            self.player:accelerate(-2 * vel, 0)
        else
            self.player:accelerate(-vel, 0)
        end
        self.player.xflip = -1
    end
    if isDown('right') then
        if isDown('lshift') or isDown('down') then
            self.player:accelerate(2 * vel, 0)
        else
            self.player:accelerate(vel, 0)
        end
        self.player.xflip = 1
    end
    if (isDown('space') or isDown("up")) and self.player.onGround then
        self.player:setVelocity(self.player.vel.x, -1000)
        self.player.onGround = false
    end
end

local function ballLogic(self)
    if self.player.ball.pos.y > self.height + 100 then
        if self.player.ball.pos.x > self.width / 2 then
            self.player.ball:setPosition(0, self.height - 100)
            self.player.ball:setVelocity(500, -1000)
        else
            self.player.ball:setPosition(self.width, self.height - 100)
            self.player.ball:setVelocity(-500, -1000)
        end
    end
end

local function updatePawns(self, dt)
    -- specific logics
    self:playerLogic(dt)
    if self.player.hasBall then self:ballLogic(dt) end

    -- reset some flags
    self.player.onGround = false
    self.player.againstWall = false
    if self.player.hasPikachu then
        self.player.pikachu.onGround = false
        self.player.pikachu.againstWall = false
    end

    -- perform collision multiple times
    local precision = 1
    local dtNew = dt / precision
    for i = 1, precision do
        -- accelerate
        local gravity = 2040 * dtNew
        self.player:accelerate(0, gravity)

        -- update position
        local vx, vy = self.player:getVelocity()
        self.player:move(vx * dtNew, vy * dtNew)

        -- player
        self:handleCollisionsNoResolution(self.player, self.platform, dtNew)
        self.player:update(dtNew)

        -- npcs
        if self.npcLeft then self.npcLeft:update(dtNew) end
        if self.npcRight then self.npcRight:update(dtNew) end

        -- pikachu 
        if self.player.hasPikachu then
            self.player.pikachu:accelerate(0, gravity)
            local vx, vy = self.player.pikachu:getVelocity()
            self.player.pikachu:move(vx * dtNew, vy * dtNew)
            self:handleCollisionsNoResolution(self.player.pikachu, self.platform, dtNew)
            self.player.pikachu:update(dtNew)
        end

        -- ball
        if self.player.hasBall then
            self.player.ball:accelerate(0, gravity)
            local vx, vy = self.player.ball:getVelocity()
            self.player.ball:move(vx * dtNew, vy * dtNew)
            self:handleCollisionsNoResolution(self.player.ball, self.platform, dtNew)
            self.player.ball:update(dtNew)
        end

        -- snitch
        if self.player.hasSnitch then
            self.player.goldenSnitch:accelerate(0, gravity)
            local vx, vy = self.player.goldenSnitch:getVelocity()
            self.player.goldenSnitch:move(vx * dtNew, vy * dtNew)
            self.player.goldenSnitch:update(dtNew)
        end
    end
end

local function handleCollisionsNoResolution(self, pawn, pPlatform, dt)
    -- collision
    -- player bounds    
    local pw, ph = pawn:getDimensions()
    local ptop, pright, pbottom, pleft = pawn:getBounds()

    -- get direction
    local goingDown = pawn.vel.y > 0

    -- collision flags
    local collTop = false
    local collRight = false
    local collBottom = false
    local collLeft = false

    local dy = 0
    if goingDown then
        local collision = self:isInPlatform(pPlatform, pright - pw / 3, pbottom) or self:isInPlatform(pPlatform, (pleft + pright) / 2, pbottom) or self:isInPlatform(pPlatform, pleft + pw / 3, pbottom)
        if collision then
            collBottom = true
            dy = pPlatform.top - 0.1 - pbottom
            pawn.onGround = true
        end
    else
        local collision = self:isInPlatform(pPlatform, pright - pw / 3, ptop) or self:isInPlatform(pPlatform, (pleft + pright) / 2, ptop) or self:isInPlatform(pPlatform, pleft + pw / 3, ptop)
        if collision then
            collTop = true
            dy = pPlatform.bottom + 0.1 - ptop
        end
    end

    -- rectify position
    pawn:move(0, dy)

    -- object collision callback
    if collTop then pawn:onCollision('top') end
    if collBottom then pawn:onCollision('bottom') end

    -- get new bounds
    local ptop, pright, pbottom, pleft = pawn:getBounds()

    -- get direction
    local goingLeft = pawn.vel.x < 0

    local dx = 0
    if goingLeft then
        -- compute collisions
        local collision = self:isInPlatform(pPlatform, pleft, ptop + ph / 3)
        collision = collision or self:isInPlatform(pPlatform, pleft, (ptop + pbottom) / 2)
        collision = collision or self:isInPlatform(pPlatform, pleft, pbottom - ph / 3)
        -- react to collisions
        if collision then
            dx = pPlatform.right + 0.1 - pleft
            pawn.againstWall = true
            collLeft = true
        end
    else
        -- compute collisions
        local collision = self:isInPlatform(pPlatform, pright, ptop + ph / 3)
        collision = collision or self:isInPlatform(pPlatform, pright, (ptop + pbottom) / 2)
        collision = collision or self:isInPlatform(pPlatform, pright, pbottom - ph / 3)
        -- react to collisions
        if collision then
            dx = pPlatform.left - 0.1 - pright
            pawn.againstWall = true
            collRight = true
        end
    end

    -- rectify position
    pawn:move(dx, 0)

    -- object collision callback
    if collRight then pawn:onCollision('right') end
    if collLeft then pawn:onCollision('left') end

end

local function isInPlatform(self, pPlatform, x, y)
    return not (x < pPlatform.left or x > pPlatform.right or y < pPlatform.top or y > pPlatform.bottom)
end

local function leftStencil()
    if localSelf.playerSide == "left" then
        love.graphics.rectangle("fill", localSelf.player.pos.x, 0, localSelf.width / 2 - localSelf.player.pos.x, localSelf.height)
    end
end

local function rightStencil()
    if localSelf.playerSide == "right" then
        love.graphics.rectangle("fill", localSelf.width / 2, 0, localSelf.player.pos.x - localSelf.width / 2, localSelf.height)
    end
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
    self.handleCollisionsNoResolution = handleCollisionsNoResolution
    self.updatePawns = updatePawns
    self.ballLogic = ballLogic
    self.playerLogic = playerLogic
    self.leftStencil = leftStencil
    self.rightStencil = rightStencil

    return self
end

local localSelf = {}
return SceneChoiceBase
