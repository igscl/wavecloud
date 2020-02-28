class Track < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_one :audio, :genre
  has_many :comments
end
