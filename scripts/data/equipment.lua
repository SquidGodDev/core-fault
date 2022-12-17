import "scripts/level/player/equipment/beam"
import "scripts/level/player/equipment/shockProd"
import "scripts/level/player/equipment/peaShooter"
import "scripts/level/player/equipment/StaticField"
import "scripts/level/player/equipment/Discharge"

equipment = {
    shockProd = {
        name = "Shock Prod",
        description = "Periodically fires a shock horizontally, damaging nearby enemies",
        level = 1,
        maxLevel = 5,
        damage = 2,
        cooldown = 500,
        imagePath = "",
        constructor = ShockProd
    },
    beam = {
        name = "Beam",
        description = "Periodically fires a damaging beam in the direction the player is facing",
        level = 1,
        maxLevel = 5,
        damage = 2,
        cooldown = 1000,
        imagePath = "",
        constructor = Beam
    },
    peaShooter = {
        name = "Pea Shooter",
        description = "Fires bullets in the direction the player is facing",
        level = 1,
        maxLevel = 5,
        damage = 1,
        cooldown = 300,
        velocity = 6,
        imagePath = "",
        constructor = PeaShooter
    },
    staticField = {
        name = "Static Field",
        description = "Deals continuous damage in an area around the player",
        level = 1,
        maxLevel = 5,
        damage = 0.5,
        cooldown = 200,
        radius = 40,
        imagePath = "",
        constructor = StaticField
    },
    discharge = {
        name = "Discharge",
        description = "Periodically deals damage in an area around the player",
        level = 1,
        maxLevel = 5,
        damage = 3,
        cooldown = 1000,
        radius = 50,
        imagePath = "",
        constructor = Discharge
    }
}