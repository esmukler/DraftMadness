class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.integer :user_id,   null: false
      t.integer :league_id, null: false
      t.string  :team_name, null: false
      t.string  :motto
      t.integer :draft_pick

      t.timestamps
    end
  end
end
