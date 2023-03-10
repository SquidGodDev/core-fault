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
        description = "Increases all damage by {}",
        level = 0, -- Current level
        maxLevel = 5, -- Maximum upgrade level
        value = 0.1, -- Base value
        scaling = 0.05, -- Increase amount per level
        percent = true, -- If the value should be interpreted as a percentage
        imagePath = "images/ui/upgradeIcons/iconUpgradeDamage", -- Path to upgrade image
        constructor = Damage
    },
    health = {
        name = "Health",
        description = "Max health increased by {}",
        level = 0,
        maxLevel = 5,
        value = 10,
        scaling = 5,
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeHealth",
        constructor = Health
    },
    healthRegen = {
        name = "Health Regen",
        description = "Restores {} health every 1/2 second",
        level = 0,
        maxLevel = 5,
        value = 0.25,
        scaling = 0.25,
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeHealthRegen",
        constructor = HealthRegen
    },
    critChance = {
        name = "Crit Chance",
        description = "Crit chance set to {}",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeCritChance",
        constructor = CritChance
    },
    critDamage = {
        name = "Crit Damage",
        description = "Crits deal 1{} damage",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeCritDamage",
        constructor = CritDamage
    },
    moveSpeed = {
        name = "Move Speed",
        description = "Move speed increased by {}",
        level = 0,
        maxLevel = 5,
        value = 0.1,
        scaling = 0.05,
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeMoveSpeed",
        constructor = MoveSpeed
    },
    attackSpeed = {
        name = "Attack Speed",
        description = "Decreases attack cooldowns by {}",
        level = 0,
        maxLevel = 5,
        value = 0.02,
        scaling = 0.02,
        percent = true,
        imagePath = "images/ui/upgradeIcons/iconUpgradeAttackSpeed",
        constructor = AttackSpeed
    },
    piercing = {
        name = "Piercing",
        description = "Projectiles pass through {} enemies",
        level = 0,
        maxLevel = 5,
        value = 1,
        scaling = 1,
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
        percent = false,
        imagePath = "images/ui/upgradeIcons/iconUpgradeRestoration",
        constructor = Piercing
    }
}