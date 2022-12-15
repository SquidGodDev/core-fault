-- Scene for when the player first starts a run and needs to select start equipment

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('StartScene').extends(gfx.sprite)

function StartScene:init(gameManager)
    self.gameManager = gameManager
    local backgroundImage = gfx.image.new("images/game/startSceneTemp")
    self:setImage(backgroundImage)
    self:moveTo(200, 120)
    self:add()
end

function StartScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        -- TODO: Pass in equipment selected
        self.gameManager:startEquipmentSelected()
    end
end