import "scripts/level/player/weapons/components/hasCooldown"
import "scripts/level/player/weapons/components/followsPlayer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Beam').extends(gfx.sprite)

function Beam:init(player)
    self.player = player
    self:setZIndex(Z_INDEXES.WEAPON)

    self.beamCooldown = 1000

    HasCooldown(self.beamCooldown, self.fireBeam, self)
    FollowsPlayer(self, player)

    self.lineLength = 90
    self.lineWidth = 5

    self.drawTime = 500

    self.enemyTag = TAGS.ENEMY

    self.beamDamage = 2

    self:add()
end

function Beam:fireBeam()
    local x, y = self.player.x, self.player.y
    local crankPos = pd.getCrankPosition() - 90
    local angleInRad = math.rad(crankPos)
    local angleCos = math.cos(angleInRad)
    local angleSine = math.sin(angleInRad)

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
    for i=1, #hitObjects do
        local curObject = hitObjects[i]
        if curObject:getTag() == self.enemyTag then
            curObject:damage(self.beamDamage)
        end
    end
end