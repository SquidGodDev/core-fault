import "scripts/libraries/AnimatedSprite"
import "scripts/level/player/healthbar"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local floor <const> = math.floor
local getCrankPosition <const> = pd.getCrankPosition

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

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

-- Screen Shake
local setDisplayOffset <const> = pd.display.setOffset
local random <const> = math.random

class('Player').extends(gfx.sprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    -- Player Stats
    self.MaxVelocity = 2
    self.MaxHealth = 100
    self.HealthRegen = 0
    self.CritChance = 0.1
    self.CritDamage = 1.5
    self.AttackSpeed = 1
    self.BonusDamage = 0

    self.healthbar = Healthbar(self.MaxHealth, self)
    self.flashTime = 100

    self:initializeUpgrades()
    self:initializeEquipment()

    local playerSpriteSheet = gfx.imagetable.new("images/player/player")

    self.animationLoop = gfx.animation.loop.new(200, playerSpriteSheet, true)
    self.startFrame = 1
    self.endFrame = 2
    self:setImage(self.animationLoop:image())
    self:add()

    self:setZIndex(Z_INDEXES.PLAYER)

    self.velocity = 0
    self.xVelocity = 0
    self.yVelocity = 0

    self:moveTo(x, y)

    -- Hitbox/Collisions
    self:setGroups(COLLISION_GROUPS.PLAYER)
    self:setCollidesWithGroups(COLLISION_GROUPS.WALL)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "slide"
    self:setTag(TAGS.PLAYER)

    local playerWidth, playerHeight = self:getSize()
    local hurtboxBuffer = 4
    self.hurtboxWidth = playerWidth - hurtboxBuffer * 2
    self.hurtboxHeight = playerHeight - hurtboxBuffer * 2
    self.hurtboxHalfWidth = playerWidth / 2 - hurtboxBuffer
    self.hurtboxHalfHeight = playerHeight / 2 - hurtboxBuffer

    self.enemyTag = TAGS.ENEMY

    -- Screen Shake
    self.shakeTimer = nil
    self.shakeAmount = 4
end

function Player:update()
    -- Check if being damaged by enemies
    local hurtboxX = self.x - self.hurtboxHalfWidth
    local hurtboxY = self.y - self.hurtboxHalfHeight
    local overlappingSprites = querySpritesInRect(hurtboxX, hurtboxY, self.hurtboxWidth, self.hurtboxHeight)
    for i=1, #overlappingSprites do
        local enemy = overlappingSprites[i]
        if enemy:getTag() == self.enemyTag and enemy:canAttack() then
            self:damage(enemy.attackDamage)
            enemy:setAttackCooldown()
        end
    end

    local crankPos = getCrankPosition()
    local dirIndex = floor((crankPos + 22.5) / 45) % 8 + 1
    local animationStartIndex = 1 + (dirIndex - 1) * 2
    self.animationLoop.startFrame = animationStartIndex
    self.animationLoop.endFrame = animationStartIndex + 1
    self:updateMovement(crankPos)

    local drawOffsetX, drawOffsetY = getDrawOffset()
    local targetOffsetX, targetOffsetY = -(self.x - 200), -(self.y - 120)
    local smoothSpeed = 0.06
    local smoothedX = lerp(drawOffsetX, targetOffsetX, smoothSpeed)
    local smoothedY = lerp(drawOffsetY, targetOffsetY, smoothSpeed)
    setDrawOffset(smoothedX, smoothedY)

    self:setImage(self.animationLoop:image())
end

function Player:initializeUpgrades()
    local upgrades = self.gameManager.upgrades
    for i=1, #upgrades do
        local upgradeData = upgrades[i]
        local upgradeConstructor = upgradeData.constructor
        upgradeConstructor(self, upgradeData)
    end
end

function Player:initializeEquipment()
    local equipment = self.gameManager.equipment
    for i=1, #equipment do
        local equipmentData = equipment[i]
        local equipmentConstructor = equipmentData.constructor
        equipmentConstructor(self, equipmentData)
    end
end

function Player:damage(amount)
    if self.invincible then
        return
    end

    self.healthbar:damage(amount)
    if self.healthbar:isDead() then
        self.gameManager:runEnded()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    self.healthbar:setFillWhite(true)
    pd.timer.new(self.flashTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
        self.healthbar:setFillWhite(false)
    end)
end

function Player:heal(amount)
    self.healthbar:heal(amount)
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

function Player:screenShake()
    if self.shakeTimer then
        self.shakeTimer:remove()
    end
    self.shakeTimer = pd.timer.new(700, self.shakeAmount, 0)
    self.shakeTimer.timerEndedCallback = function()
        setDisplayOffset(0, 0)
        self.shakeTimer = nil
    end
    self.shakeTimer.updateCallback = function(timer)
        local shakeAmount = timer.value
        local shakeAngle = random()*360;
        shakeX = floor(calculatedCosine[floor(shakeAngle)]*shakeAmount);
        shakeY = floor(calculatedSine[floor(shakeAngle)]*shakeAmount);
        setDisplayOffset(shakeX, shakeY)
    end
end