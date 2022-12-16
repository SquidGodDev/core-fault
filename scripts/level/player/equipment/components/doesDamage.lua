local pd <const> = playdate
local gfx <const> = playdate.graphics

local random <const> = math.random

class('DoesDamage').extends()

function DoesDamage:init(player, damage)
    self.enemyTag = TAGS.ENEMY
    self.damage = damage
    self.CritChance = player.CritChance
    self.CritDamage = player.CritDamage
    self.BonusDamage = player.BonusDamage
end

function DoesDamage:dealDamage(hitEntities)
    local crit = random() <= self.CritChance
    local damageAmount = self.damage + self.BonusDamage
    if crit then
        damageAmount *= 1 + self.CritDamage
    end

    for i=1, #hitEntities do
        local curObject = hitEntities[i]
        if curObject:getTag() == self.enemyTag then
            curObject:damage(damageAmount)
        end
    end
end