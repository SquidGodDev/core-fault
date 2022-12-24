import "scripts/level/player/upgrades/attackSpeed"
import "scripts/level/player/upgrades/critChance"
import "scripts/level/player/upgrades/critDamage"
import "scripts/level/player/upgrades/damage"
import "scripts/level/player/upgrades/health"
import "scripts/level/player/upgrades/healthRegen"
import "scripts/level/player/upgrades/moveSpeed"
import "scripts/level/player/upgrades/piercing"

-- Use {} in description where value should be inserted

upgrades = {
    damage = {
        description = "Increases all damage by {}",
        level = 1, -- Current level
        maxLevel = 3, -- Maximum upgrade level
        value = 2, -- Base value
        scaling = 1, -- Increase amount per level
        percent = false, -- If the value should be interpreted as a percentage
        imagePath = "", -- Path to upgrade image
        constructor = Damage
    },
    health = {
        description = "Increases health by {}",
        level = 1,
        maxLevel = 3,
        value = 10,
        scaling = 10,
        percent = false,
        imagePath = "",
        constructor = Health
    },
    healthRegen = {
        description = "Increases health regen by {}",
        level = 1,
        maxLevel = 3,
        value = 0.1,
        scaling = 0.2,
        percent = false,
        imagePath = "",
        constructor = HealthRegen
    },
    critChance = {
        description = "Increases crit chance by {}",
        level = 1,
        maxLevel = 3,
        value = 0.1,
        scaling = 0.1,
        percent = true,
        imagePath = "",
        constructor = CritChance
    },
    critDamage = {
        description = "Increases crit damage by {}",
        level = 1,
        maxLevel = 3,
        value = 0.1,
        scaling = 0.1,
        percent = true,
        imagePath = "",
        constructor = CritDamage
    },
    moveSpeed = {
        description = "Increases move speed by {}",
        level = 1,
        maxLevel = 3,
        value = 0.1,
        scaling = 0.1,
        percent = true,
        imagePath = "",
        constructor = MoveSpeed
    },
    attackSpeed = {
        description = "Increases attack speed by {}",
        level = 1,
        maxLevel = 3,
        value = 0.1,
        scaling = 0.1,
        percent = true,
        imagePath = "",
        constructor = AttackSpeed
    },
    piercing = {
        description = "Projectiles pass through {} more enemies",
        level = 1,
        maxLevel = 5,
        value = 1,
        scaling = 1,
        imagePath = "",
        constructor = Piercing
    }
}