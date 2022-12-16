local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FollowsPlayer').extends(gfx.sprite)

function FollowsPlayer:init(equipment, player)
    self.equipment = equipment
    self.player = player
    self:add()
end

function FollowsPlayer:update()
    self.equipment:moveTo(self.player.x, self.player.y)
end