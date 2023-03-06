import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math
local sqrt <const> = math.sqrt
local random <const> = math.random
local kImageUnflipped <const> = gfx.kImageUnflipped
local kImageFlippedX <const> = gfx.kImageFlippedX
local sfxPlayer <const> = SfxPlayer

-- Enemy Consts
local invincibilityTime <const> = 100
local directionUpdateInterval <const> = 60
local dieTimerMax <const> = 20


local enemySprites <const> = {
    slime = gfx.imagetable.new("images/enemies/slime-small-table-36-34"),
    slimeMedium = gfx.imagetable.new("images/enemies/slime-medium-table-50-50"),
    crab = gfx.imagetable.new("images/enemies/crab-small-table-40-34"),
    crabMedium = gfx.imagetable.new("images/enemies/crab-medium-table-80-34"),
    fly = gfx.imagetable.new("images/enemies/fly-small-table-34-40"),
    flyMedium = gfx.imagetable.new("images/enemies/fly-medium-table-34-80")
}

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y, levelManager, spriteName)
    self.spritesheet = enemySprites[spriteName]
    self.animationLoopCount = 1
    self.animationFrameTime = 6
    self.animationFrame = 1
    self.maxAnimationFrame = self.spritesheet:getLength()
    self:setImage(self.spritesheet:getImage(1))
    self:add()

    -- Stats
    self.attackCooldown = 1000
    self.attackDamage = 2
    self.health = 4
    self.maxVelocity = 1

    self.experience = 10

    self.levelManager = levelManager

    self:setGroups(COLLISION_GROUPS.ENEMY)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "overlap"
    self:setTag(TAGS.ENEMY)

    self.playerTag = TAGS.PLAYER

    self.invincible = false

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0

    self.player = self.levelManager.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.randomMoveUpdateInterval = 40

    self.dieTimer = dieTimerMax

    self.imageFlip = kImageUnflipped

    self.attackOnCooldown = false

    self.dieSound = sfxPlayer("sfx-enemy-death")
    self.damageSound = sfxPlayer("sfx-enemy-damage")

    self.spriteWidth, self.spriteHeight = self:getSize()
end

function Enemy:update()
    local playerX, playerY = self.player.x, self.player.y
    local x, y = self.x, self.y

    if self.dieTimer < 0 then
        self:die()
        return
    end
    if y < playerY - (120 + self.spriteHeight)
        or y > playerY + (120 + self.spriteHeight)
        or x < playerX - (200 + self.spriteWidth)
        or x > playerX + (200 + self.spriteWidth)
    then
        self.dieTimer = self.dieTimer - 1
    else
        self.dieTimer = dieTimerMax
    end

    local curImageFlip <const> = self.imageFlip

    local animationLoopCount = self.animationLoopCount
    animationLoopCount = animationLoopCount % self.animationFrameTime + 1
    self.animationLoopCount = animationLoopCount
    if animationLoopCount == 1 then
        local animationFrame = self.animationFrame % self.maxAnimationFrame + 1
        self.animationFrame = animationFrame
        self:setImage(self.spritesheet:getImage(animationFrame), curImageFlip)
        self:setZIndex(y)
    end

    local xVelocity, yVelocity = self.xVelocity, self.yVelocity
    local directionUpdateCount <const> = self.directionUpdateCount
    if directionUpdateCount == 0 then
        local xDiff = playerX - x
        local yDiff = playerY - y

        local maxVelocity = self.maxVelocity
        if xDiff < 0 then
            xVelocity = -maxVelocity
        else
            xVelocity = maxVelocity
        end
        if yDiff < 0 then
            yVelocity = -maxVelocity
        else
            yVelocity = maxVelocity
        end
        -- local magnitude = sqrt(xDiff * xDiff + yDiff * yDiff)
        -- local scaledMagnitude = self.maxVelocity / magnitude
        -- xVelocity = xDiff * scaledMagnitude
        -- yVelocity = yDiff * scaledMagnitude

        if xVelocity < 0 and curImageFlip == kImageUnflipped then
            self.imageFlip = kImageFlippedX
        elseif xVelocity > 0 and curImageFlip == kImageFlippedX then
            self.imageFlip = kImageUnflipped
        end
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
        self.randomMoveUpdateInterval = random(30, 50)
    elseif directionUpdateCount == self.randomMoveUpdateInterval then
        local randomMoveAmount <const> = 3
        xVelocity = (random() - 0.5) * randomMoveAmount
        yVelocity = (random() - 0.5) * randomMoveAmount

        if xVelocity < 0 and curImageFlip == kImageUnflipped then
            self.imageFlip = kImageFlippedX
        elseif xVelocity > 0 and curImageFlip == kImageFlippedX then
            self.imageFlip = kImageUnflipped
        end
        self.xVelocity = xVelocity
        self.yVelocity = yVelocity
    end
    self.directionUpdateCount = (directionUpdateCount + 1) % directionUpdateInterval
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
    self.damageSound:play()
    self.health -= amount
    if self.health <= 0 then
        self:die()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    self.invincible = true
    pd.timer.new(invincibilityTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
        self.invincible = false
    end)
end

function Enemy:die()
    if self.health > 0 then
        self.levelManager:enemyDied(0)
    else
        self.dieSound:play()
        self.levelManager:enemyDied(self.experience)
    end
    self:remove()
end