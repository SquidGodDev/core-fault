import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('PeaShooter').extends(Equipment)

function PeaShooter:init(player, data)
    data = PeaShooter.super.init(self, player, data)

    local cooldown = data.cooldown
    self.hitStun = data.hitStun

    local projectileComponent = FiresProjectile(player, data)

    self.sfxPlayer = SfxPlayer("sfx-pea-shooter")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        projectileComponent:fireProjectile(180)
        self.sfxPlayer:play()
    end)
    self.cooldownTimer.repeats = true
end