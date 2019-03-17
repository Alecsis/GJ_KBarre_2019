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
                action = (function(player) player:makeGirly() end),
            },
            right = {
                text = "Olive et Tom",
                sound = "Olive-et-Tom-preview.mp3",
                background = "Olive-et-Tom-background.jpg",
                npc = "Olive-et-Tom",
                destination = "Olive et Tom minijeu",
            },
        },
        transition = true,
    },
    ["Olive et Tom minijeu"] = {
        type = "game",
        scene = "SceneGameBall",
        background = "Olive-et-Tom-background.jpg",
        destination = "Olive et Tom"
    },
    ["Princesse Sarah"] = {
        type = "choice",
        choices = {
            left = {
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
                npc = "tamagotchi",
                destination = "Tamagochi",
            },
        },
    },
    ["Olive et Tom"] = {
        type = "choice",
        choices = {
            left = {
                text = "Diddl",
                sound = "Diddle-musique.mp3",
                background = "Diddle.jpg",
                npc = "Diddle",
                destination = "firstLevel",
                action = (function(player) player:makeGirly() end)
            },
            right = {
                text = "Pokemon",
                sound = "pokemonGenerique.mp3",
                background = "Pokemon.jpg",
                npc = "pikachu",
                destination = "firstLevel",
                action = (function(player) player:addPikachu() end),
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
                destination = "firstLevel",
            },
            right = {
                text = "MSN",
                sound = "MSN.mp3",
                background = "msn.png",
                npc = "wizz",
                destination = "firstLevel",
            },
        },
    },

    -- Scène narration level one -- 
        ["firstLevel"] = {
            type = "narrative",
            sound = "theLeftouts.mp3",
            script = {
                "If you could go back",
                "would you choose the same things?",
                "Choose the same people to trust",
                "and to love?",
                "Would you get addicted the same way?",
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
                    npc = nil,
                    destination = "screens",
                },  
                right = {
                    text = "Les booms de folie",
                    sound = "demonsDeMinuit.mp3",
                    background = "tektonic.jpg",
                    npc = nil,
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
                    sound = "dvdSound.mp3",
                    background = "dvd.jpeg",
                    npc = nil,
                    destination = "lesDVD",
                },  
                right = {
                    text = "La trilogie du samedi",
                    sound = "trilogieDuSamedi.mp3",
                    background = "trilogieDuSamedi.jpg",
                    npc = nil,
                    destination = "trilogieDuSamedi",
                },
            },
            transition = true,
        },

        ["lesDVD"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Le Seigneur des Anneaux",
                    sound = "seigneurDesAnneaux.mp3",
                    background = "seigneurDesAnneaux.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },
                right = {
                    text = "Harry Potter",
                    sound = "HP.mp3",
                    background = "HP.jpg",
                    npc = nil,
                    destination = "HermioneOuGinny",
                },
            },
        },
        ["trilogieDuSamedi"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Prison Break",
                    sound = "PrisonBreak.mp3",
                    background = "Diddle.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },
                right = {
                    text = "Charmed",
                    sound = "charmedSound.mp3",
                    background = "Pokemon.jpg",
                    npc = nil,
                    destination = "agentsSecret",
                },
            },
        },

        ["HermioneOuGinny"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Hermione",
                    sound = "Hermione.mp3",
                    background = "Hermione.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },
                right = {
                    text = "Ginny",
                    sound = "Ginny.mp3",
                    background = "ginny.jpg",
                    npc = nil,
                    destination = "Disney",
                },
            },
        },

        ["Disney"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Mulan",
                    sound = "mulanSound.mp3",
                    background = "Mulan.jpg",
                    npc = nil,
                    destination = "LastLevel",
                },
                right = {
                    text = "Le Roi Lion",
                    sound = "roiLionSound.mp3",
                    background = "roiLion.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },
            },
        },

        ["Dancing"] = {
            type = "choice",
            choices = {
                left = {
                    text = "Manau",
                    sound = "tribuDeDana.mp3",
                    background = "tribuDeDana.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },  
                right = {
                    text = "Indochine",
                    sound = "aventurierIndochine.mp3",
                    background = "indochine.jpg",
                    npc = nil,
                    destination = "lastLevel",
                },
            },
            transition = true,
        },

            ["agentsSecret"] = {
                type = "choice",
                choices = {
                    left = {
                        text = "Code Lyoko",
                        sound = "codeLyoko.mp3",
                        background = "codeLyoko.jpg",
                        npc = nil,
                        destination = "lastLevel",
                    },
                    right = {
                        text = "Totally Spies",
                        sound = "totallySpied.mp3",
                        background = "totallySpies.jpg",
                        npc = nil,
                        destination = "lastLevel",
                    },
                },
            },


        ["lastLevel"] = {
            type = "narrative",
            sound = "Ilona.mp3",
            script = {
                "What sort of adult are you?",
                "Nobody can tell you but yourself.",
                "Be whoever the f you want,",
                "and make your kid version proud",
                "of your day to day choices!",
            },
            transition = {speed = 2, image = "coeurPixel.png"},
            destination = "final",
        },

        ["final"] = {
            type = "final",
            sound = "Ilona.mp3",
        },

}

return scenes
