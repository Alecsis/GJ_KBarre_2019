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
    end

    if self.pos.x < self.player.pos.x then
        self.xflip = 1
    else
        self.xflip = -1
    end

    -- Follow player's x position
    local targetX = 0
    if self.player.xflip == 1 then
        targetX = self.player.pos.x - self.player.dimensions.w / 2 - self.dimensions.w / 2 - 20
    else
        targetX = self.player.pos.x + self.player.dimensions.w / 2 + self.dimensions.w / 2 + 20
    end

    local vel = (targetX - self.pos.x)
    local sgn = (vel < 0 and -1) or 1
    self.vel.x = 100 * sgn * math.log(1 + math.abs(vel)) * math.sqrt(2)

    if math.abs(self.vel.x) < 1 then
        self.vel.x = 0
    end

    -- Follow player's x position
    local targetY = self.player.pos.y - self.player.dimensions.h + 20

    local vel = (targetY - self.pos.y)
    local sgn = (vel < 0 and -1) or 1
    self.vel.y = 75 * sgn * math.log(1 + math.abs(vel)) * math.sqrt(2)

    if math.abs(self.vel.y) < 1 then
        self.vel.y = 0
    end
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

local function onCollision(self, pSide) end

local function GoldenSnitch(player)
    local Pawn = require("src.objects.Pawn")
    local self = Pawn()

    -- attributes
    self.type = "floating"  -- do we collide bottom
    self.onGround = false
    self.againstWall = false
    self.player = player
    
    -- methods
    self.onCollision = onCollision
    self.update = update
    self.draw = draw
    self.setSpritesheet = setSpritesheet


    -- spritesheet & animations
    local props = require("data.EntitiesProperties")
    self:setSpritesheet(props["pikachu"])

    return self
end

return GoldenSnitch
