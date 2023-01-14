COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2,
    PROJECTILE = 3,
    WALL = 4,
    ORE = 5
}

Z_INDEXES = {
    UI = 200,
    PLAYER = 100,
    EQUIPMENT = 90
}

TAGS = {
    PLAYER = 1,
    ENEMY = 2,
    WALL = 3,
    ORE = 4
}

PROJECTILES = table.create(40, 0)
local projectiles <const> = PROJECTILES

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/crank"
import "CoreLibs/utilities/sampler"
import "scripts/libraries/SceneManager"

import "scripts/data/storedDataManager"
import "scripts/game/gameManager"
import "scripts/title/titleScene"
import "scripts/game/upgradeScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

math.randomseed(pd.getSecondsSinceEpoch())

SCENE_MANAGER = SceneManager()

GameManager()
-- TitleScene()

local spriteUpdate <const> = gfx.sprite.update
local timerUpdate <const> = pd.timer.updateTimers
local drawFPS <const> = pd.drawFPS

gfx.setColor(gfx.kColorWhite)

function pd.update()
    spriteUpdate()
    timerUpdate()
    drawFPS(5, 5)

    for i=1, #projectiles do
        local projectile <const> = projectiles[i]
        if projectile then
            projectile:update()
        end
    end
end
