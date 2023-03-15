import "scripts/level/enemies/crab"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["crabMedium"]

class('CrabMedium').extends(Crab)

function CrabMedium:init(x, y, level)
    CrabMedium.super.init(self, x, y, level, "crabMedium")
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity
    self.resistance = stats.resistance

    self.experience = stats.experience
end