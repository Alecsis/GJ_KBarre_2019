local sceneManager = nil

function love.load()
    love.graphics.setDefaultFilter("nearest")
    io.stdout:setvbuf("no")

    local SceneManager = require("lib.SceneManager")
    local SceneMenu = require("src.scenes.SceneMenu")
    local SceneChoiceBase = require("src.scenes.SceneChoiceBase")

    local SceneData = require("data.SceneData")

    -- create scene manager
    sceneManager = SceneManager()

    -- register scenes
    sceneManager:register("menu", SceneMenu(sceneManager))
    sceneManager:register("start", SceneChoiceBase(sceneManager, SceneData["start"].choice))
    sceneManager:register("Princesse Sarah", SceneChoiceBase(sceneManager, SceneData["Princesse Sarah"].choice))
    sceneManager:register("Tamagochi", SceneChoiceBase(sceneManager, SceneData["Tamagochi"].choice))
    sceneManager:register("Olive et Tom", SceneChoiceBase(sceneManager, SceneData["Olive et Tom"].choice))

    -- load start scene by default
    sceneManager:load("start")
    --sceneManager:load("menu")
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    sceneManager:draw()
end

function love.keypressed(k)
    sceneManager:keyPressed(k)
end

function love.keyreleased(k)
    sceneManager:keyReleased(k)
end
