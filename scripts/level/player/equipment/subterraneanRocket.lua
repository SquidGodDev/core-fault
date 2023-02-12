import "scripts/level/player/equipment/components/doesAOEDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

class('SubterraneanRocket').extends(Equipment)

function SubterraneanRocket:init(player, data)
    data = SubterraneanRocket.super.init(self, player, data)

    local radius = data.radius
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

    local explosionDistance = data.distance

    self.aoeDamageComponent = DoesAOEDamage(player, data.damage, radius)

    self.sfxPlayer = SfxPlayer("sfx-sub-rocket")

    self.cooldownTimer = pd.timer.new(data.cooldown, function()
        self.sfxPlayer:play()
        local x, y = player.x, player.y
        local crankPos = getCrankPosition() - 90
        local angleInRad = rad(crankPos)
        local angleCos = cos(angleInRad)
        local angleSine = sin(angleInRad)
        local explosionX = x + angleCos * explosionDistance
        local explosionY = y + angleSine * explosionDistance
        self.aoeDamageComponent:dealAOEDamage(explosionX, explosionY)
        self:moveTo(explosionX, explosionY)
        self:setVisible(true)
        pd.timer.new(flashTime, function()
            self:setVisible(false)
        end)
    end)
    self.cooldownTimer.repeats = true
end