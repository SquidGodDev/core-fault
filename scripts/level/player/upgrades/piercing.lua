
class('Piercing').extends()

function Piercing:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.Piercing += calculatedValue
end