import "scripts/level/enemies/enemy"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["slime"]

class('Slime').extends(Enemy)

function Slime:init(x, y, level, spriteName)
    if not spriteName then
        spriteName = "slime"
    end
    Slime.super.init(self, x, y, level, spriteName)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end