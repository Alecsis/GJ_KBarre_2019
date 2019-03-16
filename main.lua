local sceneManager = nil

function love.load()
    love.graphics.setDefaultFilter("nearest")
    io.stdout:setvbuf("no")

    local SceneManager = require("lib.SceneManager")
    local SceneMenu = require("src.scenes.SceneMenu")
    local SceneNarration = require("src.scenes.SceneNarration")
    local SceneChoiceBase = require("src.scenes.SceneChoiceBase")

    local SceneData = require("data.SceneData")
    local choices = SceneData.choices

    -- create scene manager
    sceneManager = SceneManager()

    -- register scenes
    local data = {script = {"Hello", "How are you ?", "Bye",}}
    sceneManager:register("narrative", SceneNarration(sceneManager, data))
    sceneManager:register("menu", SceneMenu(sceneManager))
    sceneManager:register(
        "start",
        SceneChoiceBase(sceneManager, choices["start"])
    )
    sceneManager:register(
        "Princesse Sarah",
        SceneChoiceBase(sceneManager, choices["Princesse Sarah"])
    )
    sceneManager:register(
        "Tamagochi",
        SceneChoiceBase(sceneManager, choices["Tamagochi"])
    )
    sceneManager:register(
        "Olive et Tom",
        SceneChoiceBase(sceneManager, choices["Olive et Tom"])
    )

    -- sceneManager:register("Skyblog", SceneChoiceBase(sceneManager, SceneData["Skyblog"].choice))
    -- sceneManager:register("MSN", SceneChoiceBase(sceneManager, SceneData["MSN"].choice))

    -- load start scene by default
    sceneManager:load("narrative")
    -- sceneManager:load("menu")
end

function love.update(dt) sceneManager:update(dt) end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    sceneManager:draw()
end

function love.keypressed(k) sceneManager:keyPressed(k) end

function love.keyreleased(k) sceneManager:keyReleased(k) end
