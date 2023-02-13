local pd <const> = playdate
local sampleplayer <const> = playdate.sound.sampleplayer.new

local songs <const> = {
    title = sampleplayer("audio/music/title"),
    gameplay = sampleplayer("audio/music/gameplay"),
}

class('MusicPlayer').extends()

function MusicPlayer:init(song)
    self.lowPassFilter = pd.sound.twopolefilter.new(pd.sound.kFilterLowPass)
    self.lowPassFilter:setResonance(0.95)
    self.lowPassFilter:setFrequency(1000)

    self.currentSong = songs[song]
    self.currentSong:play(0)

    self.fadeOutTime = 1000
    self.transitioning = false
    self.ducking = false
end

function MusicPlayer:switchSong(song)
    if self.transitioning then
        return
    end

    self.ducking = false
    self.transitioning = true
    local songFile = songs[song]
    local fadeTimer = pd.timer.new(self.fadeOutTime, 1, 0)
    fadeTimer.updateCallback = function(timer)
        self.currentSong:setVolume(timer.value)
    end
    fadeTimer.timerEndedCallback = function()
        self.transitioning = false
        self.currentSong = songFile
        songFile:play(0)
    end
end

function MusicPlayer:addLowPass()
    -- pd.sound.addEffect(self.lowPassFilter)
end

function MusicPlayer:removeLowPass()
    -- pd.sound.removeEffect(self.lowPassFilter)
end

function MusicPlayer:duck(time)
    if self.ducking then
        return
    end
    self.ducking = true
    local duckStartTime = math.floor(time*.3)
    local duckEndTime = math.floor(time*.7)
    local minVolume = 0
    local duckStartTimer = pd.timer.new(duckStartTime, 1, minVolume, pd.easingFunctions.inOutCubic)
    duckStartTimer.updateCallback = function(timer)
        self.currentSong:setVolume(timer.value)
    end
    duckStartTimer.timerEndedCallback = function()
        local duckEndTimer = pd.timer.new(duckEndTime, minVolume, 1, pd.easingFunctions.inOutCubic)
        duckEndTimer.updateCallback = function(timer)
            self.currentSong:setVolume(timer.value)
        end
        duckEndTimer.timerEndedCallback = function()
            self.ducking = false
        end
    end
end