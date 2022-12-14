import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math
local sqrt <const> = math.sqrt
local random <const> = math.random
local kImageUnflipped <const> = gfx.kImageUnflipped
local kImageFlippedX <const> = gfx.kImageFlippedX

class('TestEnemy').extends(gfx.sprite)

local enemySpriteSheet = {gfx.imagetable.new("images/enemies/slime-small"), gfx.imagetable.new("images/enemies/crab-small"), gfx.imagetable.new("images/enemies/fly-small")}

function TestEnemy:init(x, y, level)
    self.animationLoop = gfx.animation.loop.new(200, enemySpriteSheet[random(3)], true)
    self.startFrame = 1
    self.endFrame = 4
    self:setImage(self.animationLoop:image())
    self:add()

    self.level = level

    self:setGroups(COLLISION_GROUPS.ENEMY)
    -- self:setCollidesWithGroups({COLLISION_GROUPS.ENEMY, COLLISION_GROUPS.PLAYER})
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "overlap"
    self:setTag(TAGS.ENEMY)

    local width = self:getSize()
    self.width = width
    self.halfWidth = width / 2
    self.quarterWidth = width / 4

    self.playerTag = TAGS.PLAYER

    self.health = 4
    self.invincibilityTime = 100
    self.invincible = false

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.MaxVelocity = 1

    self.player = self.level.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.directionUpdateInterval = 60
    self.randomMoveUpdateInterval = 30

    self.randomMoveAmount = 3
    self.imageFlip = kImageUnflipped

    self.attackOnCooldown = false
    self.attackCooldown = 1000
    self.attackDamage = 2
end

function TestEnemy:update()
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
        local scaledMagnitude = self.MaxVelocity / magnitude
        self.xVelocity = xDiff * scaledMagnitude
        self.yVelocity = yDiff * scaledMagnitude
    elseif self.directionUpdateCount == self.randomMoveUpdateInterval then
        self.xVelocity = (random() - 0.5) * self.randomMoveAmount
        self.yVelocity = (random() - 0.5) * self.randomMoveAmount
    end
    self.directionUpdateCount = (self.directionUpdateCount + 1) % self.directionUpdateInterval
    -- self:moveWithCollisions(self.x + self.xVelocity + seperateX, self.y + self.yVelocity + seperateY)
    self:moveBy(self.xVelocity, self.yVelocity)
end

function TestEnemy:setAttackCooldown()
    self.attackOnCooldown = true
    pd.timer.new(self.attackCooldown, function()
        self.attackOnCooldown = false
    end)
end

function TestEnemy:canAttack()
    return not self.attackOnCooldown
end

function TestEnemy:damage(amount)
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