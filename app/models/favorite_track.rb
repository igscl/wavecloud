class FavoriteTrack < ApplicationRecord
    belongs_to :track
    belongs_to :user
end
