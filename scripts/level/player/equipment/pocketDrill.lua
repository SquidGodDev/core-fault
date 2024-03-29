import "scripts/level/player/equipment/components/equipment"
import "scripts/level/ore/ore"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('PocketDrill').extends(Equipment)

function PocketDrill:init(player, data)
    local dataCopy = PocketDrill.super.init(self, player, data)

    local cooldown = dataCopy.cooldown

    self.sfxPlayer = SfxPlayer("sfx-pocket-drill")

    self.cooldownTimer = pd.timer.new(cooldown, function()
        self.sfxPlayer:play()
        local oreSpawner = player.levelScene.oreSpawner
        local playerX = math.floor(player.x)
        local playerY = math.floor(player.y)
        local randX = math.random(playerX - 10, playerX + 10)
        local randY = math.random(playerY - 10, playerY + 10)
        oreSpawner:spawnOre(randX, randY)
    end)
    self.cooldownTimer.repeats = true
end