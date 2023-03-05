
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
    self:setZIndex(self.y)

    self.health = 100

    self.flashTime = 100

    self.coreCollectSound = SfxPlayer("sfx-core-collect")
    self.coreDamageSound = SfxPlayer("sfx-core-damage")
end

function Ore:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.coreCollectSound:play()
        self.oreSpawner:oreMined()
        self:remove()
    else
        self.coreDamageSound:play()
    end

    self:setImageDrawMode(gfx.kDrawModeFillWhite)
    pd.timer.new(self.flashTime, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)
end