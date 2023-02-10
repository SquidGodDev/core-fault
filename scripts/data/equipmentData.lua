import "scripts/level/player/equipment/beam"
import "scripts/level/player/equipment/shockProd"
import "scripts/level/player/equipment/peaShooter"
import "scripts/level/player/equipment/staticField"
import "scripts/level/player/equipment/discharge"
import "scripts/level/player/equipment/subterraneanRocket"
import "scripts/level/player/equipment/radioWaves"
import "scripts/level/player/equipment/plasmaCannon"
import "scripts/level/player/equipment/pocketDrill"

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
        imagePath = "images/ui/equipmentIcons/iconShockProd",
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
        imagePath = "images/ui/equipmentIcons/iconBeam",
        constructor = Beam
    },
    peaShooter = {
        name = "Pea Shooter",
        description = "Fires bullets in the direction the player is facing",
        level = 1,
        damage = 1,
        cooldown = 400,
        velocity = 6,
        levelStats = {
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
            {damage = 0.25, cooldown = -50},
        },
        imagePath = "images/ui/equipmentIcons/iconPeaShooter",
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
        imagePath = "images/ui/equipmentIcons/iconStaticField",
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
        imagePath = "images/ui/equipmentIcons/iconDischarge",
        constructor = Discharge
    },
    subterraneanRocket = {
        name = "Subterranean Rocket",
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
        imagePath = "images/ui/equipmentIcons/iconSubterraneanRocket",
        constructor = SubterraneanRocket
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
        imagePath = "images/ui/equipmentIcons/iconPocketDrill",
        constructor = PocketDrill
    },
    radioWaves = {
        name = "Radio Waves",
        description = "Periodically shoots out a ring of projectiles",
        level = 1,
        damage = 1,
        cooldown = 2000,
        velocity = 6,
        projectileCount = 12,
        levelStats = {
            {cooldown = -200},
            {cooldown = -200},
            {cooldown = -200},
            {cooldown = -200},
            {cooldown = -200},
        },
        imagePath = "images/ui/equipmentIcons/iconRadioWaves",
        constructor = RadioWaves
    },
    plasmaCannon = {
        name = "Plasma Cannon",
        description = "Fires a large bullet in the direction the player is facing",
        level = 1,
        damage = 4,
        cooldown = 1500,
        velocity = 3,
        levelStats = {
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
            {damage = 0.25, cooldown = -100},
        },
        imagePath = "images/ui/equipmentIcons/iconPlasmaCannon",
        constructor = PlasmaCannon
    },
}