
local pd <const> = playdate
local gfx <const> = playdate.graphics

local playerTag <const> = TAGS.PLAYER
local wallTag <const> = TAGS.WALL

local querySpritesInRect <const> = gfx.sprite.querySpritesInRect
local abs <const> = math.abs

local fillCircleAtPoint <const> = gfx.fillCircleAtPoint

local projectilesArray <const> = PROJECTILES

class('Projectile').extends()

function Projectile:init(projectileManager, damageComponent, projectileDiameter, player)
    self.projectileManager = projectileManager
    self.damageComponent = damageComponent
    self.player = player

    self.projectileImage = gfx.image.new(projectileDiameter, projectileDiameter)

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
    self.x = x
    self.y = y
    table.insert(projectilesArray, self)
end

function Projectile:update()
    local x <const> = self.x + self.xVelocity
    local y <const> = self.y + self.yVelocity
    self.x = x
    self.y = y

    fillCircleAtPoint(x, y, self.radius)

    local collisionCheckCounter = self.collisionCheckCounter
    collisionCheckCounter = (collisionCheckCounter + 1) % self.collisionCheckInterval
    self.collisionCheckCounter = collisionCheckCounter
    if collisionCheckCounter ~= 0 then
        return
    end

    local player <const> = self.player
    if abs(x - player.x) > 210 or abs(y - player.y) > 130 then
        local index = table.indexOfElement(projectilesArray, self)
        if index then
            table.remove(projectilesArray, index)
        end
        self.projectileManager:addToPool(self)
        return
    end
    local queryX, queryY = x - self.radius, y - self.radius
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
                    local index = table.indexOfElement(projectilesArray, self)
                    if index then
                        table.remove(projectilesArray, index)
                    end
                    self.projectileManager:addToPool(self)
                end
            end
        else
            local index = table.indexOfElement(projectilesArray, self)
            if index then
                table.remove(projectilesArray, index)
            end
            self.projectileManager:addToPool(self)
        end
    end
end