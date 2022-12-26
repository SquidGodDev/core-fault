-- Manager class that will handle switching between various scenes
-- (e.g. startScene -> levelScene -> upgradeScene -> levelScene -> upgradeScene -> ... -> gameOverScene)

import "scripts/level/levelScene"
import "scripts/game/startScene"
import "scripts/game/gameOverScene"
import "scripts/game/upgradeScene"

import "scripts/data/upgradeData"
import "scripts/data/equipmentData"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local upgrades <const> = upgrades
local equipment <const> = equipment

class('GameManager').extends()

function GameManager:init()
    self.sceneManager = SCENE_MANAGER
    self.curLevel = 1
    self.minedOre = 0
    -- TODO: Pass in upgrades as argument from unlocks purchased with Ore
    self.upgrades = {}
    self.equipment = {equipment.plasmaCannon, equipment.radioWaves}
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