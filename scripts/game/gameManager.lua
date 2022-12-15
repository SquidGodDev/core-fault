-- Manager class that will handle switching between various scenes
-- (e.g. startScene -> levelScene -> upgradeScene -> levelScene -> upgradeScene -> ... -> gameOverScene)

import "scripts/level/levelScene"
import "scripts/game/startScene"
import "scripts/game/gameOverScene"
import "scripts/game/upgradeScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameManager').extends()

function GameManager:init()
    self.sceneManager = SCENE_MANAGER
    self.curLevel = 1
    StartScene(self)
end

function GameManager:startEquipmentSelected()
    self.sceneManager:switchScene(LevelScene, self, self.curLevel)
end

function GameManager:upgradesSelected()
    self.sceneManager:switchScene(LevelScene, self, self.curLevel)
end

function GameManager:levelDefeated()
    self.curLevel += 1
    self.sceneManager:switchScene(UpgradeScene, self)
end

function GameManager:runEnded()
    self.sceneManager:switchScene(GameOverScene)
end