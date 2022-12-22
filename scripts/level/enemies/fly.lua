import "scripts/level/enemies/enemy"

class('Fly').extends(Enemy)

function Fly:init(x, y, level)
    Fly.super.init(self, x, y, level, "images/enemies/fly-small-table-34-40")
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1
end