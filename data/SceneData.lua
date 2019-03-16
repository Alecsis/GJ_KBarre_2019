local scenes = {
    ["start"] = "choice",
    ["Princesse Sarah"] = "choice",
    ["Olive et Tom"] = "choice",
    ["Game Boy"] = "choice",
    ["Tamagochi"] = "choice",
    ["Didle"] = "choice",
    ["Pokemon"] = "choice",
    ["Skyblog"] = "choice",
    ["MSN"] = "choice",
    ["Beginning"] = "narrative",
    ["Heart"] = "transition"
}

local transitions = {
    ["Heart"] = {
        speed = 7,
        image = "coeurPixel.jpg",
        sound = "beginningTheme.jpg",
    }
}

local narratives = {
    ["Beginning"] = {
        sound = "beginningTheme.mp3",
        script = {
            "Relive your childhood",
            "between nostalgia and fond memories. ",
            "And discover another life",
            "in the  intertwined paths",
            "of a great adventure !",
        },
    },
}

local choices = {
    ["start"] = {
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
        switchMusic = true,
    },
    ["Princesse Sarah"] = {
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
    ["Olive et Tom"] = {
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
            destination = "Olive et Tom",
        },
        switchMusic = true,
    },
    ["Tamagochi"] = {
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
        switchMusic = true,
    },
}

local ScenesData = {
    scenes = scenes,
    choices = choices,
    narratives = narratives,
    transitions = transitions,
}
return ScenesData
