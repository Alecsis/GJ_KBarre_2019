local sceneManager = nil

function love.load()
    love.graphics.setDefaultFilter('nearest')
    io.stdout:setvbuf('no')

    local SceneManager = require("lib.SceneManager")
    local SceneStart = require("src.scenes.SceneStart")
    local SceneChoiceBase = require("src.scenes.SceneChoiceBase")

    -- create scene manager
    sceneManager = SceneManager()

    -- register scenes
    sceneChoiceBase = SceneChoiceBase(sceneManager)
    sceneStart = SceneStart(sceneManager)

    sceneManager:register("choicebase", sceneChoiceBase)
    sceneManager:register("start", sceneStart)

    -- load start scene by default
    sceneManager:load("choicebase")
    --sceneManager:load("play")
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw()
    love.graphics.setColor(1,1,1)
    sceneManager:draw()
end

function love.keypressed(k)
    sceneManager:keyPressed(k)
end

function love.keyreleased(k)
    sceneManager:keyReleased(k)
end
