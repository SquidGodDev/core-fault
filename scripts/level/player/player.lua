import "scripts/libraries/AnimatedSprite"
import "scripts/level/player/healthbar"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local floor <const> = math.floor
local getCrankPosition <const> = pd.getCrankPosition

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

local calculatedCosine <const> = {}
local calculatedSine <const> = {}
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

local smoothSpeed <const> = 0.06

local hurtboxWidth
local hurtboxHeight
local hurtboxHalfWidth
local hurtboxHalfHeight

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
    self.Piercing = 0

    self.BonusDamage = 0

    self:initializeUpgrades()
    self:initializeEquipment()

    local healthbar <const> = Healthbar(self.MaxHealth, self)
    self.healthbar = healthbar
    self.flashTime = 100

    local healthRegenTickRate = 500
    local healthRegen <const> = self.HealthRegen
    local healthRegenTimer = pd.timer.new(healthRegenTickRate, function()
        healthbar:heal(healthRegen)
    end)
    healthRegenTimer.repeats = true

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
    setDrawOffset(-(x - 200), -(y - 120))

    -- Hitbox/Collisions
    self:setGroups(COLLISION_GROUPS.PLAYER)
    self:setCollidesWithGroups(COLLISION_GROUPS.WALL)
    self:setCollideRect(0, 0, self:getSize())
    self.collisionResponse = "slide"
    self:setTag(TAGS.PLAYER)

    local playerWidth, playerHeight = self:getSize()
    local hurtboxBuffer = 4
    hurtboxWidth = playerWidth - hurtboxBuffer * 2
    hurtboxHeight = playerHeight - hurtboxBuffer * 2
    hurtboxHalfWidth = playerWidth / 2 - hurtboxBuffer
    hurtboxHalfHeight = playerHeight / 2 - hurtboxBuffer

    self.enemyTag = TAGS.ENEMY
end

function Player:update()
    local playerX, playerY = self.x, self.y

    -- Check if being damaged by enemies
    local hurtboxX = playerX - hurtboxHalfWidth
    local hurtboxY = playerY - hurtboxHalfHeight
    local overlappingSprites = querySpritesInRect(hurtboxX, hurtboxY, hurtboxWidth, hurtboxHeight)
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
    local animationLoop <const> = self.animationLoop
    animationLoop.startFrame = animationStartIndex
    animationLoop.endFrame = animationStartIndex + 1
    self:updateMovement(crankPos)

    local drawOffsetX, drawOffsetY = getDrawOffset()
    local targetOffsetX, targetOffsetY = -(playerX - 200), -(playerY - 120)
    local smoothedX = lerp(drawOffsetX, targetOffsetX, smoothSpeed)
    local smoothedY = lerp(drawOffsetY, targetOffsetY, smoothSpeed)
    setDrawOffset(smoothedX, smoothedY)

    self:setImage(animationLoop:image())
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
    local attackSpeed <const> = self.AttackSpeed
    for i=1, #equipment do
        local equipmentData = equipment[i]
        local equipmentConstructor = equipmentData.constructor
        if equipmentData.cooldown then
            equipmentData.cooldown *= attackSpeed
        end
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
    local maxVelocity <const> = self.MaxVelocity
    local angleCos = calculatedCosine[floor(crankAngle)]
    local angleSin = calculatedSine[floor(crankAngle)]
    local maxX = angleCos * maxVelocity
    local maxY = angleSin * maxVelocity
    self.xVelocity = maxX
    self.yVelocity = maxY
    self:moveWithCollisions(self.x + maxX, self.y + maxY)
end
