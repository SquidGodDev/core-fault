local pd <const> = playdate
local sampleplayer <const> = playdate.sound.sampleplayer.new

local songs <const> = {
    title = sampleplayer("audio/music/title"),
    gameplay = sampleplayer("audio/music/gameplay"),
}

class('MusicPlayer').extends()

function MusicPlayer:init(song)
    self.currentSong = songs[song]
    self.currentSong:play(0)

    self.fadeOutTime = 1000
    self.transitioning = false
end

function MusicPlayer:switchSong(song)
    if self.transitioning then
        return
    end

    self.transitioning = true
    local songFile = songs[song]
    local fadeTimer = pd.timer.new(self.fadeOutTime, 1, 0)
    fadeTimer.updateCallback = function(timer)
        self.currentSong:setVolume(timer.value)
    end
    fadeTimer.timerEndedCallback = function()
        self.transitioning = false
        songFile:play(0)
    end
end