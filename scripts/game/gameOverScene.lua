-- Scene after a run that shows how far the player got, different stats, and ore earned
import "scripts/title/titleScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init()
    local backgroundImage = gfx.image.new("images/game/gameOverTemp")
    self:setImage(backgroundImage)
    self:moveTo(200, 120)
    self:add()
end

function GameOverScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(TitleScene)
    end
end