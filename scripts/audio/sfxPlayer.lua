import "scripts/audio/soundFiles"

local soundFiles <const> = soundFiles
local rand <const> = math.random

class('SfxPlayer').extends()

function SfxPlayer:init(soundName)
    local soundFile = soundFiles[soundName]
    local files = soundFile.files

    self.sounds = {}
    self.max = #files

    local volume = soundFile.level
    for i=1,self.max do
        local soundSample = files[i]:copy()
        soundSample:setVolume(volume)
        self.sounds[i] = soundSample
    end
end

function SfxPlayer:play()
    self.sounds[rand(1,self.max)]:play()
end