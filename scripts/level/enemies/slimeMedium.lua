import "scripts/level/enemies/slime"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["slimeMedium"]

class('SlimeMedium').extends(Slime)

function SlimeMedium:init(x, y, level)
    SlimeMedium.super.init(self, x, y, level, "slimeMedium")
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end