local function update(self, dt)
    -- get current state
    local currentState = self.stateManager:getCurrentState()

    -- update mouse
    self.mouse:update(dt)
    -- check if we clicked on any entity
    local lstHover = {}
    local mx, my = self.mouse:getPosition()

    -- update all entities
    for i = 1, #self.lstEntities do
        local entity = self.lstEntities[i]

        -- differentiate entities
        if entity.type == "unit" then
            if self.mouse.pressed2 then
                entity:setDestination(self.mouse.x, self.mouse.y)
            end
        elseif entity.type == "pawn" then
            entity:setPosition(self.mouse:getPosition())
        end

        -- get hovered entities
        local ex, ey = entity:getPosition()
        local dx = mx - ex
        local dy = my - ey
        if dx * dx + dy * dy < 9 then
            table.insert(lstHover, entity)
        end

        -- entity update logic
        entity:update(dt)
    end

    -- clicBg event
    if self.mouse.clic then
        if #lstHover == 0 or currentState == self.states.construction then
            self.stateManager:notify(self.events.clicBg)
        end
    end

    -- remove all killed entities
    for i = #self.lstEntities, 1, -1 do
        local entity = self.lstEntities[i]
        if entity.kill == true then
            table.remove(self.lstEntities, i)
        end
    end
end

local function sortEntities(self)
    -- sort all entities by y position
    table.sort(
        self.lstEntities,
        (function(a, b)
            return b.pos.y > a.pos.y
        end)
    )
end

local function draw(self)
    love.graphics.print("play scene")

    -- sort all entities by y position
    self:sortEntities()

    -- draw all entities
    for i = 1, #self.lstEntities do
        local entity = self.lstEntities[i]
        entity:draw()
    end

    -- draw mouse
    self.mouse:draw()
end

local function keyPressed(self, k)
    if k == "escape" then
        self.manager:load("start")
    end
    if k == "c" then
        self.stateManager:notify(self.events.constructBat)
    end
end

local function ScenePlay(pSceneManager)
    local SceneBase = require("lib.SceneBase")
    local self = SceneBase(pSceneManager)

    ---- mouse -----------
    local Mouse = require("lib.Mouse")
    self.mouse = Mouse()

    -- selected entities
    self.lstSelected = {}

    ---- stateManager ----
    local StateManager = require("lib.StateManager")
    local stateManager = StateManager(self)
    self.stateManager = stateManager

    -- list all states and events
    local states = {idle = 1, unitsCtrl = 2, construction = 3}
    local events = {clicBg = 1, unitSel = 2, constructBat = 3}
    self.states = states
    self.events = events

    ----- interface functions ----
    self.update = update
    self.draw = draw
    self.sortEntities = sortEntities
    self.keyPressed = keyPressed

    ---- finish initialization ----

    -- register states
    stateManager:addState(states.idle)
    stateManager:addState(states.unitsCtrl)
    stateManager:addState(states.construction)

    -- set first state
    stateManager:setCurrentState(states.idle)

    -- register transitions
    stateManager:addTransition(
        states.idle,
        states.unitsCtrl,
        events.unitSel,
        (function(self, args)
        end)
    )
    stateManager:addTransition(
        states.unitsCtrl,
        states.idle,
        events.clicBg,
        (function(self, args)
            self.lstSelected = {}
        end)
    )
    stateManager:addTransition(
        states.idle,
        states.construction,
        events.constructBat,
        (function(self, args)
            local pawn = require("src.objects.Pawn")()
            self:addEntity(pawn)
            pawn:setPosition(self.mouse.x, self.mouse.y)
            self.lstSelected = {pawn}
        end)
    )
    stateManager:addTransition(
        states.construction,
        states.idle,
        events.clicBg,
        (function(self, args)
            local pawn = self.lstSelected[1]
            pawn.kill = true
            local building = require("src.objects.Building")()
            building:setPosition(pawn:getPosition())
            self:addEntity(building)
            self.lstSelected = {}
        end)
    )

    -- entitites
    local unit = require("src.objects.Unit")()
    unit:setPosition(100, 100)
    self:addEntity(unit)

    return self
end

return ScenePlay
