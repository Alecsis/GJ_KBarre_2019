local function SceneBase(pSceneManager)
    local scene = {}
    scene.manager = pSceneManager

    scene.lstEntities = {}

    function scene:init()
    end

    function scene:exit()
    end

    function scene:update(dt)
    end

    function scene:draw()
        love.graphics.print("default scene")
    end
    
    function scene:keyPressed(k)
    end

    function scene:keyReleased(k)
    end

    function scene:addEntity(pEntity)
        table.insert(self.lstEntities, pEntity)
    end

    function scene:removeEntity(pEntity)
        for i = #self.lstEntities, 1, -1 do
            if self.lstEntities[i].id == pEntity.id then
                table.remove(self.lstEntities, i)
                break
            end
        end
        print("Entity not found")
    end
    return scene
end

return SceneBase
