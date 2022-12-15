-- Scene between levels where the player gets new equipment and upgrades

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('UpgradeScene').extends(gfx.sprite)

function UpgradeScene:init(gameManager)
    self.gameManager = gameManager

    local backgroundImage = gfx.image.new("images/game/upgradeSceneTemp")
    self:setImage(backgroundImage)
    self:moveTo(200, 120)
    self:add()
end

function UpgradeScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        -- TODO: Pass in selected upgrades/equipment
        self.gameManager:upgradesSelected()
    end
end