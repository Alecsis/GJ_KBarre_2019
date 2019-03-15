local function update(self, dt)
    local gravity = 640 * dt
    self.player:accelerate(0, gravity)
    local vx, vy = self.player:getVelocity()
    self.player:move(vx * dt, vy * dt)
end

local function draw(self)
    love.graphics.print("Generic choice scene")

    -- draw all entities
    love.graphics.draw(self.platform.sprite, self.platform.x, self.platform.y, 0, self.platform.scale)
    self.player:draw()
end

local function keyPressed(self, k)
    if k == "escape" then
        self.manager:load("start")
    end
end

local function SceneChoiceBase(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)

    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    ----- objects -----
    self.platform = { x=0, y=0, width=480, height=160 }
    self.platform.x = (self.width - self.platform.width) / 2
    self.platform.y = self.height - self.platform.height
    self.platform.sprite = love.graphics.newImage("assets/platform.png")
    self.platform.scale = self.platform.width / self.platform.sprite:getWidth()

     ----- player ----    
    local player = require("src.objects.Player")()
    player:setPosition(self.width / 2, self.height / 2)
    player:setVelocity(50, -100)
    self.player = player
    
    ----- interface functions ----
    self.update = update
    self.draw = draw
    self.keyPressed = keyPressed

    return self
end

return SceneChoiceBase
