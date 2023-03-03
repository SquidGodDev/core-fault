
class('Restoration').extends()

function Restoration:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.Restoration += calculatedValue
end