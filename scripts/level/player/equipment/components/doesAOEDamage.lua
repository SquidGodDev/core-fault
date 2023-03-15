import "scripts/level/player/equipment/components/doesDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DoesAOEDamage').extends()

function DoesAOEDamage:init(player, data)
    self.radius = data.radius
    self.diameter = self.radius * 2
    self.damageComponent = DoesDamage(player, data)
end

function DoesAOEDamage:addBonusDamage(amount)
    self.damageComponent:addBonusDamage(amount)
end

function DoesAOEDamage:dealAOEDamage(x, y)
    local collisions = gfx.sprite.querySpritesInRect(x - self.radius, y - self.radius, self.diameter, self.diameter)
    self.damageComponent:dealDamage(collisions)
end