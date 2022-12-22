import "scripts/level/player/equipment/components/hasCooldown"
import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('PeaShooter').extends(Equipment)

function PeaShooter:init(player, data)
    data = Equipment.super.init(self, player, data)

    local cooldown = data.cooldown
    local velocity = data.velocity
    local damage = data.damage

    local projectileComponent = FiresProjectile(player, velocity, damage)

    local fireTimer = pd.timer.new(cooldown, function()
        projectileComponent:fireProjectile()
    end)
    fireTimer.repeats = true
end