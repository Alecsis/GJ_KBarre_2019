local scenes = {
    ["Beginning"] = {
        type = "narrative",
        sound = "beginningTheme.mp3",
        script = {
            "Relive your childhood",
            "between nostalgia and fond memories.",
            "And discover another life",
            "in the intertwined paths",
            "of a great adventure!",
        },
        transition = {speed = 2, image = "coeurPixel.png",},
        destination = "start"
    },
    ["start"] = {
        type = "choice",
        choices = {
            left = {
                text = "Princesse Sarah",
                sound = "Princesse-Sarah-preview.mp3",
                background = "Princesse-Sarah-background.jpg",
                npc = nil,
                destination = "Princesse Sarah",
            },
            right = {
                npc = "oliveEtTom",
                text = "Olive et Tom",
                sound = "Olive-et-Tom-preview.mp3",
                background = "Olive-et-Tom-background.jpg",
                npc = "Olive-et-Tom",
                destination = "Olive et Tom",
            },
        },
        transition = true,
    },
    ["Princesse Sarah"] = {
        type = "choice",
        choices = {
            left = {
                npc = "gameBoyAnimated",
                text = "Game Boy",
                sound = "Pokemon-Kbarre.mp3",
                background = "Gameboy.jpg",
                npc = "Game-Boy",
                destination = "Princesse Sarah",
            },
            right = {
                text = "Tamagochi",
                sound = "Tamagotchi.mp3",
                background = "tamagochi.jpg",
                npc = nil,
                destination = "Tamagochi",
            },
        },
    },
    ["Olive et Tom"] = {
        type = "choice",
        choices = {
            left = {
                npc = "didleAnimated",
                text = "Didle",
                sound = "Diddle-musique.mp3",
                background = "Diddle.jpg",
                npc = "Diddle",
                destination = "start",
            },
            right = {
                text = "Pokemon",
                sound = "pokemonGenerique.mp3",
                background = "Pokemon.jpg",
                npc = "pikachu",
                destination = "start",
            },
        },
    },
    ["Tamagochi"] = {
        type = "choice",
        choices = {
            left = {
                text = "Skyblog",
                sound = "skyblog.mp3",
                background = "skyblogs2.png",
                npc = nil,
                destination = "start",
            },
            right = {
                npc = "wizzMSNAnimated",
                text = "MSN",
                sound = "MSN.mp3",
                background = "msn.png",
                npc = "wizz",
                destination = "start",
            },
        },
    },
}

return scenes
