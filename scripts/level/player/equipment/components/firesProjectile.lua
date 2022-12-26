import "scripts/level/player/equipment/components/doesDamage"
import "scripts/level/player/equipment/components/projectile"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local calculatedCosine <const> = {}
local calculatedSine <const> = {}
for i=0,360 do
    local angleInRadians = math.rad(i)
    calculatedCosine[i] = math.cos(angleInRadians)
    calculatedSine[i] = math.sin(angleInRadians)
end

class('FiresProjectile').extends()

function FiresProjectile:init(player, velocity, damage, size)
    self.player = player
    self.pierceCount = player.Piercing
    self.velocity = velocity
    self.damageComponent = DoesDamage(player, damage)

    self.projectileDiameter = 5
    if size then
        self.projectileDiameter = size
    end
    local projectilePoolCount = 30
    self.projectilePool = {}
    for i=1,projectilePoolCount do
        self.projectilePool[i] = Projectile(self, self.damageComponent, self.projectileDiameter)
    end
end

function FiresProjectile:fireProjectile()
    local x, y = self.player.x, self.player.y
    local crankPos = math.floor(getCrankPosition() - 90) % 360
    local angleCos = calculatedCosine[crankPos]
    local angleSine = calculatedSine[crankPos]

    local xVelocity = angleCos * self.velocity
    local yVelocity = angleSine * self.velocity
    local projectileInstance = table.remove(self.projectilePool)
    if projectileInstance then
        projectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    else
        local newProjectileInstance = Projectile(self, self.damageComponent)
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
        local newProjectileInstance = Projectile(self, self.damageComponent, self.projectileDiameter)
        newProjectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    end
end

function FiresProjectile:addToPool(projectileInstance)
    table.insert(self.projectilePool, projectileInstance)
end
