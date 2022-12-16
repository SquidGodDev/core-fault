
class('AttackSpeed').extends()

function AttackSpeed:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.AttackSpeed += calculatedValue
end