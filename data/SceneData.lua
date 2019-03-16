local scenes = {
    ["start"] = {
        choice = {
            left = {
                text = "Olive et Tom",
                sound = "Olive-et-Tom-preview.mp3",
                background = "Olive-et-Tom-background.jpg",
                destination = "Olive et Tom",
            },
            right = {
                text = "Princesse Sarah",
                sound = "Princesse-Sarah-preview.mp3",
                background = "Princesse-Sarah-background.jpg",
                destination = "Princesse Sarah",
            },
            switchMusic = true,
        },
    },
    ["Princesse Sarah"] = {
        choice = {
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
            switchMusic = true,
        },
    },
    ["Tamagochi"] = {
        choice = {
            left = {
                text = "Game Boy",
                sound = "Pokemon-Kbarre.mp3",
                background = "Gameboy.jpg",
                destination = "start",
            },
            right = {
                text = "Tamagochi",
                sound = "Tamagotchi.mp3",
                background = "tamagochi.jpg",
                destination = "start",
            },
            switchMusic = true,
        },
    },
    ["Olive et Tom"] = {
        choice = {
            left = {
                text = "Didle",
                sound = "Diddle-musique.mp3",
                background = "Diddle.jpg",
                destination = "start",
            },
            right = {
                text = "Pokemon",
                sound = "PokemonGenerique.mp3",
                background = "Pokemon.jpg",
                destination = "start",
            },
            switchMusic = true,
        },
    },
}

return scenes