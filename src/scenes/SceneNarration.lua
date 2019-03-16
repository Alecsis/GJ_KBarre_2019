local utf8 = require("utf8")

local function SceneNarration(pSceneManager, pData)
    local self = require("lib.SceneBase")(pSceneManager)

    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.script = pData.script
    self.nbLines = #self.script
    self.indexLine = 1
    self.lineDone = false

    self.indexChar = 0
    self.currentLine = self.script[self.indexLine]
    self.toWrite = ""
    self.destination = pData.destination
    self.font = love.graphics.newFont(32)
    self.writeTmr = -1
    self.writeSpeed = 0.05
    self.music = love.audio.newSource("assets/" .. pData.sound, "stream")

    function self:init(args)
        self.indexLine = 1
        self.indexChar = 0
        self.lineDone = false
        self.writeTmr = 0
        self.music:play()        
    end

    function self:keyPressed(k)
        if k == "escape" then
            love.event.quit()
        end
        if k == "space" or k == "return" then
            if self.lineDone then
                if self.indexLine == self.nbLines then
                    print("oui")
                    self.manager:load("Heart", {next="start", music=self.music})
                else
                    self:newLine()
                end
            end
        end
    end

    function self:newLine()
        self.lineDone = false
        self.indexLine = self.indexLine + 1
        self.currentLine = self.script[self.indexLine]
        self.indexChar = 0
        self.toWrite = ""
    end

    function self:update(dt)
        if not self.lineDone then
            self.writeTmr = self.writeTmr + dt
            if self.writeTmr > self.writeSpeed then
                self.writeTmr = 0
                self.indexChar = self.indexChar + 1
                local char = self.currentLine:sub(self.indexChar, self.indexChar)
                self.toWrite = self.toWrite .. char
                if self.indexChar > string.len(self.currentLine) then
                    self.indexChar = 1
                    self.lineDone = true
                end
            end
        end
    end

    function self:draw() 
        love.graphics.printf(self.toWrite, self.font, 0, self.height / 2, self.width, "center")
    end

    return self
end

return SceneNarration   