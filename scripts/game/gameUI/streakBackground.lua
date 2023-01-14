local pd <const> = playdate
local gfx <const> = playdate.graphics

class('StreakBackground').extends(gfx.sprite)

function StreakBackground:init()
    -- Background
    local blackImage = gfx.image.new(400, 240, gfx.kColorBlack)
    gfx.sprite.setBackgroundDrawingCallback(function()
        blackImage:draw(0, 0)
    end)

    local streakImage = gfx.image.new("images/ui/upgradeMenu/streak")
    local streakTimer = pd.timer.new(50, function()
        Streak(streakImage)
        Streak(streakImage)
    end)
    streakTimer.repeats = true
end

class('Streak').extends(gfx.sprite)

function Streak:init(image)
    local x = math.random(5, 395)
    local velocity = math.random(-11, -7)
    self.acceleration = 0.02
    self:setImage(image)
    self.velocity = velocity
    self:setCenter(0.5, 0)
    self:setZIndex(-100)
    self:moveTo(x, 240)
    self:add()
end

function Streak:update()
    self.velocity -= self.acceleration
    self:moveBy(0, self.velocity)
    if self.y <= -200 then
        self:remove()
    end
end