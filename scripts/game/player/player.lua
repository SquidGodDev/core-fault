import "scripts/libraries/AnimatedSprite"
import "scripts/game/player/weapons/beam"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local floor <const> = math.floor
local getCrankPosition <const> = pd.getCrankPosition

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
    self:setTag(TAGS.PLAYER)

    self:setZIndex(Z_INDEXES.PLAYER)

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0
    self.MaxVelocity = 2

    self:moveTo(x, y)

    self.prevDirIndex = -1

    Beam(self)
end

function Player:update()
    local crankPos = getCrankPosition()
    local dirIndex = floor((crankPos + 22.5) / 45) % 8 + 1
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
    local angleCos = calculatedCosine[floor(crankAngle)]
    local angleSin = calculatedSine[floor(crankAngle)]
    local maxX = angleCos * self.MaxVelocity
    local maxY = angleSin * self.MaxVelocity
    self.xVelocity = maxX
    self.yVelocity = maxY
    self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
end

function Player:lerp(a, b, t)
    return a * (1-t) + b * t
end