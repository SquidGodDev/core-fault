local pd <const> = playdate
local fileplayer <const> = playdate.sound.fileplayer.new

local songs <const> = {
    title = fileplayer("audio/music/title"),
    gameplay = fileplayer("audio/music/gameplay"),
}

class('MusicPlayer').extends()

function MusicPlayer:init(song)
    for _, track in pairs(songs) do
        track:setStopOnUnderrun(false)
    end

    self.lowPassFilter = pd.sound.twopolefilter.new(pd.sound.kFilterLowPass)
    self.lowPassFilter:setResonance(0.65)
    self.lowPassFilter:setFrequency(500)

    self.currentSong = songs[song]
    self.currentSong:play(0)
    self.nextSong = songs[song]

    self.fadeOutTime = 10000
    self.ducking = false
end

function MusicPlayer:switchSong(song)
    self.ducking = false
    local songFile = songs[song]
    self.nextSong = songFile

    self.currentSong:setVolume(0, 0, 1, function(thisFile, musicPlayer)
        thisFile:stop()
        musicPlayer.currentSong = musicPlayer.nextSong
        musicPlayer.currentSong:setVolume(1)
        musicPlayer.currentSong:play(0)
    end, self)
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
    local duckStartTime = math.floor(time*.1)
    local duckEndTime = math.floor(time*.9)
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