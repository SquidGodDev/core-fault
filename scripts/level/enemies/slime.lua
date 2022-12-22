import "scripts/level/enemies/enemy"

class('Slime').extends(Enemy)

function Slime:init(x, y, level)
    Slime.super.init(self, x, y, level, "images/enemies/crab-small-table-36-34")
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1
end