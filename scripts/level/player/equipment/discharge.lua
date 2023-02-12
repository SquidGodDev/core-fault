import "scripts/level/player/equipment/components/followsPlayer"
import "scripts/level/player/equipment/components/doesAOEDamage"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Discharge').extends(Equipment)

function Discharge:init(player, data)
    data = Discharge.super.init(self, player, data)

    local radius = data.radius
    local cooldown = data.cooldown
    local damage = data.damage
    local bonusDamageScaling = data.bonusDamageScaling

    local diameter = radius * 2

    local dischargeImage = gfx.image.new(diameter, diameter)
    gfx.pushContext(dischargeImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.setPattern({0xFE, 0x38, 0xFE, 0xEE, 0xEF, 0x83, 0xEF, 0xEE})
        gfx.fillCircleInRect(0, 0, diameter, diameter)
    gfx.popContext()
    self:setImage(dischargeImage)

    local flashTime = 200
    self:setVisible(false)

    self.aoeDamageComponent = DoesAOEDamage(player, damage, radius)
    FollowsPlayer(self, player)

    local playerHealthbar = player.healthbar
    local playerHealth = playerHealthbar:getHealth()

    self.sfxPlayer = SfxPlayer("sfx-discharge")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        self.sfxPlayer:play()

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
    self.cooldownTimer.repeats = true
end