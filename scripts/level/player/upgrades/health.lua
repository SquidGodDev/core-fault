
class('Health').extends()

function Health:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.MaxHealth += calculatedValue
end