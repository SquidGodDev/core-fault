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

    -- TODO: Replace dummy equipment with what's available and level
    local allEquipment = {}
    local availableEquipment = {}
    for _, equipment in pairs(equipment) do
        table.insert(allEquipment, equipment)
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
        self.equipmentPanel = SelectionPanel(availableEquipment, true, #gameManager.equipment == 3)
    end

    self.selectedUpgrade = nil
    self.selectedNewEquipment = nil

    self:add()
end

function UpgradeScene:update()
    local crankTicks = pd.getCrankTicks(3)
    if self.state == states.upgradeSelect then
        if pd.buttonJustPressed(pd.kButtonLeft) or crankTicks == -1 then
            self.upgradePanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or crankTicks == 1 then
            self.upgradePanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            self.selectedUpgrade = self.upgradePanel:select()
            self.upgradePanel:animateOut()
            self.selectedUpgrade.level += 1
            self.gameManager:upgradesSelected(self.selectedUpgrade, nil, nil)
            self.state = states.finished
        end
    elseif self.state == states.equipmentSelect then
        if pd.buttonJustPressed(pd.kButtonLeft) or crankTicks == -1 then
            self.equipmentPanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or crankTicks == 1 then
            self.equipmentPanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            self.selectedNewEquipment = self.equipmentPanel:select()
            self.equipmentPanel:animateOut()
            local equipmentTableLength = #self.gameManager.equipment
            if equipmentTableLength < 3 then
                self.gameManager:upgradesSelected(nil, self.selectedNewEquipment, equipmentTableLength + 1)
                self.state = states.finished
            else
                self.equipmentSwapPanel = SwapPanel(self.selectedNewEquipment, self.gameManager.equipment)
                self.equipmentSwapPanel:animateIn()
                self.state = states.equipmentSwap
            end
        end
    elseif self.state == states.equipmentSwap then
        if pd.buttonJustPressed(pd.kButtonLeft) or pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
            self.equipmentSwapPanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
            self.equipmentSwapPanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            local swappedIndex = self.equipmentSwapPanel:select()
            self.state = states.finished
            self.selectedNewEquipment.level += 1
            self.gameManager:upgradesSelected(nil, self.selectedNewEquipment, swappedIndex)
        end
    end
end