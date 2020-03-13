class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tracks
  has_many :comments
  has_one :profile
  has_many :favorite_tracks
  has_many :favorites, through: :favorite_tracks, source: :track # the actual tracks a user favorites
  has_many :track_donations
  has_many :donations, through: :track_donations, source: :track # the actual donations a user has given
  
end
