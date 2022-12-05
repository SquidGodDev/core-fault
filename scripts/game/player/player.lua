import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local directions = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}

math.lerp = function(a, b, t)
    return a * (1-t) + b * t
end

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
    local playerSpriteSheet = gfx.imagetable.new("images/player/testPlayer-table-16-17")
    Player.super.init(self, playerSpriteSheet)

    for i, direction in ipairs(directions) do
        local baseIndex = 1 + (i - 1) * 4
        self:addState("run" .. direction, baseIndex, baseIndex + 3, {tickStep = 5})
        self:addState("idle" .. direction, baseIndex + 1, baseIndex + 1, {tickStep = 5})
    end

    self:playAnimation()

    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "slide"

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.Acceleration = 0.1
    self.MaxVelocity = 2
    self.MaxVelocitySquared = self.MaxVelocity ^ 2

    self:moveTo(x, y)
end

function Player:update()
    local crankPos = pd.getCrankPosition()
    local dirIndex = math.floor((crankPos + 22.5) / 45) % 8 + 1
    local direction = directions[dirIndex]
    self:changeState("run" .. direction)
    self:updateMovement(crankPos)

    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    local targetOffsetX, targetOffsetY = -(self.x - 200), -(self.y - 120)
    local smoothSpeed = 0.1
    local smoothedX = math.lerp(drawOffsetX, targetOffsetX, smoothSpeed)
    local smoothedY = math.lerp(drawOffsetY, targetOffsetY, smoothSpeed)
    gfx.setDrawOffset(smoothedX, smoothedY)

    self:updateAnimation()
end

function Player:updateMovement(crankAngle)
    local angleInRadians = math.rad(crankAngle - 90)
    local angleCos = math.cos(angleInRadians)
    local angleSin = math.sin(angleInRadians)
    local maxX = angleCos * self.MaxVelocity
    local maxY = angleSin * self.MaxVelocity
    self.xVelocity = maxX
    self.yVelocity = maxY
    -- ACCELERATED MOVEMENT
    -- self.xVelocity += angleCos * self.Acceleration
    -- self.yVelocity += angleSin * self.Acceleration
    -- if math.abs(self.xVelocity) >= math.abs(maxX) then
    --     self.xVelocity = maxX
    -- end
    -- if math.abs(self.yVelocity) >= math.abs(maxY) then
    --     self.yVelocity = maxY
    -- end
    self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
end

function Player:lerp(a, b, t)
    return a * (1-t) + b * t
end