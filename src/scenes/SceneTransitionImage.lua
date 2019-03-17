local function SceneTransitionImage(pSceneManager)
    local self = require("lib.SceneBase")(pSceneManager)
    self.screenw = love.graphics.getWidth()
    self.screenh = love.graphics.getHeight()
    
    function self:init(args)
        self.image = love.graphics.newImage("assets/" .. args.image)
        self.imagew = self.image:getWidth()
        self.imageh = self.image:getHeight()

        self.speed = args.speed

        self.destination = args.destination

        self.tmr = 0
        self.alpha = 0

        self.music = args.music
        self.musicVol = 1

        self.sound = args.sound
        if self.sound then
            self.sound:play()
        end
    end

    function self:exit()
        self.image:release()
        if self.music then
            self.music:stop()
            self.music:release()
        end
    end

    function self:update(dt)
        self.tmr = self.tmr + dt
        self.alpha = math.sin(math.pi * self.tmr / self.speed)
        self.musicVol = math.cos(math.pi * self.tmr / self.speed / 2)
        self.music:setVolume(self.musicVol)
        if self.tmr > self.speed then
            self.music:stop()
            self.manager:load(self.destination)
        end
    end

    function self:draw()
        love.graphics.setColor(1,1,1,self.alpha)
        love.graphics.draw(self.image, self.screenw / 2, self.screenh / 2, 0, 1, 1, self.imagew / 2, self.imageh / 2)
    end

    function self:keyPressed(k)
        self.music:stop()
        self.manager:load(self.destination)
    end

    return self
end

return SceneTransitionImage