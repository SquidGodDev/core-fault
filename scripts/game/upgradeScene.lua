-- Scene between levels where the player gets new equipment and upgrades
import "scripts/game/gameUI/selectionPanel"
import "scripts/game/gameUI/streakBackground"
import "scripts/game/gameUI/swapPanel"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

class('UpgradeScene').extends(gfx.sprite)

function UpgradeScene:init(gameManager)
    self.gameManager = gameManager

    -- TODO: Replace dummy available upgrades with randomized upgrades
    -- based on what's available and level
    local allUpgrades = {}
    local dummyAvailableUpgrades = {}
    for _, upgrade in pairs(upgrades) do
        table.insert(allUpgrades, upgrade)
    end
    ShuffleInPlace(allUpgrades)
    for i=1,3 do
        dummyAvailableUpgrades[i] = allUpgrades[i]
    end

    StreakBackground()

    self.upgradePanel = SelectionPanel(dummyAvailableUpgrades, false)

    -- TODO: Replace dummy equipment with game equipment and new
    -- equipment with what's available and level
    local allEquipment = {}
    local dummyEquipment = {}
    for _, equipment in pairs(equipment) do
        table.insert(allEquipment, equipment)
    end
    ShuffleInPlace(allEquipment)
    for i=1,3 do
        dummyEquipment[i] = allEquipment[i]
    end
    local dummyNewEquipment = allEquipment[4]
    self.equipmentPanel = SwapPanel(dummyNewEquipment, dummyEquipment)

    self.selectingUpgrade = true
    self.selectingEquipment = false

    self:add()
end

function UpgradeScene:update()
    if self.selectingUpgrade then
        if pd.buttonJustPressed(pd.kButtonLeft) then
            self.upgradePanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) then
            self.upgradePanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            -- TODO: Pass in selected upgrades
            local selectedUpgrade = self.upgradePanel:select()
            self.selectingUpgrade = false
            self.selectingEquipment = true
            self.equipmentPanel:animateIn()
            self.upgradePanel:animateOut()
        end
    elseif self.selectingEquipment then
        if pd.buttonJustPressed(pd.kButtonLeft) or pd.buttonJustPressed(pd.kButtonUp) then
            self.equipmentPanel:selectLeft()
        elseif pd.buttonJustPressed(pd.kButtonRight) or pd.buttonJustPressed(pd.kButtonDown) then
            self.equipmentPanel:selectRight()
        elseif pd.buttonJustPressed(pd.kButtonA) then
            local selectedEquipment, swappedIndex = self.equipmentPanel:select()
            self.selectingEquipment = false
            -- TODO: Pass in selected equipment
            self.gameManager:upgradesSelected()
        end
    end
end