
local pd <const> = playdate
local gfx <const> = playdate.graphics

local fadedImageTable <const> = gfx.imagetable.new("images/ui/faded/faded")

class('SceneManager').extends()

function SceneManager:init()
    self.transitionTime = 1200
    self.transitioning = false
end

function SceneManager:switchScene(scene, ...)
    if self.transitioning then
        return
    end

    self.transitioning = true

    self.newScene = scene
    local args = {...}
    self.sceneArgs = args

    self:startTransition()
end

function SceneManager:loadNewScene()
    self:cleanupScene()
    self.newScene(table.unpack(self.sceneArgs))
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
    pd.display.setOffset(0, 0)
end

function SceneManager:startTransition()
    local transitionTimer = self:fadeTransition(0, 1)

    transitionTimer.timerEndedCallback = function()
        self:loadNewScene()
        self.transitioning = false
        transitionTimer = self:fadeTransition(1, 0)
        transitionTimer.timerEndedCallback = function()
            self.transitionSprite:remove()
            local allSprites = gfx.sprite.getAllSprites()
            for i=1,#allSprites do
                allSprites[i]:markDirty()
            end
        end
    end
end

function SceneManager:fadeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setImage(self:getFadedImage(startValue))

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        transitionSprite:setImage(self:getFadedImage(timer.value))
        local mask = gfx.image.new(400, 240)
        gfx.pushContext(mask)
            gfx.fillCircleAtPoint(200, 120, timer.value * 240)
        gfx.popContext()
        transitionSprite:setStencilImage(mask)
    end
    transitionTimer.timerEndedCallback = function()
        if endValue == 0 then
            transitionSprite:remove()
        end
    end
    return transitionTimer
end

function SceneManager:getFadedImage(alpha)
    return fadedImageTable:getImage(math.ceil(alpha * 100) + 1)
end

function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400, 240, gfx.kColorWhite)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(32767)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    self.transitionSprite = transitionSprite
    return transitionSprite
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end