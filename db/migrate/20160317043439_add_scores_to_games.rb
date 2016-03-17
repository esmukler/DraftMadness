class AddScoresToGames < ActiveRecord::Migration
  def change
    add_column :games, :school1_score, :integer
    add_column :games, :school2_score, :integer

    add_index :games, :school1_id
    add_index :games, :school2_id
  end
end
