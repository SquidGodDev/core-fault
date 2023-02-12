-- Scene between levels where the player gets new equipment and upgrades
import "scripts/game/gameUI/selectionPanel"
import "scripts/game/gameUI/streakBackground"
import "scripts/game/gameUI/swapPanel"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local states <const> = {
    upgradeSelect = 1,
    equipmentSelect = 2,
    equipmentSwap = 3,
    finished = 4
}

local function shuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function findInTable(table, object)
    for i=1, #table do
        if table[i].name == object.name then
            return true
        end
    end
    return false
end

class('UpgradeScene').extends(gfx.sprite)

function UpgradeScene:init(gameManager, curLevel)
    self.gameManager = gameManager

    StreakBackground()

    local allUpgrades = {}
    local availableUpgrades = {}
    for _, upgrade in pairs(upgrades) do
        if upgrade.level ~= upgrade.maxLevel then
            table.insert(allUpgrades, upgrade)
        end
    end
    shuffleInPlace(allUpgrades)
    for i=1,3 do
        availableUpgrades[i] = allUpgrades[i]
    end

    local allEquipment = {}
    local availableEquipment = {}
    for _, equipment in pairs(equipment) do
        if not findInTable(self.gameManager.equipment, equipment) then
            table.insert(allEquipment, equipment)
        end
    end
    shuffleInPlace(allEquipment)
    for i=1,3 do
        availableEquipment[i] = allEquipment[i]
    end

    if curLevel % 2 == 0 then
        self.state = states.upgradeSelect
        self.upgradePanel = SelectionPanel(availableUpgrades, false)
    else
        self.state = states.equipmentSelect
        local equipmentLevel = 1
        if curLevel >= 7 then
            equipmentLevel = math.floor((curLevel - 3)/2)
        end
        self.equipmentPanel = SelectionPanel(availableEquipment, true, equipmentLevel, curLevel >= 7)
    end

    self.selectedUpgrade = nil
    self.selectedNewEquipment = nil
    self.selectedNewEquipmentLevel = nil

    self:add()

    self.menuMoveSound = SfxPlayer("sfx-menu-move")
    self.menuSelectSound = SfxPlayer("sfx-menu-select")
end

function UpgradeScene:update()
    local crankTicks = pd.getCrankTicks(3)
    if self.state == states.upgradeSelect then
        if pd.buttonJustPressed(pd.kButtonLeft) or crankTicks == -1 then
            self.menuMoveSound:play()
            self.upgradePanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or crankTicks == 1 then
            self.menuMoveSound:play()
            self.upgradePanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            self.menuSelectSound:play()
            self.selectedUpgrade = self.upgradePanel:select()
            self.upgradePanel:animateOut()
            self.selectedUpgrade.level += 1
            self.gameManager:upgradesSelected(self.selectedUpgrade, nil, nil)
            self.state = states.finished
        end
    elseif self.state == states.equipmentSelect then
        if pd.buttonJustPressed(pd.kButtonLeft) or crankTicks == -1 then
            self.menuMoveSound:play()
            self.equipmentPanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or crankTicks == 1 then
            self.menuMoveSound:play()
            self.equipmentPanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            self.menuSelectSound:play()
            self.selectedNewEquipment, self.selectedNewEquipmentLevel = self.equipmentPanel:select()
            self.equipmentPanel:animateOut()
            local equipmentTableLength = #self.gameManager.equipment
            if equipmentTableLength < 3 then
                self.gameManager:upgradesSelected(nil, self.selectedNewEquipment, equipmentTableLength + 1)
                self.state = states.finished
            else
                self.equipmentSwapPanel = SwapPanel(self.selectedNewEquipment, self.gameManager.equipment, self.selectedNewEquipmentLevel)
                self.equipmentSwapPanel:animateIn()
                self.state = states.equipmentSwap
            end
        end
    elseif self.state == states.equipmentSwap then
        if pd.buttonJustPressed(pd.kButtonLeft) or pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
            self.menuMoveSound:play()
            self.equipmentSwapPanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
            self.menuMoveSound:play()
            self.equipmentSwapPanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            self.menuSelectSound:play()
            local swappedIndex = self.equipmentSwapPanel:select()
            self.state = states.finished
            self.selectedNewEquipment.level += 1
            self.gameManager:upgradesSelected(nil, self.selectedNewEquipment, swappedIndex)
        end
    end
end