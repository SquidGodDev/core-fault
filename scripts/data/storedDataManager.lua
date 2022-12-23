
local pd <const> = playdate

TOTAL_ORE = 0

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        TOTAL_ORE = gameData.totalOre
    end
end

function saveGameData()
    local gameData = {
        totalOre = TOTAL_ORE
    }
    pd.datastore.write(gameData)
end

function pd.gameWillTerminate()
    saveGameData()
end

function pd.gameWillSleep()
    saveGameData()
end

loadGameData()