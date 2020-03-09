class Track < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_one :audio
  has_many :comments
  has_one_attached :audio

  has_many :favorite_tracks # just the 'relationships'
  has_many :favorited_by, through: :favorite_tracks, source: :user # the actual users favoriting a recipe

  def progress
    total_donations.to_f / donate * 100
  end


end
