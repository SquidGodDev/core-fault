import "scripts/audio/soundFiles"

local soundFiles <const> = soundFiles

local rand <const> = math.random

class('SfxPlayer').extends()

function SfxPlayer:init(soundName)
    local soundFile = soundFiles[soundName]
    local files = soundFile.files
    local volume = soundFile.level

    self.sounds = files
    self.max = #files
    self.volume = volume
end

function SfxPlayer:play()
    local sound = self.sounds[rand(1,self.max)]
    sound:setVolume(self.volume + rand(1)*0.05 - 0.025)
    sound:play()
end