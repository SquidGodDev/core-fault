-- Scene for when the player first starts a run and needs to select start equipment
import "scripts/data/equipmentData"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

class('StartScene').extends(gfx.sprite)

function StartScene:init(gameManager)
    self.gameManager = gameManager
    self.starterEquipment = {}
    local allEquipment = {}
    for _, equipment in pairs(equipment) do
        table.insert(allEquipment, equipment)
    end
    ShuffleInPlace(allEquipment)
    for i=1,3 do
        self.starterEquipment[i] = allEquipment[i]
    end

    -- Background
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(function()
        blackImage:draw(0, 0)
    end)

    local streakImage = gfx.image.new("images/ui/upgradeMenu/streak")
    local streakTimer = pd.timer.new(50, function()
        Streak(streakImage)
        Streak(streakImage)
    end)
    streakTimer.repeats = true

    -- Selection data
    self.selectIndex = 2

    -- Panel Drawing
    self.panelFont = gfx.font.new("fonts/alpha_custom")
    self.upgradePanelImage = gfx.image.new("images/ui/upgradeMenu/upgrade-panel")
    self.upgradeMenuSprite = gfx.sprite.new()

    self.arrowRightImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-right")
    self.arrowLeftImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-left")
    self.upgradeSelectionArrow = gfx.image.new("images/ui/upgradeMenu/upgrade-selection-arrow")
    self.selectedEquipmentSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-selected")
    self.deselectedEquipmentSlot = gfx.image.new("images/ui/upgradeMenu/equipment-slot-deselected")
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

function StartScene:update()
    if self.selected then
        return
    end

    if pd.buttonJustPressed(pd.kButtonLeft) then
        if self.selectIndex > 1 then
            self.selectIndex -= 1
            self:drawUI()
        end
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        if self.selectIndex < 3 then
            self.selectIndex += 1
            self:drawUI()
        end
    elseif pd.buttonJustPressed(pd.kButtonA) then
        self.selected = true
        self.aButtonSprite:setImage(self.aButtonImageDown)
        pd.timer.new(100, function()
            self.aButtonSprite:setImage(self.aButtonImage)
        end)
        local selectedEquipment = self.starterEquipment[self.selectIndex]
        self.gameManager:startEquipmentSelected(selectedEquipment)
    end
end

function StartScene:drawUI()
    local upgradePanelImage = self.upgradePanelImage:copy()
    gfx.pushContext(upgradePanelImage)
        local selectedEquipment = self.starterEquipment[self.selectIndex]

        local panelX, panelY = 60, 38
        local slotBaseX, slotBaseY = 88 - panelX, 62 - panelY
        local slotGap = 80
        local selectionArrowBaseX, selectionArrowBaseY = 113 - panelX, 146 - panelY
        local arrowSlotLeftX, arrowSlotLeftY = 156 - panelX, 93 - panelY
        local arrowSlotRightX, arrowSlotRightY = 236 - panelX, 93 - panelY
        for i=1,3 do
            local slotX = slotBaseX + (i-1) * slotGap
            local selectionArrowX = selectionArrowBaseX + (i-1) * slotGap
            if self.selectIndex == i then
                self.selectedEquipmentSlot:draw(slotX, slotBaseY)
                self.upgradeSelectionArrow:draw(selectionArrowX, selectionArrowBaseY)
            else
                self.deselectedEquipmentSlot:draw(slotX, slotBaseY)
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
        self.panelFont:drawText(selectedEquipment.name, itemTextX, itemTextY)
        local levelTextX, levelTextY = 293 - panelX, 158 - panelY
        self.panelFont:drawText("lvl " .. selectedEquipment.level, levelTextX, levelTextY)

        local descriptionX, descriptionY = 75 - panelX, 176 - panelY
        local descriptionWidth, desciptionHeight = 213, 43
        local lineSpacing = 2
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextInRect(selectedEquipment.description, descriptionX, descriptionY, descriptionWidth, desciptionHeight, lineSpacing, nil, nil, self.panelFont)
    gfx.popContext()
    self.upgradeMenuSprite:setImage(upgradePanelImage)
end

function StartScene:animateSprite(sprite, endY, time, delay, easingFunction)
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



class('Streak').extends(gfx.sprite)

function Streak:init(image)
    local x = math.random(5, 395)
    local velocity = math.random(-11, -7)
    self.acceleration = 0.02
    self:setImage(image)
    self.velocity = velocity
    self:setCenter(0.5, 0)
    self:setZIndex(-100)
    self:moveTo(x, 240)
    self:add()
end

function Streak:update()
    self.velocity -= self.acceleration
    self:moveBy(0, self.velocity)
    if self.y <= -200 then
        self:remove()
    end
end