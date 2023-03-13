import "scripts/level/player/equipment/components/doesAOEDamage"
import "scripts/level/player/equipment/components/equipment"
import "CoreLibs/math"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local shootAngle = 0
local angleSpeed <const> = 20

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

class('SubterraneanRocket').extends(Equipment)

function SubterraneanRocket:init(player, data)
    local dataCopy = SubterraneanRocket.super.init(self, player, data)

    local radius = dataCopy.radius
    local diameter = radius * 2
    local explosionImage = gfx.image.new(diameter, diameter)
    gfx.pushContext(explosionImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setPattern({0x80, 0x49, 0x94, 0x8, 0x20, 0x52, 0x25, 0x2})
        gfx.fillCircleInRect(0, 0, diameter, diameter)
    gfx.popContext()
    self:setImage(explosionImage)

    local flashTime = 200
    self:setVisible(false)

    self.explosionDistance = dataCopy.distance
    self.hitStun = dataCopy.hitStun

    self.aoeDamageComponent = DoesAOEDamage(player, dataCopy)

    self.sfxPlayer = SfxPlayer("sfx-sub-rocket")

    self.reticleSprite = gfx.sprite.new(gfx.image.new("images/player/equipment/reticle"))
    self.reticleSprite:add()
    self.reticleSprite:setZIndex(Z_INDEXES.EQUIPMENT + 1)
    local explosionX, explosionY = self:getNextPosition()
    self.reticleSprite.offsetX = explosionX
    self.reticleSprite.offsetY = explosionY
    self.reticleSprite.player = player

    self.cooldownTimer = pd.timer.new(dataCopy.cooldown, function()
        self.sfxPlayer:play()
        
        explosionX = self.reticleSprite.x
        explosionY = self.reticleSprite.y
        self.aoeDamageComponent:dealAOEDamage(explosionX, explosionY)
        self:moveTo(explosionX, explosionY)
        self:setVisible(true)
        self:calculateNextAngle()
        self.reticleSprite.offsetX, self.reticleSprite.offsetY = self:getNextPosition()
        pd.timer.new(flashTime, function()
            self:setVisible(false)
        end)
    end)
    self.cooldownTimer.repeats = true
end

function SubterraneanRocket:calculateNextAngle()
    shootAngle = (shootAngle + angleSpeed) % 360
end

function SubterraneanRocket:getNextPosition()
    local angleInRad = rad(shootAngle)
    local angleCos = cos(angleInRad)
    local angleSine = sin(angleInRad)
    local explosionX = angleCos * self.explosionDistance
    local explosionY = angleSine * self.explosionDistance
    return explosionX, explosionY
end

function SubterraneanRocket:update()
    local reticleX = playdate.math.lerp(self.reticleSprite.x, self.reticleSprite.player.x + self.reticleSprite.offsetX, 0.25)
    local reticleY = playdate.math.lerp(self.reticleSprite.y, self.reticleSprite.player.y + self.reticleSprite.offsetY, 0.25)
    self.reticleSprite:moveTo(reticleX, reticleY)
end