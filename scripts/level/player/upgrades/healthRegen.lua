
class('HealthRegen').extends()

function HealthRegen:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.HealthRegen += calculatedValue
end