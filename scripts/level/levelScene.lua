import "scripts/level/player/player"
import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"
import "scripts/level/enemies/slimeMedium"
import "scripts/level/enemies/flyMedium"
import "scripts/level/enemies/crabMedium"
import "scripts/data/spawnProbabilities"
import "scripts/level/mapGeneration/mapGenerator"
import "scripts/level/ore/oreSpawner"
import "scripts/level/hud"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local projectiles <const> = PROJECTILES
local spawnProbabilities <const> = SpawnProbabilities

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(gameManager, curLevel, time, playerHealth)
    self.gameManager = gameManager
    self.curLevel = curLevel

    self.playerHealth = playerHealth

    -- TODO: Calculate level experience scaling
    local levelExperience = 6 + curLevel * 6 + math.max(0, (curLevel - 7) * 12) + math.max(0, curLevel - 3)
    self.hud = HUD(time, levelExperience, self)
    self:setupLevelLayout()
    self:setupOreSpawner()
    self:setupEnemySpawner()

    self.canDig = false
    self.digSpriteY = 162
    self.digSpriteAnimationTime = 800
    local digNotificationImageTable = gfx.imagetable.new("images/ui/dig-notification-table-55-77")
    self.digSpriteAnimation = gfx.animation.loop.new(100, digNotificationImageTable, true)
    self.digSprite = gfx.sprite.new(digNotificationImageTable[1])
    self.digSprite:setCenter(0, 0)
    self.digSprite:moveTo(13, 240)
    self.digSprite:setIgnoresDrawOffset(true)
    self.digSprite:setZIndex(Z_INDEXES.UI)

    self.levelAnimatingOut = false

    self.playerDead = false

    self:add()
end

function LevelScene:update()
    if self.canDig and not self.playerDead then
        self.digSprite:setImage(self.digSpriteAnimation:image())
        if pd.buttonJustPressed(pd.kButtonDown) and not self.levelAnimatingOut then
            self.levelAnimatingOut = true
            self.player:levelDefeated()
            self.hud:stopTimer()
        end
    end

    -- LEVEL SKIP
    -- if pd.buttonIsPressed(pd.kButtonB) then
    --     self.levelAnimatingOut = true
    --     self.player:levelDefeated()
    --     self.hud:stopTimer()
    -- end
end

function LevelScene:setupLevelLayout()
    self.mapGenerator = MapGenerator()

    local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
    self.player = Player(spawnX, spawnY, self.playerHealth, self.gameManager, self)
end

function LevelScene:setupOreSpawner()
    self.oreSpawner = OreSpawner(self.gameManager, self.mapGenerator, self.curLevel)
end

function LevelScene:setupEnemySpawner()
    self.spawnProbabilities = spawnProbabilities[self.curLevel]
    if not self.spawnProbabilities then
        self.spawnProbabilities = spawnProbabilities[#spawnProbabilities]
    end

    self.enemyCount = 0
    self.maxEnemies = math.min(2 + self.curLevel * 2, 10)
    -- self.maxEnemies = 100
    self.enemiesDefeated = 0

    local levelStartDelay = 1000
    pd.timer.performAfterDelay(levelStartDelay, function()
        local spawnTimer = pd.timer.new(math.max(100, 900 - self.curLevel * 100), function()
            if self.enemyCount >= self.maxEnemies then
                return
            end
            self.enemyCount += 1
            local RandEnemy = self:getRandomEnemy()
            --local spawnX, spawnY = self.mapGenerator:getRandomEmptyPosition()
            local spawnX = self.player.x + self.player.xVelocity * 100 + math.random(-200, 200)
            local spawnY = self.player.y + self.player.yVelocity * 100 + math.random(-120, 120)
            local minX = self.player.x - 242
            local maxX = self.player.x + 242
            local minY = self.player.y - 152
            local maxY = self.player.y + 152
            local inBounds = (spawnX > minX and spawnX < maxX) and (spawnY > minY and spawnY < maxY)

            if inBounds then
                if spawnY > self.player.y then spawnY = maxY else spawnY = minY end
            else
                if spawnX > maxX then
                    spawnX = maxX
                    spawnY = minY + math.random() * (maxY - minY)
                elseif spawnX < minX then
                    spawnX = minX
                    spawnY = minY + math.random() * (maxY - minY)
                elseif spawnY < minY then
                    spawnY = minY
                    spawnX = minX + math.random() * (maxX - minX)
                else
                    spawnY = maxY
                    spawnX = minX + math.random() * (maxX - minX)
                end
            end

            RandEnemy(spawnX, spawnY, self)
        end)
        spawnTimer.repeats = true
    end)
end

function LevelScene:getRandomEnemy()
    local probabilityWeightTotal = 0
    for _, probabilityObject in ipairs(self.spawnProbabilities) do
        probabilityWeightTotal += probabilityObject[1]
    end
    
    local probablitySum = 0
    local randNum = math.random() * probabilityWeightTotal
    for _, probabilityObject in ipairs(self.spawnProbabilities) do
        probablitySum += probabilityObject[1]
        if randNum <= probablitySum then
            return probabilityObject[2]
        end
    end
end

function LevelScene:enemyDied(experience)
    self.enemyCount -= 1
    if experience > 0 then
        self.enemiesDefeated += 1
    end
    self.hud:addExperience(experience)
end

function LevelScene:levelDefeated(playerHealth)
    local time = self.hud:getTimeLeft()
    for i=1,#projectiles do
        projectiles[i] = nil
    end
    self.gameManager:levelDefeated(time, self.enemiesDefeated, playerHealth)
end

function LevelScene:enableDigging()
    if not self.canDig and not self.playerDead then
        self.canDig = true
        self.digSprite:add()
        local animateInTimer = pd.timer.new(self.digSpriteAnimationTime, self.digSprite.y, self.digSpriteY, pd.easingFunctions.inOutCubic)
        animateInTimer.updateCallback = function(timer)
            self.digSprite:moveTo(self.digSprite.x, timer.value)
        end
    end
end

function LevelScene:playerDied()
    self.playerDead = true
    self.digSprite:remove()
    for i=1,#projectiles do
        projectiles[i] = nil
    end
    self.gameManager:playerDied(self.hud:stopTimer(), self.enemiesDefeated)
end