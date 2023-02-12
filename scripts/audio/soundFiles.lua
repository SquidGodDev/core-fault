local sfxPath <const> = "audio/sfx/"
local sampleplayer <const> = playdate.sound.sampleplayer.new
local sp <const> = function(path)
    return sampleplayer(sfxPath..path)
end

soundFiles = {
    ["sfx-beam"] = {
        files = {
            sp("sfx-beam-1"),
            sp("sfx-beam-2"),
            sp("sfx-beam-3"),
            sp("sfx-beam-4")
        },
        level = 1.0
    },
    ["sfx-core-collect"] = {
        files = {
            sp("sfx-core-collect-1"),
            sp("sfx-core-collect-2"),
            sp("sfx-core-collect-3"),
            sp("sfx-core-collect-4")
        },
        level = 1.0
    },
    ["sfx-core-damage"] = {
        files = {
            sp("sfx-core-damage-1"),
            sp("sfx-core-damage-2"),
            sp("sfx-core-damage-3"),
            sp("sfx-core-damage-4")
        },
        level = 1.0
    },
    ["sfx-discharge"] = {
        files = {
            sp("sfx-discharge-1"),
            sp("sfx-discharge-2"),
            sp("sfx-discharge-3"),
            sp("sfx-discharge-4")
        },
        level = 1.0
    },
    ["sfx-enemy-damage"] = {
        files = {
            sp("sfx-enemy-damage-1"),
            sp("sfx-enemy-damage-2"),
            sp("sfx-enemy-damage-3"),
            sp("sfx-enemy-damage-4")
        },
        level = 1.0
    },
    ["sfx-enemy-death"] = {
        files = {
            sp("sfx-enemy-death-1"),
            sp("sfx-enemy-death-2"),
            sp("sfx-enemy-death-3"),
            sp("sfx-enemy-death-4")
        },
        level = 1.0
    },
    ["sfx-menu-back"] = {
        files = {
            sp("sfx-menu-back")
        },
        level = 1.0
    },
    ["sfx-menu-move"] = {
        files = {
            sp("sfx-menu-move")
        },
        level = 1.0
    },
    ["sfx-menu-select"] = {
        files = {
            sp("sfx-menu-select")
        },
        level = 1.0
    },
    ["sfx-pea-shooter"] = {
        files = {
            sp("sfx-pea-shooter-1"),
            sp("sfx-pea-shooter-2"),
            sp("sfx-pea-shooter-3"),
            sp("sfx-pea-shooter-4")
        },
        level = 1.0
    },
    ["sfx-plasma-cannon"] = {
        files = {
            sp("sfx-plasma-cannon-1"),
            sp("sfx-plasma-cannon-2"),
            sp("sfx-plasma-cannon-3"),
            sp("sfx-plasma-cannon-4")
        },
        level = 1.0
    },
    ["sfx-player-damage"] = {
        files = {
            sp("sfx-player-damage-1"),
            sp("sfx-player-damage-2"),
            sp("sfx-player-damage-3"),
            sp("sfx-player-damage-4")
        },
        level = 1.0
    },
    ["sfx-player-death"] = {
        files = {
            sp("sfx-player-death")
        },
        level = 1.0
    },
    ["sfx-player-dig"] = {
        files = {
            sp("sfx-player-dig")
        },
        level = 1.0
    },
    ["sfx-player-power-down"] = {
        files = {
            sp("sfx-player-power-down")
        },
        level = 1.0
    },
    ["sfx-pocket-drill"] = {
        files = {
            sp("sfx-pocket-drill-1"),
            sp("sfx-pocket-drill-2"),
            sp("sfx-pocket-drill-3"),
            sp("sfx-pocket-drill-4")
        },
        level = 1.0
    },
    ["sfx-radio-waves"] = {
        files = {
            sp("sfx-radio-waves-1"),
            sp("sfx-radio-waves-2"),
            sp("sfx-radio-waves-3"),
            sp("sfx-radio-waves-4")
        },
        level = 1.0
    },
    ["sfx-shock-prod"] = {
        files = {
            sp("sfx-shock-prod-1"),
            sp("sfx-shock-prod-2"),
            sp("sfx-shock-prod-3"),
            sp("sfx-shock-prod-4")
        },
        level = 1.0
    },
    ["sfx-startup"] = {
        files = {
            sp("sfx-startup")
        },
        level = 1.0
    },
    ["sfx-static-field"] = {
        files = {
            sp("sfx-static-field-1"),
            sp("sfx-static-field-2"),
            sp("sfx-static-field-3"),
            sp("sfx-static-field-4")
        },
        level = 1.0
    },
    ["sfx-sub-rocket"] = {
        files = {
            sp("sfx-sub-rocket-1"),
            sp("sfx-sub-rocket-2"),
            sp("sfx-sub-rocket-3"),
            sp("sfx-sub-rocket-4")
        },
        level = 1.0
    },
    ["sfx-typing"] = {
        files = {
            sp("sfx-typing")
        },
        level = 1.0
    },
    ["time-warning"] = {
        files = {
            sp("time-warning")
        },
        level = 1.0
    },
}