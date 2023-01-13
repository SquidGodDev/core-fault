-- Scene for when the player first starts a run and needs to select start equipment
import "scripts/data/equipmentData"
import "scripts/game/selectionPanel"

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
    for _, equipment in pairs(equipment) do
        table.insert(allEquipment, equipment)
    end
    ShuffleInPlace(allEquipment)
    for i=1,3 do
        self.starterEquipment[i] = allEquipment[i]
    end

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

    self.equipmentPanel = SelectionPanel(self.starterEquipment, true)

    self:add()
end

function StartScene:update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.equipmentPanel:selectLeft()
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self.equipmentPanel:selectRight()
    elseif pd.buttonJustPressed(pd.kButtonA) then
        local selectedEquipment = self.equipmentPanel:select()
        if selectedEquipment then
            self.gameManager:startEquipmentSelected(selectedEquipment)
        end
    end
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