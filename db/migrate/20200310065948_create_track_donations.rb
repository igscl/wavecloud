class CreateTrackDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :track_donations do |t|
      t.integer :track_id
      t.integer :user_id

      t.timestamps
    end
  end
end
