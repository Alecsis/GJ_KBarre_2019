local sceneManager = nil

function love.load()
    love.graphics.setDefaultFilter("nearest")
    io.stdout:setvbuf("no")

    local SceneManager = require("lib.SceneManager")
    local SceneMenu = require("src.scenes.SceneMenu")
    local SceneNarration = require("src.scenes.SceneNarration")
    local SceneChoiceBase = require("src.scenes.SceneChoiceBase")
    local SceneTransitionImage = require("src.scenes.SceneTransitionImage")
    local SceneGameBall = require("src.scenes.SceneGameBall")

    -- create scene manager
    sceneManager = SceneManager()

    -- create player
    local player = require("src.objects.Player")()
    local pikachu = require("src.objects.Pikachu")(player)
    local ball = require("src.objects.Ball")(player)
    
    -- register scenes
    local SceneData = require("data.SceneData")
    sceneManager:register("menu", SceneMenu(sceneManager))
    sceneManager:register("transition", SceneTransitionImage(sceneManager))
    for k, v in pairs(SceneData) do
        if v.type == "choice" then
            sceneManager:register(k, SceneChoiceBase(sceneManager, v, player, pikachu, ball))
        elseif v.type == "narrative" then
            sceneManager:register(k, SceneNarration(sceneManager, v))
        end
    end

    sceneManager:register("Ball", SceneGameBall(sceneManager, player, pikachu, ball))

    -- load start scene by default
    sceneManager:load("Beginning")
    --sceneManager:load("Ball")
end

function love.update(dt) sceneManager:update(dt) end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    sceneManager:draw()
end

function love.keypressed(k) sceneManager:keyPressed(k) end

function love.keyreleased(k) sceneManager:keyReleased(k) end
