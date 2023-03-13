-- Scene for where the player spends ore to unlock permanent buffs
import "scripts/data/unlockData"
import "scripts/data/equipmentData"
import "scripts/data/upgradeData"
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local unlocks <const> = unlocks
local equipment <const> = equipment
local upgrades <const> = upgrades

local disketteImage <const> = gfx.image.new("images/ui/unlockMenu/unlock-diskette")
local unlockCostHolder <const> = gfx.image.new("images/ui/unlockMenu/unlock-cost-holder")
local unlockItemHolder <const> = gfx.image.new("images/ui/unlockMenu/unlock-item-holder")
local coreImage <const> = gfx.image.new("images/ui/summary/summary-icon-cores")
local aButton <const> = gfx.image.new("images/ui/upgradeMenu/button-big-a-up")
local aButtonPressed <const> = gfx.image.new("images/ui/upgradeMenu/button-big-a-down")
local upArrow <const> = gfx.image.new("images/ui/swapMenu/swap-arrow-up")
local downArrow <const> = gfx.image.new("images/ui/swapMenu/swap-arrow-down")

local itemIcons <const> = gfx.imagetable.new("images/ui/unlockMenu/unlock-item-icon-table-18-18")
local getItemIcon <const> = function(index)
    local unlock = unlocks[index]
    if unlock.level == unlock.maxLevel then
        return itemIcons:getImage(5)
    elseif unlock.level >= 1 then
        if TOTAL_CORES >= unlock.cost[unlock.level + 1] then
            return itemIcons:getImage(4)
        else
            return itemIcons:getImage(3)
        end
    else
        if TOTAL_CORES >= unlock.cost[unlock.level + 1] then
            return itemIcons:getImage(2)
        else
            return itemIcons:getImage(1)
        end
    end
end

local getUpgradeDescription = function(upgrade, level)
    local amount = (level - 1) * upgrade.scaling + upgrade.value
    local amountText = tostring(amount)
    if upgrade.percent then
        amountText = tostring(amount*100) .. "%%" 
    end
    local description = upgrade.description
    description = description:gsub("{}", amountText)
    return description
end

-- Returns Name, Description, Level, Max Level, Cost
local getUnlockData <const> = function(unlock)
    local cost = unlock.cost[unlock.level + 1]
    if unlock.isEquipment then
        local equipmentData = equipment[unlock.name]
        local name = equipmentData.name
        local maxLevel = unlock.maxLevel
        local level = unlock.level
        local equipmentLevelDescription = "Starts at level " .. level+2 .. ". "
        local description = equipmentLevelDescription .. equipmentData.description
        return name, description, level, maxLevel, cost
    else
        local upgradeData = upgrades[unlock.name]
        local name = upgradeData.name
        local description = getUpgradeDescription(upgradeData, unlock.level+1)
        local maxLevel = unlock.maxLevel
        local level = unlock.level
        return name, description, level, maxLevel, cost
    end
end

local unlockIcons <const> = {}
for i=1,#unlocks do
    local unlock = unlocks[i]
    if unlock.isEquipment then
        local equipmentImagePath = equipment[unlock.name].imagePath
        unlockIcons[i] = gfx.image.new(equipmentImagePath)
    else
        local equipmentImagePath = upgrades[unlock.name].imagePath
        unlockIcons[i] = gfx.image.new(equipmentImagePath)
    end
end

class('UnlockScene').extends(gfx.sprite)

function UnlockScene:init()
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(function()
        blackImage:draw(0, 0)
    end)

    local scrollbarImage = gfx.image.new("images/ui/unlockMenu/unlock-scrollbar")
    self.scrollbarSprite = gfx.sprite.new(scrollbarImage)
    self.scrollbarSprite:setCenter(0, 0)
    self.scrollbarSprite:moveTo(0, 0)
    self.scrollbarSprite:add()

    self.scrollbarPadding = 5
    self.scrollbarWidth = 27
    self.scrollbarList = pd.ui.gridview.new(self.scrollbarWidth, 18)
    self.scrollbarList:setNumberOfRows(#unlocks + self.scrollbarPadding * 2)
    self.scrollbarList:setCellPadding(0, 0, 0, 9)
    self.scrollbarList:scrollToRow(self.scrollbarPadding + 1, false)
    self.scrollbarList:setSelectedRow(self.scrollbarPadding + 1)

    local scrollbarObject = getmetatable(self.scrollbarList)
    scrollbarObject.scrollbarPadding = self.scrollbarPadding

    self.scrollbarListSprite = gfx.sprite.new()
    self.scrollbarListSprite:setCenter(0, 0)
    self.scrollbarListSprite:moveTo(0, 5)
    self.scrollbarListSprite:add()

    function self.scrollbarList:drawCell(section, row, column, selected, x, y, width, height)
        row -= self.scrollbarPadding
        local unlock = unlocks[row]
        if unlock then
            local icon = getItemIcon(row)
            icon:draw(x + 5, y)
        end
    end

    self.unlockPadding = 1
    self.unlockWidth = 349
    self.unlockList = pd.ui.gridview.new(self.unlockWidth, 113)
    self.unlockList:setNumberOfRows(#unlocks + self.unlockPadding * 2)
    self.unlockList:setCellPadding(0, 0, 12, 3)
    self.unlockList:scrollToRow(self.unlockPadding + 1, false)
    self.unlockList:setSelectedRow(self.unlockPadding + 1)

    self.unlockListObject = getmetatable(self.unlockList)
    self.unlockListObject.unlockPadding = self.unlockPadding
    self.unlockListObject.aPressed = false
    self.unlockListObject.buttonActive = false

    self.unlockListSprite = gfx.sprite.new()
    self.unlockListSprite:setCenter(0, 0)
    self.unlockListOffset = 0
    self.unlockListSprite:moveTo(51, self.unlockListOffset)
    self.unlockListSprite:add()

    function self.unlockList:drawCell(section, row, column, selected, x, y, width, height)
        row -= self.unlockPadding
        local unlock = unlocks[row]
        if unlock then
            local icon = unlockIcons[row]
            unlockItemHolder:draw(x, y + 12)
            icon:drawAnchored(x + 31, y + 42, 0.5, 0.5)
            local name, description, level, maxLevel, cost = getUnlockData(unlock)
            gfx.pushContext()
                gfx.drawText(name, x + 66, y + 19)
                gfx.drawText(level .. "/" .. maxLevel, x + 293, y + 19)
                if level == maxLevel then
                    description = "**MAX LEVEL**"
                else
                    unlockCostHolder:draw(x + 211, y+ 77)
                    coreImage:draw(x + 235, y+ 83)
                    gfx.drawText(cost, x + 255, y+ 87)
                end

                if selected then
                    local topX, topY = x + 156, y + 0
                    local bottomX, bottomY = x + 156, y + 92
                    if row ~= 1 then
                        upArrow:draw(topX, topY)
                    end
                    if row ~= #unlocks then
                        downArrow:draw(bottomX, bottomY)
                    end
                    if (TOTAL_CORES >= cost and level < maxLevel) or self.buttonActive then
                        if self.aPressed then
                            aButtonPressed:draw(x + 290, y + 55)
                        else
                            aButton:draw(x + 290, y + 55)
                        end
                    end
                end

                gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
                gfx.drawTextInRect(description, x + 67, y + 35, 212, 43)
            gfx.popContext()
        end
    end

    local unlockSelectorImage = gfx.image.new("images/ui/unlockMenu/unlock-selector")
    self.unlockSelectorSprite = gfx.sprite.new(unlockSelectorImage)
    self.unlockSelectorSprite:setCenter(0, 0)
    self.unlockSelectorSprite:moveTo(29, 54)
    self.unlockSelectorSprite:add()

    self.coresHolderImage = gfx.image.new("images/ui/unlockMenu/player-cores-holder")
    gfx.pushContext(self.coresHolderImage)
        coreImage:draw(6, 5)
    gfx.popContext()
    self.coresSprite = gfx.sprite.new()
    self.coresSprite:setCenter(0, 0)
    self.coresSprite:moveTo(0, 0)
    self.coresSprite:add()

    self.updateDisplay = false

    self:add()

    self:animateIn()

    self.menuMoveSound = SfxPlayer("sfx-menu-move")
    self.menuSelectSound = SfxPlayer("sfx-menu-select")
    self.menuBackSound = SfxPlayer("sfx-menu-back")

    self.transitioningOut = false
end

function UnlockScene:animateIn()
    self:createAnimator(self.scrollbarSprite, -27, true, 300, 0)
    self:createAnimator(self.scrollbarListSprite, 200, false, 800, 50)
    self:createAnimator(self.unlockListSprite, 360, true, 1000, 400)
    self:createAnimator(self.unlockSelectorSprite, -200, false, 1000, 500)
    self:createAnimator(self.coresSprite, -30, false, 700, 1100)
end

function UnlockScene:animateOut()
    self:createAnimator(self.coresSprite, -30, false, 700, 0, true)
    self:createAnimator(self.unlockSelectorSprite, -200, false, 1000, 50, true)
    self:createAnimator(self.unlockListSprite, 360, true, 1000, 400, true)
    self:createAnimator(self.scrollbarListSprite, 200, false, 800, 500, true)
    self:createAnimator(self.scrollbarSprite, -27, true, 300, 1100, true)
end

function UnlockScene:createAnimator(sprite, offset, horizontal, time, delay, out)
    local startVal, endVal
    if horizontal then
        if out then
            startVal = sprite.x
            endVal = sprite.x + offset
        else
            startVal = sprite.x + offset
            endVal = sprite.x
        end
        sprite:moveTo(startVal, sprite.y)
    else
        if out then
            startVal = sprite.y
            endVal = sprite.y + offset
        else
            startVal = sprite.y + offset
            endVal = sprite.y
        end
        sprite:moveTo(sprite.x, startVal)
    end
    pd.timer.performAfterDelay(delay, function()
        local moveTimer = pd.timer.new(time, startVal, endVal, pd.easingFunctions.inOutCubic)
        moveTimer.updateCallback = function(timer)
            if horizontal then
                sprite:moveTo(timer.value, sprite.y)
            else
                sprite:moveTo(sprite.x, timer.value)
            end
        end
    end)
end

function UnlockScene:update()
    local coreSpriteImage = self.coresHolderImage:copy()
    gfx.pushContext(coreSpriteImage)
        gfx.drawText(TOTAL_CORES, 28, 9)
    gfx.popContext()
    self.coresSprite:setImage(coreSpriteImage)

    if pd.buttonJustPressed(pd.kButtonA) then
        local selectedUnlockIndex = self.scrollbarList:getSelectedRow() - self.scrollbarPadding
        local selectedUnlock = unlocks[selectedUnlockIndex]
        if selectedUnlock then
            local _, _, level, maxLevel, cost = getUnlockData(selectedUnlock)
            if level < maxLevel and TOTAL_CORES >= cost then
                self.menuSelectSound:play()
                TOTAL_CORES -= cost
                selectedUnlock.level += 1
                self.unlockList.aPressed = true
                self.unlockList.buttonActive = true
                self.updateDisplay = true
                pd.timer.performAfterDelay(50, function()
                    self.unlockList.aPressed = false
                    self.updateDisplay = true
                end)
                pd.timer.performAfterDelay(100, function()
                    self.unlockList.buttonActive = false
                    self.updateDisplay = true
                end)
            end
        end
    elseif pd.buttonJustPressed(pd.kButtonB) and not self.transitioningOut then
        self.transitioningOut = true
        self:animateOut()
        SCENE_MANAGER:switchScene(TitleScene)
        self.menuBackSound:play()
    end

    local crankTicks = pd.getCrankTicks(2)

    if pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
        local selectedRow = self.scrollbarList:getSelectedRow()
        if selectedRow > self.scrollbarPadding + 1 then
            self.menuMoveSound:play()
            self.scrollbarList:selectPreviousRow(false)
            self.unlockList:selectPreviousRow(false)
        end
    elseif pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
        local selectedRow = self.scrollbarList:getSelectedRow()
        if selectedRow < self.scrollbarPadding + #unlocks then
            self.menuMoveSound:play()
            self.scrollbarList:selectNextRow(false)
            self.unlockList:selectNextRow(false)
        end
    end
    if self.scrollbarList.needsDisplay or self.updateDisplay then
        local scrollbarListImage = gfx.image.new(self.scrollbarWidth, 240)
        gfx.pushContext(scrollbarListImage)
            self.scrollbarList:drawInRect(0, 0, self.scrollbarWidth, 240)
        gfx.popContext()
        self.scrollbarListSprite:setImage(scrollbarListImage)
    end
    if self.unlockList.needsDisplay or self.updateDisplay then
        local unlockListImage = gfx.image.new(self.unlockWidth, 240 - self.unlockListOffset)
        gfx.pushContext(unlockListImage)
            self.unlockList:drawInRect(0, 0, self.unlockWidth, 240 - self.unlockListOffset)
        gfx.popContext()
        self.unlockListSprite:setImage(unlockListImage)
    end
    self.updateDisplay = false

    -- if DEBUG_KEY then -- FOR DEBUG
    --     for i=1, #unlocks do
    --         unlocks[i].level = 0
    --     end
    --     TOTAL_CORES = 999
    -- end
end