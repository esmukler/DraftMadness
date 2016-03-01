class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.integer :seed_number,  null: false
      t.string  :region,       null: false
      t.boolean :play_in_game, default: false

      t.timestamps
    end
  end
end
