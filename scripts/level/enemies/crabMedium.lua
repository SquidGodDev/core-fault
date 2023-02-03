import "scripts/level/enemies/crab"

class('CrabMedium').extends(Crab)

function CrabMedium:init(x, y, level)
    CrabMedium.super.init(self, x, y, level, "images/enemies/crab-medium-table-80-34")
    self.attackCooldown = 1000
    self.attackDamage = 6
    self.health = 10
    self.maxVelocity = 0.6

    self.experience = 7
end