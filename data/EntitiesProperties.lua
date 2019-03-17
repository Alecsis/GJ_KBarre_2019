local scale = 4
local props = {
    ["default"] = {
        spritesheet = {
            filename = "assets/player-export.png",
            frameWidth = 16 * scale,
            frameHeight = 32 * scale,
            width = 8,
        },
        animations = {
            ["idle"] = {
                frames = {9, 10, 11, 12, 13, 14, 15, 16},
                speed = 1 / 8,
                next = "idle",
            },
            ["walk"] = {frames = {1, 2, 3, 4}, speed = 1 / 8, next = "walk",},
        },
        defaultAnimation = "idle",
    },
    ["girly"] = {
        spritesheet = {
            filename = "assets/girly.png",
            frameWidth = 16 * scale,
            frameHeight = 32 * scale,
            width = 8,
        },
        animations = {
            ["idle"] = {
                frames = {9, 10, 11, 12, 13, 14, 15, 16},
                speed = 1 / 8,
                next = "idle",
            },
            ["walk"] = {frames = {1, 2, 3, 4}, speed = 1 / 8, next = "walk",},
        },
    },
    ["ball"] = {
        spritesheet = {
            filename = "assets/ballonFoot.png",
            frameWidth = 11 * scale,
            frameHeight = 11 * scale,
            width = 4,
        },
        
        animations = {
            ["idle"] = {frames = {1}, speed = 0, next = "walk",},
            ["walk"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",
    },
    ["pikachu"] = {
        spritesheet = {
            filename = "assets/pikachu.png",
            frameWidth = 16 * scale,
            frameHeight = 18 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {5, 6, 7, 8}, speed = 1 / 4, next = "walk",},
            ["walk"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["Olive-et-Tom"] = {
        spritesheet = {
            filename = "assets/oliveEtTom.png",
            frameWidth = 32 * scale,
            frameHeight = 45 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
}

return props
