local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Healthbar').extends(gfx.sprite)

function Healthbar:init(maxHealth, health, player)
    self.player = player
    self.maxHealth = maxHealth
    self.health = health

    self:setZIndex(Z_INDEXES.UI)
    self:add()

    -- Drawing
    self.drawHeight = 6
    self.maxDrawWidth = 30
    self.drawWidth = self.maxDrawWidth

    self.drawOffset = 25

    self:updateBarImage()
end

function Healthbar:update()
    local drawX, drawY = self.player.x, self.player.y + self.drawOffset
    self:moveTo(drawX, drawY)
end

function Healthbar:getHealth()
    return self.health
end

function Healthbar:getMaxHealth()
    return self.maxHealth
end

function Healthbar:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.health = 0
    end
    self:updateBarImage()
end

function Healthbar:heal(amount)
    self.health += amount
    if self.health >= self.maxHealth then
        self.health = self.maxHealth
    end
    self:updateBarImage()
end

function Healthbar:isDead()
    return self.health <= 0
end

function Healthbar:updateBarImage()
    local barImage = gfx.image.new(self.maxDrawWidth, self.drawHeight)
    self.drawWidth = (self.health / self.maxHealth) * self.maxDrawWidth
    gfx.pushContext(barImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0, 0, self.maxDrawWidth, self.drawHeight)
        gfx.setColor(gfx.kColorWhite)
        gfx.drawRect(0, 0, self.maxDrawWidth, self.drawHeight)
        gfx.fillRect(0, 0, self.drawWidth, self.drawHeight)
    gfx.popContext()
    self:setImage(barImage)
end

function Healthbar:setFillWhite(flag)
    if flag then
        self:setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end
end