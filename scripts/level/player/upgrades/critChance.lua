
class('CritChance').extends()

function CritChance:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.CritChance += calculatedValue
end