local function draw(self)
    local x = self.pos.x
    local y = self.pos.y
    local w = self.dimensions.w
    local h = self.dimensions.h
    love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle("fill", x - w / 2, y - h, w, h)
    -- love.graphics.setColor(1, 0, 1)
    -- love.graphics.rectangle("line", x - w / 2, y - h, w, h)
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

    local top, right, bottom, left = self:getBounds()
    love.graphics.rectangle('line', left, top, right - left, bottom - top)
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

local function setSpritesheet(self, playerProps)
    -- physical bounds
    local spritesheet = playerProps.spritesheet
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
            -- print(x, y)
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

local function addPikachu(self) self.hasPikachu = true end

local function addBall(self) self.hasBall = true end

local function makeGirly(self)
    local props = require("data.EntitiesProperties")
    self:setSpritesheet(props["girly"])
    self.isGirly = true
end

local function onCollision(self, pSide)
    if pSide == "top" then
        self.vel.y = 0
    elseif pSide == "bottom" then
        self.vel.y = 0
    elseif pSide == "left" then
        self.vel.x = 0
    elseif pSide == "right" then
        self.vel.x = 0
    end
end

local function Player()
    local Pawn = require("src.objects.Pawn")
    local self = Pawn()

    -- attributes
    self.type = "player" -- do we collide bottom
    self.onGround = false
    self.againstWall = false
    self.hasPikachu = false
    self.hasBall = false
    self.isGirly = false

    -- methods
    self.update = update
    self.draw = draw
    self.setSpritesheet = setSpritesheet
    self.onCollision = onCollision
    self.addPikachu = addPikachu
    self.addBall = addBall
    self.makeGirly = makeGirly

    -- spritesheet & animations
    local props = require("data.EntitiesProperties")
    self:setSpritesheet(props["default"])

    return self
end

return Player
