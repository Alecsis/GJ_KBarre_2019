local function StateManager(pOwner)
    local stateManager = {}

    stateManager.owner = pOwner
    stateManager.currentState = 0
    stateManager.lstStates = {}
    stateManager.lstTransitions = {}

    function stateManager:addState(pStateId)
        -- register it to the list
        table.insert(stateManager.lstStates, pStateId)
    end

    function stateManager:addTransition(pFromId, pToId, pEvent, pCallback)
        -- create transition object
        local transition = {}
        transition.from = pFromId
        transition.to = pToId
        transition.event = pEvent
        transition.callback = pCallback

        -- register it to the list
        table.insert(self.lstTransitions, transition)
    end

    function stateManager:notify(pEvent, pArgs)
        for i = 1, #self.lstTransitions do
            local transition = self.lstTransitions[i]

            -- do we match the current state
            if transition.from == self.currentState and transition.event == pEvent then
                print("from " .. transition.from .. " to " .. transition.to .. " on " .. transition.event)

                -- change current state
                self:setCurrentState(transition.to)

                -- execute callback function if it exists
                local callback = transition.callback
                if callback then
                    --self.owner:callback()
                    callback(self.owner, pArgs)
                end

                -- exit loop
                break
            end
        end
    end

    function stateManager:setCurrentState(pStateId)
        self.currentState = pStateId
    end

    function stateManager:getCurrentState()
        return self.currentState
    end

    return stateManager
end

return StateManager
