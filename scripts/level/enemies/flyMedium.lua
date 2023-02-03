import "scripts/level/enemies/fly"

class('FlyMedium').extends(Fly)

function FlyMedium:init(x, y, level)
    self.projectileCooldown = 4000
    FlyMedium.super.init(self, x, y, level, "images/enemies/fly-medium-table-34-80", self.projectileCooldown)
    self.attackCooldown = 1000
    self.attackDamage = 1
    self.health = 6
    self.maxVelocity = 1

    self.experience = 8

    self.projectileDamage = 2
    self.projectileDiameter = 8
    self.projectileSpeed = 3
end