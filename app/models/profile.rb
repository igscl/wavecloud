class Profile < ApplicationRecord
    has_many :tracks
    belongs_to :user#, :optional => true
    validates_uniqueness_of :user_id, message: "you already have a profile"
end
