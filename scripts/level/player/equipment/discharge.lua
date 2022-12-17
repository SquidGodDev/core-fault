import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesAOEDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Discharge').extends(gfx.sprite)

function Discharge:init(player, data)
    local radius = data.radius
    local diameter = radius * 2
    local dischargeImage = gfx.image.new(diameter, diameter)
    gfx.pushContext(dischargeImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setPattern({0xFE, 0x38, 0xFE, 0xEE, 0xEF, 0x83, 0xEF, 0xEE})
        gfx.fillCircleInRect(0, 0, diameter, diameter)
    gfx.popContext()
    self:setImage(dischargeImage)
    self:setZIndex(Z_INDEXES.EQUIPMENT)
    self:add()

    local flashTime = 200
    self:setVisible(false)

    self.aoeDamageComponent = DoesAOEDamage(player, data.damage, radius)
    FollowsPlayer(self, player)

    local playerHealthbar = player.healthbar
    local playerHealth = playerHealthbar:getHealth()
    local bonusDamageScaling = data.bonusDamageScaling

    local attackTimer = pd.timer.new(data.cooldown, function()
        local curHealth = playerHealthbar:getHealth()
        local lostHealth = playerHealth - curHealth
        if lostHealth < 0 then
            lostHealth = 0
        end
        local bonusDamage = lostHealth * bonusDamageScaling
        playerHealth = curHealth

        self.aoeDamageComponent:addBonusDamage(bonusDamage)
        self.aoeDamageComponent:dealAOEDamage(self.x, self.y)
        self:setVisible(true)
        pd.timer.new(flashTime, function()
            self:setVisible(false)
        end)
    end)
    attackTimer.repeats = true
end