import "scripts/level/enemies/enemy"

class('Slime').extends(Enemy)

function Slime:init(x, y, level, spriteSheetPath)
    if not spriteSheetPath then
        spriteSheetPath = "images/enemies/slime-small-table-36-34"
    end
    Slime.super.init(self, x, y, level, spriteSheetPath)
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1
end