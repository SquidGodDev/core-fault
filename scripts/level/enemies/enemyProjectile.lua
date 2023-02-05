
local pd <const> = playdate
local gfx <const> = playdate.graphics

local playerTag <const> = TAGS.PLAYER
local wallTag <const> = TAGS.WALL

local abs <const> = math.abs

local fillCircleAtPoint <const> = gfx.fillCircleAtPoint

local projectilesArray <const> = PROJECTILES
local tableInsert <const> = table.insert
local tableRemove <const> = table.remove
local tableIndex <const> = table.indexOfElement

class('EnemyProjectile').extends()

function EnemyProjectile:init(x, y, xVelocity, yVelocity, damage, projectileDiameter, player)
    self.projectileManager = projectileManager
    self.damageComponent = damageComponent
    self.player = player
    self.isEnemy = isEnemy

    self.diameter = projectileDiameter
    self.radius = projectileDiameter / 2

    self.collisionCheckCounter = 0
    self.collisionCheckInterval = 4

    self.x = x
    self.y = y
    self.xVelocity = xVelocity
    self.yVelocity = yVelocity
    self.damage = damage

    self.playerHalfWidth = player.hurtboxHalfWidth
    self.playerHalfHeight = player.hurtboxHalfHeight

    tableInsert(projectilesArray, self)
end

function EnemyProjectile:update()
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
    local playerX <const> = player.x
    local playerY <const> = player.y
    if abs(x - playerX) > 210 or abs(y - playerY) > 130 then
        local index = tableIndex(projectilesArray, self)
        if index then
            tableRemove(projectilesArray, index)
        end
        return
    end
    if abs(x - playerX) < self.playerHalfWidth and abs(y - playerY) < self.playerHalfHeight then
        self.player:damage(self.damage)
        local index = tableIndex(projectilesArray, self)
        if index then
            tableRemove(projectilesArray, index)
        end
    end
end