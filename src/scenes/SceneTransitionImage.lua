local function SceneTransitionImage(pSceneManager, pData)
    local self = require("lib.SceneBase")(pSceneManager)
    self.screenw = love.graphics.getWidth()
    self.screenh = love.graphics.getHeight()
    self.image = love.graphics.newImage("assets/" .. pData.image)
    self.imagew = self.image:getWidth()
    self.imageh = self.image:getHeight()
    self.speed = pData.speed

    function self:init(args)
        self.next = args.next
        self.tmr = 0
        self.alpha = 0
        self.music = args.music
        self.musicVol = 1
    end

    function self:update(dt)
        self.tmr = self.tmr + dt
        self.alpha = math.sin(math.pi * self.tmr / self.speed)
        self.musicVol = math.cos(math.pi * self.tmr / self.speed / 2)
        self.music:setVolume(self.musicVol)
        if self.tmr > self.speed then
            self.music:stop()
            self.manager:load(self.next)
        end
    end

    function self:draw()
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.image, self.screenw / 2, self.screenh / 2, 0, 1, 1, self.imagew / 2, self.imageh / 2)
    end

    return self
end

return SceneTransitionImage