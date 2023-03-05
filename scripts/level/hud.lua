
local pd <const> = playdate
local gfx <const> = playdate.graphics

local timeFormat <const> = function(time)
    local seconds = string.format("%02d", math.floor(time / 1000) % 60)
    local minutes = tostring(math.floor(time / (60 * 1000)))
    return minutes .. ":" .. seconds
end

class('HUD').extends(gfx.sprite)

function HUD:init(time, maxExperience, levelScene)
    self.experience = 0
    self.maxExperience = maxExperience
    self.levelScene = levelScene

    local hudImage = gfx.image.new("images/ui/hud")
    self:setImage(hudImage)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:setZIndex(Z_INDEXES.UI)
    self:setIgnoresDrawOffset(true)
    self:add()

    local fillImage = gfx.image.new(9, 240, gfx.kColorBlack)
    self.fillSprite = gfx.sprite.new(fillImage)
    self.fillSprite:setCenter(0, 0)
    self.fillSprite:moveTo(0, 0)
    self.fillSprite:setZIndex(Z_INDEXES.UI)
    self.fillSprite:setIgnoresDrawOffset(true)
    self.fillSprite:add()

    self.fillSpriteWidth = self.fillSprite:getSize()

    self.drawAnimator = pd.timer.new(500)
    self.drawAnimator.discardOnCompletion = false
    self.drawAnimator.easingFunction = pd.easingFunctions.outCubic
    self.drawAnimator:pause()
    self.clipHeight = 240
    self.drawAnimator.updateCallback = function(timer)
        self.clipHeight = timer.value
    end
    self.drawAnimator.timerEndedCallback = function(timer)
        self.clipHeight = timer.endValue
    end

    self.timeSprite = gfx.sprite.new()
    self.timeSprite:setCenter(0, 0)
    self.timeSprite:moveTo(15, 8)
    self.timeSprite:setZIndex(Z_INDEXES.UI)
    self.timeSprite:setIgnoresDrawOffset(true)
    self.timeSprite:add()
    local timeWidth, timeHeight = 40, 7
    self.timeImage = gfx.image.new(timeWidth, timeHeight)
    self.timeSprite:setImage(self.timeImage)

    local warningSpriteImageTable = gfx.imagetable.new("images/ui/power-warning-table-389-38")
    local warningSpriteAnimationLoop
    local warningSprite = gfx.sprite.new()
    warningSprite:setZIndex(Z_INDEXES.UI)
    warningSprite:setIgnoresDrawOffset(true)
    warningSprite:setCenter(0, 0)
    warningSprite:moveTo(11, 240)
    warningSprite:setVisible(false)
    warningSprite:add()

    local warningX, warningY = 200, 223
    local deadBatteryImage = gfx.image.new("images/ui/no-battery-icon")
    local warningIconSprite = gfx.sprite.new(deadBatteryImage)
    warningIconSprite:setZIndex(Z_INDEXES.UI)
    warningIconSprite:setIgnoresDrawOffset(true)
    warningIconSprite:moveTo(warningX, warningY)
    warningIconSprite:add()
    warningIconSprite:setVisible(false)
    self.drawWarningText = false
    self.warningTextFont = gfx.font.new("fonts/tall_robot")


    self.time = time
    self.clockFont = gfx.font.new("fonts/alpha_custom")
    self.clock = pd.timer.new(time)
    self.clock.updateCallback = function(timer)
        local timeString = timeFormat(timer.timeLeft)
        gfx.pushContext(self.timeImage)
            gfx.clear(gfx.kColorClear)
            gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
            self.clockFont:drawTextAligned(timeString, timeWidth/2, 0, kTextAlignment.center)
        gfx.popContext()

        self.timeWarningSound = SfxPlayer("time-warning")
        if timer.timeLeft < 12500 then
            if not warningSprite:isVisible() then
                warningSprite:setVisible(true)
                warningSpriteAnimationLoop = gfx.animation.loop.new(100, warningSpriteImageTable, true)
                local warningAnimateInTimer = pd.timer.new(500, warningSprite.y, 240 - 38, pd.easingFunctions.inOutCubic)
                warningAnimateInTimer.updateCallback = function(animateTimer)
                    warningSprite:moveTo(warningSprite.x, animateTimer.value)
                end
                warningAnimateInTimer.timerEndedCallback = function()
                    self.timeWarningSound:play()
                    warningIconSprite:setVisible(true)
                    pd.timer.performAfterDelay(500, function()
                        warningIconSprite:setVisible(false)
                        pd.timer.performAfterDelay(500, function()
                            warningIconSprite:setVisible(true)
                            pd.timer.performAfterDelay(500, function()
                                warningIconSprite:setVisible(false)
                                pd.timer.performAfterDelay(500, function()
                                    self.drawWarningText = true
                                end)
                            end)
                        end)
                    end)
                end
            end
            if self.drawWarningText then
                warningIconSprite:setVisible(true)
                local secondsText = gfx.imageWithText(string.format("%02d", math.floor(timer.timeLeft / 1000) % 60), 32, 24, gfx.kColorClear, nil, nil, kTextAlignment.center, self.warningTextFont)
                warningIconSprite:setImage(secondsText)
                warningIconSprite:setImageDrawMode(gfx.kDrawModeFillWhite)
            end
            warningSprite:setImage(warningSpriteAnimationLoop:image())
        end
    end

    self.powerDownSound = SfxPlayer("sfx-player-power-down")
    self.clock.timerEndedCallback = function()
        self.powerDownSound:play()
        self.levelScene:levelDefeated(0)
    end
end

function HUD:update()
    -- self.fillSprite:setClipRect(0, 0, self.fillSpriteWidth, self.clipHeight)
end

function HUD:addExperience(amount)
    self.experience += amount
    if self.experience >= self.maxExperience then
        self.experience = self.maxExperience
        self.levelScene:enableDigging()
    end
    local newClipHeight = ((self.maxExperience - self.experience)/self.maxExperience) * 240
    self.drawAnimator:reset()
    self.drawAnimator.startValue = self.clipHeight
    self.drawAnimator.endValue = newClipHeight
    self.drawAnimator:start()
end

function HUD:stopTimer()
    self.clock:pause()
    return self.clock.timeLeft
end

function HUD:getTimeLeft()
    return self.clock.timeLeft
end