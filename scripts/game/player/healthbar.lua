local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Healthbar').extends(gfx.sprite)

function Healthbar:init(maxHealth, player)
    self.player = player
    self.maxHealth = maxHealth
    self.health = maxHealth

    self:setZIndex(Z_INDEXES.UI)
    self:add()

    -- Drawing
    self.drawHeight = 6
    self.maxDrawWidth = 30
    self.drawWidth = self.maxDrawWidth

    self.drawAnimator = pd.timer.new(500)
    self.drawAnimator.discardOnCompletion = false
    self.drawAnimator.easingFunction = pd.easingFunctions.outCubic
    self.drawAnimator:pause()
    self.drawAnimator.updateCallback = function(timer)
        self.drawWidth = timer.value
    end
    self.drawAnimator.timerEndedCallback = function(timer)
        self.drawWidth = timer.endValue
    end

    self.barSprite = gfx.sprite.new()
    self.barSprite:setZIndex(Z_INDEXES.UI)
    self.barSprite:add()

    self.drawOffset = 25
end

function Healthbar:update()
    local barImage = gfx.image.new(self.maxDrawWidth, self.drawHeight)
    gfx.pushContext(barImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0, 0, self.maxDrawWidth, self.drawHeight)
        gfx.setColor(gfx.kColorWhite)
        gfx.drawRect(0, 0, self.maxDrawWidth, self.drawHeight)
        gfx.fillRect(0, 0, self.drawWidth, self.drawHeight)
    gfx.popContext()
    self.barSprite:setImage(barImage)
    local drawX, drawY = self.player.x, self.player.y + self.drawOffset
    self:moveTo(drawX, drawY)
    self.barSprite:moveTo(drawX, drawY)
end

function Healthbar:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.health = 0
    end
    self:animateBar(self.health)
end

function Healthbar:heal(amount)
    self.health += amount
    if self.health >= self.maxHealth then
        self.health = self.maxHealth
    end
    self:animateBar(self.health)
end

function Healthbar:isDead()
    return self.health <= 0
end

function Healthbar:animateBar(newValue)
    local newDrawWidth = (newValue / self.maxHealth) * self.maxDrawWidth
    self.drawAnimator:reset()
    self.drawAnimator.startValue = self.drawWidth
    self.drawAnimator.endValue = newDrawWidth
    self.drawAnimator:start()
end