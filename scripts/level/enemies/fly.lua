import "scripts/level/enemies/enemy"
import "scripts/level/enemies/enemyProjectile"
import "scripts/data/enemyStats"

local stats <const> = enemyStats["fly"]

local pd <const> = playdate

class('Fly').extends(Enemy)

function Fly:init(x, y, level, spriteName, cooldown)
    if not spriteName then
        spriteName = "fly"
    end
    Fly.super.init(self, x, y, level, spriteName)
    self.attackCooldown = stats.attackCooldown
    self.attackDamage = stats.attackDamage
    self.health = stats.health
    self.maxVelocity = stats.velocity
    self.resistance = stats.resistance

    self.experience = stats.experience

    self.projectileDamage = stats.projectileDamage
    self.projectileDiameter = stats.projectileDiameter
    if not cooldown then
        self.projectileCooldown = stats.projectileCooldown
    else
        self.projectileCooldown = cooldown
    end
    self.projectileSpeed = stats.projectileSpeed

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
    self.projectileTimer:remove()
    Fly.super.die(self)
end
