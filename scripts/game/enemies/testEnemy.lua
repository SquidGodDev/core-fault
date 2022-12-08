import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math
local sqrt <const> = math.sqrt

class('TestEnemy').extends(gfx.sprite)

function TestEnemy:init(x, y, gameManager, quadTree)
    local enemyImage = gfx.image.new("images/enemies/mandrake")
    self:setImage(enemyImage)
    self:add()

    self.gameManager = gameManager

    self:setGroups(COLLISION_GROUPS.ENEMY)
    -- self:setCollidesWithGroups({COLLISION_GROUPS.ENEMY, COLLISION_GROUPS.PLAYER})
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "overlap"

    local width = self:getSize()
    self.width = width
    self.halfWidth = width / 2
    self.quarterWidth = width / 4

    self.playerTag = TAGS.PLAYER

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.MaxVelocity = 1

    self.SeperateVelocity = 0.8

    self.player = self.gameManager.player

    self:moveTo(x, y)

    self.directionUpdateCount = 0
    self.directionUpdateInterval = 60
    self.interesectUpdateInterval = 20

    self.quadTree = quadTree
end

function TestEnemy:update()
    local seperateX, seperateY = 0, 0
    if self.directionUpdateCount == 0 then
        local xDiff = self.player.x - self.x
        local yDiff = self.player.y - self.y
        local magnitude = sqrt(xDiff^2 + yDiff^2)
        local scaledMagnitude = self.MaxVelocity / magnitude
        self.xVelocity = xDiff * scaledMagnitude
        self.yVelocity = yDiff * scaledMagnitude
    elseif self.directionUpdateCount % self.interesectUpdateInterval == 0 then
        local interesectingEnemy = self.quadTree:fastQuery(self.x - self.halfWidth, self.y - self.halfWidth, self.width, self.width, self)
        if interesectingEnemy then
            local intersectXDiff = self.x - interesectingEnemy.x
            local intersectYDiff = self.y - interesectingEnemy.y
            if intersectXDiff < 0 then
                self.xVelocity -= self.SeperateVelocity
            else
                self.xVelocity += self.SeperateVelocity
            end

            if intersectYDiff < 0 then
                self.yVelocity -= self.SeperateVelocity
            else
                self.yVelocity += self.SeperateVelocity
            end
        end
    end
    self.directionUpdateCount = (self.directionUpdateCount + 1) % self.directionUpdateInterval
    -- self:moveWithCollisions(self.x + self.xVelocity + seperateX, self.y + self.yVelocity + seperateY)
    self:moveBy(self.xVelocity + seperateX, self.yVelocity + seperateY)
end
