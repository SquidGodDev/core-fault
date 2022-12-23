import "scripts/level/player/equipment/components/firesProjectile"
import "scripts/level/player/equipment/components/equipment"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Generator').extends(Equipment)

function Generator:init(player, data)
    data = Generator.super.init(self, player, data)

    self.cooldown = data.cooldown
    local velocity = data.velocity
    local damage = data.damage
    local projectileCount = data.projectileCount

    self.projectileComponent = FiresProjectile(player, velocity, damage)

    self.fireAngles = {}
    local angleIncrement = 360 / projectileCount
    for i=0,projectileCount-1 do
        table.insert(self.fireAngles, i*angleIncrement)
    end

    self.onCooldown = false
end

function Generator:update()
    local crankTicks = pd.getCrankTicks(1)
    if crankTicks ~= 0 then
        self:activate()
    end
end

function Generator:activate()
    if not self.onCooldown then
        for i=1,#self.fireAngles do
            local angle = self.fireAngles[i]
            self.projectileComponent:fireProjectileAtAngle(angle)
        end
        self.onCooldown = true
        pd.timer.new(self.cooldown, function()
            self.onCooldown = false
        end)
    end
end