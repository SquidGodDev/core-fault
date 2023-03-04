-- Scene after a run that shows how far the player got, different stats, and cores earned
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local timeFormat = function(time)
    local seconds = string.format("%02d", math.floor(time / 1000) % 60)
    local minutes = string.format("%02d", math.floor(time / (60 * 1000)))
    return minutes .. ":" .. seconds
end

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init(equipment, upgrades, time, level, enemiesDefeated, cores)
    TOTAL_CORES += cores
    self.upgrades = upgrades
    self.selectedUpgrade = math.ceil(#upgrades/2)

    local xpGained = level * 10

    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(function()
        blackImage:draw(0, 0)
    end)

    local splashDeathImage = gfx.image.new("images/ui/summary/summary-splash-death")
    local splashSprite = gfx.sprite.new(splashDeathImage)
    splashSprite:setCenter(0, 0)
    splashSprite:moveTo(0, 0)
    splashSprite:add()

    -- Drawing Panel
    self.panelImage = gfx.image.new("images/ui/summary/summary-panel-populated")
    self.pipFullImage = gfx.image.new("images/ui/summary/summary-pip-full")
    self.pipEmptyImage = gfx.image.new("images/ui/summary/summary-pip-empty")

    self.font = gfx.font.new("fonts/alpha_custom")
    local iconTextBaseX, iconTextBaseY = 112, 45
    local iconGap = 23

    local equipmentBaseX, equipmentBaseY = 20, 19
    local equipmentGap = 78

    local equipmentLevelBaseX, equipmentLevelBaseY = 66, 20
    local equipmentLevelGap = 78

    gfx.pushContext(self.panelImage)
        local timeString = timeFormat(time)
        self.font:drawText(timeString, iconTextBaseX, iconTextBaseY + 0*iconGap)
        self.font:drawText(level, iconTextBaseX, iconTextBaseY + 1*iconGap)
        self.font:drawText(xpGained, iconTextBaseX, iconTextBaseY + 2*iconGap)
        self.font:drawText(enemiesDefeated, iconTextBaseX, iconTextBaseY + 3*iconGap)
        self.font:drawText(cores, iconTextBaseX, iconTextBaseY + 4*iconGap)

        for i=1,#equipment do
            local curEquipment = equipment[i]
            local equipmentLevel = curEquipment.level
            local equipmentImage = gfx.image.new(curEquipment.imagePath)
            equipmentImage:draw(equipmentBaseX, equipmentBaseY + (i-1)*equipmentGap)
            self.font:drawTextAligned(equipmentLevel, equipmentLevelBaseX, equipmentLevelBaseY + (i-1)*equipmentLevelGap, kTextAlignment.center)
        end
    gfx.popContext()

    self.panelSprite = gfx.sprite.new()
    self.panelSprite:setCenter(1, 0)
    self.panelSprite:moveTo(0, 0)
    self.panelSprite:setImage(self.panelImage)
    self.panelSprite:add()
    self:drawUpgrades()

    -- Animation
    local panelWidth = self.panelImage:getSize()
    pd.timer.performAfterDelay(100, function()
        local entranceTimer = pd.timer.new(1000, 0, panelWidth, pd.easingFunctions.inOutCubic)
        entranceTimer.updateCallback = function(timer)
            self.panelSprite:moveTo(timer.value, self.panelSprite.y)
        end
        local exitTimer = pd.timer.new(1200, 0, 120, pd.easingFunctions.inOutCubic)
        exitTimer.updateCallback = function(timer)
            splashSprite:moveTo(timer.value, splashSprite.y)
        end
    end)
    self:moveTo(200, 120)
    self:add()
end

function GameOverScene:update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.selectedUpgrade -= 1
        if self.selectedUpgrade < 1 then
            self.selectedUpgrade = 1
        end
        self:drawUpgrades()
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self.selectedUpgrade += 1
        if self.selectedUpgrade > #self.upgrades then
            self.selectedUpgrade = #self.upgrades
        end
        self:drawUpgrades()
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        MUSIC_PLAYER:switchSong("title")
        SCENE_MANAGER:switchScene(TitleScene)
    end
end

function GameOverScene:drawUpgrades()
    local upgradeCount = #self.upgrades
    if upgradeCount == 0 then
        return
    end

    local upgradeCenter = 150
    local pipY = 228
    local pipGap = 6
    local pipStartX = (upgradeCenter - 1) - (upgradeCount - 1) * pipGap/2

    local newPanelImage = self.panelImage:copy()
    gfx.pushContext(newPanelImage)
        for i=1,upgradeCount do
            local pipX = pipStartX + pipGap * (i-1)
            if i == self.selectedUpgrade then
                self.pipFullImage:draw(pipX, pipY)
            else
                self.pipEmptyImage:draw(pipX, pipY)
            end
        end

        local upgradeObject = self.upgrades[self.selectedUpgrade]
        local upgradeName = upgradeObject.name
        local upgradeLevel = upgradeObject.level
        local upgradeText = upgradeName .. " lvl " .. upgradeLevel
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        self.font:drawTextAligned(upgradeText, upgradeCenter, 209, kTextAlignment.center)
    gfx.popContext()
    self.panelSprite:setImage(newPanelImage)
end