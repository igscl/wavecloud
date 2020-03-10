class AddValueToTrackDonations < ActiveRecord::Migration[5.2]
  def change
    add_column :track_donations, :value, :integer , default: 0
  end
end
