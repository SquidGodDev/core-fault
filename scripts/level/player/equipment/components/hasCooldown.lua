local pd <const> = playdate

class('HasCooldown').extends()

function HasCooldown:init(cooldown, callback, caller)
    self.cooldownTimer = pd.timer.new(cooldown, function()
        callback(caller)
    end)
    self.cooldownTimer.repeats = true
end

function HasCooldown:remove()
    self.cooldownTimer:remove()
end