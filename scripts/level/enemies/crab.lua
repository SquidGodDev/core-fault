import "scripts/level/enemies/enemy"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["crab"]

class('Crab').extends(Enemy)

function Crab:init(x, y, level, spriteName)
    if not spriteName then
        spriteName = "crab"
    end
    Crab.super.init(self, x, y, level, spriteName)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end