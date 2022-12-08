local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FollowsPlayer').extends(gfx.sprite)

function FollowsPlayer:init(weapon, player)
    self.weapon = weapon
    self.player = player
    self:add()
end

function FollowsPlayer:update()
    self.weapon:moveTo(self.player.x, self.player.y)
end