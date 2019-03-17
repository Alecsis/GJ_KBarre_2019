local function init(self, args)
    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.shadeTmr = 1

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(32)

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

    self.platform = {x = 0, y = 0, width = self.width - 200, height = 52}
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()
    self.platform.top = self.platform.y
    self.platform.bottom = self.platform.y + self.platform.height
    self.platform.left = self.platform.x
    self.platform.right = self.platform.x + self.platform.width

    self.wall = {x = 0, y = 0, width = 52, height = self.height}
    self.wall.y = self.height - self.wall.height
    self.wall.sprite = love.graphics.newImage("assets/wall.png")
    self.wall.scale = self.wall.width / self.wall.sprite:getWidth()
    self.wall.top = self.wall.y
    self.wall.bottom = self.wall.y + self.wall.height
    self.wall.left = self.wall.x
    self.wall.right = self.wall.x + self.wall.width

    self.cages = {}
    self.cages.sprite = love.graphics.newImage("assets/cageFoot.png")
    self.cages.height = self.ball.dimensions.h * 4
    self.cages.scale = self.cages.height / self.cages.sprite:getHeight()
    self.cages.width = self.cages.scale * self.cages.sprite:getWidth()
    self.cages.x = self.platform.x + self.platform.width - self.cages.width
    self.cages.y = self.platform.y - self.cages.height
    self.cages.top = self.cages.y
    self.cages.bottom = self.cages.y + self.cages.height
    self.cages.left = self.cages.x
    self.cages.right = self.cages.x + self.cages.width

    self.video = love.graphics.newVideo("assets/Olive-et-Tom.ogv", { audio=false })
    self.video:play()
    self.videoX = (self.width - self.video:getWidth()) / 2
    self.videoY = 0

    self.music = love.audio.newSource("assets/Olive-et-Tom.mp3", "stream")
    self.music:play()
    self.music:setLooping(true)

    ----- player ----
    self.player:setPosition(self.width / 2 - 1, 0)
    self.ball:setPosition(0, self.height - 100)

    self.player:setVelocity(0, 0)
    self.ball:setVelocity(1000, -1000)
end

local function update(self, dt)
    self.shadeTmr = self.shadeTmr - dt
    if self.shadeTmr <= 0 then self.shadeTmr = 0 end

    self:updatePawns(dt)

    if not self.video:isPlaying() then
        self.video:rewind()
        self.video:play()
    end

    if self.player.pos.y > self.height + 2 * self.player.dimensions.h then self:validatedChoice() end
end

local function exit(self)
    if self.music then
        self.music:stop()
        self.music:release()
    end
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

    love.graphics.draw(
        self.video,
        self.videoX,
        self.videoY
    )

    -- draw wall
    love.graphics.draw(
        self.wall.sprite,
        self.wall.x,
        self.wall.y,
        0,
        self.wall.scale
    )

    -- draw platform
    love.graphics.draw(
        self.platform.sprite,
        self.platform.x,
        self.platform.y,
        0,
        self.platform.scale
    )

    -- draw player
    self.ball:draw()
    self.player:draw()

    -- draw cages
    love.graphics.draw(
        self.cages.sprite,
        self.cages.x,
        self.cages.y,
        0,
        self.cages.scale
    )

    if self.shadeTmr > 0 then
        love.graphics.setColor(0, 0, 0, self.shadeTmr)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end
end

local function keyPressed(self, k) if k == "escape" then self.manager:load("menu") end end

local function validatedChoice(self)
end

local function updatePawns(self, dt)
    self.player:update(dt)

    ---- Player movement ----

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

    self.player.againstWall = false
    self:handleCollisions(self.player, dt)

    -- ball movement
    self.ball:update(dt)

    self.ball.againstWall = false
    local vy = self.ball.vel.y
    self:handleCollisions(self.ball, dt)
    local newvy = self.ball.vel.y

    if vy > 20 and newvy < 20 then
        self.ball.vel.y = -vy / 2
    end

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

local function handleCollisions(self, pawn, dt)
    -- accelerate
    local gravity = 3040 * dt
    pawn:accelerate(0, gravity)

    -- update position
    local vx, vy = pawn:getVelocity()
    pawn:move(vx * dt, vy * dt)

    ----- collision with cages -----
    if pawn == self.ball then
        -- side
        local pw, ph = pawn:getDimensions()

        local ptop, pright, pbottom, pleft = pawn:getBounds()

        local ptop, pright, pbottom, pleft = pawn:getBounds()
        local goingRight = pawn.vel.x > 0
        local dx = 0

        local collisionTop = false
        local collisionRight = false
        local collisionBottom = false
        local collisionLeft = false

        if goingRight then
        local collision = self:isInCage(pright, ptop + ph / 5) or self:isInCage(pright, (ptop + pbottom) / 2) or self:isInCage(pright, pbottom - ph / 5)
            if collision then dx = self.cages.right - 10 - 0.1 - pright end
        end
        pawn:move(dx, 0)

        -- top
        local pw, ph = pawn:getDimensions()

        local ptop, pright, pbottom, pleft = pawn:getBounds()
        local goingDown = pawn.vel.y > 0
        local dy = 0
        if goingDown then
            pawn.onGround = false
            local collision = self:isInCage(pright - pw / 5, pbottom) or self:isInCage((pleft + pright) / 2, pbottom) or self:isInCage(pleft + pw / 5, pbottom)
            if collision then
                pawn:setVelocity(pawn.vel.x, 0)
                dy = self.cages.top - 0.1 - pbottom
                pawn.onGround = true
            end
        else
            local collision = self:isInCage(pright - pw / 5, ptop) or self:isInCage((pleft + pright) / 2, ptop) or self:isInCage(pleft + pw / 5, ptop)
            if collision then dy = self.cages.top + 0.1 - ptop + 10 end
        end
        pawn:move(0, dy)
    end

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

    ---- collision with platform ----
    -- player bounds
    local pw, ph = pawn:getDimensions()

    local ptop, pright, pbottom, pleft = pawn:getBounds()

    local ptop, pright, pbottom, pleft = pawn:getBounds()
    local goingRight = pawn.vel.x > 0
    local dx = 0
    pawn.againstWall = false
    if not goingRight then
        local collision = self:isInWall(pleft, ptop + ph / 5) or self:isInWall(pleft, (ptop + pbottom) / 2) or self:isInWall(pleft, pbottom - ph / 5)
        if collision then
            dx = self.wall.right - 0.1 - pleft
            pawn.againstWall = true
        end
    end
    pawn:move(dx, 0)
end

local function isInPlatform(self, x, y)
    return not (x < self.platform.left or x > self.platform.right or y < self.platform.top or y > self.platform.bottom)
end

local function isInWall(self, x, y)
    return not (x < self.wall.left or x > self.wall.right or y < self.wall.top or y > self.wall.bottom)
end

local function isInCage(self, x, y)
    if (x >= self.cages.right - 10 and x < self.cages.right and y > self.cages.top and y < self.cages.bottom) then
        return true
    end

    if (x > self.cages.left and x < self.cages.right and y < self.cages.top and y >= self.cages.top - 10) then
        return true
    end

    return false
end


local function SceneChoiceBase(pSceneManager, player, pikachu, ball)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    self.player = player
    self.ball = ball

    ----- interface functions ----
    self.isInPlatform = isInPlatform
    self.isInWall = isInWall
    self.isInCage = isInCage
    self.update = update
    self.exit = exit
    self.draw = draw
    self.init = init
    self.keyPressed = keyPressed
    self.validatedChoice = validatedChoice
    self.updatePawns = updatePawns
    self.handleCollisions = handleCollisions

    return self
end

return SceneChoiceBase
