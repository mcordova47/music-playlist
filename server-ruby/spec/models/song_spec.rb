require 'rails_helper'

RSpec.describe Song, type: :model do
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:artist) }
  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:album) }
end
