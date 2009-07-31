require 'rubygems'
require 'rbosa'

def format_time_from_seconds(original_time)
  minutes = (original_time / 60).to_i
  seconds = (original_time - (minutes * 60)).to_i
  sprintf "%02d:%02d", minutes, seconds
end

begin
  iTunes = OSA.app 'iTunes'
  track = iTunes.current_track
  current_position = format_time_from_seconds iTunes.player_position
  track_length = format_time_from_seconds track.duration
  puts "currently playing #{track.name} by #{track.artist} [#{current_position}/#{track_length}]"
rescue Exception => e
  puts "Sorry, there was an error."
end
