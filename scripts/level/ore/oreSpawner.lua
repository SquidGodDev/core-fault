import "scripts/level/ore/ore"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('OreSpawner').extends(gfx.sprite)

function OreSpawner:init(gameManager, mapGenerator)
    self.gameManager = gameManager

    self.spawnTime = 3000

    self.currentOreCount = 0
    self.maxOre = 5

    self.totalOreCount = 0
    self.maxLevelOre = 50

    local spawnTimer = pd.timer.new(self.spawnTime, function()
        if self.totalOreCount < self.maxLevelOre and self.currentOreCount < self.maxOre then
            self.currentOreCount += 1
            self.totalOreCount += 1
            local spawnX, spawnY = mapGenerator:getRandomEmptyPosition()
            Ore(spawnX, spawnY, self)
        end
    end)
    spawnTimer.repeats = true
end

function OreSpawner:oreMined()
    self.currentOreCount -= 1
    self.gameManager.minedOre += 1
    print(self.gameManager.minedOre)
end
