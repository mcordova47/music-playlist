class SongsController < ApplicationController
  def index
    @songs = Song.all
    json_response(@songs)
  end

  def show
    @song = Song.find(params[:id])
    json_response(@song)
  end
end
