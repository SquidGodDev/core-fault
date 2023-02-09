import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate

class('PlasmaCannon').extends(Equipment)

function PlasmaCannon:init(player, data)
    data = PlasmaCannon.super.init(self, player, data)

    local cooldown = data.cooldown
    local velocity = data.velocity
    local damage = data.damage
    local size = 15

    local projectileComponent = FiresProjectile(player, velocity, damage, size)

    self.cooldownTimer = pd.timer.new(cooldown, function()
        projectileComponent:fireProjectile()
    end)
    self.cooldownTimer.repeats = true
end