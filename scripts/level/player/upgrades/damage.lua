
class('Damage').extends()

function Damage:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.BonusDamage += calculatedValue
end