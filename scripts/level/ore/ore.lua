
local pd <const> = playdate
local gfx <const> = playdate.graphics

local oreImage <const> = gfx.image.new("images/levels/ore")

class('Ore').extends(gfx.sprite)

function Ore:init(x, y, oreSpawner)
    self.oreSpawner = oreSpawner

    self:setImage(oreImage)
    self:moveTo(x, y)
    self:setTag(TAGS.ORE)
    self:setGroups(COLLISION_GROUPS.ORE)
    self:setCollideRect(0, 0, self:getSize())
    self:add()

    self.health = 5

    self.flashTime = 100
end

function Ore:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.oreSpawner:oreMined()
        self:remove()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    pd.timer.new(self.flashTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)
end