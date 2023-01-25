import "scripts/level/player/player"
import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/mapGeneration/mapGenerator"
import "scripts/level/ore/oreSpawner"
import "scripts/level/hud"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(gameManager, curLevel, time)
    self.gameManager = gameManager
    self.curLevel = curLevel

    -- TODO: Calculate level experience scaling
    self.hud = HUD(time, curLevel * 50, self)
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
    self.enemyCount = 0
    self.maxEnemies = 40
    self.enemiesDefeated = 0
    local spawnTimer = pd.timer.new(100, function()
        if self.enemyCount >= self.maxEnemies then
            return
        end
        self.enemyCount += 1
        local RandEnemy = enemiesList[math.random(#enemiesList)]
        local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
        RandEnemy(spawnX, spawnY, self)
    end)
    spawnTimer.repeats = true
end

function LevelScene:enemyDied(experience)
    self.enemyCount -= 1
    self.enemiesDefeated += 1
    self.hud:addExperience(experience)
end

function LevelScene:levelDefeated(time)
    self.gameManager:levelDefeated(time, self.enemiesDefeated)
end
