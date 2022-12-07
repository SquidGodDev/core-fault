import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/utilities/sampler"

import "scripts/game/gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

GameScene()

local spriteUpdate <const> = gfx.sprite.update
local timerUpdate <const> = pd.timer.updateTimers
local drawFPS <const> = pd.drawFPS

local levelImage = gfx.image.new("assets/testLevel/png/Level_0")

function pd.update()
    spriteUpdate()
    timerUpdate()
    drawFPS(5, 5)
end
