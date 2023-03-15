import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/projectile"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local calculatedCosine <const> = table.create(361, 0)
local calculatedSine <const> = table.create(361, 0)
for i=0,360 do
    local angleInRadians = math.rad(i)
    calculatedCosine[i] = math.cos(angleInRadians)
    calculatedSine[i] = math.sin(angleInRadians)
end

class('FiresProjectile').extends()

function FiresProjectile:init(player, data)
    self.player = player
    self.pierceCount = player.Piercing
    self.velocity = data.velocity
    self.damageComponent = DoesDamage(player, data)

    local size = data.size or 5
    self.projectileDiameter = size
    local projectilePoolCount <const> = 30
    self.projectilePool = table.create(projectilePoolCount, 0)
    for i=1,projectilePoolCount do
        self.projectilePool[i] = Projectile(self, self.damageComponent, self.projectileDiameter, player)
    end
end

function FiresProjectile:fireProjectile(angleAdjustment)
    local adjustment = angleAdjustment or 0
    local x, y = self.player.x, self.player.y
    local crankPos = math.floor(getCrankPosition() - 90 + adjustment) % 360
    local angleCos = calculatedCosine[crankPos]
    local angleSine = calculatedSine[crankPos]

    local xVelocity = angleCos * self.velocity
    local yVelocity = angleSine * self.velocity
    local projectileInstance = table.remove(self.projectilePool)
    if projectileInstance then
        projectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    else
        local newProjectileInstance = Projectile(self, self.damageComponent, self.projectileDiameter, self.player)
        newProjectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    end
end

function FiresProjectile:fireProjectileAtAngle(angle)
    local x, y = self.player.x, self.player.y
    local angleCos = calculatedCosine[math.floor(angle)]
    local angleSine = calculatedSine[math.floor(angle)]

    local xVelocity = angleCos * self.velocity
    local yVelocity = angleSine * self.velocity
    local projectileInstance = table.remove(self.projectilePool)
    if projectileInstance then
        projectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    else
        local newProjectileInstance = Projectile(self, self.damageComponent, self.projectileDiameter, self.player)
        newProjectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    end
end

function FiresProjectile:addToPool(projectileInstance)
    table.insert(self.projectilePool, projectileInstance)
end
