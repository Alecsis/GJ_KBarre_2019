local function SceneManager()
    local sceneManager = {}

    sceneManager.lstScenes = {}
    sceneManager.currentScene = nil

    function sceneManager:register(k, v)
        self.lstScenes[k] = v
    end

    function sceneManager:load(k)
        local newScene = self.lstScenes[k]
        if newScene == nil then
            print("!SceneManager: Scene " .. k .. " unknown.")
        else
            if self.currentScene ~= nil then
                self.currentScene:exit()
            end
            self.currentScene = newScene
        end
    end

    function sceneManager:update(dt)
        if self.currentScene ~= nil then
            self.currentScene:update(dt)
        end
    end

    function sceneManager:draw()
        if self.currentScene ~= nil then
            self.currentScene:draw()
        end
    end

    function sceneManager:keyPressed(k)
        if self.currentScene ~= nil then
            self.currentScene:keyPressed(k)
        end
    end

    function sceneManager:keyReleased(k)
        if self.currentScene ~= nil then
            self.currentScene:keyReleased(k)
        end
    end

    return sceneManager
end

return SceneManager