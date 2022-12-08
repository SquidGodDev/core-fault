import "scripts/libraries/LDtk"
import "scripts/game/player/player"
import "scripts/game/enemies/testEnemy"
import "scripts/game/collisions/quadTree"

local pd <const> = playdate
local gfx <const> = playdate.graphics

COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2
}

Z_INDEXES = {
    PLAYER = 100,
    WEAPON = 90
}

TAGS = {
    PLAYER = 1,
    ENEMY = 2,
    WALL = 3
}

class('GameScene').extends(gfx.sprite)

function GameScene:init()
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            blackImage:draw(0, 0)
        end
    )
    gfx.sprite.setAlwaysRedraw(true)

    LDtk.load("assets/testLevel.ldtk")
    self.tilemap = LDtk.create_tilemap("Level_0")
    gfx.sprite.addWallSprites(self.tilemap, LDtk.get_empty_tileIDs("Level_0", "Solid"))
    -- self:setTilemap(self.tilemap)

    self:createTilemapSprite("leftWall", 8, 8)
    self:createTilemapSprite("topWall", 24, 8)
    self:createTilemapSprite("rightWall", 784, 8)
    self:createTilemapSprite("bottomWall", 24, 520)
    self:createTilemapSprite("topLeftRock", 120, 24)
    self:createTilemapSprite("topRock", 280, 24)
    self:createTilemapSprite("leftRock", 40, 144)
    self:createTilemapSprite("leftSmallRock", 136, 128)

    self.player = Player(200, 120)
    -- TestEnemy(240, 120, self)

    local levelWidth, levelHeight = 808, 544

    local spawnBorderBuffer = 20
    self.enemyCount = 0
    self.maxEnemies = 60
    local spawnTimer = pd.timer.new(1000, function(timer)
        if self.enemyCount >= self.maxEnemies then
            return
        end
        self.enemyCount += 1
        local spawnX = math.random(spawnBorderBuffer, levelWidth - spawnBorderBuffer)
        local spawnY = math.random(spawnBorderBuffer, levelHeight - spawnBorderBuffer)
        TestEnemy(spawnX, spawnY, self)
        TestEnemy(200, 120, self)
    end)
    spawnTimer.repeats = true

    self:add()
end

function GameScene:update()

end

function GameScene:enemyDied()
    self.enemyCount -= 1
end

function GameScene:createTilemapSprite(name, x, y)
    local tilemapImage = gfx.image.new("images/levels/testLevel/"..name)
    local tilemapSprite = gfx.sprite.new(tilemapImage)
    tilemapSprite:setCenter(0, 0)
    tilemapSprite:moveTo(x, y)
    tilemapSprite:add()
end