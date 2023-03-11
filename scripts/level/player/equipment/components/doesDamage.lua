local pd <const> = playdate
local gfx <const> = playdate.graphics

local random <const> = math.random

class('DoesDamage').extends()

function DoesDamage:init(player, data)
    self.enemyTag = TAGS.ENEMY
    self.oreTag = TAGS.ORE
    self.damage = data.damage
    self.hitStun = data.hitStun or 0
    self.percentStun = player.percentStun
    self.CritChance = player.CritChance
    self.CritDamage = player.CritDamage
    self.BonusDamage = player.BonusDamage
    self.PercentDamage = player.PercentDamage
    self.BaseBonusDamage = self.BonusDamage
end

function DoesDamage:addBonusDamage(amount)
    self.BonusDamage += amount
end

function DoesDamage:dealDamage(hitEntities)
    local crit = random() <= self.CritChance
    local damageAmount = (self.damage * (1 + self.PercentDamage)) + self.BonusDamage
    if crit then
        damageAmount *= 1 + self.CritDamage
    end

    for i=1, #hitEntities do
        local curObject = hitEntities[i]
        local hitEntityTag = curObject:getTag()
        if hitEntityTag == self.enemyTag or hitEntityTag == self.oreTag then
            curObject:damage(damageAmount, self.hitStun * (1 + self.percentStun))
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

    local hitEntityTag = hitEntity:getTag()
    if hitEntityTag == self.enemyTag or hitEntityTag == self.oreTag then
        hitEntity:damage(damageAmount, self.hitStun * (1 + self.percentStun))
    end

    self.BonusDamage = self.BaseBonusDamage
end