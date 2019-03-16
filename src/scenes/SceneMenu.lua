local function SceneMenu(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local sceneMenu = SceneBase(pSceneManager)

    function sceneMenu:draw()
        love.graphics.print("start scene")
    end

    function sceneMenu:keyPressed(k)
        if k == "escape" then
            love.event.quit()
        else
            self.manager:load("start")
        end
    end

    return sceneMenu
end

return SceneMenu
