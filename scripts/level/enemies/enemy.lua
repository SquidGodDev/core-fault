import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math
local sqrt <const> = math.sqrt
local random <const> = math.random
local kImageUnflipped <const> = gfx.kImageUnflipped
local kImageFlippedX <const> = gfx.kImageFlippedX

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y, level, spritesheetPath)
    local spritesheet = gfx.imagetable.new(spritesheetPath)
    self.animationLoop = gfx.animation.loop.new(200, spritesheet, true)
    self:setImage(self.animationLoop:image())
    self:add()

    -- Stats
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1

    self.level = level

    self:setGroups(COLLISION_GROUPS.ENEMY)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "overlap"
    self:setTag(TAGS.ENEMY)

    self.playerTag = TAGS.PLAYER

    self.invincibilityTime = 100
    self.invincible = false

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0

    self.player = self.level.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.directionUpdateInterval = 60
    self.randomMoveUpdateInterval = 30

    self.randomMoveAmount = 3
    self.imageFlip = kImageUnflipped

    self.attackOnCooldown = false
end

function Enemy:update()
    self:setImage(self.animationLoop:image(), self.imageFlip)
    if self.directionUpdateCount == 0 then
        if self.xVelocity < 0 and self.imageFlip == kImageUnflipped then
            self.imageFlip = kImageFlippedX
        elseif self.xVelocity > 0 and self.imageFlip == kImageFlippedX then
            self.imageFlip = kImageUnflipped
        end
        local xDiff = self.player.x - self.x
        local yDiff = self.player.y - self.y
        local magnitude = sqrt(xDiff^2 + yDiff^2)
        local scaledMagnitude = self.maxVelocity / magnitude
        self.xVelocity = xDiff * scaledMagnitude
        self.yVelocity = yDiff * scaledMagnitude
    elseif self.directionUpdateCount == self.randomMoveUpdateInterval then
        self.xVelocity = (random() - 0.5) * self.randomMoveAmount
        self.yVelocity = (random() - 0.5) * self.randomMoveAmount
    end
    self.directionUpdateCount = (self.directionUpdateCount + 1) % self.directionUpdateInterval
    self:moveBy(self.xVelocity, self.yVelocity)
end

function Enemy:setAttackCooldown()
    self.attackOnCooldown = true
    pd.timer.new(self.attackCooldown, function()
        self.attackOnCooldown = false
    end)
end

function Enemy:canAttack()
    return not self.attackOnCooldown
end

function Enemy:damage(amount)
    if self.invincible then
        return
    end
    self.health -= amount
    if self.health <= 0 then
        self.level:enemyDied()
        self:remove()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    self.invincible = true
    pd.timer.new(self.invincibilityTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
        self.invincible = false
    end)
end