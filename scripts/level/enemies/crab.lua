import "scripts/level/enemies/enemy"

class('Crab').extends(Enemy)

function Crab:init(x, y, level)
    Crab.super.init(self, x, y, level, "images/enemies/crab-small-table-40-34")
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1
end