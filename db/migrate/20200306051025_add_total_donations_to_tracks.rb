class AddTotalDonationsToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :total_donations, :integer, default: 0
  end
end
