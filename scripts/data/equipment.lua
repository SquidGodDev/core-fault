import "scripts/level/player/equipment/beam"
import "scripts/level/player/equipment/shockProd"
import "scripts/level/player/equipment/peaShooter"

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
    }
}