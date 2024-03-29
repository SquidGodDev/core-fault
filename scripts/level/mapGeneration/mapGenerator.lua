import "scripts/level/mapGeneration/mapPatterns"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local mapPatterns <const> = mapPatterns
local mapZ <const> = -32767

class('MapGenerator').extends()

function MapGenerator:init()
    self.mapPattern = mapPatterns[math.random(#mapPatterns)]

    self.blockImage = gfx.image.new("images/levels/block")
    self.groundImage = gfx.image.new("images/levels/ground1")
    self.baseX = 32
    self.baseY = 32
    self.blockSize = self.blockImage:getSize()
    self.borderBuffer = 30

    self.validCoordinates = {}
    for i=1,3 do
        for j=1,3 do
            local spot = self.mapPattern[i][j]
            if spot == 1 then
                self:createBlockSprite(j, i)
            else
                self:createGroundSprite(j, i)
                table.insert(self.validCoordinates, {x=j, y=i})
            end
        end
    end

    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.clear(gfx.kColorBlack)
    gfx.sprite.setAlwaysRedraw(false)

    self:createTilemapSprite("westWall", 0, 0)
    self:createTilemapSprite("eastWall", 800, 0)
    self:createTilemapSprite("northWall", 32, 0)
    self:createTilemapSprite("southWall", 32, 800)
end

function MapGenerator:getRandomEmptyPosition()
    local validPosition = self.validCoordinates[math.random(#self.validCoordinates)]
    local minX = self.baseX + self.blockSize*(validPosition.x - 1) + self.borderBuffer
    local maxX = self.baseX + self.blockSize*(validPosition.x) - self.borderBuffer
    local minY = self.baseY + self.blockSize*(validPosition.y - 1) + self.borderBuffer
    local maxY = self.baseY + self.blockSize*(validPosition.y) - self.borderBuffer
    return math.random(minX, maxX), math.random(minY, maxY)
end

function MapGenerator:createTilemapSprite(name, x, y)
    local tilemapImage = gfx.image.new("images/levels/"..name)
    local tilemapSprite = gfx.sprite.new(tilemapImage)
    tilemapSprite:setGroups(COLLISION_GROUPS.WALL)
    tilemapSprite:setTag(TAGS.WALL)
    tilemapSprite:setCollideRect(0, 0, tilemapSprite:getSize())
    tilemapSprite:setCenter(0, 0)
    tilemapSprite:moveTo(x, y)
    tilemapSprite:setZIndex(mapZ + 1)
    tilemapSprite:add()
end

function MapGenerator:createBlockSprite(x, y)
    local blockX = self.baseX + self.blockSize*(x - 1)
    local blockY = self.baseX + self.blockSize*(y - 1)
    local blockSprite = gfx.sprite.new(self.blockImage)
    blockSprite:setGroups(COLLISION_GROUPS.WALL)
    blockSprite:setTag(TAGS.WALL)
    blockSprite:setCollideRect(0, 0, blockSprite:getSize())
    blockSprite:setCenter(0, 0)
    blockSprite:moveTo(blockX, blockY)
    blockSprite:setZIndex(mapZ + 2)
    blockSprite:add()
end

function MapGenerator:createGroundSprite(x, y)
    local groundX = self.baseX + self.blockSize*(x - 1)
    local groundY = self.baseX + self.blockSize*(y - 1)
    local groundSprite = gfx.sprite.new(self.groundImage)
    groundSprite:setCenter(0, 0)
    groundSprite:moveTo(groundX, groundY)
    groundSprite:setZIndex(mapZ)
    groundSprite:add()
end