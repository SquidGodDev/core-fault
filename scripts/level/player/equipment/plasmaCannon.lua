import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate

class('PlasmaCannon').extends(Equipment)

function PlasmaCannon:init(player, data)
    data = PlasmaCannon.super.init(self, player, data)

    local cooldown = data.cooldown

    local projectileComponent = FiresProjectile(player, data)

    self.sfxPlayer = SfxPlayer("sfx-plasma-cannon")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        projectileComponent:fireProjectile()
        self.sfxPlayer:play()
    end)
    self.cooldownTimer.repeats = true
end