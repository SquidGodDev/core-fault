import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local directions = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}

local calculatedCosine = {}
local calculatedSine = {}
for i=0,360 do
    local angleInRadians = math.rad(i - 90)
    calculatedCosine[i] = math.cos(angleInRadians)
    calculatedSine[i] = math.sin(angleInRadians)
end

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

local getDrawOffset <const> = gfx.getDrawOffset
local setDrawOffset <const> = gfx.setDrawOffset

class('Player').extends(AnimatedSprite)

function Player:init(x, y)
    local playerSpriteSheet = gfx.imagetable.new("images/player/testPlayer-table-16-17")
    -- Player.super.init(self, playerSpriteSheet)

    -- for i, direction in ipairs(directions) do
    --     local baseIndex = 1 + (i - 1) * 4
    --     self:addState("run" .. direction, baseIndex, baseIndex + 3, {tickStep = 5})
    --     self:addState("idle" .. direction, baseIndex + 1, baseIndex + 1, {tickStep = 5})
    -- end

    -- self:playAnimation()

    self.animationLoop = gfx.animation.loop.new(200, playerSpriteSheet, true)
    self.startFrame = 1
    self.endFrame = 4
    self:setImage(self.animationLoop:image())
    self:add()

    self:setGroups(COLLISION_GROUPS.PLAYER)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "slide"

    self:setZIndex(Z_INDEXES.PLAYER)

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.MaxVelocity = 2

    self:moveTo(x, y)
end

function Player:update()
    local crankPos = pd.getCrankPosition()
    local dirIndex = math.floor((crankPos + 22.5) / 45) % 8 + 1
    local animationStartIndex = 1 + (dirIndex - 1) * 4
    self.animationLoop.startFrame = animationStartIndex
    self.animationLoop.endFrame = animationStartIndex + 3
    -- local direction = directions[dirIndex]
    -- self:changeState("run" .. direction)
    self:updateMovement(crankPos)

    local drawOffsetX, drawOffsetY = getDrawOffset()
    local targetOffsetX, targetOffsetY = -(self.x - 200), -(self.y - 120)
    local smoothSpeed = 0.06
    local smoothedX = lerp(drawOffsetX, targetOffsetX, smoothSpeed)
    local smoothedY = lerp(drawOffsetY, targetOffsetY, smoothSpeed)
    setDrawOffset(smoothedX, smoothedY)

    self:setImage(self.animationLoop:image())
    -- self:updateAnimation()
end

function Player:updateMovement(crankAngle)
    local angleCos = calculatedCosine[math.floor(crankAngle)]
    local angleSin = calculatedSine[math.floor(crankAngle)]
    local maxX = angleCos * self.MaxVelocity
    local maxY = angleSin * self.MaxVelocity
    self.xVelocity = maxX
    self.yVelocity = maxY
    self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
end

function Player:lerp(a, b, t)
    return a * (1-t) + b * t
end