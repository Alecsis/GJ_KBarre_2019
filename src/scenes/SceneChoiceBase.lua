local function update(self, dt)
    -- get current state
    local currentState = self.stateManager:getCurrentState()
end

local function draw(self)
    love.graphics.print("Generic choice scene")
end

local function keyPressed(self, k)
    if k == "escape" then
        self.manager:load("start")
    end
end

local function SceneChoiceBase(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)

    ----- interface functions ----
    self.update = update
    self.draw = draw
    self.keyPressed = keyPressed

    return self
end

return SceneChoiceBase
