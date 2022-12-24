import "scripts/level/player/equipment/components/doesDamage"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local getCrankPosition <const> = pd.getCrankPosition

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

local equipmentZIndex <const> = Z_INDEXES.EQUIPMENT

class('FiresProjectile').extends()

function FiresProjectile:init(player, velocity, damage)
    self.player = player
    self.pierceCount = player.Piercing
    self.velocity = velocity
    self.projectileConstructor = Projectile
    self.damageComponent = DoesDamage(player, damage)
end

function FiresProjectile:fireProjectile()
    local x, y = self.player.x, self.player.y
    local crankPos = getCrankPosition() - 90
    local angleInRad = rad(crankPos)
    local angleCos = cos(angleInRad)
    local angleSine = sin(angleInRad)

    local xVelocity = angleCos * self.velocity
    local yVelocity = angleSine * self.velocity
    self.projectileConstructor(x, y, xVelocity, yVelocity, self.damageComponent, self.pierceCount)
end

function FiresProjectile:fireProjectileAtAngle(angle)
    local x, y = self.player.x, self.player.y
    local angleInRad = rad(angle)
    local angleCos = cos(angleInRad)
    local angleSine = sin(angleInRad)

    local xVelocity = angleCos * self.velocity
    local yVelocity = angleSine * self.velocity
    self.projectileConstructor(x, y, xVelocity, yVelocity, self.damageComponent, self.pierceCount)
end

class('Projectile').extends(gfx.sprite)

function Projectile:init(x, y, xVelocity, yVelocity, damageComponent, pierceCount)
    self.xVelocity = xVelocity
    self.yVelocity = yVelocity
    self.damageComponent = damageComponent

    local projectileDiameter = 5
    local projectileImage = gfx.image.new(projectileDiameter, projectileDiameter)
    gfx.pushContext(projectileImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleInRect(0, 0, projectileDiameter, projectileDiameter)
    gfx.popContext()
    self:setImage(projectileImage)
    self:setZIndex(equipmentZIndex)
    self:moveTo(x, y)
    self:add()

    self.wallTag = TAGS.WALL
    self.playerTag = TAGS.PLAYER

    self.diameter = projectileDiameter
    self.radius = projectileDiameter / 2

    self.pierceCount = pierceCount

    self.collisionDict = {}
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
                    self:remove()
                end
            end
        else
            self:remove()
        end
    end
end