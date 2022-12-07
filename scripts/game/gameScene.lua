import "scripts/libraries/LDtk"
import "scripts/game/player/player"
import "scripts/game/enemies/testEnemy"

local pd <const> = playdate
local gfx <const> = playdate.graphics

COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2
}

Z_INDEXES = {
    PLAYER = 100
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
    gfx.setScreenClipRect(0, 0, 400, 240)

    -- LDtk.load("assets/testLevel.ldtk")
    -- self.tilemap = LDtk.create_tilemap("Level_0")
    -- gfx.sprite.addWallSprites(self.tilemap, LDtk.get_empty_tileIDs("Level_0", "Solid"))
    -- self:setTilemap(self.tilemap)
    -- local levelImage = gfx.image.new("assets/testLevel/png/Level_0")
    -- self:setCenter(0, 0)
    -- self:moveTo(0, 0)
    -- self:setImage(levelImage)
    -- self:add()

    self:createTilemapSprite("leftWall", 8, 8)
    self:createTilemapSprite("topWall", 24, 8)
    self:createTilemapSprite("rightWall", 784, 8)
    self:createTilemapSprite("bottomWall", 24, 520)
    self:createTilemapSprite("topLeftRock", 120, 24)
    self:createTilemapSprite("topRock", 280, 24)
    self:createTilemapSprite("leftRock", 40, 144)
    self:createTilemapSprite("leftSmallRock", 136, 128)

    -- Create sprites for all tiles
    -- local mapWidth, mapHeight = self.tilemap:getSize()
    -- local tilemapImageTable = gfx.imagetable.new("assets/1bit-table-8-8")
    -- local blankTileIndex = 21
    -- local tileSize = 8
    -- for x=1, mapWidth do
    --     for y=1, mapHeight do
    --         local tileIndex = self.tilemap:getTileAtPosition(x, y)
    --         if tileIndex ~= blankTileIndex then
    --             local tileImage = tilemapImageTable:getImage(tileIndex)
    --             local tileSprite = gfx.sprite.new(tileImage)
    --             tileSprite:setCenter(0, 0)
    --             tileSprite:moveTo((x-1)*tileSize, (y-1)*tileSize)
    --             tileSprite:add()
    --         end
    --     end
    -- end

    self.player = Player(200, 120)
    -- TestEnemy(240, 120, self)

    local enemyCount, maxEnemies = 0, 80
    local spawnTimer = pd.timer.new(100, function(timer)
        enemyCount += 1
        TestEnemy(200, 120, self)
        if enemyCount >= maxEnemies then
            timer:remove()
        end
    end)
    spawnTimer.repeats = true
end

function GameScene:update()

end

function GameScene:createTilemapSprite(name, x, y)
    local tilemapImage = gfx.image.new("images/levels/testLevel/"..name)
    local tilemapSprite = gfx.sprite.new(tilemapImage)
    tilemapSprite:setCenter(0, 0)
    tilemapSprite:moveTo(x, y)
    tilemapSprite:add()
end