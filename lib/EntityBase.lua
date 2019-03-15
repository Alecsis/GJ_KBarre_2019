local _id = 0

local function EntityBase()
    local entity = {}
    
    entity.id = _id
    _id = _id + 1

    entity.kill = false

    function entity:update(dt)
    end

    function entity:draw()
    end

    return entity
end

return EntityBase
