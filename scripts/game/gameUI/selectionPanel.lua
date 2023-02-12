import "scripts/data/unlockData"
import "scripts/data/equipmentData"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local unlocks <const> = unlocks
local equipment <const> = equipment
local equipmentDisplayNameToKey <const> = {}
for equipmentKey, equipmentData in pairs(equipment) do
    local equipmentDisplayName = equipmentData.name
    equipmentDisplayNameToKey[equipmentDisplayName] = equipmentKey
end

local getEquipmentUnlockLevel = function(equipmentObj)
    local equipmentDisplayName = equipmentObj.name
    local equipmentKey = equipmentDisplayNameToKey[equipmentDisplayName]
    for i=1,#unlocks do
        local unlockData = unlocks[i]
        print("Unlock Name")
        print(unlockData.name)
        print("Equipment Key")
        print(equipmentKey)
        if unlockData.name == equipmentKey then
            return unlockData.level
        end
    end
end

class('SelectionPanel').extends(gfx.sprite)

function SelectionPanel:init(choices, isEquipment, equipmentLevel, addUnlockLevel)
    self.choices = choices
    self.isEquipment = isEquipment
    self.equipmentLevel = equipmentLevel
    self.addUnlockLevel = addUnlockLevel

    -- Selection data
    self.selectIndex = 2

    -- Panel Drawing
    self.panelFont = gfx.font.new("fonts/alpha_custom")
    self.panelImage = gfx.image.new("images/ui/upgradeMenu/upgrade-panel")
    self.selectionPanelSprite = gfx.sprite.new()

    self.icons = {}
    for i=1,3 do
        self.icons[i] = gfx.image.new(choices[i].imagePath)
    end
    self.arrowRightImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-right")
    self.arrowLeftImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-left")
    self.selectionArrow = gfx.image.new("images/ui/upgradeMenu/upgrade-selection-arrow")
    if isEquipment then
        self.selectedSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-selected")
        self.deselectedSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-deselected")
    else
        self.selectedSlot = gfx.image.new("images/ui/upgradeMenu/buff-slot-selected")
        self.deselectedSlot = gfx.image.new("images/ui/upgradeMenu/buff-slot-deselected")
    end
    self:drawUI()

    self.selectionPanelSpriteY = 133
    self.selectionPanelSprite:moveTo(200, self.selectionPanelSpriteY + 240)
    self.selectionPanelSprite:add()
    self:animateSprite(self.selectionPanelSprite, self.selectionPanelSpriteY, 900, 700, pd.easingFunctions.outBack)

    -- Title Drawing
    local titleImage = gfx.image.new("images/ui/upgradeMenu/upgrade-title-holder")
    local titleFont = gfx.font.new("fonts/tall_robot")
    gfx.pushContext(titleImage)
        local titleWidth, titleHeight = titleImage:getSize()
        local fontHeight = titleFont:getHeight()
        local drawX = titleWidth / 2
        local drawY = (titleHeight - fontHeight) / 2
        titleFont:drawTextAligned("Choose Equipment", drawX, drawY, kTextAlignment.center)
    gfx.popContext()
    self.titleSprite = gfx.sprite.new(titleImage)
    self.titleSpriteY = 35
    self.titleSprite:setZIndex(10)
    self.titleSprite:moveTo(200, self.titleSpriteY + 240)
    self.titleSprite:add()
    self:animateSprite(self.titleSprite, self.titleSpriteY, 900, 500, pd.easingFunctions.outBack)

    -- A Button Drawing
    self.aButtonImage = gfx.image.new("images/ui/upgradeMenu/button-big-a-up")
    self.aButtonImageDown = gfx.image.new("images/ui/upgradeMenu/button-big-a-down")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSpriteY = 208
    self.aButtonSprite:setZIndex(10)
    self.aButtonSprite:moveTo(326, self.aButtonSpriteY + 240)
    self.aButtonSprite:add()
    self:animateSprite(self.aButtonSprite, self.aButtonSpriteY, 900, 1000, pd.easingFunctions.outBack)

    self:add()

    self.selected = false
end

function SelectionPanel:selectRight()
    if self.selectIndex < 3 and not self.selected then
        self.selectIndex += 1
        self:drawUI()
    end
end

function SelectionPanel:selectLeft()
    if self.selectIndex > 1 and not self.selected then
        self.selectIndex -= 1
        self:drawUI()
    end
end

function SelectionPanel:select()
    self.selected = true
    self.aButtonSprite:setImage(self.aButtonImageDown)
    pd.timer.new(100, function()
        self.aButtonSprite:setImage(self.aButtonImage)
    end)
    local selectedChoice = self.choices[self.selectIndex]
    return selectedChoice, self:getItemLevel(selectedChoice)
end

function SelectionPanel:getItemLevel(item)
    local itemLevel = item.level
    if self.isEquipment then
        itemLevel = self.equipmentLevel
        if self.addUnlockLevel then
            return itemLevel + getEquipmentUnlockLevel(item)
        end
        local maxLevel = #item.levelStats + 1
        if itemLevel > maxLevel then
            itemLevel = maxLevel
        end
        return itemLevel
    else
        return itemLevel + 1
    end
end

function SelectionPanel:drawUI()
    local panelImage = self.panelImage:copy()
    gfx.pushContext(panelImage)
        local selectedItem = self.choices[self.selectIndex]
        local itemLevel = self:getItemLevel(selectedItem)

        local panelX, panelY = 60, 38
        local slotBaseX, slotBaseY = 88 - panelX, 62 - panelY
        local slotGap = 80
        local selectionArrowBaseX, selectionArrowBaseY = 113 - panelX, 147 - panelY
        local arrowSlotLeftX, arrowSlotLeftY = 156 - panelX, 93 - panelY
        local arrowSlotRightX, arrowSlotRightY = 236 - panelX, 93 - panelY
        local iconBaseX, iconBaseY = 41, 41
        for i=1,3 do
            local slotX = slotBaseX + (i-1) * slotGap
            local selectionArrowX = selectionArrowBaseX + (i-1) * slotGap
            if self.selectIndex == i then
                self.selectedSlot:draw(slotX, slotBaseY)
                self.selectionArrow:draw(selectionArrowX, selectionArrowBaseY)
            else
                self.deselectedSlot:draw(slotX, slotBaseY)
            end
            local iconX = iconBaseX + (i-1) * slotGap
            local iconImage = self.icons[i]
            if iconImage then
                iconImage:draw(iconX, iconBaseY)
            end
        end
        if self.selectIndex == 1 then
            self.arrowRightImage:draw(arrowSlotLeftX, arrowSlotLeftY)
        elseif self.selectIndex == 2 then
            self.arrowLeftImage:draw(arrowSlotLeftX, arrowSlotLeftY)
            self.arrowRightImage:draw(arrowSlotRightX, arrowSlotRightY)
        elseif self.selectIndex == 3 then
            self.arrowLeftImage:draw(arrowSlotRightX, arrowSlotRightY)
        end

        local itemTextX, itemTextY = 74 - panelX, 158 - panelY
        self.panelFont:drawText(selectedItem.name, itemTextX, itemTextY)
        local levelTextX, levelTextY = 293 - panelX, 158 - panelY
        self.panelFont:drawText("lvl " .. itemLevel, levelTextX, levelTextY)

        local descriptionX, descriptionY = 75 - panelX, 176 - panelY
        local descriptionWidth, descriptionHeight = 213, 43
        local lineSpacing = 2
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        local description = selectedItem.description
        if not self.isEquipment then
            local amount = (itemLevel - 1) * selectedItem.scaling + selectedItem.value
            local amountText = tostring(amount)
            if selectedItem.percent then
                amountText = tostring(amount*100) .. "%%" 
            end
            description = description:gsub("{}", amountText)
        end
        gfx.drawTextInRect(description, descriptionX, descriptionY, descriptionWidth, descriptionHeight, lineSpacing, nil, nil, self.panelFont)
    gfx.popContext()
    self.selectionPanelSprite:setImage(panelImage)
end

function SelectionPanel:animateOut()
    local animateTime = 500
    self:animateSprite(self.aButtonSprite, self.aButtonSpriteY - 400, animateTime, 100, pd.easingFunctions.inBack)
    self:animateSprite(self.titleSprite, self.titleSpriteY - 400, animateTime, 300, pd.easingFunctions.inBack)
    self:animateSprite(self.selectionPanelSprite, self.selectionPanelSpriteY - 400, animateTime, 500, pd.easingFunctions.inBack)
end

function SelectionPanel:animateSprite(sprite, endY, time, delay, easingFunction)
    local animateTimer = pd.timer.new(time, sprite.y, endY, easingFunction)
    animateTimer.easingAmplitude = 1.2
    animateTimer.updateCallback = function(timer)
        sprite:moveTo(sprite.x, timer.value)
    end
    animateTimer:pause()
    pd.timer.performAfterDelay(delay, function()
        animateTimer:start()
    end)
    return animateTimer
end
