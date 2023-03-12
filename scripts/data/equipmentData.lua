import "scripts/level/player/equipment/beam"
import "scripts/level/player/equipment/shockProd"
import "scripts/level/player/equipment/peaShooter"
import "scripts/level/player/equipment/staticField"
import "scripts/level/player/equipment/discharge"
import "scripts/level/player/equipment/subterraneanRocket"
import "scripts/level/player/equipment/radioWaves"
import "scripts/level/player/equipment/plasmaCannon"
import "scripts/level/player/equipment/pocketDrill"
import "scripts/level/player/equipment/overdrive"

equipment = {
    shockProd = {
        name = "Shock Prod",
        description = "Periodically fires a shock horizontally, damaging nearby enemies",
        level = 1,
        damage = 15,
        cooldown = 700,
        hitStun = 10,
        levelStats = {
            {damage = 6, hitStun = 2},
            {damage = 3, cooldown = -200, hitStun = 2},
            {damage = 6, hitStun = 4},
            {damage = 3, cooldown = -200, hitStun = 2},
            {damage = 6, cooldown = -100, hitStun = 5},
        },
        imagePath = "images/ui/equipmentIcons/iconShockProd",
        constructor = ShockProd
    },
    beam = {
        name = "Beam",
        description = "Periodically fires a damaging beam around the player",
        level = 1,
        damage = 20,
        cooldown = 1500,
        length = 96,
        hitStun = 10,
        levelStats = {
            {cooldown = -200, length = 24, hitStun = 2},
            {damage = 6, length = 12, hitStun = 2},
            {damage = 10, cooldown = -200, hitStun = 4},
            {damage = 6, cooldown = -300, length = 16, hitStun = 2},
            {damage = 10, cooldown = -200, length = 24, hitStun = 4},
        },
        imagePath = "images/ui/equipmentIcons/iconBeam",
        constructor = Beam
    },
    peaShooter = {
        name = "Pea Shooter",
        description = "Fires small bullets from behind",
        level = 1,
        damage = 16,
        cooldown = 400,
        velocity = 6,
        hitStun = 3,
        levelStats = {
            {damage = 4},
            {velocity = 1, hitStun = 2},
            {damage = 6, hitStun = 4},
            {damage = 2, velocity = 1},
            {damage = 4, velocity = 1, hitStun = 4},
        },
        imagePath = "images/ui/equipmentIcons/iconPeaShooter",
        constructor = PeaShooter
    },
    staticField = {
        name = "Static Field",
        description = "Deals continuous damage in an area around the player",
        level = 1,
        damage = 3,
        cooldown = 400,
        radius = 40,
        hitStun = 2,
        levelStats = {
            {radius = 16},
            {damage = 6},
            {radius = 24},
            {damage = 6},
            {radius = 24, damage = 6},
        },
        imagePath = "images/ui/equipmentIcons/iconStaticField",
        constructor = StaticField
    },
    -- discharge = {
    --     name = "Discharge",
    --     description = "Discharges damage in an area around the player based on a percentage of damage taken recently",
    --     level = 1,
    --     damage = 10,
    --     bonusDamageScaling = 0.5,
    --     cooldown = 2000,
    --     radius = 50,
    --     levelStats = {
    --         {radius = 5},
    --         {damage = 4, cooldown = -100},
    --         {radius = 8, cooldown = -100},
    --         {damage = 10, cooldown = -200},
    --         {damage = 6, cooldown = -100, radius = 12},
    --     },
    --     imagePath = "images/ui/equipmentIcons/iconDischarge",
    --     constructor = Discharge
    -- },
    subterraneanRocket = {
        name = "Subterranean Rocket",
        description = "Periodically causes an explosion at a distance circling the player",
        level = 1,
        damage = 16,
        cooldown = 1000,
        radius = 16,
        distance = 100,
        hitStun = 20,
        levelStats = {
            {damage = 6, radius = 8},
            {damage = 6, cooldown = -100, hitStun = 2},
            {radius = 12, cooldown = -200, hitStun = 4},
            {damage = 6, hitStun = 2},
            {damage = 6, cooldown = -200, radius = 16, hitStun = 6},
        },
        imagePath = "images/ui/equipmentIcons/iconSubterraneanRocket",
        constructor = SubterraneanRocket
    },
    pocketDrill = {
        name = "Pocket Drill",
        description = "Passively drills and produces ore periodically",
        level = 1,
        cooldown = 4500,
        levelStats = {
            {cooldown = -100},
            {cooldown = -200},
            {cooldown = -300},
            {cooldown = -400},
            {cooldown = -500},
        },
        imagePath = "images/ui/equipmentIcons/iconPocketDrill",
        constructor = PocketDrill
    },
    radioWaves = {
        name = "Radio Waves",
        description = "Periodically shoots out a ring of projectiles",
        level = 1,
        damage = 10,
        cooldown = 2000,
        velocity = 6,
        projectileCount = 4,
        hitStun = 5,
        levelStats = {
            {damage = 6, projectileCount = 2},
            {velocity = 1},
            {damage = 4, projectileCount = 2, hitStun = 2},
            {velocity = 1, hitStun = 2},
            {damage = 10, velocity = 1, hitStun = 6},
        },
        imagePath = "images/ui/equipmentIcons/iconRadioWaves",
        constructor = RadioWaves
    },
    plasmaCannon = {
        name = "Plasma Cannon",
        description = "Fires a large bullet in the direction the player is facing",
        level = 1,
        damage = 48,
        cooldown = 1500,
        velocity = 3,
        hitStun = 30,
        size = 15,
        levelStats = {
            {damage = 6},
            {velocity = 1, cooldown = -200},
            {damage = 12, hitStun = 2},
            {velocity = 1, cooldown = -200, hitStun = 4},
            {damage = 6, velocity = 1, cooldown = -200, hitStun = 6},
        },
        imagePath = "images/ui/equipmentIcons/iconPlasmaCannon",
        constructor = PlasmaCannon
    },
    overdrive = {
        name = "Overdrive",
        description = "Periodically causes player to rush forward, damaging nearby enemies",
        level = 1,
        damage = 20,
        velocity = 4,
        cooldown = 2000,
        duration = 600,
        levelStats = {
            {damage = 4},
            {damage = 4},
            {damage = 4},
            {damage = 4},
            {damage = 4},
        },
        imagePath = "images/ui/equipmentIcons/iconOverdrive",
        constructor = Overdrive
    }
}