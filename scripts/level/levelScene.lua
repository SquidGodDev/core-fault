import "scripts/level/player/player"
import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/enemies/slimeMedium"
import "scripts/level/enemies/flyMedium"
import "scripts/level/enemies/crabMedium"
import "scripts/level/enemies/spawnProbabilities"
import "scripts/level/mapGeneration/mapGenerator"
import "scripts/level/ore/oreSpawner"
import "scripts/level/hud"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spawnProbabilities <const> = SpawnProbabilities

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
    self.player = Player(spawnX, spawnY, self.gameManager, self)
end

function LevelScene:setupOreSpawner()
    OreSpawner(self.gameManager, self.mapGenerator)
end

function LevelScene:setupEnemySpawner()
    self.spawnProbabilities = spawnProbabilities[self.curLevel]
    if not self.spawnProbabilities then
        self.spawnProbabilities = spawnProbabilities[#spawnProbabilities]
    end

    self.enemyCount = 0
    self.maxEnemies = 10 + self.curLevel * 4
    self.enemiesDefeated = 0

    local levelStartDelay = 1000
    pd.timer.performAfterDelay(levelStartDelay, function()
        local spawnTimer = pd.timer.new(100, function()
            if self.enemyCount >= self.maxEnemies then
                return
            end
            self.enemyCount += 1
            local RandEnemy = self:getRandomEnemy()
            local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
            RandEnemy(spawnX, spawnY, self)
        end)
        spawnTimer.repeats = true
    end)
end

function LevelScene:getRandomEnemy()
    local probablitySum = 0
    local randNum = math.random()
    for _, probabilityObject in ipairs(self.spawnProbabilities) do
        probablitySum += probabilityObject[1]
        if randNum <= probablitySum then
            return probabilityObject[2]
        end
    end
end

function LevelScene:enemyDied(experience)
    self.enemyCount -= 1
    self.enemiesDefeated += 1
    self.hud:addExperience(experience)
end

function LevelScene:levelDefeated(time)
    local allSprites = gfx.sprite.getAllSprites()
    for i=1,#allSprites do
        local curSprite = allSprites[i]
        if curSprite:isa(Enemy) or curSprite:isa(Player) then
            curSprite:setUpdatesEnabled(false)
        end
    end
    self.gameManager:levelDefeated(time, self.enemiesDefeated)
end

function LevelScene:playerDied()
    local allSprites = gfx.sprite.getAllSprites()
    for i=1,#allSprites do
        local curSprite = allSprites[i]
        if curSprite:isa(Enemy) or curSprite:isa(Player) then
            curSprite:setUpdatesEnabled(false)
        end
    end
    self.gameManager:playerDied(self.hud:stopTimer(), self.enemiesDefeated)
end