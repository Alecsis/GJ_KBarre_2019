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
    self.cages.height = self.player.ball.dimensions.h * 4
    self.cages.scale = self.cages.height / self.cages.sprite:getHeight()
    self.cages.width = self.cages.scale * self.cages.sprite:getWidth()
    self.cages.x = self.platform.x + self.platform.width - self.cages.width
    self.cages.y = self.platform.y - self.cages.height
    self.cages.top = self.cages.y
    self.cages.bottom = self.cages.y + self.cages.height
    self.cages.left = self.cages.x
    self.cages.right = self.cages.x + self.cages.width
    self.cages.colliders = {
        {
            top = self.cages.top,
            right = self.cages.right,
            bottom = self.cages.bottom,
            left = self.cages.right - self.cages.width / 10,
        },
        {
            top = self.cages.top,
            right = self.cages.right,
            bottom = self.cages.top + self.cages.height / 10,
            left = self.cages.left,
        }
    }

    self.video = love.graphics.newVideo("assets/Olive-et-Tom.ogv", { audio=false })
    self.video:play()
    self.videoX = (self.width - self.video:getWidth()) / 2
    self.videoY = 0

    self.music = love.audio.newSource("assets/Olive-et-Tom.mp3", "stream")

    self.npc = require("src.objects.NPC")("Olive-et-Tom")
    self.npc.pos.x = self.wall.right + 50
    self.npc.pos.y = self.platform.y
    self.npc.xflip = -1

    ----- player ----
    self.player:addBall()
    self.player:setPosition(self.width / 2 - 1, 0)
    self.player.ball:setPosition(0, self.height - 100)

    self.player:setVelocity(0, 0)
    self.player.ball:setVelocity(1000, -1000)
end

local function update(self, dt)
    self.shadeTmr = self.shadeTmr - dt
    if self.shadeTmr <= 0 then self.shadeTmr = 0 end

    self:updatePawns(dt)

    if not self.video:isPlaying() then
        self.video:rewind()
        self.video:play()
    end

    if not self.music:isPlaying() then
        self.music = love.audio.newSource("assets/Olive-et-Tom.mp3", "stream")
        self.music:seek(0)
        self.music:setVolume(1.0)
        self.music:play()
    end

    if self.player.pos.y > self.height + 2 * self.player.dimensions.h then self:validatedChoice() end
end

local function exit(self)
    -- self.video:stop()
    self.video:release()
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

    -- draw npc
    self.npc:draw()

    -- draw player
    self.player.ball:draw()
    self.player:draw()

    -- draw cages
    love.graphics.draw(
        self.cages.sprite,
        self.cages.x,
        self.cages.y,
        0,
        self.cages.scale
    )

    --[[love.graphics.setColor(1, 0, 1)
    for i = 1, #self.cages.colliders do
        local coll = self.cages.colliders[i]
        local w = coll.right - coll.left
        local h = coll.bottom - coll.top
        love.graphics.rectangle('line', coll.left, coll.top, w, h)
    end
    love.graphics.setColor(1, 1, 1)
    ]]

    if self.shadeTmr > 0 then
        love.graphics.setColor(0, 0, 0, self.shadeTmr)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end
end

local function keyPressed(self, k) if k == "escape" then self.manager:load("menu") end end

local function validatedChoice(self)
    -- print("Player chose " .. self.playerSide)
    -- print("Going to: " .. destination)
    -- load new scene
    self.manager:load(
        "transition",
        {
            music = self.music,
            image = self.data.background,
            speed = 1,
            destination = self.data.destination
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
    self:ballLogic(dt)
    self.npc:update(dt)

    -- reset some flags
    self.player.onGround = false
    self.player.ball.onGround = false
    self.player.ball.againstWall = false
    self.player.againstWall = false

    -- perform collision multiple times
    local precision = 2
    local dtNew = dt / precision
    for i = 1, precision do
        -- accelerate
        local gravity = 2040 * dtNew
        self.player:accelerate(0, gravity)
        self.player.ball:accelerate(0, gravity)
    
        -- update position
        local vx, vy = self.player:getVelocity()
        self.player:move(vx * dtNew, vy * dtNew)
        local vx, vy = self.player.ball:getVelocity()
        self.player.ball:move(vx * dtNew, vy * dtNew)

        -- player
        self:handleCollisionsNoResolution(self.player, self.platform, dtNew)
        self:handleCollisionsNoResolution(self.player, self.wall, dtNew)
        self.player:update(dtNew)
        -- ball
        self:handleCollisionsNoResolution(self.player.ball, self.platform, dtNew)
        self:handleCollisionsNoResolution(self.player.ball, self.wall, dtNew)
        for i = 1, #self.cages.colliders do
            local collider = self.cages.colliders[i]
            self:handleCollisionsNoResolution(self.player.ball, collider, dtNew)
        end
        self.player.ball:update(dtNew)
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

local function SceneChoiceBase(pSceneManager, pData, player)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    self.data = pData
    self.player = player

    ----- interface functions ----
    self.isInPlatform = isInPlatform
    self.isInCage = isInCage
    self.update = update
    self.exit = exit
    self.draw = draw
    self.init = init
    self.keyPressed = keyPressed
    self.validatedChoice = validatedChoice
    self.updatePawns = updatePawns
    self.playerLogic = playerLogic
    self.ballLogic = ballLogic
    self.handleCollisionsNoResolution = handleCollisionsNoResolution

    return self
end

return SceneChoiceBase
