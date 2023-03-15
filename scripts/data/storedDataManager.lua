import "scripts/data/unlockData"

local pd <const> = playdate

TOTAL_CORES = 0
TOTAL_DEATHS = 0

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        if gameData.totalCores then
            TOTAL_CORES = gameData.totalCores
        else
            TOTAL_CORES = 0
        end
        if gameData.unlocks then
            for i=1, #unlocks do
                local unlock = unlocks[i]
                local gameDataUnlockLevel = findUnlockLevel(gameData.unlocks, unlock)
                if gameDataUnlockLevel then
                    unlock.level = gameDataUnlockLevel
                end
            end
        end
        if gameData.totalDeaths then
            TOTAL_DEATHS = gameData.totalDeaths
        end
    end
end

function findUnlockLevel(gameDataUnlocks, unlock)
    for i=1, #gameDataUnlocks do
        local gameDataUnlock = gameDataUnlocks[i]
        if gameDataUnlock.name == unlock.name then
            return gameDataUnlock.level
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