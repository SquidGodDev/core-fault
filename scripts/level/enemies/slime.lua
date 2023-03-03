import "scripts/level/enemies/enemy"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["slime"]

class('Slime').extends(Enemy)

function Slime:init(x, y, level, spriteSheetPath)
    if not spriteSheetPath then
        spriteSheetPath = "images/enemies/slime-small-table-36-34"
    end
    Slime.super.init(self, x, y, level, spriteSheetPath)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end