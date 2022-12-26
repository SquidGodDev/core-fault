import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('RadioWaves').extends(Equipment)

function RadioWaves:init(player, data)
    data = RadioWaves.super.init(self, player, data)

    local cooldown = data.cooldown
    local velocity = data.velocity
    local damage = data.damage
    local projectileCount = data.projectileCount

    local projectileComponent = FiresProjectile(player, velocity, damage)

    local fireAngles = {}
    local angleIncrement = 360 / projectileCount
    for i=0,projectileCount-1 do
        table.insert(fireAngles, i*angleIncrement)
    end

    local fireTimer = pd.timer.new(cooldown, function()
        for i=1,#fireAngles do
            local angle = fireAngles[i]
            projectileComponent:fireProjectileAtAngle(angle)
        end
    end)
    fireTimer.repeats = true
end