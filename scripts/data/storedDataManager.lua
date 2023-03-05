import "scripts/data/unlockData"

local pd <const> = playdate

TOTAL_CORES = 0

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        TOTAL_CORES = gameData.totalCores
        unlocks = gameData.unlocks
    end
end

function saveGameData()
    local gameData = {
        totalCores = TOTAL_CORES,
        unlocks = unlocks
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