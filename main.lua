local sceneManager = nil

function love.load()
    local SceneManager = require("lib.SceneManager")
    local SceneStart = require("src.scenes.SceneStart")
    local ScenePlay = require("src.scenes.ScenePlay")

    -- create scene manager
    sceneManager = SceneManager()

    -- register scenes
    scenePlay = ScenePlay(sceneManager)
    sceneStart = SceneStart(sceneManager)

    sceneManager:register("play", scenePlay)
    sceneManager:register("start", sceneStart)

    -- load start scene by default
    --sceneManager:load("start")
    sceneManager:load("play")
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
