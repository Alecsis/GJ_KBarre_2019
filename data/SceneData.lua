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
                destination = "Princesse Sarah",
            },
            right = {
                text = "Olive et Tom",
                sound = "Olive-et-Tom-preview.mp3",
                background = "Olive-et-Tom-background.jpg",
                destination = "Olive et Tom",
            },
        },
        transition = true,
    },
    ["Princesse Sarah"] = {
        type = "choice",
        choices = {
            left = {
                text = "Game Boy",
                sound = "Pokemon-Kbarre.mp3",
                background = "Gameboy.jpg",
                destination = "Princesse Sarah",
            },
            right = {
                text = "Tamagochi",
                sound = "Tamagotchi.mp3",
                background = "tamagochi.jpg",
                destination = "Tamagochi",
            },
        },
    },
    ["Olive et Tom"] = {
        type = "choice",
        choices = {
            left = {
                text = "Didle",
                sound = "Diddle-musique.mp3",
                background = "Diddle.jpg",
                destination = "start",
            },
            right = {
                text = "Pokemon",
                sound = "pokemonGenerique.mp3",
                background = "Pokemon.jpg",
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
                destination = "start",
            },
            right = {
                text = "MSN",
                sound = "MSN.mp3",
                background = "msn.png",
                destination = "start",
            },
        },
    },
}

return scenes
