class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer   :school1_id
      t.integer   :school2_id
      t.integer   :round,       null: false
      t.datetime  :start_time,  null: false
      t.boolean   :is_over,     null: false, default: false
      t.integer   :next_game_id
      t.integer   :winning_team_id
      t.integer   :losing_team_id

      t.timestamps
    end
  end
end
