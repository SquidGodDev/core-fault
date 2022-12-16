
class('CritDamage').extends()

function CritDamage:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.CritDamage += calculatedValue
end