import "scripts/level/ore/ore"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('OreSpawner').extends(gfx.sprite)

function OreSpawner:init(gameManager, mapGenerator, level)
    self.gameManager = gameManager

    local levelOreCount = math.min(math.max(2 + level, (level - 5) * 2), 20)

    for _=1,levelOreCount do
        local spawnX, spawnY = mapGenerator:getRandomEmptyPosition()
        Ore(spawnX, spawnY, self)
    end

    self.coresSprite = gfx.sprite.new()
    self.coresSprite:setCenter(0, 0)
    self.coresSprite:moveTo(85, 8)
    self.coresSprite:setZIndex(Z_INDEXES.UI)
    self.coresSprite:setIgnoresDrawOffset(true)
    self.coresSprite:add()
    self:drawOreCount(0)
end

function OreSpawner:spawnOre(x, y)
    Ore(x, y, self)
end

function OreSpawner:oreMined()
    self.gameManager.minedOre += 1
    self:drawOreCount(self.gameManager.minedOre)
end

function OreSpawner:drawOreCount(count)
    local countImage = gfx.image.new(40, 8)
    gfx.pushContext(countImage)
        gfx.drawText(count, 0, 0)
    gfx.pushContext()
    self.coresSprite:setImage(countImage)
end