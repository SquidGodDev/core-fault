
class('MoveSpeed').extends()

function MoveSpeed:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.MaxVelocity += calculatedValue
end