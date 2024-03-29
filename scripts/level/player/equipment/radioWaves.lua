import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('RadioWaves').extends(Equipment)

function RadioWaves:init(player, data)
    local dataCopy = RadioWaves.super.init(self, player, data)

    local cooldown = dataCopy.cooldown
    local projectileCount = dataCopy.projectileCount
    self.hitStun = dataCopy.hitStun

    local projectileComponent = FiresProjectile(player, dataCopy)

    local fireAngles = table.create(projectileCount, 0)
    local angleIncrement = 360 / projectileCount
    for i=0,projectileCount-1 do
        table.insert(fireAngles, i*angleIncrement + angleIncrement * 0.5)
    end

    self.sfxPlayer = SfxPlayer("sfx-radio-waves")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        self.sfxPlayer:play()
        for i=1,#fireAngles do
            local angle = fireAngles[i]
            projectileComponent:fireProjectileAtAngle(angle)
        end
    end)
    self.cooldownTimer.repeats = true
end
