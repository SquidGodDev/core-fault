import "scripts/game/player/weapons/components/hasCooldown"
import "scripts/game/player/weapons/components/followsPlayer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

class('ShockProd').extends(gfx.sprite)

function ShockProd:init(player)
    self.player = player
    self.cooldown = 500
    self.facingRight = true
    FollowsPlayer(self, player)
    HasCooldown(self.cooldown, self.fireShock, self)

    self.damage = 2
    self.enemyTag = TAGS.ENEMY
    self.hitboxHeight = 32
    self.hitboxwidth = 64

    local imagetable = gfx.imagetable.new("images/player/weapons/shockProd")
    self.animationLoop = gfx.animation.loop.new(50, imagetable, false)
    self:setCenter(0, 0)
    self:setZIndex(Z_INDEXES.WEAPON)

    self:add()
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
    for i=1, #hitObjects do
        local curObject = hitObjects[i]
        if curObject:getTag() == self.enemyTag then
            curObject:damage(self.damage)
        end
    end
end