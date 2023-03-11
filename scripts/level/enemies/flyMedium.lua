import "scripts/level/enemies/fly"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["flyMedium"]

class('FlyMedium').extends(Fly)

function FlyMedium:init(x, y, level)
    self.projectileCooldown = stats.projectileCooldown
    FlyMedium.super.init(self, x, y, level, "flyMedium", self.projectileCooldown)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity
    self.resistance = stats.resistance

    self.experience = stats.experience

    self.projectileDamage = stats.projectileDamage
    self.projectileDiameter = stats.projectileDiameter
    self.projectileSpeed = stats.projectileSpeed
end