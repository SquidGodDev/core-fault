import "scripts/level/enemies/enemy"

class('Crab').extends(Enemy)

function Crab:init(x, y, level, spriteSheetPath)
    if not spriteSheetPath then
        spriteSheetPath = "images/enemies/crab-small-table-40-34"
    end
    Crab.super.init(self, x, y, level, spriteSheetPath)
    self.attackCooldown = 1000
    self.attackDamage = 4
    self.health = 6
    self.maxVelocity = 0.6
end