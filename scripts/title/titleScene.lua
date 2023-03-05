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
        --gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        --gfx.drawText("Connecting", 76, 136)
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

    self.menuMoveSound = SfxPlayer("sfx-menu-move")
    self.menuSelectSound = SfxPlayer("sfx-menu-select")

    self.typingSound = SfxPlayer("sfx-typing")
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
                self.menuMoveSound:play()
            end
        elseif pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
            if self.arrowIndex < 2 then
                self.arrowIndex = 2
                self.menuMoveSound:play()
            end
        end
        self.arrowSprite:moveTo(self.arrowX, self.arrowY + (self.arrowIndex - 1)*self.arrowGap)
        self.arrowSprite:setVisible(not crankDocked)
        if pd.buttonJustPressed(pd.kButtonA) and not crankDocked then
            self.menuSelectSound:play()
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
            MUSIC_PLAYER:switchSong("gameplay")
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
    slideText[1] = "Connecting..."
    slideText[2] = "Orbital link established"
    local deathCount = string.format("%05d", TOTAL_DEATHS + 1)
    slideText[3] = "Droid " .. deathCount .. " online"
    slideText[4] = "Core deposits detected"
    slideText[5] = "Fauna class: X (hostile)"
    slideText[6] = "Depth UNKNOWN"

    local slideTextLength = {}
    for i=1, 6 do
        slideTextLength[i] = string.len(slideText[i])
    end

    local dotCount = 3
    local typewriter = 1

    local typewriterDuration = 20
    local dotDuration = 300
    local pauseDuration = 2000
    local nextSlide = false

    local slidesTimer = pd.timer.new(typewriterDuration, function(timer)
        gfx.pushContext(self.panelImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(slideX, slideY, slideWidth, slideHeight)
        if slidesCount == 1 then
            local connectingText = string.sub(slideText[slidesCount], 1, typewriter)
            if typewriter >= slideTextLength[1] - dotCount then
                timer.duration = dotDuration
            end
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.drawText(connectingText, 76, 136)
        else
            local slideImage = menuSlides[slidesCount - 1]
            if typewriter <= 10 then
                slideImage:drawFaded(slideX, slideY, typewriter/10, gfx.image.kDitherTypeBayer2x2)
            else
                slideImage:draw(slideX, slideY)
            end
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            local txt = string.sub(slideText[slidesCount], 1, math.min(typewriter, slideTextLength[slidesCount]))
            gfx.drawText(txt, textBaseX, textBaseY + (slidesCount - 2)*textGap)
        end
        gfx.popContext()
        self.panelSprite:setImage(self.panelImage)
        if nextSlide then
            timer.duration = typewriterDuration
            timer:reset()
            nextSlide = false
        elseif typewriter > slideTextLength[slidesCount] then
            timer.duration = pauseDuration
            timer:reset()
            if slidesCount == 1 then timer.duration = dotDuration end
            slidesCount += 1
            typewriter = 1
            nextSlide = true
        else
            self.typingSound:play()
            typewriter += 1
        end
        --slidesCount += 1
        if slidesCount == 7 then
            timer:remove()
        end
    end)
    slidesTimer.repeats = true

end