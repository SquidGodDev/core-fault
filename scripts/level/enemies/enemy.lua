import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math
local sqrt <const> = math.sqrt
local random <const> = math.random
local kImageUnflipped <const> = gfx.kImageUnflipped
local kImageFlippedX <const> = gfx.kImageFlippedX

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y, levelManager, spritesheetPath)
    local spritesheet = gfx.imagetable.new(spritesheetPath)
    self.animationLoop = gfx.animation.loop.new(200, spritesheet, true)
    self:setImage(self.animationLoop:image())
    self:add()

    -- Stats
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1

    self.levelManager = levelManager

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

    self.player = self.levelManager.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.directionUpdateInterval = 60
    self.randomMoveUpdateInterval = 30

    self.imageFlip = kImageUnflipped

    self.attackOnCooldown = false
end

function Enemy:update()
    self:setImage(self.animationLoop:image(), self.imageFlip)
    local xVelocity, yVelocity = self.xVelocity, self.yVelocity
    local directionUpdateCount <const> = self.directionUpdateCount
    if directionUpdateCount == 0 then
        local player = self.player
        local xDiff = player.x - self.x
        local yDiff = player.y - self.y
        local magnitude = sqrt(xDiff * xDiff + yDiff * yDiff)
        local scaledMagnitude = self.maxVelocity / magnitude
        xVelocity = xDiff * scaledMagnitude
        yVelocity = yDiff * scaledMagnitude

        local curImageFlip <const> = self.imageFlip
        if xVelocity < 0 and curImageFlip == kImageUnflipped then
            self.imageFlip = kImageFlippedX
        elseif xVelocity > 0 and curImageFlip == kImageFlippedX then
            self.imageFlip = kImageUnflipped
        end
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
    elseif directionUpdateCount == self.randomMoveUpdateInterval then
        local randomMoveAmount <const> = 3
        xVelocity = (random() - 0.5) * randomMoveAmount
        yVelocity = (random() - 0.5) * randomMoveAmount

        local curImageFlip <const> = self.imageFlip
        if xVelocity < 0 and curImageFlip == kImageUnflipped then
            self.imageFlip = kImageFlippedX
        elseif xVelocity > 0 and curImageFlip == kImageFlippedX then
            self.imageFlip = kImageUnflipped
        end
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
    end
    self.directionUpdateCount = (directionUpdateCount + 1) % self.directionUpdateInterval
    self:moveBy(xVelocity, yVelocity)
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
        self.levelManager:enemyDied()
        self:remove()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    self.invincible = true
    pd.timer.new(self.invincibilityTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
        self.invincible = false
    end)
end