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
        defaultAnimation = "idle",
    },
    ["ball"] = {
        spritesheet = {
            filename = "assets/ballonFoot.png",
            frameWidth = 11 * scale,
            frameHeight = 11 * scale,
            width = 4,
        },
        
        animations = {
            ["idle"] = {frames = {1}, speed = 0, next = "idle",},
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
            ["idle"] = {frames = {5, 6, 7, 8}, speed = 1 / 4, next = "idle",},
            ["walk"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["golden snitch"] = {
        spritesheet = {
            filename = "assets/goldenSnitchAnimated.png",
            frameWidth = 32 * scale,
            frameHeight = 14 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 8, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["Olive-et-Tom"] = {
        spritesheet = {
            filename = "assets/oliveEtTomAnimated.png",
            frameWidth = 32 * scale,
            frameHeight = 45 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["Diddle"] = {
        spritesheet = {
            filename = "assets/didleAnimated.png",
            frameWidth = 32 * scale,
            frameHeight = 45 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["Game-Boy"] = {
        spritesheet = {
            filename = "assets/gameBoyAnimated.png",
            frameWidth = 32 * scale,
            frameHeight = 32 * scale,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["wizz"] = {
        spritesheet = {
            filename = "assets/wizzMSNAnimated.png",
            frameWidth = 31 * scale,
            frameHeight = 22 * scale,
            width = 6,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4, 5, 6}, speed = 1 / 12, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["tamagotchi"] = {
        spritesheet = {
            filename = "assets/tamagotchiAnimated.png",
            frameWidth = 140,
            frameHeight = 160,
            width = 2,
        },
        animations = {
            ["idle"] = {frames = {1, 2}, speed = 1 / 2, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["princessSarah"] = {
        spritesheet = {
            filename = "assets/princessSarah.png",
            frameWidth = 100,
            frameHeight = 144,
            width = 4,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4}, speed = 1 / 4, next = "idle",},
        },
        defaultAnimation = "idle",

    },
    ["boom"] = {
        spritesheet = {
            filename = "assets/boom-export.png",
            frameWidth = 48*2,
            frameHeight = 48*2,
            width = 8,
        },
        animations = {
            ["idle"] = {frames = {1, 2, 3, 4, 5, 6, 7, 8}, speed = 1 / 8, next = "idle",},
        },
        defaultAnimation = "idle",

    },
}

return props
