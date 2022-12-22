
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Equipment').extends(gfx.sprite)

function Equipment:init(player, data)
    self.player = player
    self:setZIndex(Z_INDEXES.EQUIPMENT)
    self:add()

    local level = data.level
    local levelStats = data.levelStats
    for i=1,level-1 do
        local levelStat = levelStats[i]
        for key, value in pairs(data) do
            local stat = levelStat[key]
            if stat then
                data[key] = value + stat
            end
        end
    end

    return data
end