-- Title screen that appears when the player first launches the game

import "scripts/game/gameManager"
import "scripts/title/unlockScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    local backgroundImage = gfx.image.new("images/ui/mainMenu/main-menu-title")
    self:setImage(backgroundImage)
    self:moveTo(200, 120)
    self:add()

    local tallRobotFont = gfx.font.new("fonts/tall_robot")
    self.panelImage = gfx.image.new("images/ui/mainMenu/main-menu-panel")
    gfx.pushContext(self.panelImage)
        tallRobotFont:drawText("REMOTE DROID INTERFACE", 16, 16)
        tallRobotFont:drawText("Deploy", 290, 82)
        tallRobotFont:drawText("Unlock", 290, 118)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Connecting", 76, 136)
    gfx.popContext()
    self.panelSprite = gfx.sprite.new(self.panelImage)
    self.panelSprite:moveTo(200, 120 + 240)
    self.panelSprite:add()

    local animateInTimer = pd.timer.new(1200, 120 + 240, 120, pd.easingFunctions.inOutCubic)
    animateInTimer.updateCallback = function(timer)
        self.panelSprite:moveTo(200, timer.value)
    end
    animateInTimer.timerEndedCallback = function()
        self:createSlidesTimer()
        self.arrowSprite:setVisible(true)
        self.inputActive = true
        self.aButtonSprite:add()
        self.crankIndicatorSprite:add()
    end

    self.arrowIndex = 1
    self.arrowX, self.arrowY = 278, 92
    self.arrowGap = 36
    self.arrowSprite = gfx.sprite.new()
    self.arrowSprite:moveTo(self.arrowX, self.arrowY)
    local arrowImage = gfx.image.new("images/ui/upgradeMenu/upgrade-slot-arrow-right")
    self.arrowSprite:setImage(arrowImage)
    self.arrowSprite:setImageDrawMode(gfx.kDrawModeFillBlack)
    self.arrowSprite:setVisible(false)
    self.arrowSprite:add()

    self.aButtonImage = gfx.image.new("images/ui/upgradeMenu/button-big-a-up")
    self.aButtonDownImage = gfx.image.new("images/ui/upgradeMenu/button-big-a-down")
    self.aButtonSprite = gfx.sprite.new(self.aButtonImage)
    self.aButtonSprite:setCenter(0, 0)
    self.aButtonSprite:moveTo(341, 177)
    self.aButtonSprite:setVisible(false)

    local crankIndicatorImageTable = gfx.imagetable.new("images/ui/crank-indicator")
    self.crankAnimationLoop = gfx.animation.loop.new(50, crankIndicatorImageTable, true)
    self.crankIndicatorSprite = gfx.sprite.new()
    self.crankIndicatorSprite:setCenter(0, 0)
    self.crankIndicatorSprite:moveTo(335, 191)

    self.inputActive = false

    self.crankDocked = false
end

function TitleScene:update()
    local crankDocked = pd.isCrankDocked()
    if crankDocked then
        self.crankIndicatorSprite:setVisible(true)
        self.aButtonSprite:setVisible(false)
        if not self.crankDocked then
            self.crankAnimationLoop.frame = 1
        end
    else
        self.crankIndicatorSprite:setVisible(false)
        self.aButtonSprite:setVisible(true)
    end

    self.crankDocked = crankDocked

    self.crankIndicatorSprite:setImage(self.crankAnimationLoop:image())
    if self.inputActive then
        local crankTicks = pd.getCrankTicks(4)
        if pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
            if self.arrowIndex > 1 then
                self.arrowIndex = 1
            end
        elseif pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
            if self.arrowIndex < 2 then
                self.arrowIndex = 2
            end
        end
        self.arrowSprite:moveTo(self.arrowX, self.arrowY + (self.arrowIndex - 1)*self.arrowGap)
        if pd.buttonJustPressed(pd.kButtonA) and not crankDocked then
            self.inputActive = false
            self:animateOut()
            self.aButtonSprite:setImage(self.aButtonDownImage)
            pd.timer.performAfterDelay(200, function()
                self.aButtonSprite:setImage(self.aButtonImage)
            end)
        end
    end
end

function TitleScene:animateOut()
    local animateTimer = pd.timer.new(1000, 0, 240, pd.easingFunctions.inOutCubic)
    local arrowBaseY = self.arrowSprite.y
    local panelBaseY = self.panelSprite.y
    local aButtonbaseY = self.aButtonSprite.y
    animateTimer.updateCallback = function(timer)
        self.arrowSprite:moveTo(self.arrowSprite.x, arrowBaseY + timer.value)
        self.panelSprite:moveTo(self.panelSprite.x, panelBaseY + timer.value)
        self.aButtonSprite:moveTo(self.aButtonSprite.x, aButtonbaseY + timer.value)
    end
    animateTimer.timerEndedCallback = function()
        if self.arrowIndex == 1 then
            SCENE_MANAGER:switchScene(GameManager)
        else
            SCENE_MANAGER:switchScene(UnlockScene)
        end
    end
end

function TitleScene:createSlidesTimer()
    local slidesCount = 1
    local textBaseX, textBaseY = 24, 165
    local textGap = 12
    local menuSlides = gfx.imagetable.new("images/ui/mainMenu/main-menu-slides-table-192-80")
    local slideX, slideY = 24, 72
    local slideWidth, slideHeight = menuSlides[1]:getSize()

    local slideText = {}
    slideText[1] = "Orbital link established"
    -- TODO: Keep track of death count
    slideText[2] = "Droid 00001 online"
    slideText[3] = "Core deposits detected"
    slideText[4] = "Fauna class: X (hostile)"
    slideText[5] = "Depth UNKNOWN"

    local slidesTimer = pd.timer.new(500, function(timer)
        gfx.pushContext(self.panelImage)
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRect(slideX, slideY, slideWidth, slideHeight)
            if slidesCount <= 3 then
                local connectingText = "Connecting"
                for _=1,slidesCount do
                    connectingText = connectingText .. "."
                end
                gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
                gfx.drawText(connectingText, 76, 136)
            else
                timer.delay = 1000
                local slideIndex = slidesCount - 3
                local slideImage = menuSlides[slideIndex]
                slideImage:draw(slideX, slideY)
                gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
                gfx.drawText(slideText[slideIndex], textBaseX, textBaseY + (slideIndex - 1)*textGap)
            end
        gfx.popContext()
        self.panelSprite:setImage(self.panelImage)
        slidesCount += 1
        if slidesCount == 9 then
            timer:remove()
        end
    end)
    slidesTimer.repeats = true
end