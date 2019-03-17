local function init(self, args)
    ----- scene -----
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.shadeTmr = 1

    ----- fonts -----
    self.chooseFont = love.graphics.newFont(32)

    -- choices
    self.choices = self.data.choices

    ----- player ----
    self.player:setPosition(250, self.height - self.player.dimensions.w / 2 - 20)
    self.player.pikachu:setPosition(self.player.pos.x - 80, self.player.pos.y)
    self.player.ball:setPosition(self.player.pos.x + 80, self.player.pos.y)
    self.player.goldenSnitch:setPosition(self.player.pos.x, self.player.pos.y - self.player.dimensions.h)

    self.player:setVelocity(0, 0)
    self.player.pikachu:setVelocity(0, 0)
    self.player.ball:setVelocity(0, 0)
    self.player.goldenSnitch:setVelocity(0, 0)

    self.currentMusic = love.audio.newSource('assets/' .. "Olive-et-Tom.mp3", "stream")
    self.currentMusic:play()
    self.currentMusic:setVolume(1)
    self.currentMusic:setLooping(true)

    self.text = ""
    for i=1, #self.player.history do
        local ligne = self.player.history[i]
        self.text = self.text .. i .. ": " .. ligne .. "\n"
    end
end

local function update(self, dt)
    -- change screen shading
    self.shadeTmr = self.shadeTmr - dt
    if self.shadeTmr <= 0 then self.shadeTmr = 0 end
end

local function exit(self) end

local function draw(self)
    -- draw npcs and player
    self.player:draw()

    if self.shadeTmr > 0 then
        love.graphics.setColor(0, 0, 0, self.shadeTmr)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end

    -- draw text
    love.graphics.setFont(love.graphics.newFont(25))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.text, 0, 100, self.width, "center")
end

local function setChoices(self, choices) self.choices = choices end

local function keyPressed(self, k) end

local function SceneFinal(pSceneManager, pData, player)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)
    self.data = pData
    self.player = player

    ----- interface functions ----
    self.update = update
    self.exit = exit
    self.draw = draw
    self.init = init
    self.setChoices = setChoices
    self.keyPressed = keyPressed

    return self
end

local localSelf = {}
return SceneFinal
