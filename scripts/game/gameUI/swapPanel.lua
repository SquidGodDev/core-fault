local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SwapPanel').extends(gfx.sprite)

function SwapPanel:init(newEquipment, curEquipment)
    self.newEquipment = newEquipment
    self.curEquipment = curEquipment

    -- Selection data
    self.selectIndex = 2
    self.selected = false

    -- Panel Drawing
    self.panelFont = gfx.font.new("fonts/alpha_custom")
    self.panelImage = gfx.image.new("images/ui/swapMenu/swap-panel")
    self.menuSprite = gfx.sprite.new()
    self.menuX = 200
    self.menuY = 120
    self.menuSprite:moveTo(self.menuX, self.menuY + 240)
    self.menuSprite:add()

    self.newEquipmentSprite = gfx.sprite.new()
    self.newEquipmentSprite:setZIndex(20)
    self.newEquipmentY = 102
    self.newEquipmentX = 251
    self.newEquipmentSprite:moveTo(self.newEquipmentX, self.newEquipmentY + 240)
    self.newEquipmentSprite:add()

    self.newEquipmentAnimator = pd.timer.new(1500, 0, 2 * math.pi)
    self.newEquipmentAnimator:pause()
    self.newEquipmentAnimator.updateCallback = function(timer)
        self.newEquipmentSprite:moveTo(self.newEquipmentX, self.newEquipmentY - 3 * math.sin(timer.value))
    end
    self.newEquipmentAnimator.repeats = true

    self.upArrowImage = gfx.image.new("images/ui/swapMenu/swap-arrow-up")
    self.downArrowImage = gfx.image.new("images/ui/swapMenu/swap-arrow-down")
    self.slotImage = gfx.image.new("images/ui/upgradeMenu/equipment-slot-deselected")
    self.swapSelect1 = gfx.image.new("images/ui/swapMenu/swap-select-1")
    self.swapSelect2 = gfx.image.new("images/ui/swapMenu/swap-select-2")
    self.swapSelect3 = gfx.image.new("images/ui/swapMenu/swap-select-3")
    self.equipmentImages = {}
    for i=1,3 do
        self.equipmentImages[i] = gfx.image.new(self.curEquipment[i].imagePath)
    end
    self.swapHolderOld = gfx.image.new("images/ui/swapMenu/swap-holder-old")
    self.swapHolderNew = gfx.image.new("images/ui/swapMenu/swap-holder-new")

    self:drawUI()

    local newEquipmentPanel = self.swapHolderNew:copy()
    gfx.pushContext(newEquipmentPanel)
        local newItemTextX, newItemTextY = 14, 27
        self.panelFont:drawText(self.newEquipment.name, newItemTextX, newItemTextY)
        local newLevelTextX, newLevelTextY = 241, 27
        self.panelFont:drawText("lvl " .. self.newEquipment.level, newLevelTextX, newLevelTextY)

        local newItemDescriptionX, newItemDescriptionY = 15, 43
        local newDescriptionWidth, newDescriptionHeight = 213, 43
        local lineSpacing = 2
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextInRect(
            self.newEquipment.description,
            newItemDescriptionX,
            newItemDescriptionY,
            newDescriptionWidth,
            newDescriptionHeight,
            lineSpacing,
            nil,
            nil,
            self.panelFont
        )
    gfx.popContext()
    self.newEquipmentSprite:setImage(newEquipmentPanel)

    -- Title Drawing
    local titleImage = gfx.image.new("images/ui/swapMenu/swap-title-holder")
    local titleFont = gfx.font.new("fonts/tall_robot")
    gfx.pushContext(titleImage)
        local titleWidth, titleHeight = titleImage:getSize()
        local fontHeight = titleFont:getHeight()
        local drawX = titleWidth / 2
        local drawY = (titleHeight - fontHeight) / 2
        titleFont:drawTextAligned("Replace Equipment", drawX, drawY, kTextAlignment.center)
    gfx.popContext()
    self.titleSprite = gfx.sprite.new(titleImage)
    self.titleSprite:setZIndex(10)
    self.titleY = 32
    self.titleX = 241
    self.titleSprite:moveTo(self.titleX, self.titleY + 240)
    self.titleSprite:add()

    -- A Button Drawing
    self.aButtonImage = gfx.image.new("images/ui/upgradeMenu/button-big-a-up")
    self.aButtonImageDown = gfx.image.new("images/ui/upgradeMenu/button-big-a-down")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSprite:setZIndex(10)
    self.aButtonY = 203
    self.aButtonX = 368
    self.aButtonSprite:moveTo(self.aButtonX, self.aButtonY + 240)
    self.aButtonSprite:add()
end

function SwapPanel:selectRight()
    if self.selectIndex < 3 and not self.selected then
        self.selectIndex += 1
        self:drawUI()
    end
end

function SwapPanel:selectLeft()
    if self.selectIndex > 1 and not self.selected then
        self.selectIndex -= 1
        self:drawUI()
    end
end

function SwapPanel:select()
    if self.selected then
        return nil
    end
    self.selected = true
    self.aButtonSprite:setImage(self.aButtonImageDown)
    pd.timer.new(100, function()
        self.aButtonSprite:setImage(self.aButtonImage)
    end)
    local selectedChoice = self.newEquipment[self.selectIndex]
    return selectedChoice, self.selectIndex
end

function SwapPanel:drawUI()
    local selectedEquipment = self.curEquipment[self.selectIndex]
    local panelImage = gfx.image.new(400, 240)
    gfx.pushContext(panelImage)
        local panelX, panelY = 38, 22
        self.panelImage:draw(panelX, panelY)

        local slotBaseX, slotBaseY = 8, 4
        local slotGap = 78

        local slotImageBaseX, slotImageBaseY = 20, 19
        local slotImageGap = 79

        local arrowSlotX = 31
        local arrowSlotTopY, arrowSlotBottomY = 70, 157

        local swapSelectX, swapSelectY = 46, 4

        local swapHolderX, swapHolderY = 92, 149

        for i=1,3 do
            local slotY = slotBaseY + (i-1) * slotGap
            self.slotImage:draw(slotBaseX, slotY)
            local slotImageY = slotImageBaseY + (i-1) * slotImageGap
            self.equipmentImages[i]:draw(slotImageBaseX, slotImageY)
        end

        if self.selectIndex == 1 then
            self.downArrowImage:draw(arrowSlotX, arrowSlotTopY)
            self.swapSelect1:draw(swapSelectX, swapSelectY)
        elseif self.selectIndex == 2 then
            self.upArrowImage:draw(arrowSlotX, arrowSlotTopY)
            self.downArrowImage:draw(arrowSlotX, arrowSlotBottomY)
            self.swapSelect2:draw(swapSelectX, swapSelectY)
        elseif self.selectIndex == 3 then
            self.upArrowImage:draw(arrowSlotX, arrowSlotBottomY)
            self.swapSelect3:draw(swapSelectX, swapSelectY)
        end

        self.swapHolderOld:draw(swapHolderX, swapHolderY)

        local oldItemTextX, oldItemTextY = 106, 156
        self.panelFont:drawText(selectedEquipment.name, oldItemTextX, oldItemTextY)
        local oldLevelTextX, oldLevelTextY = 333, 156
        self.panelFont:drawText("lvl " .. selectedEquipment.level, oldLevelTextX, oldLevelTextY)

        local oldItemDescriptionX, oldItemDescriptionY = 107, 172
        local oldDescriptionWidth, oldDescriptionHeight = 213, 43
        local lineSpacing = 2
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextInRect(
            selectedEquipment.description,
            oldItemDescriptionX,
            oldItemDescriptionY,
            oldDescriptionWidth,
            oldDescriptionHeight,
            lineSpacing,
            nil,
            nil,
            self.panelFont
        )
    gfx.popContext()
    self.menuSprite:setImage(panelImage)
end

function SwapPanel:animateIn()
    local animateTime = 900
    self:animateSprite(self.titleSprite, self.titleY, animateTime, 500, pd.easingFunctions.outBack)
    self:animateSprite(self.menuSprite, self.menuY, animateTime, 700, pd.easingFunctions.outBack)
    local newEquipmentTimer = self:animateSprite(self.newEquipmentSprite, self.newEquipmentY, animateTime, 900, pd.easingFunctions.outBack)
    newEquipmentTimer.timerEndedCallback = function()
        self.newEquipmentAnimator:start()
    end
    self:animateSprite(self.aButtonSprite, self.aButtonY, animateTime, 1100, pd.easingFunctions.outBack)
end

function SwapPanel:animateSprite(sprite, endY, time, delay, easingFunction)
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