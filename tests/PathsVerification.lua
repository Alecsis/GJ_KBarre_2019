local function Node(pName, pChilds)
    local self = {}
    self.name = pName
    self.childs = pChilds
    return self
end

local function PathVerification(pData, pBeginning)
    assert(pData, " Test needs data object ")
    assert(pBeginning, " Test needs beginning ")

    local lstNodes = {}

    -- builds nodes
    for key, scene in pairs(pData) do
        local node = Node(key)
        if scene.type == "choice" then
            local left = scene.choices.left.destination
            local right = scene.choices.right.destination
            node = Node(key, {left, right})
        elseif scene.type == "narrative" then
            node = Node(key, {scene.destination})
        elseif scene.type == "game" then
            node = Node(key, {scene.destination})
        end
        assert(
            lstNodes[key] == nil,
            " Must only have one scene called " .. key
        )
        lstNodes[key] = node
    end

    assert(
        lstNodes[pBeginning] ~= nil,
        "Beginning scene must exists : " .. pBeginning
    )

    -- print nodes
    --[[for key, node in pairs(lstNodes) do
        print(key)
        for _, child in pairs(node.childs) do
            print("\t"..child)
        end
    end]]
    
    local lstVisited = {}
    lstVisited[pBeginning] = true
    lstLeaves = {}
    local lstfifo = {lstNodes[pBeginning]}
    while #lstfifo > 0 do
        -- pop first elt
        local node = lstfifo[1]
        --lstVisited[node.name] = true
        --print(node.name)
        table.remove(lstfifo, 1)
        -- add all childs
        if #node.childs == 0 then
            table.insert(lstLeaves, node.name)
        else
            for _, child in pairs(node.childs) do 
                if lstVisited[child] == true then
                    -- already visited
                else
                    lstVisited[child] = true
                    table.insert(lstfifo, lstNodes[child])
                end
            end
        end
    end

    print("Leaves : ")
    for _, node in pairs(lstLeaves) do
        print(node)
    end
    -- love.event.quit()
end

return PathVerification
