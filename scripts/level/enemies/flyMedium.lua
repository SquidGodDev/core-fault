import "scripts/level/enemies/fly"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["flyMedium"]

class('FlyMedium').extends(Fly)

function FlyMedium:init(x, y, level)
    self.projectileCooldown = stats.projectileCooldown
    FlyMedium.super.init(self, x, y, level, "images/enemies/fly-medium-table-34-80", self.projectileCooldown)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience

    self.projectileDamage = stats.projectileDamage
    self.projectileDiameter = stats.projectileDiameter
    self.projectileSpeed = stats.projectileSpeed
end