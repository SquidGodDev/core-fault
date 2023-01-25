-- Manager class that will handle switching between various scenes
-- (e.g. startScene -> levelScene -> upgradeScene -> levelScene -> upgradeScene -> ... -> gameOverScene)

import "scripts/level/levelScene"
import "scripts/game/startScene"
import "scripts/game/gameOverScene"
import "scripts/game/upgradeScene"

import "scripts/data/upgradeData"
import "scripts/data/equipmentData"

local totalGameTime <const> = 60000

local upgrades <const> = upgrades
local equipment <const> = equipment

class('GameManager').extends()

function GameManager:init()
    self.sceneManager = SCENE_MANAGER
    self.curLevel = 1
    self.minedOre = 0
    self.enemiesDefeated = 0
    self.time = totalGameTime
    -- TODO: Pass in upgrades as argument from unlocks purchased with Ore
    self.upgrades = {}
    self.equipment = {}
    StartScene(self)
end

function GameManager:startEquipmentSelected(selectedEquipment)
    table.insert(self.equipment, selectedEquipment)
    self.sceneManager:switchScene(LevelScene, self, self.curLevel, self.time)
end

function GameManager:upgradesSelected(selectedUpgrade, selectedEquipment, swappedIndex)
    if selectedUpgrade then
        table.insert(self.upgrades, selectedUpgrade)
    end
    if selectedEquipment then
        self.equipment[swappedIndex] = selectedEquipment
    end
    self.sceneManager:switchScene(LevelScene, self, self.curLevel, self.time)
end

function GameManager:levelDefeated(time, enemiesDefeated)
    self.enemiesDefeated += enemiesDefeated
    if time <= 0 then
        self.sceneManager:switchScene(GameOverScene, self.equipment, self.upgrades, totalGameTime - time, self.curLevel, self.enemiesDefeated, self.minedOre)
        return
    end
    self.time = time
    self.curLevel += 1
    self.sceneManager:switchScene(UpgradeScene, self)
end