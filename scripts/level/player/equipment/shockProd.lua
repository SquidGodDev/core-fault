import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

class('ShockProd').extends(Equipment)

function ShockProd:init(player, data)
    data = ShockProd.super.init(self, player, data)

    self.cooldown = data.cooldown
    self.facingRight = true

    self.damage = data.damage
    self.enemyTag = TAGS.ENEMY
    self.hitboxHeight = 32
    self.hitboxwidth = 64

    local imagetable = gfx.imagetable.new("images/player/equipment/shockProd")
    self.animationLoop = gfx.animation.loop.new(50, imagetable, false)
    self:setCenter(0, 0)

    -- Components
    FollowsPlayer(self, player)
    HasCooldown(self.cooldown, self.fireShock, self)
    self.damageComponent = DoesDamage(player, self.damage)
end

function ShockProd:update()
    local flip = gfx.kImageFlippedX
    if self.facingRight then
        flip = gfx.kImageUnflipped
    end
    self:setImage(self.animationLoop:image(), flip)
end

function ShockProd:fireShock()
    self.facingRight = not self.facingRight
    self.animationLoop.paused = false
    self.animationLoop.frame = 1
    if self.facingRight then
        self:setCenter(0, 0.5)
    else
        self:setCenter(1, 0.5)
    end

    local rectX, rectY = self.x - self.hitboxwidth, self.y - self.hitboxHeight / 2
    if self.facingRight then
        rectX, rectY = self.x, self.y - self.hitboxHeight / 2
    end
    local hitObjects = querySpritesInRect(rectX, rectY, self.hitboxwidth, self.hitboxHeight)
    self.damageComponent:dealDamage(hitObjects)
end