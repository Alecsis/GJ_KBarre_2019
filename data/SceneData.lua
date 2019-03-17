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
                npc = "oliveEtTom",
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
                npc = "gameBoyAnimated",
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
                npc = "didleAnimated",
                text = "Didle",
                sound = "Diddle-musique.mp3",
                background = "Diddle.jpg",
                destination = "start",
            },
            right = {
                text = "Pokemon",
                sound = "pokemonGenerique.mp3",
                background = "Pokemon.jpg",
                destination = "firstLevel",
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
                destination = "firstLevel",
            },
            right = {
                npc = "wizzMSNAnimated",
                text = "MSN",
                sound = "MSN.mp3",
                background = "msn.png",
                destination = "firstLevel",
            },
        },
    },
    -- Scène narration level one -- 
        ["firstLevel"] = {
            type = "narrative",
            sound = "beginningTheme.mp3",
            script = {
                "If you could go back",
                "would you choose the same things ?",
                "Choose the same people to trust",
                "and to love ?",
                "Would you get addicted the same way ?",
            },
            transition = {speed = 2, image = "coeurPixel.png",},
            destination = "afterFirstLevel"
        },
    
        -- première scène niveau 1 -- 
    
        ["afterFirstLevel"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Les écrans",
                    sound = "cinema.mp3",
                    background = "tnt.jpg",
                    destination = "screens",
                },  
                right = {
                    npc = "oliveEtTom",
                    text = "Les booms de folie",
                    sound = "Olive-et-Tom-preview.mp3",
                    background = "Olive-et-Tom-background.jpg",
                    destination = "Dancing",
                },
            },
            transition = true,
        },

        ["screens"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Les DVD",
                    sound = "Princesse-Sarah-preview.mp3",
                    background = "Princesse-Sarah-background.jpg",
                    destination = "lesDVD",
                },  
                right = {
                    npc = "oliveEtTom",
                    text = "La trilogie du samedi",
                    sound = "trilogieDuSamedi.mp3",
                    background = "trilogieDuSamedi.jpg",
                    destination = "trilogieDuSamedi",
                },
            },
            transition = true,
        },

        ["lesDVD"] = {
            type = "choice",
            choices = {
                left = {
                    npc = "",
                    text = "Le Seigneur des Anneaux",
                    sound = "seigneurDesAnneaux.mp3",
                    background = "seigneurDesAnneaux.jpg",
                    destination = "",
                },
                right = {
                    text = "Harry Potter",
                    sound = "HP.mp3",
                    background = "HP.jpg",
                    destination = "",
                },
            },
        },
        ["trilogieDuSamedi"] = {
            type = "choice",
            choices = {
                left = {
                    npc = "",
                    text = "Prison Break",
                    sound = "PrisonBreak.mp3",
                    background = "Diddle.jpg",
                    destination = "",
                },
                right = {
                    text = "Charmed",
                    sound = "tribuDeDana.mp3",
                    background = "Pokemon.jpg",
                    destination = "piperOrPhoebe",
                },
            },
        },
}

return scenes
