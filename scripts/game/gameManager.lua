-- Manager class that will handle switching between various scenes
-- (e.g. startScene -> levelScene -> upgradeScene -> levelScene -> upgradeScene -> ... -> gameOverScene)

import "scripts/level/levelScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameManager').extends()

function GameManager:init()
    
end