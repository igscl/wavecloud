class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :album
      t.string :description
      t.references :user, foreign_key: true
      t.integer :donate
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
