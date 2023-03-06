import "scripts/audio/soundFiles"

local soundFiles <const> = soundFiles

for i=1, #soundFiles do
    local soundFile = soundFiles[i]
    local volume = soundFile.level
    local files = soundFile
    for j=1, #files do
        local soundSample = files[j]
        soundSample:setVolume(volume)
    end
end
local rand <const> = math.random

class('SfxPlayer').extends()

function SfxPlayer:init(soundName)
    local soundFile = soundFiles[soundName]
    local files = soundFile.files

    self.sounds = files
    self.max = #files
end

function SfxPlayer:play()
    self.sounds[rand(1,self.max)]:play()
end