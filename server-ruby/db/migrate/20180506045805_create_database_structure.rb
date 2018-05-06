class CreateDatabaseStructure < ActiveRecord::Migration[5.1]
  def change
    create_table "music_playlist_song", id: :integer, force: :cascade do |t|
      t.string "video", limit: 15, null: false
      t.string "title", limit: 200, null: false
      t.string "artist", limit: 200, null: false
      t.integer "year", null: false
      t.string "album", limit: 200, null: false
      t.text "notes", limit: 4294967295, null: false
    end
  end
end
