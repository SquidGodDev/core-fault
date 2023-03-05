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
        name = "Damage",
        description = "Increases all damage by {} per level",
        level = 0, -- Current level
        maxLevel = 5, -- Maximum upgrade level
        value = 0.1, -- Base value
        scaling = 0.05, -- Increase amount per level
        -- max = .35
        percent = true, -- If the value should be interpreted as a percentage
        imagePath = "images/ui/upgradeIcons/iconUpgradeDamage", -- Path to upgrade image
        constructor = Damage
    },
    health = {
        name = "Health",
        description = "Increases health by {} per level",
        level = 0,
        maxLevel = 5,
        value = 10,
        scaling = 5,
        -- max = 35
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeHealth",
        constructor = Health
    },
    healthRegen = {
        name = "Health Regen",
        description = "Increases health regen by {} per level",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        -- max = 0.35
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeHealthRegen",
        constructor = HealthRegen
    },
    critChance = {
        name = "Crit Chance",
        description = "Increases crit chance by {} per level",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        -- max = 0.35
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeCritChance",
        constructor = CritChance
    },
    critDamage = {
        name = "Crit Damage",
        description = "Increases crit damage by {} per level",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        -- max = 0.35
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeCritDamage",
        constructor = CritDamage
    },
    moveSpeed = {
        name = "Move Speed",
        description = "Increases move speed by {} per level",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        -- max = 0.35
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeMoveSpeed",
        constructor = MoveSpeed
    },
    attackSpeed = {
        name = "Attack Speed",
        description = "Decreases attack cooldowns by {} per level",
        level = 0,
        maxLevel = 5,
        value = 0.02,
        scaling = 0.02,
        -- max = 0.12
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeAttackSpeed",
        constructor = AttackSpeed
    },
    piercing = {
        name = "Piercing",
        description = "Projectiles pass through {} more enemies per level",
        level = 0,
        maxLevel = 5,
        value = 1,
        scaling = 1,
        -- max = 6
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradePiercing",
        constructor = Piercing
    },
    restoration = {
        name = "Restoration",
        description = "Restore {} health between levels",
        level = 0,
        maxLevel = 5,
        value = 10,
        scaling = 10,
        -- max = 60
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeRestoration",
        constructor = Piercing
    }
}