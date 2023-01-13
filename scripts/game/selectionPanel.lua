local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SelectionPanel').extends(gfx.sprite)

function SelectionPanel:init(choices, isEquipment)
    self.choices = choices
    self.isEquipment = isEquipment

    -- Selection data
    self.selectIndex = 2

    -- Panel Drawing
    self.panelFont = gfx.font.new("fonts/alpha_custom")
    self.upgradePanelImage = gfx.image.new("images/ui/upgradeMenu/upgrade-panel")
    self.upgradeMenuSprite = gfx.sprite.new()

    self.arrowRightImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-right")
    self.arrowLeftImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-left")
    self.upgradeSelectionArrow = gfx.image.new("images/ui/upgradeMenu/upgrade-selection-arrow")
    if isEquipment then
        self.selectedSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-selected")
        self.deselectedSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-deselected")
    else
        self.selectedSlot = gfx.image.new("images/ui/upgradeMenu/buff-slot-selected")
        self.deselectedSlot = gfx.image.new("images/ui/upgradeMenu/buff-slot-deselected")
    end
    self:drawUI()

    self.upgradeMenuSprite:moveTo(200, 133 + 240)
    self.upgradeMenuSprite:add()
    self:animateSprite(self.upgradeMenuSprite, 133, 900, 700, pd.easingFunctions.outBack)

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
    self.titleSprite:setZIndex(10)
    self.titleSprite:moveTo(200, 35 + 240)
    self.titleSprite:add()
    self:animateSprite(self.titleSprite, 35, 900, 500, pd.easingFunctions.outBack)

    -- A Button Drawing
    self.aButtonImage = gfx.image.new("images/ui/upgradeMenu/button-big-a-up")
    self.aButtonImageDown = gfx.image.new("images/ui/upgradeMenu/button-big-a-down")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSprite:setZIndex(10)
    self.aButtonSprite:moveTo(326, 208 + 240)
    self.aButtonSprite:add()
    self:animateSprite(self.aButtonSprite, 208, 900, 1000, pd.easingFunctions.outBack)

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
    if self.selected then
        return nil
    end
    self.selected = true
    self.aButtonSprite:setImage(self.aButtonImageDown)
    pd.timer.new(100, function()
        self.aButtonSprite:setImage(self.aButtonImage)
    end)
    local selectedChoice = self.choices[self.selectIndex]
    return selectedChoice
end

function SelectionPanel:drawUI()
    local upgradePanelImage = self.upgradePanelImage:copy()
    gfx.pushContext(upgradePanelImage)
        local selectedItem = self.choices[self.selectIndex]

        local panelX, panelY = 60, 38
        local slotBaseX, slotBaseY = 88 - panelX, 62 - panelY
        local slotGap = 80
        local selectionArrowBaseX, selectionArrowBaseY = 113 - panelX, 147 - panelY
        local arrowSlotLeftX, arrowSlotLeftY = 156 - panelX, 93 - panelY
        local arrowSlotRightX, arrowSlotRightY = 236 - panelX, 93 - panelY
        for i=1,3 do
            local slotX = slotBaseX + (i-1) * slotGap
            local selectionArrowX = selectionArrowBaseX + (i-1) * slotGap
            if self.selectIndex == i then
                self.selectedSlot:draw(slotX, slotBaseY)
                self.upgradeSelectionArrow:draw(selectionArrowX, selectionArrowBaseY)
            else
                self.deselectedSlot:draw(slotX, slotBaseY)
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
        self.panelFont:drawText("lvl " .. selectedItem.level, levelTextX, levelTextY)

        local descriptionX, descriptionY = 75 - panelX, 176 - panelY
        local descriptionWidth, desciptionHeight = 213, 43
        local lineSpacing = 2
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextInRect(selectedItem.description, descriptionX, descriptionY, descriptionWidth, desciptionHeight, lineSpacing, nil, nil, self.panelFont)
    gfx.popContext()
    self.upgradeMenuSprite:setImage(upgradePanelImage)
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
