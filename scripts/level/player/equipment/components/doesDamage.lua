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
    self.BaseBonusDamage = self.BonusDamage
end

function DoesDamage:addBonusDamage(amount)
    self.BonusDamage += amount
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

    self.BonusDamage = self.BaseBonusDamage
end

function DoesDamage:dealDamageSingle(hitEntity)
    local crit = random() <= self.CritChance
    local damageAmount = self.damage + self.BonusDamage
    if crit then
        damageAmount *= 1 + self.CritDamage
    end

    if hitEntity:getTag() == self.enemyTag then
        hitEntity:damage(damageAmount)
    end

    self.BonusDamage = self.BaseBonusDamage
end