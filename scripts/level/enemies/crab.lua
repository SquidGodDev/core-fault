import "scripts/level/enemies/enemy"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["crab"]

class('Crab').extends(Enemy)

function Crab:init(x, y, level, spriteSheetPath)
    if not spriteSheetPath then
        spriteSheetPath = "images/enemies/crab-small-table-40-34"
    end
    Crab.super.init(self, x, y, level, spriteSheetPath)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity

    self.experience = stats.experience
end