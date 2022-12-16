local pd <const> = playdate
local gfx <const> = playdate.graphics

class('HasCooldown').extends()

function HasCooldown:init(cooldown, callback, caller)
    local cooldownTimer = pd.timer.new(cooldown, function()
        callback(caller)
    end)
    cooldownTimer.repeats = true
end