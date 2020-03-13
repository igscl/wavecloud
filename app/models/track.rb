class Track < ApplicationRecord
  validates_presence_of :title, :genre_id, :album, :description, :donate
  belongs_to :user
  belongs_to :genre
  has_one :audio
  has_many :comments
  has_one_attached :audio

  has_many :favorite_tracks # just the 'relationships'
  has_many :favorited_by, through: :favorite_tracks, source: :user # these are the actual users favoriting a track
  has_many :track_donations
  has_many :donated_by, through: :track_donations, source: :user # these are the actual users who have donated to a track
  
  def progress
    total_donations.to_f / donate * 100
  end


end
