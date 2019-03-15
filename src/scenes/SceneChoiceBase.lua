local function update(self, dt)
    -- get current state
    local currentState = self.stateManager:getCurrentState()
end

local function draw(self)
    love.graphics.print("Generic choice scene")
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
    
    local player = require("src.objects.Player")()
    player:setPosition(self.w / 2, self.h / 2)
    self.player = player
    
    ----- interface functions ----
    self.update = update
    self.draw = draw
    self.keyPressed = keyPressed

    return self
end

return SceneChoiceBase
