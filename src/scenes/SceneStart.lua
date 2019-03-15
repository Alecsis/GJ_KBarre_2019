local function SceneStart(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local sceneStart = SceneBase(pSceneManager)

    function sceneStart:draw()
        love.graphics.print("start scene")
    end

    function sceneStart:keyPressed(k)
        if k == "escape" then
            love.event.quit()
        else
            self.manager:load('choicebase')
        end
    end

    return sceneStart
end

return SceneStart
