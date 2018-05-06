class Song < ApplicationRecord
  self.table_name = "music_playlist_song"
  validates_presence_of :video, :title, :artist, :year, :album
end
