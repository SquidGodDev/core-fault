import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/utilities/sampler"
import "scripts/libraries/SceneManager"

import "scripts/game/gameManager"
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

math.randomseed(pd.getSecondsSinceEpoch())

SCENE_MANAGER = SceneManager()

GameManager()
-- TitleScene()

local spriteUpdate <const> = gfx.sprite.update
local timerUpdate <const> = pd.timer.updateTimers
local drawFPS <const> = pd.drawFPS

function pd.update()
    spriteUpdate()
    timerUpdate()
    drawFPS(5, 5)
end
