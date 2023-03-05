import "scripts/data/unlockData"

local pd <const> = playdate

TOTAL_CORES = 0
TOTAL_DEATHS = 0

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        if gameData.totalCores then
            TOTAL_CORES = gameData.totalCores
        end
        if gameData.unlocks then
            unlocks = gameData.unlocks
        end
        if gameData.totalDeaths then
            TOTAL_DEATHS = gameData.totalDeaths
        end
    end
end

function saveGameData()
    local gameData = {
        totalCores = TOTAL_CORES,
        unlocks = unlocks,
        totalDeaths = TOTAL_DEATHS
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