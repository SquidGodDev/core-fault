import "scripts/level/player/equipment/beam"
import "scripts/level/player/equipment/shockProd"
import "scripts/level/player/equipment/peaShooter"
import "scripts/level/player/equipment/StaticField"
import "scripts/level/player/equipment/Discharge"
import "scripts/level/player/equipment/SubterranianRocket"
import "scripts/level/player/equipment/Generator"

equipment = {
    shockProd = {
        name = "Shock Prod",
        description = "Periodically fires a shock horizontally, damaging nearby enemies",
        level = 1,
        damage = 1,
        cooldown = 1000,
        levelStats = {
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
        },
        imagePath = "",
        constructor = ShockProd
    },
    beam = {
        name = "Beam",
        description = "Periodically fires a damaging beam in the direction the player is facing",
        level = 1,
        damage = 2,
        cooldown = 2000,
        levelStats = {
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
        },
        imagePath = "",
        constructor = Beam
    },
    peaShooter = {
        name = "Pea Shooter",
        description = "Fires bullets in the direction the player is facing",
        level = 1,
        damage = 1,
        cooldown = 600,
        velocity = 6,
        levelStats = {
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
        },
        imagePath = "",
        constructor = PeaShooter
    },
    staticField = {
        name = "Static Field",
        description = "Deals continuous damage in an area around the player",
        level = 1,
        damage = 0.5,
        cooldown = 200,
        radius = 40,
        levelStats = {
            {radius = 5},
            {damage = 0.25},
            {radius = 5},
            {damage = 0.25},
            {radius = 5},
        },
        imagePath = "",
        constructor = StaticField
    },
    discharge = {
        name = "Discharge",
        description = "Discharges damage in an area around the player based on a percentage of damage taken recently",
        level = 1,
        damage = 2,
        bonusDamageScaling = 0.5,
        cooldown = 2000,
        radius = 50,
        levelStats = {
            {radius = 5},
            {cooldown = -100},
            {radius = 5},
            {cooldown = -100},
            {radius = 5},
        },
        imagePath = "",
        constructor = Discharge
    },
    subterranianRocket = {
        name = "Subterranian Rocket",
        description = "Periodically causes an explosion at a distance in front of the player",
        level = 1,
        damage = 4,
        cooldown = 1000,
        radius = 20,
        distance = 100,
        levelStats = {
            {radius = 5},
            {damage = 0.25},
            {cooldown = -200},
            {damage = 0.25},
            {radius = 5},
        },
        imagePath = "",
        constructor = SubterranianRocket
    },
    pocketDrill = {
        name = "Pocket Drill",
        description = "Passively drills and produces ore periodically",
        level = 1,
        cooldown = 3000,
        levelStats = {
            {cooldown = -100},
            {cooldown = -100},
            {cooldown = -100},
            {cooldown = -100},
            {cooldown = -100},
        },
        imagePath = "",
        constructor = PocketDrill
    },
    generator = {
        name = "Generator",
        description = "Every time the crank is rotated 360 degrees, fires out projectiles in all directions",
        level = 1,
        damage = 1,
        cooldown = 300,
        velocity = 6,
        projectileCount = 4,
        levelStats = {
            {damage = 0.25, projectileCount = 1},
            {damage = 0.25, projectileCount = 1},
            {damage = 0.25, projectileCount = 1},
            {damage = 0.25, projectileCount = 1},
            {damage = 0.25, projectileCount = 1},
        },
        imagePath = "",
        constructor = Generator
    }
}