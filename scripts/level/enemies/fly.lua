import "scripts/level/enemies/enemy"
import "scripts/level/enemies/enemyProjectile"

local pd <const> = playdate

class('Fly').extends(Enemy)

function Fly:init(x, y, level, spriteSheetPath, cooldown)
    if not spriteSheetPath then
        spriteSheetPath = "images/enemies/fly-small-table-34-40"
    end
    Fly.super.init(self, x, y, level, spriteSheetPath)
    self.attackCooldown = 1000
    self.attackDamage = 1
    self.health = 4
    self.maxVelocity = 1

    self.experience = 4

    self.projectileDamage = 1
    self.projectileDiameter = 8
    if not cooldown then
        self.projectileCooldown = 6000
    else
        self.projectileCooldown = cooldown
    end
    self.projectileSpeed = 2

    self.player = level.player

    self.projectileTimer = pd.timer.new(self.projectileCooldown, function()
        local xDiff = self.player.x - self.x
        local yDiff = self.player.y - self.y
        local magnitude = math.sqrt(xDiff^2 + yDiff^2)
        if magnitude ~= 0 then
            local speedMultiplier = self.projectileSpeed / magnitude
            local xVelocity, yVelocity = xDiff * speedMultiplier, yDiff * speedMultiplier
            EnemyProjectile(self.x, self.y, xVelocity, yVelocity, self.projectileDamage, self.projectileDiameter, self.player)
        end
    end)
    self.projectileTimer.repeats = true
end

function Fly:die()
    Fly.super.die(self)
    self.projectileTimer:remove()
end
