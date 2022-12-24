import "scripts/level/player/equipment/components/doesDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

local calculatedCosine <const> = {}
local calculatedSine <const> = {}
for i=0,360 do
    local angleInRadians = math.rad(i)
    calculatedCosine[i] = math.cos(angleInRadians)
    calculatedSine[i] = math.sin(angleInRadians)
end

local equipmentZIndex <const> = Z_INDEXES.EQUIPMENT

class('FiresProjectile').extends()

function FiresProjectile:init(player, velocity, damage)
    self.player = player
    self.pierceCount = player.Piercing
    self.velocity = velocity
    self.damageComponent = DoesDamage(player, damage)

    local projectilePoolCount = 30
    self.projectilePool = {}
    for i=1,projectilePoolCount do
        self.projectilePool[i] = Projectile(self, self.damageComponent)
    end
end

function FiresProjectile:fireProjectile()
    local x, y = self.player.x, self.player.y
    local crankPos = math.floor(getCrankPosition() - 90)
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
        local newProjectileInstance = Projectile(self, self.damageComponent)
        newProjectileInstance:activate(x, y, xVelocity, yVelocity, self.pierceCount)
    end
end

function FiresProjectile:addToPool(projectileInstance)
    table.insert(self.projectilePool, projectileInstance)
end

class('Projectile').extends(gfx.sprite)

function Projectile:init(projectileManager, damageComponent)
    self.projectileManager = projectileManager
    self.damageComponent = damageComponent

    local projectileDiameter = 5
    local projectileImage = gfx.image.new(projectileDiameter, projectileDiameter)
    gfx.pushContext(projectileImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleInRect(0, 0, projectileDiameter, projectileDiameter)
    gfx.popContext()
    self:setImage(projectileImage)
    self:setZIndex(equipmentZIndex)

    self.wallTag = TAGS.WALL
    self.playerTag = TAGS.PLAYER

    self.diameter = projectileDiameter
    self.radius = projectileDiameter / 2

    self:setUpdatesEnabled(false)
    self:setVisible(false)
    self:add()
end

function Projectile:activate(x, y, xVelocity, yVelocity, pierceCount)
    self.xVelocity = xVelocity
    self.yVelocity = yVelocity
    self.pierceCount = pierceCount
    self.collisionDict = {}
    self:moveTo(x, y)
    self:setUpdatesEnabled(true)
    self:setVisible(true)
end

function Projectile:update()
    self:moveBy(self.xVelocity, self.yVelocity)
    local queryX, queryY = self.x - self.radius, self.y - self.radius
    local collisions = gfx.sprite.querySpritesInRect(queryX, queryY, self.diameter, self.diameter)
    if #collisions > 0 then
        local collision = collisions[1]
        local collisionTag = collision:getTag()
        if collisionTag == self.playerTag then
            return
        end

        if collisionTag ~= self.wallTag then
            local collisionID = collision._sprite
            if not self.collisionDict[collisionID] then
                self.collisionDict[collisionID] = true
                self.damageComponent:dealDamageSingle(collision)
                self.pierceCount -= 1
                if self.pierceCount <= 0 then
                    self:setUpdatesEnabled(false)
                    self:setVisible(false)
                    self.projectileManager:addToPool(self)
                end
            end
        else
            self:setUpdatesEnabled(false)
            self:setVisible(false)
            self.projectileManager:addToPool(self)
        end
    end
end