import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

class('Beam').extends(Equipment)

function Beam:init(player, data)
    data = Beam.super.init(self, player, data)

    self.beamCooldown = data.cooldown

    self.lineLength = 90
    self.lineWidth = 5

    self.drawTime = 500

    self.enemyTag = TAGS.ENEMY

    self.beamDamage = data.damage

    -- Components
    self.cooldownTimer = HasCooldown(self.beamCooldown, self.fireBeam, self)
    FollowsPlayer(self, player)
    self.damageComponent = DoesDamage(player, self.beamDamage)

    self.sfxPlayer = SfxPlayer("sfx-beam")
end

function Beam:fireBeam()
    local x, y = self.player.x, self.player.y
    local crankPos = getCrankPosition() - 90
    local angleInRad = rad(crankPos)
    local angleCos = cos(angleInRad)
    local angleSine = sin(angleInRad)

    local targetXOffset = angleCos * self.lineLength
    local targetYOffset = angleSine * self.lineLength

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
end