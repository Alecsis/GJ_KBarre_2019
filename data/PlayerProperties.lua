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

return props