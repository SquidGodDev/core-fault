import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('PeaShooter').extends(Equipment)

function PeaShooter:init(player, data)
    local dataCopy = PeaShooter.super.init(self, player, data)

    local cooldown = dataCopy.cooldown
    self.hitStun = dataCopy.hitStun

    local projectileComponent = FiresProjectile(player, dataCopy)

    self.sfxPlayer = SfxPlayer("sfx-pea-shooter")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        projectileComponent:fireProjectile(180)
        self.sfxPlayer:play()
    end)
    self.cooldownTimer.repeats = true
end