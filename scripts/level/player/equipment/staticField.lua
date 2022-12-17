import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesAOEDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('StaticField').extends(gfx.sprite)

function StaticField:init(player, data)
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
    self:setZIndex(Z_INDEXES.EQUIPMENT)
    self:add()

    self.aoeDamageComponent = DoesAOEDamage(player, data.damage, radius)
    FollowsPlayer(self, player)

    local attackTimer = pd.timer.new(data.cooldown, function()
        self.aoeDamageComponent:dealAOEDamage(self.x, self.y)
    end)
    attackTimer.repeats = true
end