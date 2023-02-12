-- Scene for when the player first starts a run and needs to select start equipment
import "scripts/data/equipmentData"
import "scripts/game/gameUI/selectionPanel"
import "scripts/game/gameUI/streakBackground"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

class('StartScene').extends(gfx.sprite)

function StartScene:init(gameManager)
    self.gameManager = gameManager
    self.starterEquipment = {}
    local allEquipment = {}
    for equipmentKey, equipment in pairs(equipment) do
        if equipmentKey ~= "pocketDrill" then
            table.insert(allEquipment, equipment)
        end
    end
    ShuffleInPlace(allEquipment)
    for i=1,3 do
        self.starterEquipment[i] = allEquipment[i]
    end

    StreakBackground()

    self.equipmentPanel = SelectionPanel(self.starterEquipment, true, 1, false)

    self:add()

    self.selected = false

    self.menuMoveSound = SfxPlayer("sfx-menu-move")
    self.menuSelectSound = SfxPlayer("sfx-menu-select")
end

function StartScene:update()
    if self.selected then
        return
    end
    local crankTicks = pd.getCrankTicks(3)
    if pd.buttonJustPressed(pd.kButtonLeft) or crankTicks == -1 then
        self.menuMoveSound:play()
        self.equipmentPanel:selectLeft()
    elseif pd.buttonJustPressed(pd.kButtonRight) or crankTicks == 1 then
        self.menuMoveSound:play()
        self.equipmentPanel:selectRight()
    elseif pd.buttonJustPressed(pd.kButtonA) then
        self.selected = true
        local selectedEquipment = self.equipmentPanel:select()
        if selectedEquipment then
            self.menuSelectSound:play()
            self.gameManager:startEquipmentSelected(selectedEquipment)
        end
    end
end
