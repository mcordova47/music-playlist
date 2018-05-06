require 'rails_helper'

RSpec.describe 'Songs API', type: :request do
  # initialize test data
  let!(:songs) { create_list(:song, 10) }
  let(:song_id) { songs.first.id }

  # Test suite for GET /songs
  describe 'GET /songs' do
    # make HTTP get request before each example
    before { get '/songs' }

    it 'returns songs' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /songs/:id
  describe 'GET /songs/:id' do
    before { get "/songs/#{song_id}" }

    context 'when the record exists' do
      it 'returns the song' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(song_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:song_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end
  end
end
