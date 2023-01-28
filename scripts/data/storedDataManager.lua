
local pd <const> = playdate

TOTAL_CORES = 800

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        TOTAL_CORES = gameData.totalCores
    end
end

function saveGameData()
    local gameData = {
        totalCores = TOTAL_CORES
    }
    pd.datastore.write(gameData)
end

function pd.gameWillTerminate()
    saveGameData()
end

function pd.gameWillSleep()
    saveGameData()
end

-- loadGameData()