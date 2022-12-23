import "scripts/level/player/player"
import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/mapGeneration/mapGenerator"
import "scripts/level/ore/oreSpawner"

local pd <const> = playdate
local gfx <const> = playdate.graphics

COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2,
    PROJECTILE = 3,
    WALL = 4,
    ORE = 5
}

Z_INDEXES = {
    UI = 200,
    PLAYER = 100,
    EQUIPMENT = 90
}

TAGS = {
    PLAYER = 1,
    ENEMY = 2,
    WALL = 3,
    ORE = 4
}

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(gameManager, curLevel)
    self.gameManager = gameManager
    self.curLevel = curLevel

    self:setupLevelLayout()
    self:setupOreSpawner()
    self:setupEnemySpawner()
end

function LevelScene:setupLevelLayout()
    self.mapGenerator = MapGenerator()

    local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
    self.player = Player(spawnX, spawnY, self.gameManager)
end

function LevelScene:setupOreSpawner()
    OreSpawner(self.gameManager, self.mapGenerator)
end

function LevelScene:setupEnemySpawner()
    local enemiesList = {Slime, Fly, Crab}
    local levelWidth, levelHeight = 800, 800

    local spawnBorderBuffer = 20
    self.enemyCount = 0
    self.maxEnemies = 35
    self.enemiesDefeated = 0
    self.enemiesToDefeat = self.curLevel * 5 + 5 + 100
    local spawnTimer = pd.timer.new(100, function()
        if self.enemyCount >= self.maxEnemies or self.enemyCount >= self.enemiesToDefeat then
            return
        end
        self.enemyCount += 1
        -- local spawnX = math.random(spawnBorderBuffer, levelWidth - spawnBorderBuffer)
        -- local spawnY = math.random(spawnBorderBuffer, levelHeight - spawnBorderBuffer)
        local RandEnemy = enemiesList[math.random(#enemiesList)]
        local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
        RandEnemy(spawnX, spawnY, self)
    end)
    spawnTimer.repeats = true
end

function LevelScene:enemyDied()
    self.enemyCount -= 1
    self.enemiesToDefeat -= 1
    if self.enemiesToDefeat <= 0 then
        self.gameManager:levelDefeated()
    end
end
