COLLISION_GROUPS = {
    PLAYER = 1,
    ENEMY = 2,
    PROJECTILE = 3,
    WALL = 4,
    ORE = 5
}

Z_INDEXES = {
    UI = 32766,
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
-- import "CoreLibs/frameTimer" -- FOR DEBUG
import "CoreLibs/animation"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "CoreLibs/utilities/sampler"
import "scripts/libraries/SceneManager"

import "scripts/audio/sfxPlayer"
import "scripts/audio/musicPlayer"

import "scripts/data/storedDataManager"
import "scripts/game/gameManager"
import "scripts/title/titleScene"
import "scripts/title/unlockScene"
import "scripts/game/upgradeScene"
import "scripts/game/gameOverScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local alphaCustomFont = gfx.font.new("fonts/alpha_custom")
gfx.setFont(alphaCustomFont)
math.randomseed(pd.getSecondsSinceEpoch())

SCENE_MANAGER = SceneManager()
MUSIC_PLAYER = MusicPlayer("title")

DEBUG_KEY = false

-- GameManager()
TitleScene()

local spriteUpdate <const> = gfx.sprite.update
local timerUpdate <const> = pd.timer.updateTimers
-- local frameTimerUpdate <const> = pd.frameTimer.updateTimers -- FOR DEBUG
local drawFPS <const> = pd.drawFPS

gfx.setColor(gfx.kColorWhite)

function pd.update()
    spriteUpdate()
    timerUpdate()
    -- frameTimerUpdate() -- FOR DEBUG
    -- drawFPS(5, 5)

    for i=1, #projectiles do
        local projectile <const> = projectiles[i]
        if projectile then
            projectile:update()
        end
    end
end


-- function playdate.keyPressed(key) -- FOR DEBUG
--     if key == "`" and DEBUG_KEY == false then
--         print("DEBUG KEY PRESSED")
--         DEBUG_KEY = true
--         playdate.frameTimer.new(2, function()
--             DEBUG_KEY = false
--             print("RESET")
--         end)
--     end
-- end
