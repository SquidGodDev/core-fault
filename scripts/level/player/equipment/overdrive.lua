import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect

class('Overdrive').extends(Equipment)

function Overdrive:init(player, data)
    data = Overdrive.super.init(self, player, data)

    self.cooldown = data.cooldown
    self.velocity = data.velocity
    self.damage = data.damage
    self.ramTime = data.duration

    self.enemyTag = TAGS.ENEMY
    self.hitboxHeight = 32
    self.hitboxWidth = 32
    self.hitboxHalfWidth = self.hitboxWidth / 2
    self.hitboxHalfHeight = self.hitboxHeight / 2

    self.player = player
    -- Components
    self.cooldownTimer = HasCooldown(self.cooldown, self.createRamTimer, self)
    self.damageComponent = DoesDamage(player, data)
end

function Overdrive:createRamTimer()
    self.player:setVelocityModifier(self.velocity)
    local ramTimer = pd.timer.new(self.ramTime, self.velocity, 0, pd.easingFunctions.outQuad)
    ramTimer.updateCallback = function(timer)
        self.player:updateVelocityModifer(timer.value)
        self:ram()
    end
    ramTimer.timerEndedCallback = function()
        self.player:clearVelocityModifier()
    end
end

function Overdrive:ram()
    local player = self.player
    local rectX, rectY = player.x - self.hitboxHalfWidth, player.y - self.hitboxHalfHeight
    local hitObjects = querySpritesInRect(rectX, rectY, self.hitboxWidth, self.hitboxHeight)
    self.damageComponent:dealDamage(hitObjects)
end