import "scripts/level/player/player"
import "scripts/level/enemies/slime"
import "scripts/level/enemies/fly"
import "scripts/level/enemies/crab"

local pd <const> = playdate
local gfx <const> = playdate.graphics

COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2,
    PROJECTILE = 3,
    WALL = 4
}

Z_INDEXES = {
    UI = 200,
    PLAYER = 100,
    EQUIPMENT = 90
}

TAGS = {
    PLAYER = 1,
    ENEMY = 2,
    WALL = 3
}

class('LevelScene').extends(gfx.sprite)

function LevelScene:init(gameManager, curLevel)
    self.gameManager = gameManager
    self.curLevel = curLevel

    self:setupLevelLayout()
    self:setupEnemySpawner()
end

function LevelScene:setupLevelLayout()
    gfx.setBackgroundColor(gfx.kColorBlack)
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            blackImage:draw(0, 0)
        end
    )
    gfx.sprite.setAlwaysRedraw(false)

    self:createTilemapSprite("verticalWall", 0, 0)
    self:createTilemapSprite("verticalWall", 800, 0)
    self:createTilemapSprite("horizontalWall", 32, 0)
    self:createTilemapSprite("horizontalWall", 32, 800)

    self.player = Player(200, 120, self.gameManager)
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
        local spawnX = math.random(spawnBorderBuffer, levelWidth - spawnBorderBuffer)
        local spawnY = math.random(spawnBorderBuffer, levelHeight - spawnBorderBuffer)
        local RandEnemy = enemiesList[math.random(#enemiesList)]
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

function LevelScene:createTilemapSprite(name, x, y)
    local tilemapImage = gfx.image.new("images/levels/testLevel/"..name)
    local tilemapSprite = gfx.sprite.new(tilemapImage)
    tilemapSprite:setGroups(COLLISION_GROUPS.WALL)
    tilemapSprite:setTag(TAGS.WALL)
    tilemapSprite:setCollideRect(0, 0, tilemapSprite:getSize())
    tilemapSprite:setCenter(0, 0)
    tilemapSprite:moveTo(x, y)
    tilemapSprite:add()
end