
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('WeaponController').extends()

function WeaponController:init()
    self.weapons = {}
end