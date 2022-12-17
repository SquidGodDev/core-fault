import "scripts/level/player/equipment/components/doesDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DoesAOEDamage').extends()

function DoesAOEDamage:init(player, damage, radius)
    self.radius = radius
    self.diameter = radius * 2
    self.damageComponent = DoesDamage(player, damage)
end

function DoesAOEDamage:dealAOEDamage(x, y)
    local collisions = gfx.sprite.querySpritesInRect(x - self.radius, y - self.radius, self.diameter, self.diameter)
    self.damageComponent:dealDamage(collisions)
end