
class('Stun').extends()

function Stun:init(player, data)
    local calculatedValue = data.value + (data.level - 1) * data.scaling
    player.percentStun += calculatedValue
end