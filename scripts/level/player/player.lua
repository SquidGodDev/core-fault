import "scripts/libraries/AnimatedSprite"
import "scripts/level/player/healthbar"
import "scripts/data/playerStats"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local math <const> = math

local playerStats <const> = playerStats

local floor <const> = math.floor
local getCrankPosition <const> = pd.getCrankPosition

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

local calculatedCosine <const> = table.create(361, 0)
local calculatedSine <const> = table.create(361, 0)
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

local playerStates <const> = {
    animatingIn = 1,
    animatingOut = 2,
    active = 3,
    inactive = 4
}

class('Player').extends(gfx.sprite)

function Player:init(x, y, health, gameManager, levelScene)
    self.gameManager = gameManager
    self.levelScene = levelScene
    self.musicPlayer = MUSIC_PLAYER

    -- Player Stats
    self.MaxVelocity = playerStats.maxVelocity
    self.MaxHealth = playerStats.maxHealth
    self.HealthRegen = 0
    self.CritChance = playerStats.baseCritChance
    self.CritDamage = playerStats.baseCritDamage
    self.AttackSpeed = 1
    self.Piercing = 0
    self.Restoration = 0
    self.PercentDamage = 0
    self.BonusDamage = 0

    local healthbar <const> = Healthbar(self.MaxHealth, health, self)
    self.healthbar = healthbar
    self.flashTime = 100

    self.equipmentObjects = {}

    self:initializeUpgrades()
    self:initializeEquipment()

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
    self:setImage(playerSpriteSheet[10])
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
    self.hurtboxWidth = hurtboxWidth
    self.hurtboxHeight = hurtboxHeight
    self.hurtboxHalfWidth = hurtboxHalfWidth
    self.hurtboxHalfHeight = hurtboxHalfHeight

    self.enemyTag = TAGS.ENEMY

    self.playerState = playerStates.animatingIn

    local animateInTime = 1300
    local animateInTimer = pd.timer.new(animateInTime, y - 170, y, pd.easingFunctions.inOutQuad)
    animateInTimer.updateCallback = function(timer)
        self:moveTo(x, timer.value)
    end
    animateInTimer.timerEndedCallback = function()
        self.playerState = playerStates.active
    end

    self.damageSound = SfxPlayer("sfx-player-damage")
    self.deathSound = SfxPlayer("sfx-player-death")
    self.digSound = SfxPlayer("sfx-player-dig")

    self.shakeTimer = pd.timer.new(500, 5, 0)
    self.shakeTimer:pause()
    self.shakeTimer.timerEndedCallback = function(timer)
        pd.display.setOffset(0, 0)
        timer:reset()
        timer:pause()
    end
    self.shakeTimer.updateCallback = function(timer)
        local shakeAmount = timer.value
        local shakeAngle = math.random()*math.pi*2;
        shakeX = math.floor(math.cos(shakeAngle)*shakeAmount);
        shakeY = math.floor(math.sin(shakeAngle)*shakeAmount);
        pd.display.setOffset(shakeX, shakeY)
    end
    self.shakeTimer.discardOnCompletion = false
end

function Player:screenShake()
    if self.shakeTimer.paused then
        self.shakeTimer:start()
    end
end

function Player:update()
    if self.playerState == playerStates.inactive then
        return
    end

    if self.playerState == playerStates.animatingOut then
        self:setImage(self.animateOutAnimationLoop:image())
        if not self.animateOutAnimationLoop:isValid() then
            self.playerState = playerStates.inactive
            self.levelScene:levelDefeated(self.healthbar:getHealth() + self.Restoration)
        end
        return
    end

    local playerX, playerY = self.x, self.y

    local crankPos = getCrankPosition()
    local dirIndex = floor((crankPos + 22.5) / 45) % 8 + 1
    local animationStartIndex = 1 + (dirIndex - 1) * 2
    local animationLoop <const> = self.animationLoop
    animationLoop.startFrame = animationStartIndex
    animationLoop.endFrame = animationStartIndex + 1

    self:setZIndex(self.y)

    self:setImage(animationLoop:image())

    if self.playerState == playerStates.animatingIn then
        return
    end

    self:updateMovement(crankPos)

    local drawOffsetX, drawOffsetY = getDrawOffset()
    local targetOffsetX, targetOffsetY = -(playerX - 200), -(playerY - 120)
    local smoothedX = lerp(drawOffsetX, targetOffsetX, smoothSpeed)
    local smoothedY = lerp(drawOffsetY, targetOffsetY, smoothSpeed)
    setDrawOffset(smoothedX, smoothedY)

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
        table.insert(self.equipmentObjects, equipmentConstructor(self, equipmentData))
    end
end

function Player:levelDefeated()
    if self.playerState == playerStates.animatingOut then
        return
    end
    self.digSound:play()
    self:removeActivePlayerElements()
    local digImageTable = gfx.imagetable.new("images/player/player-dig-table-34-34")
    self.animateOutAnimationLoop = gfx.animation.loop.new(100, digImageTable, false)
    self.playerState = playerStates.animatingOut
end

function Player:removeActivePlayerElements()
    self.healthbar:remove()
    for i=1,#self.equipmentObjects do
        local equipment = self.equipmentObjects[i]
        equipment:disable()
    end
end

function Player:damage(amount)
    if self.invincible then
        return
    end

    self:screenShake()
    self.musicPlayer:duck(700)
    self.damageSound:play()
    self.healthbar:damage(amount)
    if self.healthbar:isDead() then
        self.deathSound:play()
        self.levelScene:playerDied()
        -- TODO: Player death animation
        self:removeActivePlayerElements()
        self.playerState = playerStates.inactive
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
