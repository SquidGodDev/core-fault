
local pd <const> = playdate
local gfx <const> = playdate.graphics

local playerTag <const> = TAGS.PLAYER
local wallTag <const> = TAGS.WALL

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect
local abs <const> = math.abs

local equipmentZIndex <const> = Z_INDEXES.EQUIPMENT

class('Projectile').extends(gfx.sprite)

function Projectile:init(projectileManager, damageComponent, projectileDiameter, player)
    self.projectileManager = projectileManager
    self.damageComponent = damageComponent
    self.player = player

    local projectileImage = gfx.image.new(projectileDiameter, projectileDiameter)
    gfx.pushContext(projectileImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleInRect(0, 0, projectileDiameter, projectileDiameter)
    gfx.popContext()
    self:setImage(projectileImage)
    self:setZIndex(equipmentZIndex)

    self.diameter = projectileDiameter
    self.radius = projectileDiameter / 2

    self.collisionCheckCounter = 0
    self.collisionCheckInterval = 4
end

function Projectile:activate(x, y, xVelocity, yVelocity, pierceCount)
    self.xVelocity = xVelocity
    self.yVelocity = yVelocity
    self.pierceCount = pierceCount
    self.collisionDict = {}
    self:moveTo(x, y)
    self:add()
end

function Projectile:update()
    self:moveBy(self.xVelocity, self.yVelocity)

    local collisionCheckCounter = self.collisionCheckCounter
    collisionCheckCounter = (collisionCheckCounter + 1) % self.collisionCheckInterval
    self.collisionCheckCounter = collisionCheckCounter
    if collisionCheckCounter ~= 0 then
        return
    end

    local player <const> = self.player
    if abs(self.x - player.x) > 210 or abs(self.y - player.y) > 130 then
        self:remove()
        self.projectileManager:addToPool(self)
        return
    end
    local queryX, queryY = self.x - self.radius, self.y - self.radius
    local collisionDiameter <const> = self.diameter
    local collisions = querySpritesInRect(queryX, queryY, collisionDiameter, collisionDiameter)
    local collidedSprite <const> = collisions[1]
    if collidedSprite then
        local collisionTag <const> = collidedSprite:getTag()
        if collisionTag == playerTag then
            return
        end

        if collisionTag ~= wallTag then
            local collisionID <const> = collidedSprite._sprite
            local collisionDict <const> = self.collisionDict
            if not collisionDict[collisionID] then
                collisionDict[collisionID] = true
                self.damageComponent:dealDamageSingle(collidedSprite)
                self.pierceCount -= 1
                if self.pierceCount <= 0 then
                    self:remove()
                    self.projectileManager:addToPool(self)
                end
            end
        else
            self:remove()
            self.projectileManager:addToPool(self)
        end
    end
end