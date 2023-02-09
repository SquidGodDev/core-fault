import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesAOEDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('StaticField').extends(Equipment)

function StaticField:init(player, data)
    data = StaticField.super.init(self, player, data)

    local radius = data.radius
    local diameter = radius * 2
    local staticFieldImage = gfx.image.new(diameter, diameter)
    gfx.pushContext(staticFieldImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setStrokeLocation(gfx.kStrokeInside)
        gfx.setLineWidth(3)
        gfx.drawCircleInRect(0, 0, diameter, diameter)
    gfx.popContext()
    self:setImage(staticFieldImage)

    self.aoeDamageComponent = DoesAOEDamage(player, data.damage, radius)
    FollowsPlayer(self, player)

    self.cooldownTimer = pd.timer.new(data.cooldown, function()
        self.aoeDamageComponent:dealAOEDamage(self.x, self.y)
    end)
    self.cooldownTimer.repeats = true
end