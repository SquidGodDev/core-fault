import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local beamDirection = 0
local angleSpeed = 45

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

class('Beam').extends(Equipment)

function Beam:init(player, data)
    data = Beam.super.init(self, player, data)

    self.beamCooldown = data.cooldown

    self.lineLength = data.length
    self.lineWidth = 5

    self.drawTime = 500

    self.enemyTag = TAGS.ENEMY

    self.beamDamage = data.damage

    self:calculateNextAngle()

    self.reticleSprite = gfx.sprite.new(gfx.image.new("images/player/equipment/reticle-small"))
    self.reticleSprite:add()
    self.reticleSprite:setZIndex(Z_INDEXES.EQUIPMENT + 1)
    self.reticleSprite.offsetX, self.reticleSprite.offsetY = self:getNextTarget()
    self.reticleSprite.player = player

    -- Components
    self.cooldownTimer = HasCooldown(self.beamCooldown, self.fireBeam, self)
    FollowsPlayer(self, player)
    self.damageComponent = DoesDamage(player, self.beamDamage)

    self.sfxPlayer = SfxPlayer("sfx-beam")
end

function Beam:calculateNextAngle()
    beamDirection = (beamDirection + angleSpeed) % 360
end

function Beam:getNextTarget()
    local angleInRad = rad(-beamDirection)
    local angleCos = cos(angleInRad)
    local angleSine = sin(angleInRad)

    local targetXOffset = angleCos * self.lineLength
    local targetYOffset = angleSine * self.lineLength
    return targetXOffset, targetYOffset
end

function Beam:fireBeam()
    local x, y = self.player.x, self.player.y
    
    local targetXOffset = self.reticleSprite.offsetX
    local targetYOffset = self.reticleSprite.offsetY
    

    self:moveTo(x, y)

    local drawTimer = pd.timer.new(self.drawTime, self.lineWidth, 0, pd.easingFunctions.inOutCubic)
    local padding = 10
    local beamImage = gfx.image.new(self.lineLength * 2 + padding * 2, self.lineLength * 2 + padding * 2)

    local beamStartX, beamStartY = self.lineLength + padding, self.lineLength + padding
    local beamEndX, beamEndY = self.lineLength + targetXOffset + padding, self.lineLength + targetYOffset + padding

    drawTimer.updateCallback = function(timer)
        beamImage:clear(gfx.kColorClear)
        if timer.value > 0.9 then
            gfx.pushContext(beamImage)
                gfx.setColor(gfx.kColorBlack)
                gfx.setLineCapStyle(gfx.kLineCapStyleRound)
                gfx.setLineWidth(timer.value + 1)
                gfx.drawLine(beamStartX, beamStartY, beamEndX, beamEndY)
                gfx.setLineWidth(timer.value)
                gfx.setColor(gfx.kColorWhite)
                gfx.drawLine(beamStartX, beamStartY, beamEndX, beamEndY)
            gfx.popContext()
        end
        self:setImage(beamImage)
    end

    local hitObjects = gfx.sprite.querySpritesAlongLine(self.player.x, self.player.y, self.player.x + targetXOffset, self.player.y + targetYOffset)
    self.damageComponent:dealDamage(hitObjects)

    self.sfxPlayer:play()

    self:calculateNextAngle()
    self.reticleSprite.offsetX, self.reticleSprite.offsetY = self:getNextTarget()
end

function Beam:update()
    local reticleX = playdate.math.lerp(self.reticleSprite.x, self.reticleSprite.player.x + self.reticleSprite.offsetX, 0.25)
    local reticleY = playdate.math.lerp(self.reticleSprite.y, self.reticleSprite.player.y + self.reticleSprite.offsetY, 0.25)
    self.reticleSprite:moveTo(reticleX, reticleY)
end