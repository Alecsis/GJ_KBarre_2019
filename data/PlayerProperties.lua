local props = {}

local scale = 4
props.spritesheet = {
    filename = "assets/player-export.png",
    frameWidth = 16 * scale,
    frameHeight = 32 * scale,
    width = 8,
}

props.spritesheetGirly = {
    filename = "assets/girly.png",
    frameWidth = 16 * scale,
    frameHeight = 32 * scale,
    width = 8,
}

props.animations = {
    ["idle"] = {
        frames = {9, 10, 11, 12, 13, 14, 15, 16},
        speed = 1/8,
        next = "idle",
    },
    ["walk"] = {
        frames = {1, 2, 3, 4},
        speed = 1/8,
        next = "walk",
    },
}
props.defaultAnimation = "idle"

props.spritesheetPikachu = {
    filename = "assets/pikachu.png",
    frameWidth = 16 * scale,
    frameHeight = 18 * scale,
    width = 4,
}

props.animationsPikachu = {
    ["idle"] = {
        frames = {5, 6, 7, 8},
        speed = 1/4,
        next = "walk",
    },
    ["walk"] = {
        frames = {1, 2, 3, 4},
        speed = 1/4,
        next = "idle",
    },
}

props.spritesheetBall = {
    filename = "assets/ballonFoot.png",
    frameWidth = 11 * scale,
    frameHeight = 11 * scale,
    width = 4,
}

props.animationsBall = {
    ["idle"] = {
        frames = {1},
        speed = 0,
        next = "walk",
    },
    ["walk"] = {
        frames = {1, 2, 3, 4},
        speed = 1/4,
        next = "idle",
    },
}

return props