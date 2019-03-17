local function draw(self)
    local x = self.pos.x
    local y = self.pos.y
    local w = self.dimensions.w
    local h = self.dimensions.h
    love.graphics.setColor(1, 1, 1)

    local quad = self.lstQuads[self.currentAnimation][self.frame]
    love.graphics.draw(
        self.image,
        quad,
        x,
        y - h,
        0, -- rot
        1 * self.xflip, -- x scale
        1, -- y scale
        w / 2, -- x origin
        0 -- y origin
    )
end

local function update(self, dt)
    local anim = self.lstAnimations[self.currentAnimation]
    self.animTmr = self.animTmr + dt
    if self.animTmr > anim.speed then
        self.animTmr = 0
        self.frame = self.frame + 1
        if self.frame > #anim.frames then
            self.frame = 1
            self.currentAnimation = anim.next
            self.animOver = true
        else
            self.animOver = false
        end
        -- print(anim.frames[self.frame])
    end

    local drag = 100 * dt
    if self.vel.x > 0 then
        self:accelerate(-drag, 0)

        if self.vel.x < 0 then
            self.vel.x = 0
        end
    elseif self.vel.x < 0 then
        self:accelerate(drag, 0)

        if self.vel.x > 0 then
            self.vel.x = 0
        end
    end

    local xvel = 600
    local yvel = 400
    if math.abs(self.vel.x) < 1000 then
        if self:isInPlayer(self.pos.x - self.dimensions.w / 2, self.pos.y - self.dimensions.h) then
            -- collide top left
            self:setVelocity(xvel, -yvel)
            self.onGround = false
            self:playSound()
        elseif self:isInPlayer(self.pos.x - self.dimensions.w / 2, self.pos.y) then
            -- collide bottom left
            self:setVelocity(xvel, -yvel)
            self.onGround = false
            self:playSound()
        elseif self:isInPlayer(self.pos.x + self.dimensions.w / 2, self.pos.y + self.dimensions.h) and not (self.againstWall and not self.onGround) then
            -- collide top right
            self:setVelocity(-xvel, -yvel)
            self.onGround = false
            self:playSound()
        elseif self:isInPlayer(self.pos.x + self.dimensions.w / 2, self.pos.y) and not (self.againstWall and not self.onGround) then
            -- collide bottom right
            self:setVelocity(-xvel, -yvel)
            self.onGround = false
            self:playSound()
        end
    end

    if self.currentAnimation == "idle" then
        if self.vel.x ~= 0 then
            self.currentAnimation = "walk"
            self.frame = 1
            self.animTmr = 0
        end
    elseif self.currentAnimation == "walk" then
        if self.vel.x == 0 then
            self.currentAnimation = "idle"
            self.frame = 1
            self.animTmr = 0
        end
    end
end

local function playSound(self)
    if not self.sound:isPlaying() then
        self.sound:seek(0)
        self.sound:play()
    end
end


local function isInPlayer(self, x, y)
    local top, right, bottom, left = self.player:getBounds()
    return not (x < left or x > right or y < top or y > bottom)
end

local function setSpritesheet(self, playerProps)
    local spritesheet = playerProps.spritesheet
     -- physical bounds
    self.dimensions = {
        w = spritesheet.frameWidth,
        h = spritesheet.frameHeight,
    }

    -- animations
    self.lstAnimations = playerProps.animations
    self.currentAnimation = playerProps.defaultAnimation
    self.frame = 1
    self.animTmr = 0
    self.xflip = 1
    self.animOver = false
    self.lstQuads = {}
    self.image = love.graphics.newImage(spritesheet.filename)
    for animType, animObj in pairs(self.lstAnimations) do
        local quads = {}
        for i = 1, #animObj.frames do
            local frame = animObj.frames[i]
            local row = math.floor((frame - 1) / spritesheet.width)
            local col = frame - row * spritesheet.width
            local x = (col - 1) * spritesheet.frameWidth
            local y = row * spritesheet.frameHeight
            --print(x, y)
            quads[i] = love.graphics.newQuad(
                x,
                y,
                spritesheet.frameWidth,
                spritesheet.frameHeight,
                self.image:getDimensions()
            )
        end
        self.lstQuads[animType] = quads
    end
end

local function onCollision(self, pSide)
    if pSide == "top" then
        self.vel.x = self.vel.x * 0.7
        self.vel.y = - self.vel.y * 0.8
    elseif pSide == "bottom" then
        self.vel.y = - self.vel.y * 0.7
        self.vel.x = self.vel.x * 0.8
    elseif pSide == "left" then
        self.vel.x = - self.vel.x * 0.7
        self.vel.y = self.vel.y * 0.8
    elseif pSide == "right" then
        self.vel.x = - self.vel.x * 0.7
        self.vel.y = self.vel.y * 0.8
    end
end

local function Ball(player)
    local Pawn = require("src.objects.Pawn")
    local self = Pawn()

    -- attributes
    self.type = "player"  -- do we collide bottom
    self.onGround = false
    self.againstWall = false
    self.player = player
    self.sound = love.audio.newSource("assets/soccer-ball.mp3", "stream")
    self.sound:setVolume(0.5)

     -- methods
    self.update = update
    self.draw = draw
    self.playSound = playSound
    self.isInPlayer = isInPlayer
    self.onCollision = onCollision
    self.setSpritesheet = setSpritesheet

    -- spritesheet & animations
    local props = require("data.EntitiesProperties")
    self:setSpritesheet(props["ball"])

    return self
end

return Ball
