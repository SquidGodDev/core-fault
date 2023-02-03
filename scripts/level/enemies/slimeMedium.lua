import "scripts/level/enemies/slime"

class('SlimeMedium').extends(Slime)

function SlimeMedium:init(x, y, level)
    SlimeMedium.super.init(self, x, y, level, "images/enemies/slime-medium-table-50-50")
    self.attackCooldown = 1000
    self.attackDamage = 4
    self.health = 6
    self.maxVelocity = 1

    self.experience = 6
end