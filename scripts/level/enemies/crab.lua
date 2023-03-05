import "scripts/level/enemies/enemy"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["crab"]

class('Crab').extends(Enemy)

function Crab:init(x, y, level)
    Crab.super.init(self, x, y, level, "crab")
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end