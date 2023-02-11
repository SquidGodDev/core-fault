-- Manager class that will handle switching between various scenes
-- (e.g. startScene -> levelScene -> upgradeScene -> levelScene -> upgradeScene -> ... -> gameOverScene)

import "scripts/level/levelScene"
import "scripts/game/startScene"
import "scripts/game/gameOverScene"
import "scripts/game/upgradeScene"

import "scripts/data/upgradeData"
import "scripts/data/equipmentData"

local totalGameTime <const> = 600000

local unlocks <const> = unlocks
local upgrades <const> = upgrades
local equipment <const> = equipment

local function findInTable(table, name)
    for i=1, #table do
        if table[i].name == name then
            return i
        end
    end
    return -1
end

class('GameManager').extends()

function GameManager:init()
    self.sceneManager = SCENE_MANAGER
    self.curLevel = 1
    self.minedOre = 0
    self.enemiesDefeated = 0
    self.time = totalGameTime
    self.upgrades = {}
    self.equipment = {}
    self:resetEquipmentAndUpgradeData()
    StartScene(self)
end

function GameManager:startEquipmentSelected(selectedEquipment)
    table.insert(self.equipment, selectedEquipment)
    self.sceneManager:switchScene(LevelScene, self, self.curLevel, self.time)
end

function GameManager:upgradesSelected(selectedUpgrade, selectedEquipment, swappedIndex)
    if selectedUpgrade then
        local upgradeIndex = findInTable(self.upgrades, selectedUpgrade.name)
        if upgradeIndex ~= -1 then
            self.upgrades[upgradeIndex] = selectedUpgrade
        else
            table.insert(self.upgrades, selectedUpgrade)
        end
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
    self.sceneManager:switchScene(UpgradeScene, self, self.curLevel)
end

function GameManager:playerDied(time, enemiesDefeated)
    self.enemiesDefeated += enemiesDefeated
    self.sceneManager:switchScene(GameOverScene, self.equipment, self.upgrades, totalGameTime - time, self.curLevel, self.enemiesDefeated, self.minedOre)
end

function GameManager:resetEquipmentAndUpgradeData()
    for i=1,#unlocks do
        local unlockData = unlocks[i]
        if unlockData.isEquipment then
            equipment[unlockData.name].level = 1
        else
            local upgradeData = upgrades[unlockData.name]
            upgradeData.level = unlockData.level
            if unlockData.level ~= 0 then
                table.insert(self.upgrades, upgradeData)
            end
        end
    end
end