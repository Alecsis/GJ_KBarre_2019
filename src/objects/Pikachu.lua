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

    if self.player.pos.x < self.pos.x then
        self.xflip = -1
    else
        self.xflip = 1
    end

    if math.abs(self.player.pos.x - self.pos.x) > 100 then
        self.vel.x = self.player.vel.x
    else
        self.vel.x = 0
    end

    if (self.pos.y - self.player.pos.y) > 2 * self.dimensions.h and self.onGround then
        self:setVelocity(self.vel.x, -800)
        self.onGround = false
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

local function getBounds(self)
    local top = self.pos.y - self.dimensions.h
    local bottom = self.pos.y
    local right = self.pos.x + self.dimensions.w / 2
    local left = self.pos.x - self.dimensions.w / 2
    return top, right, bottom, left
end

local function getDimensions(self) return self.dimensions.w, self.dimensions.h end

local function setSpritesheet(self, playerProps, spritesheet)
     -- physical bounds
    self.dimensions = {
        w = spritesheet.frameWidth,
        h = spritesheet.frameHeight,
    }

    -- animations
    self.lstAnimations = playerProps.animationsPikachu
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

local function Pikachu(player)
    local Pawn = require("src.objects.Pawn")
    local self = Pawn()

    -- attributes
    self.type = "player"  -- do we collide bottom
    self.onGround = false
    self.player = player

     -- methods
    self.update = update
    self.getDimensions = getDimensions
    self.getBounds = getBounds
    self.draw = draw
    self.setSpritesheet = setSpritesheet


    -- spritesheet & animations
    local playerProps = require("data.PlayerProperties")
    self:setSpritesheet(playerProps, playerProps.spritesheetPikachu)

    return self
end

return Pikachu
