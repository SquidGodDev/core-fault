import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

math.fastInvSqrt = function(x)
    local i = 0.5 * x * 2^(-1.5)
    x = 2^(-0.5) * (1.5 - x * i * i)
    return x
end

class('TestEnemy').extends(AnimatedSprite)

function TestEnemy:init(x, y, gameManager)
    local enemyImage = gfx.image.new("images/enemies/mandrake")
    self:setImage(enemyImage)
    self:add()

    self.gameManager = gameManager
    -- local enemySpriteSheet = gfx.imagetable.new("images/enemies/mandrake-table-18-17")
    -- TestEnemy.super.init(self, enemySpriteSheet)
    -- self:playAnimation()

    self:setGroups(COLLISION_GROUPS.ENEMY)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "slide"

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.MaxVelocity = 1

    self.player = self.gameManager.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.directionUpdateInterval = 60
end

function TestEnemy:update()
    if self.directionUpdateCount == 0 then
        local xDiff = self.player.x - self.x
        local yDiff = self.player.y - self.y
        local magnitude = math.sqrt(xDiff^2 + yDiff^2)
        local scaledMagnitude = self.MaxVelocity / magnitude
        self.xVelocity = xDiff * scaledMagnitude
        self.yVelocity = yDiff * scaledMagnitude
    end
    self.directionUpdateCount = (self.directionUpdateCount + 1) % self.directionUpdateInterval
    -- self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    self:moveBy(self.xVelocity, self.yVelocity)
    -- self:updateAnimation()
end
