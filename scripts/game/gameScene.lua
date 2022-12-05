import "scripts/libraries/LDtk"
import "scripts/game/player/player"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameScene').extends(gfx.sprite)

function GameScene:init()
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(
        function()
            blackImage:draw(0, 0)
        end
    )

    LDtk.load("assets/testLevel.ldtk")
    self.tilemap = LDtk.create_tilemap("Level_0")
    gfx.sprite.addWallSprites(self.tilemap, LDtk.get_empty_tileIDs("Level_0", "Solid"))
    self:setTilemap(self.tilemap)
    self:add()

    Player(200, 120)
end

function GameScene:update()

end